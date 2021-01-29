class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception
  include SessionsHelper

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    return I18n.locale = locale if I18n.available_locales.include?(locale)

    I18n.locale = I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
