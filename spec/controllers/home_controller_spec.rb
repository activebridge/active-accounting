require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  describe "#index" do
    subject { get :index }

    context 'with current user' do
      before { sign_in :user, user }
      it { is_expected.to be_success }
    end

    #context 'without current user' do
      #it { expect(response).to redirect_to(new_user_session_path) }
    #end
  end
end
