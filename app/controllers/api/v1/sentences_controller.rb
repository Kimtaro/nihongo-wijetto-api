class Api::V1::SentencesController < ApplicationController
  def index
    sentences = TANAKA_DB.lookup(params[:word]) || []
    sentences = sentences[0..10]
    render json: {sentences: sentences}
  end
end
