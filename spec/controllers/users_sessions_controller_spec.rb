require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:user) { FactoryBot.create(:user, password: 'Password123!') }

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'sends two-factor authentication code and redirects to two_factor_path' do
        post :create, params: { user: { email: user.email, password: 'Password123!' } }
        expect(response).to redirect_to(user_two_factor_path)
      end
    end

    context 'with invalid credentials' do
      it 'renders the new template' do
        post :create, params: { user: { email: user.email, password: 'wrongpassword' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #verify_two_factor' do
    before do
      post :create, params: { user: { email: user.email, password: 'Password123!' } }
      session[:pre_2fa_user_id] = user.id
    end

    context 'with valid two-factor code' do
      it 'authenticates the user and redirects to root_path' do
        allow_any_instance_of(User).to receive(:verify_two_factor_code).and_return(true)
        post :verify_two_factor, params: { code: '123456' }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid two-factor code' do
      it 'redirects to user_two_factor_path with alert' do
        allow_any_instance_of(User).to receive(:verify_two_factor_code).and_return(false)
        post :verify_two_factor, params: { code: 'invalid_code' }
        expect(response).to redirect_to(user_two_factor_path)
        expect(flash[:alert]).to eq('Invalid two-factor code')
      end
    end
  end

  describe 'POST #resend_two_factor_code' do
    before do
      post :create, params: { user: { email: user.email, password: 'Password123!' } }
      session[:pre_2fa_user_id] = user.id
    end

    it 'resends the two-factor code and redirects to user_two_factor_path' do
      post :resend_two_factor_code
      expect(response).to redirect_to(user_two_factor_path)
      expect(flash[:notice]).to eq('A new two-factor code has been sent to your email.')
    end
  end

  describe 'POST #cancel_two_factor' do
    before do
      post :create, params: { user: { email: user.email, password: 'Password123!' } }
      session[:pre_2fa_user_id] = user.id
    end

    it 'cancels two-factor authentication and redirects to new_user_session_path' do
      post :cancel_two_factor
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to eq('Two-factor authentication was cancelled.')
    end
  end
end