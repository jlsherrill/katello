Deface::Override.new(:virtual_path => "hostgroups/_form",
                     :name => "add_activation_keys_tab",
                     :insert_bottom => 'ul.nav-tabs',
                     :partial => '../overrides/foreman/activation_keys/host_tab')

Deface::Override.new(:virtual_path => "hostgroups/_form",
                     :name => "add_activation_keys_tab_pane",
                     :insert_bottom => 'div.tab-pane',
                     :partial => '../overrides/foreman/activation_keys/host_tab_pane')

Deface::Override.new(:virtual_path => "hostgroups/_form",
                     :name => "hostgroups_update_environments_select",
                     :replace => 'code[erb-loud]:contains("select_f"):contains(":environment_id")',
                     :partial => '../overrides/foreman/activation_keys/host_environment_select')

Deface::Override.new(:virtual_path => "hosts/_form",
                     :name => "hosts_update_environments_select",
                     :replace => 'code[erb-loud]:contains("select_f"):contains(":environment_id")',
                     :partial => '../overrides/foreman/activation_keys/host_environment_select')
