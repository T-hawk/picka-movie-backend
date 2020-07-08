require 'rails_helper'

RSpec.describe MovieSessionController, :type => :controller do
  describe "POST #create" do
    context "with valid parameters" do
      it "creates movie session" do
        user = create(:user)

        post :create, params: { ids: [454626, 419704, 475430], user: { id: user.id, token: user.token } }

        expect(MovieSession.count).to be 1
      end
    end

    context "with invalid parameters" do
      it "does not create movie session" do
        user = create(:user)

        # invalid user id
        post :create, params: { ids: [454626, 419704, 475430], user: { id: -1, token: user.token } }
        expect(MovieSession.count).to be 0

        # invalid user token
        post :create, params: { ids: [454626, 419704, 475430], user: { id: user.id, token: "invalid" } }
        expect(MovieSession.count).to be 0
      end
    end
  end

  describe "POST #join" do
    context "with valid parameters" do
      it "lets user join movie session" do
        movie_session = create(:movie_session)

        user = create(:user)
        post :join, params: { user: { id: user.id, token: user.token}, movie_session_id: movie_session.id, share_token: movie_session.share_token }

        expect(MovieSession.find(movie_session.id).users.count).to be 2
      end
    end

    context "with invalid parameters" do
      it "does not let user join movie session" do
        movie_session = create(:movie_session)

        user = create(:user)

        # invalid session id
        post :join, params: { user: { id: user.id, token: user.token }, movie_session_id: -1, share_token: movie_session.share_token }
        expect(MovieSession.find(movie_session.id).users.count).to be 1

        # invalid token
        post :join, params: { user: { id: user.id, token: user.token }, movie_session_id: movie_session.id, share_token: "invalid" }
        expect(MovieSession.find(movie_session.id).users.count).to be 1

        # invalid user id
        post :join, params: { user: { id: -1, token: user.token }, movie_session_id: movie_session.id, share_token: movie_session.share_token }
        expect(MovieSession.find(movie_session.id).users.count).to be 1

        # invalid user token
        post :join, params: { user: { id: user.id, token: "invalid" }, movie_session_id: movie_session.id, share_token: movie_session.share_token }
        expect(MovieSession.find(movie_session.id).users.count).to be 1
      end
    end
  end

  describe "POST #vote" do
    context "with valid user and session" do
      it "votes on movie" do
        movie_session = create(:movie_session)

        post :vote, params: { user: { id: movie_session.creator.id, token: movie_session.creator.token }, movie_session_id: movie_session.id, tmdb_id: movie_session.movie_refs[0].tmdb_id }
        vote_count = JSON.parse(response.body)[0]["votes"]

        expect(vote_count).to be 1
      end
    end

    context "with invalid user and session" do
      it "does not vote on movie" do
        movie_session = create(:movie_session)

        # invalid user id
        post :vote, params: { user: { id: -1, token: movie_session.creator.token }, movie_session_id: movie_session.id, tmdb_id: movie_session.movie_refs[0].tmdb_id }
        expect(JSON.parse(response.body)["status"]).to be 400

        # invalid user token
        post :vote, params: { user: { id: movie_session.creator.id, token: "invalid" }, movie_session_id: movie_session.id, tmdb_id: movie_session.movie_refs[0].tmdb_id }
        expect(JSON.parse(response.body)["status"]).to be 400

        # invalid session id
        post :vote, params: { user: { id: movie_session.creator.id, token: movie_session.creator.token }, movie_session_id: -1, tmdb_id: movie_session.movie_refs[0].tmdb_id }
        expect(JSON.parse(response.body)["status"]).to be 400

        # movie that is not in session
        post :vote, params: { user: { id: movie_session.creator.id, token: movie_session.creator.token }, movie_session_id: movie_session.id, tmdb_id: 0 }
        expect(JSON.parse(response.body)["status"]).to be 400
      end
    end
  end

  describe "GET #movies" do
    context "with valid user and session" do
      it "returns movies" do
        movie_session = create(:movie_session)

        get :movies, params: { user: { id: movie_session.creator.id, token: movie_session.creator.token }, movie_session_id: movie_session.id }

        expect(JSON.parse(response.body)).to_not be_empty
      end
    end

    context "with invalid user and session" do
      it "returns error" do
        movie_session = create(:movie_session)
        user = create(:user)

        get :movies, params: { user: { id: user.id, token: user.token }, movie_session_id: movie_session.id }

        expect(JSON.parse(response.body)["status"]).to be 403
      end
    end
  end

  describe "GET #results" do
    context "with inactive session" do
      it "returns top voted movie(s)" do
        movie_session = create(:movie_session)
        movie_session.update_attribute(:active, false)

        get :results, params: { movie_session_id: movie_session.id }

        expect(JSON.parse(response.body)).to_not eq({"status" => 400})
      end
    end

    context "with active session" do
      it "returns 400" do
        movie_session = create(:movie_session)

        get :results, params: { movie_session_id: movie_session.id }

        expect(JSON.parse(response.body)["status"]).to be 400
      end
    end
  end
end
