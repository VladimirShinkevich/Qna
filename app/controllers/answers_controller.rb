class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[show destroy update mark_as_best]
 
  def create 
    authorize Answer
    @answer = @question.answers.create(answer_params.merge(question: @question, author: current_user))
    if @answer.save 
      flash.now[:notice] = "Your answer successfully created."
      ActionCable.server.broadcast("question_#{@question.id}", 
                              { html: render_to_string(partial: 'answers/answer', locals: { answer: @answer }) })
    end
  end

  def edit; end

  def destroy
    authorize @answer
    @answer.destroy
    @question = @answer.question
  end

  def update
    authorize @answer
    @answer.update(answer_params)
    @question = @answer.question
  end

  def mark_as_best
    authorize @answer
    @question = @answer.question
    @question.update(best_answer_id: @answer.id)
    @question.award&.update(user: @answer.author)
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
