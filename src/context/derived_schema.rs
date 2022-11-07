use graph::data::graphql::ext::DirectiveFinder;
use graph_graphql::graphql_parser::schema;

use crate::context::{MatchstickInstanceContext, SCHEMA};
use crate::logging;

pub(crate) fn derive_schema<C: graph::blockchain::Blockchain>(
    context: &mut MatchstickInstanceContext<C>,
) {
    SCHEMA.definitions.iter().for_each(|def| {
        if let schema::Definition::TypeDefinition(schema::TypeDefinition::Object(o)) = def {
            let entity_type = &o.name;
            let derived_fields = o.fields.iter().filter(|&f| {
                matches!(f.field_type, schema::Type::NonNullType(..)) && f.is_derived()
            });
            for f in derived_fields {
                // field type is received as: '[ExampleClass!]!' and needs to be reduced to a class string
                let clean_field_type = f.field_type.to_string().replace(['!', '[', ']'], "");
                let mut directive = f.find_directive("derivedFrom").unwrap().clone();

                let field = directive
                    .arguments
                    .pop()
                    .unwrap()
                    .1
                    .to_string()
                    .replace('\"', "");

                if context.derived.contains_key(&clean_field_type) {
                    let mut field_names_vec = context
                        .derived
                        .get(&clean_field_type)
                        .unwrap_or_else(|| {
                            logging::critical!(
                                "Failed to get field names vector for type {}",
                                clean_field_type
                            )
                        })
                        .clone();

                    let field_names_tuple = (f.name.clone(), field, String::from(entity_type));
                    if !field_names_vec.contains(&field_names_tuple) {
                        field_names_vec.push(field_names_tuple);
                        context.derived.insert(clean_field_type, field_names_vec);
                    }
                } else {
                    context.derived.insert(
                        clean_field_type,
                        vec![(f.name.clone(), field, String::from(entity_type))],
                    );
                }
            }
        }
    });
}
