class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      @tasks = Task.all
      respond_to do |format|
        format.html
        format.csv { send_data @tasks.to_csv, filename: "tasks-#{Date.today}.csv" }
      end
      @tasks

    end
  end

  def new
    @task = Task.new
  end
end
