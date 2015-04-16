module ApplicationHelper

  def check_for_error(field)
    resource.errors.messages.include?(field) ? 'has-error' : nil
  end

  def form_group(form, field, &block)
    html = <<-EOF
      <div class="form-group #{check_for_error(field)}">
        #{ form.label field, class: 'control-label' }
        #{ capture(&block) }
      </div>
    EOF

    html.html_safe
  end

  def welcome_message
    if user_signed_in?
      user_name = current_user.name.present? ? current_user.name : 'friend'
      "Hello, #{user_name}"
    else
      "Calendar"
    end
  end

end
