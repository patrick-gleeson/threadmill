require 'rails_helper'

RSpec.describe StocksController, type: :controller do
  let(:valid_attributes) do
    { name: 'Some Stock', level: 500, unit: 'metres' }
  end

  let(:invalid_attributes) do
    { name: '', level: 'Five', unit: '' }
  end

  context 'When logged in' do
    login_user

    describe 'GET #index' do
      it 'assigns all stocks as @stocks' do
        stock = create(:stock)
        get :index
        expect(assigns(:stocks)).to eq([stock])
      end
    end

    describe 'GET #show' do
      it 'assigns the requested stock as @stock' do
        stock = create(:stock)
        get :show, id: stock.to_param
        expect(assigns(:stock)).to eq(stock)
      end
    end

    describe 'GET #new' do
      it 'assigns a new stock as @stock' do
        get :new
        expect(assigns(:stock)).to be_a_new(Stock)
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested stock as @stock' do
        stock = create(:stock)
        get :edit, id: stock.to_param
        expect(assigns(:stock)).to eq(stock)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Item' do
          expect do
            post :create, stock: valid_attributes
          end.to change(Stock, :count).by(1)
        end

        it 'assigns a newly created stock as @stock' do
          post :create, stock: valid_attributes
          expect(assigns(:stock)).to be_a(Stock)
          expect(assigns(:stock)).to be_persisted
        end

        it 'redirects to the created stock' do
          post :create, stock: valid_attributes
          expect(response).to redirect_to(Stock.last)
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved stock as @stock' do
          post :create, stock: invalid_attributes
          expect(assigns(:stock)).to be_a_new(Stock)
        end

        it "re-renders the 'new' template" do
          post :create, stock: invalid_attributes
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          { name: 'New Stock', level: 600, unit: 'kilos' }
        end

        it 'updates the requested stock' do
          stock = create(:stock)
          put :update, id: stock.to_param, stock: new_attributes
          stock.reload
          expect([stock.name, stock.level, stock.unit]).to eq [new_attributes[:name], new_attributes[:level], new_attributes[:unit]]
        end

        it 'assigns the requested stock as @stock' do
          stock = create(:stock)
          put :update, id: stock.to_param, stock: valid_attributes
          expect(assigns(:stock)).to eq(stock)
        end

        it 'redirects to the stock' do
          stock = create(:stock)
          put :update, id: stock.to_param, stock: valid_attributes
          expect(response).to redirect_to(stock)
        end
      end

      context 'with invalid params' do
        it 'assigns the stock as @stock' do
          stock = create(:stock)
          put :update, id: stock.to_param, stock: invalid_attributes
          expect(assigns(:stock)).to eq(stock)
        end

        it "re-renders the 'edit' template" do
          stock = create(:stock)
          put :update, id: stock.to_param, stock: invalid_attributes
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested stock' do
        stock = create(:stock)
        expect do
          delete :destroy, id: stock.to_param
        end.to change(Stock, :count).by(-1)
      end

      it 'redirects to the stocks list' do
        stock = create(:stock)
        delete :destroy, id: stock.to_param
        expect(response).to redirect_to(stocks_url)
      end
    end
  end

  context 'When logged out' do
    let(:sign_in_url) do
      new_user_session_path
    end

    describe 'GET #index' do
      it 'redirects to login page' do
        get :index
        expect(response).to redirect_to(sign_in_url)
      end
    end

    describe 'GET #show' do
      it 'redirects to login page' do
        stock = create(:stock)
        get :show, id: stock.to_param
        expect(response).to redirect_to(sign_in_url)
      end
    end

    describe 'GET #new' do
      it 'redirects to login page' do
        get :new
        expect(response).to redirect_to(sign_in_url)
      end
    end

    describe 'GET #edit' do
      it 'redirects to login page' do
        stock = create(:stock)
        get :edit, id: stock.to_param
        expect(response).to redirect_to(sign_in_url)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'does not create a new Item' do
          expect do
            post :create, stock: valid_attributes
          end.to change(Stock, :count).by(0)
        end
      end

      it 'redirects to login page' do
        post :create, stock: valid_attributes
        expect(response).to redirect_to(sign_in_url)
      end
    end

    describe 'PUT #update' do
      let(:new_attributes) do
        { name: 'Updated Menu Item', price_dollars: '1.50' }
      end

      context 'with valid params' do
        it 'does not update the requested stock' do
          stock = create(:stock)
          put :update, id: stock.to_param, stock: new_attributes
          stock.reload
          expect([stock.name, stock.level, stock.unit]).not_to eq [new_attributes[:name], new_attributes[:level], new_attributes[:unit]]
        end
      end

      it 'redirects to login page' do
        stock = create(:stock)
        put :update, id: stock.to_param, stock: new_attributes
        stock.reload
        expect(response).to redirect_to(sign_in_url)
      end
    end

    describe 'DELETE #destroy' do
      it 'does not destroy the requested stock' do
        stock = create(:stock)
        expect do
          delete :destroy, id: stock.to_param
        end.to change(Item, :count).by(0)
      end

      it 'redirects to login page' do
        stock = create(:stock)
        delete :destroy, id: stock.to_param
        expect(response).to redirect_to(sign_in_url)
      end
    end
  end
end
