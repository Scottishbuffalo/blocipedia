class ChargesController < ApplicationController

  after_action :upgrade_account, only: [:create]


  def create
    # authorization for signed in user to upgrade.
    authorize :charges, :create?

    #creates a stripe customer object for associating with the charges
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id, #not user.id
      amount: 15_00,
      description: "Blocipedia Membership - #{current_user.email}",
      currency: 'usd'
    )

    flash[:notice] = "Thank you for upgrading, #{current_user.email}! You are now a premium member."

    redirect_to root_path

    rescue Stripe::CardError => e
        flash[:alert] = e.message
        redirect_to new_charge_path
    end

  def new
    authorize :charges, :new?

    if current_user.role == 'premium'
      flash[:alert] = "You are already a premium member"
      redirect_to root_path
    end

    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Blocipedia Membership - #{current_user.email}",
      amount: 15_00
    }
  end

  private

  def upgrade_account
      current_user.update_attribute(:role, 'premium')
  end
end
  @stripe_btn_data = {
    key: "#{ Rails.configuration.stripe[:publishable_key] }",
    description: "BigMoney Membership - #{current_user.name}",
    amount: Amount.default
  }
end
