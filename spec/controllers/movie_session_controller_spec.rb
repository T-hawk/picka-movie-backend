require 'rails_helper'

RSpec.describe MovieSessionController, :type => :controller do
  describe "POST #create" do
    context "valid parameters" do
      it "creates movie session" do
        user = create(:user)

        post :create, params: { ids: [454626, 419704, 475430], user: { id: user.id, token: user.token } }

        puts response
        expect(response).to be_truthy
      end
    end

    #context "invalid parameters" do
      #it "does not create movie session" do

      #end
    #end
  end
end
