Deface::Override.new(:virtual_path => "colibri/admin/shared/_configuration_menu",
                     :name => "converted_admin_configurations_menu",
                     :insert_bottom => "[data-hook='admin_configurations_sidebar_menu'], #admin_configurations_sidebar_menu[data-hook]",
                     :text => "<%= configurations_sidebar_menu_item Colibri.t('colibri_reviews.review_settings'), edit_admin_review_settings_path %>",
                     :disabled => false)
