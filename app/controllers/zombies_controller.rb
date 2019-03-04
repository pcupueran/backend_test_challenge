class ZombiesController < ApplicationController
  def create
    @zombie = Zombie.new(zombie_params)

    if @zombie.save
      render json: @zombie, status: :created
    else
      render json: @zombie.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    @zombie = Zombie.find(params[:id])

    if @zombie.update!(zombie_params)
      render json: @zombie, include: [:armors], status: :ok
    else
      render json: @zombie.errors, status: :unprocessable_entity
    end
  end

  def search
    @zombies = Zombie.joins(:armors, :weapons).group('zombies.id').where('zombies.name LIKE :search_term
      OR armors.name LIKE :search_term 
      OR weapons.name LIKE :search_term', 
      search_term: "%#{params[:term]}%"
    )

    render json: @zombies, only: [:id, :name], include: { armors: { only: :name }, weapons: { only: :name } }, status: :ok
  end

  private
  def zombie_params
    params.permit(:name, :id, :armors_attributes => [:name, :zombie_id], :weapons_attributes => [:name, :zombie_id])
  end
end  