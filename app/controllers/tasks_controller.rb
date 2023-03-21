class TasksController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  
    # GET /tasks
    def index
      tasks = Task.all
      render json: tasks, only: [:task_name, :task_description, :task_status], status: :ok
    end

    # GET /tasks/:id
    def show
      task = find_task
      render json: task
    end
  
    # POST /tasks
    def create
      task= Task.create!(task_params)
      render json: task, status: :created
    end

    # PATCH /tasks/:id
    def update
        # find
        task = find_task
        # update
        task.update!(task_params)
        render json: task, status: :accepted
    rescue ActiveRecord::RecordInvalid => invalid 
        render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    end

    # DELETE /tasks/:id
    def destroy
        # find
        task = find_task
        # delete
        task.destroy
        head :no_content
    end
  
    private
  
    def task_params
      params.permit(:task_name, :task_description, :task_status)
    end
    
    def find_task
      Task.find(params[:id])
    end
  
    def render_not_found_response
      render json: { error: "Task not found" }, status: :not_found
    end
  
    def render_unprocessable_entity_response(exception)
      render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end
end
