class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    # GET /users
    def index
        render json: User.all, status: :ok
    end

    # GET /users/:id     (returns an object)
    def show
        user = find_user
        render json: user, status: :ok
    end

    # POST 
    def create
        user= User.create(user_params)
        if user.valid?
            render json: user, status: :created
        else
            render json: { error: "Invalid Credentials" }
        end
    end

    # PUT/PATCH
    def update
        # find
        user = find_user
        # update
        user.update!(user_params)
        render json: user, status: :accepted
    rescue ActiveRecord::RecordInvalid => invalid 
        render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    end

    # DELETE

    private

    def find_user
        User.find(params[:id])
    end

    def user_params
        params.permit(:username, :email, :password, :gender)
    end

    def render_not_found_response
        render json: { error: "User not found" }, status: :not_found
    end
    
    def render_unprocessable_entity_response(exception)
        render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end

end
