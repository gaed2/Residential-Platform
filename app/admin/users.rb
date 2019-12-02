ActiveAdmin.register User do
  actions :all, except: %w[edit destroy new]
  USER_SHOW_COLUMNS = %i[email first_name last_name status].freeze

  USER_SHOW_COLUMNS.each do |col|
    collection_action "autocomplete_user_#{col}", method: :get do
      return if params[:term].length < Constant::MINIMUM_CHARACTER_FOR_SEARCH
      results = User.select(col).instance_eval("by_#{col}('#{params[:term]}')")
      render json: results
    end
  end

  USER_SHOW_COLUMNS.each do |col|
    filter "#{col}_contains", input_html: {
            class: 'autocomplete-filter',
            data: {
              url: "/admin/users/autocomplete_user_#{col}"
            }
    }, label: "#{col} contains", required: false
  end

  filter :status, as: :select


  before_action only: %i[show update_status] do
    @user = User.find_by(id: params[:id])
  end

  index do
    column :id

    column :avatar do |user|
      image_tag user_avatar(user.avatar), height: 50, width: 50
    end

    USER_SHOW_COLUMNS.each do |col|
      column col
    end

    actions do |user|
      render partial: 'custom_user_links', locals: { user: user }
    end
  end

  member_action :update_status, method: :put do
    outcome = Admin::Users::UpdateStatusIntr.run(user: @user)
    message = if outcome.valid?
                t('admin.user.update_status.success')
              else
                outcome.errors.full_messages.to_sentence
              end
    redirect_to admin_users_path, notice: message
  end

  show do
    attributes_table do
      row :avatar do |user|
        image_tag user_avatar(user.avatar), height: 50, width: 50
      end

      USER_SHOW_COLUMNS.each do |col|
        row col
      end
    end
  end
end
