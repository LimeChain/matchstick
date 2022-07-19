use std::collections::HashMap;

use graph::data::store::Value;

use crate::context::MatchstickInstanceContext;
use crate::logging;

/// This function checks whether all the necessary data is present in the store to avoid linking
/// entities to other non existent entities which may cause serious collision problems later
pub(crate) fn insert_derived_field_in_store<C: graph::blockchain::Blockchain>(
    context: &mut MatchstickInstanceContext<C>,
    derived_field_value: Value,
    original_entity: String,
    linking_field: (String, String, String),
    id: String,
) {
    if derived_field_value.is_string() {
        let derived_field_string_value = derived_field_value.as_string().unwrap();
        if context.store.contains_key(&original_entity) {
            let mut inner_store = context
                .store
                .get(&original_entity)
                .unwrap_or_else(|| {
                    logging::critical!("Couldn't find value for {} in store", original_entity)
                })
                .clone();
            if inner_store.contains_key(&derived_field_string_value) {
                let mut innermost_store = inner_store
                    .get(&derived_field_string_value)
                    .unwrap_or_else(|| {
                        logging::critical!(
                            "Couldn't find value for {} in inner store",
                            derived_field_string_value
                        )
                    })
                    .clone();
                if innermost_store.contains_key(&linking_field.0) {
                    let innermost_value = innermost_store
                        .get(&linking_field.0)
                        .unwrap_or_else(|| {
                            logging::critical!(
                                "Couldn't find value for {} in innermost store",
                                linking_field.0
                            )
                        })
                        .clone();
                    if !innermost_value
                        .clone()
                        .as_list()
                        .unwrap()
                        .contains(&Value::from(id.clone()))
                    {
                        let mut innermost_value_list = innermost_value.as_list().unwrap();
                        innermost_value_list.push(Value::from(id));
                        innermost_store.insert(linking_field.0, Value::List(innermost_value_list));
                    }
                } else {
                    innermost_store.insert(linking_field.0, Value::List(vec![Value::from(id)]));
                }
                inner_store.insert(derived_field_string_value, innermost_store);
            }
            context.store.insert(original_entity, inner_store);
        }
    }
}

