class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    return @tasks = Task.all if current_user.admin?
  end

  def new
    @task = Task.new
  end
end
