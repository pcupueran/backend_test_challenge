class ZombiesController < ApplicationController
  def create
    @zombie = Zombie.new(zombie_params)

    if @zombie.save
      render json: @zombie, status: :created
    else
      render json: @zombie.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
  def zombie_params
    params.permit(:name)
  end
end
