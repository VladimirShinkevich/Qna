class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: %i[show edit update destroy]
  after_action :publish_question, only: [:create]
  
  def index
    authorize Question
    @questions = Question.all
  end

  def new
    authorize Question
    @question = current_user.questions.new
    @question.links.new
    @question.build_award
  end

  def show
    authorize @question
    @answer = Answer.new(question: @question)
    @answer.links.new
  end

  def edit; end

  def create
    authorize Question
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question is successfuly created.'
    else
      render :new
    end
  end

  def update
    authorize @question
    @question.update(question_params)
  end

  def destroy
    authorize @question
    @question.destroy 
    redirect_to questions_path, notice: "You question was successfuly deleted!"
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, award_attributes: [:id, :name, :image, :_destroy], files: [], 
      links_attributes: [:id, :name, :url, :_destroy])
  end  

  def publish_question
    return if @question.errors.any? 

    question_pub = ApplicationController.render(
      partial: "questions/question_pub",
      locals: { question: @question },
    )

    ActionCable.server.broadcast("questions", { question_pub: question_pub })
  end
end
