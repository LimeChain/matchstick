use super::{MatchstickInstanceContext, TemplateInfo, TemplateStore};
use anyhow::{Context as _, Result};
use graph::{
    prelude::DataSourceContext,
    runtime::{DeterministicHostError, HostExportError},
};
use std::collections::HashMap;

pub(crate) fn populate_templates<C: graph::blockchain::Blockchain>(
    context: &mut MatchstickInstanceContext<C>,
) {
    crate::MANIFEST_LOCATION.with(|path| {
        let names = crate::parser::collect_template_names(
            path.borrow().to_str().expect("Cannot convert to string."),
        );

        names.iter().for_each(|name| {
            context.templates.insert(name.to_string(), HashMap::new());
        });
    });
}

pub(crate) fn data_source_create(
    name: String,
    params: Vec<String>,
    context: Option<DataSourceContext>,
    templates: &mut TemplateStore,
) -> Result<(), HostExportError> {
    // Resolve the name into the right template
    templates
        .iter()
        .find(|template| template.0 == &name)
        .with_context(|| {
            format!(
                "Failed to create data source from name `{}`: \
                 No template with this name available. \
                 Available names: {}.",
                name,
                templates
                    .iter()
                    .map(|template| template.0.to_owned())
                    .collect::<Vec<_>>()
                    .join(", ")
            )
        })
        .map_err(DeterministicHostError::from)?;

    let template_info = TemplateInfo {
        kind: "ethereum/contract".to_string(),
        name: name.clone(),
        address: params[0].clone(),
        context
    };

    let template = templates.get_mut(&name).expect("Template not found.");
    template.insert(params[0].clone(), template_info);

    Ok(())
}
