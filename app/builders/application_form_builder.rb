# Kudos to https://brandnewbox.com/notes/2021/03/form-builders-in-ruby/
class ApplicationFormBuilder < ActionView::Helpers::FormBuilder
  delegate :tag, :safe_join, :t, :render, to: :@template

  def errors(attr = nil)
    errors = if attr.present?
               object.errors.full_messages_for(attr)
             else
               object.errors.full_messages
             end

    render 'form_errors', errors: errors, message: t('form_errors.message')
  end

  def text_field(attribute, options = {})
    field_helper = options[:field_helper] || proc { |a, o| super(a, o) }

    input_group(attribute, options) do
      safe_join [
                  (label(attribute, options[:label], options[:label_html]) unless options[:label] == false),
                  field_helper.call(
                    attribute,
                    merge_options({
                                    placeholder: options[:placeholder],
                                    class: "form-control #{"form-input-invalid" if has_error?(attribute)}"
                                  }, options[:input_html])
                  ),
                ]
    end
  end

  def password_field(attribute, options = {})
    text_field(attribute, options.merge(field_helper: proc { |a, o| super(a, o) }))
  end

  def email_field(attribute, options = {})
    text_field(attribute, options.merge(field_helper: proc { |a, o| super(a, o) }))
  end

  def telephone_field(attribute, options = {})
    text_field(attribute, options.merge(field_helper: proc { |a, o| super(a, o) }))
  end

  def number_field(attribute, options = {})
    text_field(attribute, options.merge(field_helper: proc { |a, o| super(a, o) }))
  end

  def date_field(attribute, options = {})
    text_field(attribute, options.merge(field_helper: proc { |a, o| super(a, o) }))
  end

  def text_area(attribute, options = {})
    text_field(attribute, options.merge(field_helper: proc { |a, o| super(a, o) }))
  end

  def rich_text_area(attribute, options = {})
    text_field(attribute, options.merge(field_helper: proc { |a, o| super(a, o) }))
  end

  alias original_check_box check_box

  def check_box(attribute, options = {})
    input_group(attribute, options) do
      safe_join [
                  tag.p(options.fetch(:title, "&nbsp;").to_s.html_safe, class: "form-label"),
                  tag.div(class: "custom-control custom-checkbox") do
                    safe_join [
                                super(
                                  attribute,
                                  merge_options({
                                                  class: "custom-control-input"
                                                }, options[:input_html])),
                                (label(attribute, options[:label], merge_options({ class: "custom-control-label" }, options[:label_html])) unless options[:label] == false),
                              ]
                  end,
                ].compact
    end
  end

  def toggle(method, options = {})
    input_group(method, options) do
      safe_join [
                  tag.p(options.fetch(:title, "&nbsp;").to_s.html_safe, class: "form-label"),
                  label(method, class: "form-input-toggle") do
                    safe_join [
                                original_check_box(method, merge_options({ class: "sr-only peer" }, options[:input_html])),
                                tag.div(class: "toggle-switch w-11 h-6 bg-primary-200 rounded-full peer peer-focus:ring-4 peer-focus:ring-primary-300 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:left-[2px] after:bg-white after:border-primary-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary-600"),
                                (tag.span(options[:label]) if options[:label]),
                              ].compact
                  end
                ]
    end
  end

  def file_field(attribute, options = {})
    input_group(attribute, options) do
      safe_join [
                  (label(attribute, options[:label], options[:label_html]) unless options[:label] == false),
                  super(attribute, options.merge(class: "custom-file-input")),
                ]
    end
  end

  def collection_select(method, options = {})
    value_method = options[:value_method] || :to_s
    text_method = options[:text_method] || :to_s
    input_options = options[:input_html] || {}

    multiple = input_options[:multiple]

    collection_input(method, options) do
      super(method, options[:collection], value_method, text_method, options, merge_options({ class: "#{"custom-select" unless multiple} form-control #{"form-input-invalid" if has_error?(method)}" }, options[:input_html]))
    end
  end

  def label(method, text = nil, options = {}, &block)
    super(method, text, (options || {}).reverse_merge(class: "form-label"), &block)
  end

  def submit(value = nil, options = {}, &block)
    button(value, options.reverse_merge(class: "button primary"), &block)
  end

  # md:grid-cols-1 md:grid-cols-2 md:grid-cols-3 md:grid-cols-4 md:grid-cols-5
  # md:grid-cols-6 md:grid-cols-7 md:grid-cols-8 md:grid-cols-9 md:grid-cols-10
  def fields_group(cols: 1, **options, &block)
    tag.div(class: "form-fields-group md:grid-cols-#{cols} #{options[:class]}", &block)
  end

  def error_text(method)
    return unless has_error?(method)

    tag.div(@object.errors[method].join("<br />").html_safe, class: "form-input-error")
  end

  private

  def input_group(method, options = {}, &block)
    tag.div class: "form-input-group #{options[:class]} #{method}" do
      safe_join [
                  block.call,
                  error_text(method),
                  hint_text(options[:hint]),
                ].compact
    end
  end

  def hint_text(text)
    return if text.nil?
    tag.p text, class: "form-hint"
  end

  def has_error?(method)
    return false unless @object.respond_to?(:errors)
    @object.errors.key?(method)
  end

  def collection_input(method, options, &block)
    input_group(method, options) do
      safe_join [
                  label(method, options[:label]),
                  block.call,
                ]
    end
  end

  def grouped_select_input(method, options = {})
    # We probably need to go back later and adjust this for more customization
    collection_input(method, options) do
      grouped_collection_select(method, options[:collection], :last, :first, :to_s, :to_s, options, merge_options({ class: "custom-select form-control #{"form-input-invalid" if has_error?(method)}" }, options[:input_html]))
    end
  end

  def collection_of(input_type, method, options = {})
    form_builder_method, custom_class, input_builder_method = case input_type
                                                              when :radio_buttons then [:collection_radio_buttons, "custom-radio", :radio_button]
                                                              when :check_boxes then [:collection_check_boxes, "custom-checkbox", :check_box]
                                                              else raise "Invalid input_type for collection_of, valid input_types are \":radio_buttons\", \":check_boxes\""
                                                              end

    input_group(method, options) do
      safe_join [
                  label(method, options[:label]),
                  tag.br,
                  (send(form_builder_method, method, options[:collection], options[:value_method], options[:text_method]) do |b|
                    tag.div(class: "custom-control #{custom_class}") {
                      safe_join [
                                  b.send(input_builder_method, class: "custom-control-input"),
                                  b.label(class: "custom-control-label"),
                                ]
                    }
                  end),
                ]
    end
  end

  def radio_buttons_input(method, options = {})
    collection_of(:radio_buttons, method, options)
  end

  def check_boxes_input(method, options = {})
    collection_of(:check_boxes, method, options)
  end

  def merge_options(options, user_options)
    return options if user_options.nil?

    # TODO handle class merging here
    options.merge(user_options)
  end
end
