class SubscribersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @stripe_list = Stripe::Plan.all
    @plans = @stripe_list[:data]
  end

  def new
  end

  def update

    token = params[:stripeToken]
    plan_id = params[:plan_id]
    plan = Stripe::Plan.retrieve(plan_id)
    role = params[:role]
    proration_date = Time.now.to_i


    if current_user.subscribed
      customer = Stripe::Customer.retrieve(current_user.stripeid)
      sub_id = customer['subscriptions']['data'][0]['id']

      subscription = Stripe::Subscription.retrieve(current_user.subscription_id)
      subscription.plan = plan_id
      subscription.prorate = true
      subscription.proration_date = proration_date
      subscription.save
    else
      customer = Stripe::Customer.create(
          card: token,
          plan: plan,
          email: current_user.email
      )

      sub = Stripe::Customer.retrieve(customer.id)
      sub_id = sub['subscriptions']['data'][0]['id']
    end

    current_user.subscribed = true
    current_user.stripeid = customer.id
    current_user.planid = plan_id
    current_user.role = role
    current_user.subscription_id = sub_id
    current_user.save

    redirect_to user_path(current_user.id), :notice => "You are now a #{role} member!"

  end

  def destroy

    token = params[:stripeToken]
    plan_id = '1001'
    plan = Stripe::Plan.retrieve(plan_id)
    role = 'member'
    proration_date = Time.now.to_i


    if current_user.subscribed
      customer = Stripe::Customer.retrieve(current_user.stripeid)
      sub_id = customer['subscriptions']['data'][0]['id']

      subscription = Stripe::Subscription.retrieve(current_user.subscription_id)
      subscription.plan = plan_id
      subscription.prorate = true
      subscription.proration_date = proration_date
      subscription.save
    else
      customer = Stripe::Customer.create(
          card: token,
          plan: plan,
          email: current_user.email
      )

      sub = Stripe::Customer.retrieve(customer.id)
      sub_id = sub['subscriptions']['data'][0]['id']
    end

    current_user.subscribed = true
    current_user.stripeid = customer.id
    current_user.planid = plan_id
    current_user.role = role
    current_user.subscription_id = sub_id
    current_user.save

    redirect_to user_path(current_user.id), :notice => "You are now a basic member!"
  end
end
