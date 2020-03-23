class ApplicationController < ActionController::Base
  around_action :switch_locale

  def switch_locale(&action)
    I18n.with_locale(http_accept_language.compatible_language_from(I18n.available_locales), &action)
  end
end
