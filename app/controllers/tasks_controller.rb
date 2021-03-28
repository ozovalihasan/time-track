class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user, only: :index

  def index
    @tasks = Task.all
    @tasks = filter_tasks(@tasks, filter_params) if params['filter']
    @tasks.nil? && @tasks = []
  end

  def new
    @task = Task.new
  end

  def create
    task = current_user.tasks.new(task_params)

    if task.save
      flash[:notice] = 'You added a task'
    else
      flash[:alert] = task.errors.full_messages[0]
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def task_params
    params.require(:task).permit(:comment, :time_type, :start_time, :end_time)
  end

  def filter_params
    params.permit(:time_type, :start_time, :end_time, :filter, users_id: [])
  end

  def filter_tasks(tasks, filter)
    filter = filter.to_h
    tasks = tasks.filter_by_start_time hash_to_datetime(filter, 'start_time')
    tasks = tasks.filter_by_end_time hash_to_datetime(filter, 'end_time')
    tasks = tasks.filter_by_time_type(filter['time_type']) unless filter['time_type'] == ''
    tasks = tasks.where(user_id: filter['users_id']) if filter['users_id'].size > 1
    tasks
  end

  def hash_to_datetime(hash, para)
    result = []
    (1.upto 5).each do |item|
      result << hash["#{para}(#{item}i)"].to_i
    end

    arrays_to_datetime(result)
  end

  def arrays_to_datetime(arr)
    DateTime.new(*arr)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
