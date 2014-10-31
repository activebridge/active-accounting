class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: HTTP_AUTH_NAME, password: HTTP_AUTH_PASS

  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token
end
