class QuestionsController < ApplicationController
   include Twitter::Extractor
   
   before_filter :authenticate
  
  # GET /questions
  # GET /questions.json
  def index
    
    per_page = 15
    
    if params[:search].blank?
      @questions = Question.paginate :per_page => per_page, :page => params[:page]
    else
      tags = params[:search].strip.split(' ')
      @questions = Question.tagged_with(tags, :any => true).paginate :per_page => per_page, :page => params[:page]
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    
    per_page = 15
    
    @question = Question.find(params[:id])
    @answers = @question.answers.paginate :per_page => per_page, :page => params[:page]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    @question = current_user.questions.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end
  
  # POST /questions
  # POST /questions.json
  def create
    @question = current_user.questions.build(params[:question]) 
    @question.tag_list = extract_hashtags(@question.title).join(",")

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render json: @question, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question = current_user.questions.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end
end
