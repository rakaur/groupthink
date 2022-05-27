class ApplicationController < ActionController::Base
  # TODO: For now require auth to do anything
  before_action :authenticate_user!
end
