require 'rails_helper'

RSpec.describe SquadsController, type: :controller do
  include Devise::Test::ControllerHelpers
  
  let(:authenticated_user) { FactoryBot.create(:user) }
  let(:squad) { FactoryBot.create(:squad, :with_players, user: authenticated_user) }

  before do
    sign_in authenticated_user
    allow(controller).to receive(:fully_authenticated?).and_return(true)
    session[:user_id] = authenticated_user.id
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new squad to @squad' do
      get :new
      expect(assigns(:squad)).to be_a_new(Squad)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new squad' do
        expect {
          post :create, params: { squad: FactoryBot.attributes_for(:squad).merge(players_attributes: [FactoryBot.attributes_for(:player)] * 5) }
        }.to change(Squad, :count).by(1)
      end

      it 'redirects to the new squad' do
        post :create, params: { squad: FactoryBot.attributes_for(:squad).merge(players_attributes: [FactoryBot.attributes_for(:player)] * 5) }
        expect(response).to redirect_to(Squad.last)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new squad' do
        expect {
          post :create, params: { squad: FactoryBot.attributes_for(:squad, name: nil) }
        }.to_not change(Squad, :count)
      end

      it 're-renders the new template' do
        post :create, params: { squad: FactoryBot.attributes_for(:squad, name: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: squad.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH #save' do
    it 'updates the squad as saved' do
      patch :save, params: { id: squad.id }
      squad.reload
      expect(squad.saved).to be_truthy
    end

    it 'redirects to the squad' do
      patch :save, params: { id: squad.id }
      expect(response).to redirect_to(squad)
    end
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #my_squads' do
    it 'returns http success' do
      get :my_squads
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { id: squad.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the squad' do
        patch :update, params: { id: squad.id, squad: { name: 'Updated Name' } }
        squad.reload
        expect(squad.name).to eq('Updated Name')
      end

      it 'redirects to the squad' do
        patch :update, params: { id: squad.id, squad: { name: 'Updated Name' } }
        expect(response).to redirect_to(squad)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the squad' do
        patch :update, params: { id: squad.id, squad: { name: nil } }
        squad.reload
        expect(squad.name).to_not be_nil
      end

      it 're-renders the edit template' do
        patch :update, params: { id: squad.id, squad: { name: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET #compare' do
    it 'returns http success' do
      get :compare
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the squad' do
      squad_to_delete = FactoryBot.create(:squad, :with_players, user: authenticated_user)
      expect {
        delete :destroy, params: { id: squad_to_delete.id }
      }.to change(Squad, :count).by(-1)
    end

    it 'redirects to my_squads path' do
      delete :destroy, params: { id: squad.id }
      expect(response).to redirect_to(my_squads_path)
    end
  end
end
