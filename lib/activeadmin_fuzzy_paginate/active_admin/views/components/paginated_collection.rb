class ActiveAdmin::Views::PaginatedCollection
  # Set num pages explicitly for fuzzy counts
  def build_pagination
    options =  request.query_parameters.except(:commit, :format)
    options[:param_name] = @param_name if @param_name

    options = options.merge(:num_pages => collection.empty? ? collection.current_page : collection.current_page + 1) if active_admin_config.fuzzy_paginate

    text_node paginate(collection, options.symbolize_keys)
  end

  def page_entries_info_with_fuzzy_paginate(options = {})
    return page_entries_info_without_fuzzy_paginate(options) unless active_admin_config.fuzzy_paginate

    if options[:entry_name]
      entry_name = options[:entry_name]
      entries_name = options[:entries_name]
    elsif collection.empty?
      entry_name = I18n.translate("active_admin.pagination.entry", :count => 1, :default => 'entry')
      entries_name = I18n.translate("active_admin.pagination.entry", :count => 2, :default => 'entries')
    else
      begin
        entry_name = I18n.translate!("activerecord.models.#{collection.first.class.model_name.i18n_key}", :count => 1)
        entries_name = I18n.translate!("activerecord.models.#{collection.first.class.model_name.i18n_key}", :count => collection.size)
      rescue I18n::MissingTranslationData
        entry_name = collection.first.class.name.underscore.sub('_', ' ')
      end
    end
    entries_name = entry_name.pluralize unless entries_name

    "Displaying results for #{entries_name}"
  end
  alias_method_chain :page_entries_info, :fuzzy_paginate

end