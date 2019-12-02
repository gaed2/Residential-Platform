module ActiveAdmin
  module UsersHelper
    def action_text(user)
      return t('admin.user.block') if user.active?
      t('admin.user.unblock')
    end
  end
end
