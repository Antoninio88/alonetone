require "rails_helper"

RSpec.describe 'tracks', type: :feature, js: true do
  it 'renders assets#show' do
    visit '/sudara/tracks/song1'
    play_button = find(".play_button a")

    Percy.snapshot(page, name: 'Single Track Page')

    # seek halfway
    # find('.waveform').click
    # Percy.snapshot(page, name: 'Single Track Seeking')
  end

  it 'renders assets#edit' do
    logged_in do
      visit 'arthur/tracks/mass_edit'
      first("input[type='text']").set("New Title")
      akismet_stub_response_ham
      first('input[name="commit"]').click
      first('.ajax_success')
      sleep(1) # wait for the spinner to dissapear, it takes 500ms
      Percy.snapshot(page, name: 'Single Track Edit')
    end
  end
end