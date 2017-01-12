require 'rails_helper'

RSpec.describe ChargesController, type: :controller do
  let(:user) { User.create!(name: "user name", email: "username@example.com", password: "helloworld", confirmed_at: Time.now) }
  before :each do
    sign_in user
  end
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

end
