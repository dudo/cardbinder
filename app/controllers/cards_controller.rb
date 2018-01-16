class CardsController < ApplicationController

  def create
  end

  def new
  end

  def show
  end

  def edit
  end

  def destroy
  end

  def index
    @card_set = CardSet.find(params[:card_set_id])
    @cards = @card_set.cards.order_by([:imageName]).limit(20)
    @cards = @cards.reject{ |c| c.alternate_info? && c.name == c.names[-1] }
  end

  def update
  end
end
