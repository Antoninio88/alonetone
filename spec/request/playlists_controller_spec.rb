
# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlaylistsController, type: :request do
  context "a visitor" do
    it "sees a playlist without a cover image" do
      playlist = playlists(:william_shatners_favorites)
      get "/#{playlist.user.login}/playlists/#{playlist.permalink}"
      expect(response).to be_successful
    end

    it "sees a playlist with an unusable cover image" do
      playlist = playlists(:jamie_kiesl_hates)
      get "/#{playlist.user.login}/playlists/#{playlist.permalink}"
      expect(response).to be_successful
    end

    it "sees a playlist with a cover image" do
      playlist = playlists(:will_studd_rockfort)
      get "/#{playlist.user.login}/playlists/#{playlist.permalink}"
      expect(response).to be_successful
      expect(response.body).to match_css('link[href]')
    end
  end

  context "a musician" do
    let(:user) { users(:jamie_kiesl) }
    before do
      create_user_session(user)
    end

    it "creates a new playlist" do
      post(
        "/Jamiek/playlists",
        params: {
          playlist: {
            title: '🧀 THE FUNK 🧀',
            year: '1999'
          }
        }
      )
      expect(response).to be_redirect
      uri = URI.parse(response.headers['Location'])
      expect(uri.path).to start_with('/Jamiek/playlists')
      expect(uri.path).to end_with('/edit')
    end
  end
end
