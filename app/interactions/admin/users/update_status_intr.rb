# frozen_string_literal: true

# The class is responsible for updating state of user
class Admin::Users::UpdateStatusIntr < ApplicationInteraction
  object :user

  def execute
    status = user.active? ? :blocked : :active
    errors.merge! user.errors unless user.update(status: status)
    user
  end
end
