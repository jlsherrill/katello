# Remove support for organization nesting
Deface::Override.new(:virtual_path => "taxonomies/index",
                     :name => "override_taxonomy_actions",
                     :replace => 'td:nth-of-type(3)',
                     :partial => '../overrides/foreman/taxonomies/action_buttons'
                    )
