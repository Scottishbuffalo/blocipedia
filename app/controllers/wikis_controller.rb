class WikisController < ApplicationController
  include ApplicationHelper
  def index
    @wiki = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    @wiki.assign_attributes(wiki_params)
    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to wikis_path
    else
      flash.now[:alert] = "There was an error deleting the wiki."
      render :show
    end
  end


  def add_collaborator
    authorize :collaboration, :create?

    user_email = params[:email]
    user_id = User.where(email: user_email).pluck(:id)
    user = User.where(id: user_id)
    @wiki = Wiki.find(params[:id])

    if collaborations = @wiki.collaborators << user && user.exists?
      flash[:notice] = "Collaborator Added"
    elsif @wiki.collaborators.exists?
      flash[:alert] = "Collaborator already exists."
    else
      flash[:alert] = "Collaborator unable to be added. Try again"
    end
    redirect_to @wiki
  end

  def remove_collaborator
    wiki = Wiki.find(params[:id])
    authorize :collaboration, :destroy?

    collaborator_id = params[:collaborator_id]

    if collaborations.destroy
      flash[:notice] = "Collaborator Removed"
    else
      flash[:alert] = "Collaborator not removed. Try again"
    end
    redirect_to @wiki
  end

  private

  def authorize_user
    unless current_user
      flash[:alert]= "You must be logged in to do that. Sign up or log in now!"
      redirect_to root_path
    end
  end

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
