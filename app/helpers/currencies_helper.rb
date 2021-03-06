module CurrenciesHelper
  def currency_types_list_for_select(exclude_list = [])
    (Currency.types-exclude_list).collect {|t| [Currency.humanize_type(t),t]}
  end
  def configurable_fields_html(currency)
    fields = currency.api_configurable_fields
    result = []
    c = currency.configuration
    fields.keys.sort.each do |field|
      next if field =~ /\.default$/
      id = "config[#{field}]"
      result << <<-EOHTML
      <p>
        #{label_tag id,field}: 
        #{text_field_tag id, c ? c[field] : fields[field+'.default'],:size=>60}
      </p>
      EOHTML
    end
    if result.empty?
      nil
    else
      %Q|<div id="configurable_fields">#{result}</div>|
    end
  end
end
