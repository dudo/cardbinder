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
    @cards = @card_set.cards.order_by([[:name]])#.page(params[:page]).per(40)
    # @presenter = {
    #   img_host: Rails.configuration.image_host,
    #   cards: @cards,
    #   add: {
    #     action: add_card_path,
    #     csrf_param: request_forgery_protection_token,
    #     csrf_token: form_authenticity_token
    #   },
    #   remove: {
    #     action: remove_card_path,
    #     csrf_param: request_forgery_protection_token,
    #     csrf_token: form_authenticity_token
    #   }
    # }
  end

  def update
  end
end
