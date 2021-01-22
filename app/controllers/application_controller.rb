class ApplicationController < ActionController::Base
  before_action :set_locale
  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    check = I18n.available_locales.include?(locale)
    return I18n.locale = locale if check == true
    return I18n.locale = I18n.default_locale if check == false
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
