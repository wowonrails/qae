module SearchHelper
  def sort_link(f, name, search, field)
    h = ''.html_safe

    h << link_to(name, { search: { sort: sort_link_param(search, field)} }, { class: sort_link_class(search, field) })
    h << f.input(:sort, as: :hidden, input_html: { value: "#{field}#{'.desc' if !search.ordered_desc}", disabled: true })

    h
  end

  private

  def sort_link_class(search, field)
    klass = ''

    if search.ordered_by == field.to_s
      klass << 'ordered'

      if search.ordered_desc
        klass << ' ordered-desc'
      end
    end

    klass
  end

  def sort_link_param(search, field)
    if search.ordered_by == field.to_s && !search.ordered_desc
      "#{field}.desc"
    else
      field
    end
  end
end
