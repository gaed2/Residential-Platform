class StaticPagesController < ApplicationController

  layout :render_layout

  def terms_and_conditions; end

  def privacy_policy; end

  private

  def render_layout
    'pre_auth_static_pages' if !user_signed_in?
  end
end
