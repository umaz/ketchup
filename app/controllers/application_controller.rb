class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :auth
  private
  def auth
    authenticate_or_request_with_http_digest('') do | name |
      u = User.find_by_name(name)
      if u
        u.password
      else
        nil
      end
    end
  end
end
