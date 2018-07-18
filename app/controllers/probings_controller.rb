class ProbingsController < ApplicationController


  def index
    @probings = Probing.all
  end

  def last
    @probings = Probing.where(user_id: current_user).last(6)

  end

  def new
    @probing = Probing.new
  end

  def create
    @probing = Probing.new(probing_params)
    @probing.user = current_user
    if @probing.save
      redirect_to probings_path
    else
      render :new
    end
  end

  private

  def probing_params
    params.require(:probing).permit(:hydratation, :quantity, :quality, :fleed)
  end

end
