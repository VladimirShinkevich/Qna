class Api::V1::QuestionsController < Api::V1::BaseController
  skip_forgery_protection 
  before_action :find_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
    render json: @questions, include: ['answers', 'author']
  end

  def show
    authorize @question
    render json: @question, include: ['comments', 'files', 'links', 'answers', 'author', 'comments.auhtor']
  end

  def create
    authorize Question
    @question = current_resource_owner.questions.new(question_params)
    if @question.save 
      ActionCable.server.broadcast('questions', { id: @question.id, title: @question.title })
      render json: @question, include: ['author']
    else
      render json: { error: 'Question does not save!!!'}
    end
  end

  def update
    authorize @question
    @question.update(question_params)
    render json: @question, include: ['author']
  end

  def destroy
    authorize @question
    if @question.destroy
      head :ok
    else
      render json: { error: "Quetion was not deleted"}
    end
  end

  private 

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:body, :title, award_attributes: %i[id name image _destroy], files: [],
                                                    links_attributes: %i[id name url _destroy] )
  end

end
