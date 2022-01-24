class Api::V1::AnswersController < Api::V1::BaseController
  skip_forgery_protection

  before_action :find_answer, only: [:update, :destroy]
  before_action :find_question, only: [:index, :show, :create]

  def index
    @answers = @question.answers
    render json: @answers, include: ['author']
  end

  def show
  	@answer = @question.answers.with_attached_files.find(params[:id])
  	render json: @answer, include: ['author', 'comments', 'files', 'links', 'comments.author']
  end

  def create
  	authorize Answer
  	@answer = Answer.new(answer_params.merge(question: @question, author: current_resource_owner))
  	if @answer.save
  		render json: @answer, include: ['author']
    else 
      render json: { error: "You answer does not create" }
    end
  end

  def update
    authorize @answer
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { error: "Updating error"}
    end
  end

  def destroy
    authorize @answer
    if @answer.delete 
      head :ok
    else
      render json: { error: "Answer was not deleted"}
    end 
  end

  private 

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
  	@question = Question.with_attached_files.find(params[:question_id])
  end

  def answer_params
  	params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end
