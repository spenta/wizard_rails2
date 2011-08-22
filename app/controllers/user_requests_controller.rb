class UserRequestsController < ActionController::Base
  layout 'application'

  def new
    @super_usages = SuperUsage.all_except_mobilities
  end

  def create
  end
end
