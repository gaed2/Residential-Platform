ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation
  actions :all, except: :destroy

  collection_action :autocomplete_admin_user_email, method: :get do
    return if params[:term].length < Constant::MINIMUM_CHARACTER_FOR_SEARCH
    admin_emails = AdminUser.select(:email).by_email(params[:term])
    render json: admin_emails
  end

  index do
    selectable_column
    id_column
    column :email
    actions
  end

  filter :email_contains, input_html: {
          class: 'autocomplete-filter',
          data: {
            url: '/admin/admin_users/autocomplete_admin_user_email'
          }
  }, label: 'Email contains', required: false

  show do
    attributes_table do
      row :email
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
