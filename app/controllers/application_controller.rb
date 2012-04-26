class ApplicationController < ActionController::Base
  protect_from_forgery
    
  helper_method :current_user, :current_user?, :ensure_not_answered, :answer_text
  
  private
  
  def authenticate
      redirect_to login_url, :notice => "Please signin." unless current_user != nil
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def ensure_not_answered
    @question = Question.find(params[:question_id])
    current_answer = @question.answers.where(:user_id => current_user)
    redirect_to questions_path unless current_answer.blank?
  end
  
  def answer_text(answer)
    if answer.nil?
      ""
    elsif answer.response.nil?
      "No Response"
    elsif answer.response
      "Yes"
    else
      "No"
    end
  end
  
end