/// Checks for and removes faulty store relations.
/// This function is called on every assert/store.get to make sure assertions and entity loading is done with an updated store
pub(crate) fn update_derived_relations_in_store<C: graph::blockchain::Blockchain>(
    context: &mut MatchstickInstanceContext<C>,
) {
    if !context.store_updated {
        for entity in context.store.clone() {
            for inner_entity in entity.1 {
                let entity_type = entity.0.clone();
                let id = inner_entity.0;
                let data = inner_entity.1;
                if context.derived.contains_key(&entity_type) {
                    let mut entity_deleted = true;
                    let linking_fields = context
                        .derived
                        .get(&entity_type)
                        .unwrap_or_else(|| {
                            logging::critical!(
                                "Couldn't find value for key {} in derived map",
                                entity_type
                            )
                        })
                        .clone();
                    for linking_field in &linking_fields {
                        if context.store.contains_key(&linking_field.2) {
                            let inner_store = context.store.get(&linking_field.2).unwrap().clone();
                            if let Some(relation_id) = data.get(&linking_field.1) {
                                if relation_id.is_string()
                                    && inner_store.contains_key(relation_id.as_str().unwrap())
                                {
                                    entity_deleted = false;
                                    let original_entity_data =
                                        inner_store.get(relation_id.as_str().unwrap()).unwrap();
                                    for field in original_entity_data {
                                        if &linking_field.0 == field.0
                                            && matches!(field.1, Value::List(_))
                                        {
                                            let value_list =
                                                field.1.clone().as_list().unwrap().clone();
                                            if !value_list.contains(&Value::String(id.clone()))
                                                && data.contains_key(&linking_field.1)
                                            {
                                                handle_different_value_types(
                                                    context,
                                                    data.clone(),
                                                    linking_field,
                                                    relation_id,
                                                    field,
                                                    id.clone(),
                                                    entity_deleted,
                                                );
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Removes the entity with no relations from every list it may be in
                    if entity_deleted {
                        for linking_field in &linking_fields {
                            if context.store.contains_key(&linking_field.2) {
                                let inner_store =
                                    context.store.get(&linking_field.2).unwrap().clone();
                                if let Some(relation_id) = data.get(&linking_field.1) {
                                    if relation_id.is_string() {
                                        for original_entity_id_and_data in &inner_store {
                                            let innermost_store = inner_store
                                                .get(original_entity_id_and_data.0)
                                                .unwrap()
                                                .clone();
                                            for field in &innermost_store {
                                                if &linking_field.0 == field.0
                                                    && matches!(field.1, Value::List(_))
                                                {
                                                    let value_list =
                                                        field.1.clone().as_list().unwrap().clone();
                                                    if value_list
                                                        .contains(&Value::String(id.clone()))
                                                        && data.contains_key(&linking_field.1)
                                                    {
                                                        handle_different_value_types(
                                                            context,
                                                            data.clone(),
                                                            linking_field,
                                                            relation_id,
                                                            field,
                                                            id.clone(),
                                                            entity_deleted,
                                                        );
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        context.store_updated = true;
    }
}

/// Removes the deleted entity from the other end of any relations it may have
pub(crate) fn cascade_remove<C: graph::blockchain::Blockchain>(
    context: &mut MatchstickInstanceContext<C>,
    entity_type: String,
    id: String,
) {
    let store = context.store.clone();
    let deleted_entity_data = store.get(&entity_type).unwrap().get(&id).unwrap();
    let linking_fields = context
        .derived
        .get(&entity_type)
        .unwrap_or_else(|| {
            logging::critical!("Couldn't find value for key {} in derived map", entity_type)
        })
        .clone();

    for linking_field in linking_fields {
        if context.store.contains_key(&linking_field.2) {
            let original_entity_type = linking_field.2.clone();
            let mut original_entity = store.get(&original_entity_type).unwrap().clone();
            if deleted_entity_data.contains_key(&linking_field.1) {
                let relation_id = deleted_entity_data.get(&linking_field.1).unwrap();
                if relation_id.is_string()
                    && original_entity.contains_key(relation_id.as_str().unwrap())
                {
                    let mut inner_store = original_entity
                        .get(relation_id.as_str().unwrap())
                        .unwrap()
                        .clone();
                    if inner_store.contains_key(&linking_field.0) {
                        let mut value_list = inner_store
                            .get(&linking_field.0)
                            .unwrap()
                            .clone()
                            .as_list()
                            .unwrap();
                        if value_list.contains(&Value::String(id.clone())) {
                            value_list.remove(
                                value_list
                                    .iter()
                                    .position(|x| *x == Value::String(id.clone()))
                                    .unwrap(),
                            );
                            inner_store.insert(linking_field.0, Value::List(value_list));
                            original_entity
                                .insert(relation_id.clone().as_string().unwrap(), inner_store);
                            context
                                .store
                                .insert(original_entity_type.clone(), original_entity.clone());
                        }
                    }
                }
            }
        }
    }
}

fn handle_different_value_types<C: graph::blockchain::Blockchain>(
    context: &mut MatchstickInstanceContext<C>,
    data: HashMap<String, Value>,
    linking_field: &(String, String, String),
    relation_id: &Value,
    field: (&String, &Value),
    id: String,
    entity_deleted: bool,
) {
    if data.get(&linking_field.1).unwrap().is_string() {
        remove_dead_relations(
            context,
            data.get(&linking_field.1).unwrap().to_owned(),
            relation_id.as_str().unwrap(),
            field,
            Value::String(id),
            linking_field.2.clone(),
            entity_deleted,
        );
    } else if matches!(data.get(&linking_field.1).unwrap(), Value::List(_)) {
        let linking_field_values = data
            .get(&linking_field.1)
            .unwrap()
            .clone()
            .as_list()
            .unwrap();
        for linking_field_value in linking_field_values {
            remove_dead_relations(
                context,
                linking_field_value,
                relation_id.as_str().unwrap(),
                field,
                Value::String(id.clone()),
                linking_field.2.clone(),
                entity_deleted,
            );
        }
    }
}

fn remove_dead_relations<C: graph::blockchain::Blockchain>(
    context: &mut MatchstickInstanceContext<C>,
    current_value: Value,
    entity: &str,
    field: (&String, &Value),
    value: Value,
    original_entity: String,
    entity_deleted: bool,
) {
    if current_value.is_string() && (current_value.as_str().unwrap() != entity && !entity_deleted)
        || (current_value.as_str().unwrap() == entity && entity_deleted)
    {
        let mut inner_store = context.store.get(&original_entity).unwrap().clone();
        if !entity_deleted {
            let mut innermost_store = inner_store.get(entity).unwrap().clone();
            let mut value_list = field.1.clone().as_list().unwrap();

            if value_list.contains(&value) {
                value_list.remove(value_list.iter().position(|x| *x == value).unwrap());
                innermost_store.insert(field.0.to_owned(), Value::List(value_list));
                inner_store.insert(entity.to_owned(), innermost_store);

                context.store.insert(original_entity, inner_store);
            }
        } else {
            for mut entity in inner_store.clone() {
                let mut value_list = field.1.clone().as_list().unwrap();

                if value_list.contains(&value) {
                    value_list.remove(value_list.iter().position(|x| *x == value).unwrap());
                    entity.1.insert(field.0.to_owned(), Value::List(value_list));
                    inner_store.insert(entity.0, entity.1);

                    context
                        .store
                        .insert(original_entity.clone(), inner_store.clone());
                }
            }
        }
    }
}
