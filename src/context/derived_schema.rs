use std::collections::HashMap;

use graph::data::graphql::ext::DirectiveFinder;
use graph_graphql::graphql_parser::schema;

use crate::context::{MatchstickInstanceContext, SCHEMA};

pub(crate) fn derive_schema<C: graph::blockchain::Blockchain>(
    context: &mut MatchstickInstanceContext<C>,
) {
    SCHEMA.definitions.iter().for_each(|def| {
        if let schema::Definition::TypeDefinition(schema::TypeDefinition::Object(o)) = def {
            let entity_type = &o.name;
            let derived_fields = o.fields.iter().filter(|&f| {
                //matches!(f.field_type, schema::Type::NonNullType(..)) &&
                f.is_derived()
            });
            for virtual_field in derived_fields {
                // field type is received as: '[ExampleClass!]!' and needs to be reduced to a class string
                let derived_from_entity_type = virtual_field
                    .field_type
                    .to_string()
                    .replace(['!', '[', ']'], "");
                let mut directive = virtual_field.find_directive("derivedFrom").unwrap().clone();

                let derived_from_entity_field = directive
                    .arguments
                    .pop()
                    .unwrap()
                    .1
                    .to_string()
                    .replace('\"', "");

                if context.derived_fields.contains_key(entity_type) {
                    let entity_virtual_fields =
                        context.derived_fields.get_mut(entity_type).unwrap();

                    if !entity_virtual_fields.contains_key(&virtual_field.name) {
                        entity_virtual_fields.insert(
                            virtual_field.name.clone(),
                            (derived_from_entity_type, derived_from_entity_field.clone()),
                        );
                    }
                } else {
                    let mut entity_virtual_fields: HashMap<String, (String, String)> =
                        HashMap::new();
                    entity_virtual_fields.insert(
                        virtual_field.name.clone(),
                        (derived_from_entity_type, derived_from_entity_field.clone()),
                    );
                    context
                        .derived_fields
                        .insert(entity_type.to_string(), entity_virtual_fields);
                }
            }
        }
    });
}
