class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show]

  def show; end

  def new; end

  def create
    @question = Question.new(question_params)

    if @question.save
      render :show 
    else
      render :new
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
  
end
