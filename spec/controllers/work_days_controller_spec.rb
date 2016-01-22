require 'rails_helper'

RSpec.describe WorkDaysController, type: :controller do
  describe '#index' do
    it 'returns a successful 200 response' do
      get :index, date: Time.current.to_s
      expect(response).to be_success
    end
  end
end
