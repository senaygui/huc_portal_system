module ApplicationHelper
	def current_class?(test_path)
    return 'nav-link active' if request.path == test_path
    ''
  end
  def status_tag(boolean, options={})
    options[:true] ||= ''
    options[:true_class] ||= 'status true'
    options[:false] ||= ''
    options[:false_class] ||= 'status false'

    if boolean
      content_tag(:span, options[:true], :class => options[:true_class])
    else
      content_tag(:span, options[:false], :class => options[:false_class])
    end
  end
end