class UserRequestsController < ActionController::Base
  def new
    @super_usages = SuperUsage.all
  end

  def create
  end
end
