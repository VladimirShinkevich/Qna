class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[show destroy]
  

  def create 
    @answer = @question.answers.new(answer_params)
    @answer.author_id = current_user.id

    if @answer.save
      redirect_to @question, notice: 'You answer succefully created!'
     
    else
      flash[:notice] = "Your answer was't created!"
    end
  end

  def destroy
    if current_user&.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'You answer if succefully deleted!'
    else 
      redirect_to question_path(@answer.question), notice: 'You are not a author of answer!'
    end
  end

  private 

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
