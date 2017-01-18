class CollaborationsController < ApplicationController

  def new
    @collaborations = Collaboration.new
    authorize @collaborations
  end


  def create
    authorize @collaborations

    wiki = Wiki.find(params[:wiki_id])
    @collaborations = wiki.collaborators.build(user_id: params[:user_id])

    if @collaborations.save
      flash[:alert] = "Collaborator Added"
      redirect_to wiki
    else
      flash[:notice] = "Collaborator unable to be added. Try again"
      render :show
    end
  end

end
