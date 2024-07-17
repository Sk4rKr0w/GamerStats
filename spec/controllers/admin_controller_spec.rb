require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:authenticated_user) { create(:authenticated_user, :admin) }
  let(:user) { create(:user) }

  before do
    sign_in authenticated_user
    allow(controller).to receive(:fully_authenticated?).and_return(true)
    session[:user_id] = authenticated_user.id
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to be_successful
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      get :show, params: { id: user.id }
      expect(response).to be_successful
      expect(response).to render_template(:show)
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit, params: { id: user.id }
      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    before do
      allow_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_later)
      allow_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_now)
    end

    it "updates the user and redirects" do
      patch :update, params: { id: user.id, user: { email: "newemail@example.com" } }
      expect(response).to redirect_to(admin_user_path(user))
      expect(flash[:notice]).to eq('User was successfully updated.')
      expect(user.reload.email).to eq("test@example.com")
    end
  end

  describe "DELETE #destroy" do
    it "deletes the user and redirects" do
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(admin_users_path)
      expect(flash[:notice]).to eq('User was successfully deleted.')
      expect(User.exists?(user.id)).to be_falsey
    end
  end

  describe "POST #ban" do
    it "bans the user and redirects" do
      post :ban, params: { id: user.id, ban_duration: 60 }
      expect(response).to redirect_to(admin_users_path)
      expect(flash[:notice]).to eq('User was successfully banned.')
      expect(user.reload.banned_until).to be_within(1.minute).of(Time.current + 60.minutes)
    end
  end

  describe "GET #warn" do
    it "renders the warn template" do
      get :warn, params: { id: user.id }
      expect(response).to be_successful
      expect(response).to render_template(:warn)
    end
  end

  describe "POST #send_warning" do
    before do
      allow(UserMailer).to receive_message_chain(:warn_user, :deliver_now)
    end

    it "sends a warning to the user and redirects" do
      post :send_warning, params: { id: user.id, message: "This is a warning." }
      expect(response).to redirect_to(admin_users_path)
      expect(flash[:notice]).to eq('User was successfully warned.')
      expect(UserMailer).to have_received(:warn_user).with(user, "This is a warning.")
    end
  end

  describe "POST #promote_to_admin" do
    it "promotes the user to admin and redirects" do
      post :promote_to_admin, params: { id: user.id }
      expect(response).to redirect_to(admin_users_path)
      expect(flash[:notice]).to eq('User was successfully promoted to admin.')
      expect(user.reload.admin?).to be_truthy
    end
  end

  describe "POST #demote_from_admin" do
    it "demotes the user from admin and redirects" do
      user.update(admin: true)
      post :demote_from_admin, params: { id: user.id }
      expect(response).to redirect_to(admin_users_path)
      expect(flash[:notice]).to eq('User was successfully demoted from admin.')
      expect(user.reload.admin?).to be_falsey
    end
  end
end
