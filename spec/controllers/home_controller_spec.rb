require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  context 'When logged in' do
    login_user

    describe 'GET #index' do
      it 'renders the index view' do
        get :index
        expect(response).to render_template('index')
      end
    end
  end

  context 'When logged out' do
    let(:sign_in_url) do
      new_user_session_path
    end

    describe 'GET #index' do
      it 'redirects to login' do
        get :index
        expect(response).to redirect_to(sign_in_url)
      end
    end
  end
end
