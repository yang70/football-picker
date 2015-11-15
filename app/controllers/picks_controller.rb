class PicksController < ApplicationController
  before_action :set_pick, only: [:update, :edit]

  def edit
  end

  def update
    if @pick.update_attributes(pick_params)
      respond_to do |format|
        format.html {}
        format.js
      end
    else
      respond_to do |format|
        format.html{ render :edit }
        format.js { render :edit }
      end
    end
  end

  private

  def pick_params
    params.require(:pick).permit(:winner)
  end

  def set_pick
    @pick = Pick.find(params[:id])
  end
end
