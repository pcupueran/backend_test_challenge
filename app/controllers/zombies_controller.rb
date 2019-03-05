class ZombiesController < ApplicationController
  before_action :zombie, only: [:create, :update, :destroy]

  def index
    @zombies = Zombie.all
    render json: @zombies, status: :ok
  end

  def create
    if @zombie.save
      render json: @zombie, status: :created
    else
      render json: @zombie.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @zombie.update(zombie_params)
      render json: @zombie, include: [:armors, :weapons], status: :ok
    else
      render json: @zombie.errors, status: :unprocessable_entity
    end
  end

  def search
    @zombies = Zombie.associated_with(params[:term])
    render json: @zombies, only: [:id, :name], include: { armors: { only: :name }, weapons: { only: :name } }, status: :ok
  end

  def destroy
    if @zombie.destroy
      render status: :ok
    else
      render status: :forbidden
    end
  end

  private
  def zombie_params
    params.permit(:name, :id, armors_attributes: [:name, :zombie_id], weapons_attributes: [:name, :zombie_id])
  end

  def zombie
    @zombie = params[:id] ? Zombie.find(params[:id]) : Zombie.new(zombie_params)
  end
end  