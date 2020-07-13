require 'rails_helper'

RSpec.describe UserController, :type => :controller do
  describe "#POST create" do
    context "with valid attributes" do
      it "creates new user" do
        user = build(:user)
        post :create, :params => { user: { name: user.name, email: user.email, password: user.password, password_confirmation: user.password_confirmation } }
        expect(User.count).to be 1
      end
    end
    context "with invalid attributes" do
      it "does not create user" do
        user = build(:invalid_user)
        post :create, :params => { user: { name: user.name, email: user.email, password: user.password, password_confirmation: user.password_confirmation } }
        expect(User.count).to be 0
      end
    end
  end

  describe "#POST login" do
    context "with valid attributes" do
      it "logs in user" do
        user = create(:user)
        post :login, :params => { user: { email: user.email, password: user.password } }
        expect(response.status).to be 200
      end
    end
    context "with invalid attributes" do
      it "does not log in user" do
        user = create(:user)
        post :login, :params => { user: { email: "fake@email.com", password: user.password } }
        expect(response.status).to be 401
      end
    end
  end

  describe "#GET index" do
    context "returns user" do
      it "creates new user" do
        user = create(:user)
        get :index, :params => { user_id: user.id }
        expect(response.status).to be 200
      end
    end

    context "with invalid attributes" do
      it "does not return user" do
        user = create(:user)

        expect{get :index, :params => { user_id: -1 }}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
