class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      @tasks = Task.all
      @filter = nil
      @filter = filter_params if params.keys.include? 'filter'
      @tasks = filter_tasks(@tasks, @filter) if @filter
      @tasks
    else
      redirect_to root_path
    end
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

  def chosen_filter_params
    params.require(:chosen_filter).permit(:time_type, :start_time, :end_time, :filter, users_id: [])
  end

  def filter_tasks(tasks, filter)
    filter = filter.to_h
    tasks = tasks.where(['time_type == ?', filter['time_type']]) unless filter['time_type'] == ''
    tasks = tasks.all.where(['start_time > ?', hash_to_datetime(filter, 'start_time')])
    tasks = tasks.all.where(['end_time < ?', hash_to_datetime(filter, 'end_time')])
    tasks.where(user_id: filter['users_id']) if filter['users_id'].size > 1
  end

  def hash_to_datetime(hash, para)
    result = []
    (1.upto 5).each do |item|
      result << hash["#{para}(#{item}i)"].to_i
    end

    integer_to_datetime(result)
  end

  def integer_to_datetime(arr)
    DateTime.new(*arr)
  end
end
