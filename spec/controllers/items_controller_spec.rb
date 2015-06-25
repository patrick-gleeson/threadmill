require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:stock) { create :stock }
  let(:valid_attributes) {
    {name: "Some Menu Item", 
     price_dollars: "1.00",
     stock_effects_attributes:[{stock_id: stock.id, change: 100}]}
  }

  let(:invalid_attributes) {
    {name: "", price_dollars: "Three"}
  }
  
  context "When logged in" do
    
    login_user
    
    describe "GET #index" do
      it "assigns all items as @items" do
        item = create(:item)
        get :index
        expect(assigns(:items)).to eq([item])
      end
    end
  
    describe "GET #show" do
      it "assigns the requested item as @item" do
        item = create(:item)
        get :show, {id: item.to_param}
        expect(assigns(:item)).to eq(item)
      end
    end
  
    describe "GET #new" do
      it "assigns a new item as @item" do
        get :new
        expect(assigns(:item)).to be_a_new(Item)
      end
    end
  
    describe "GET #edit" do
      it "assigns the requested item as @item" do
        item = create(:item)
        get :edit, {id: item.to_param}
        expect(assigns(:item)).to eq(item)
      end
    end
  
    describe "POST #create" do
      context "with valid params" do
        it "creates a new Item" do
          expect {
            post :create, {item: valid_attributes}
          }.to change(Item, :count).by(1)
        end
  
        it "assigns a newly created item as @item" do
          post :create, {item: valid_attributes}
          expect(assigns(:item)).to be_a(Item)
          expect(assigns(:item)).to be_persisted
        end
  
        it "redirects to the created item" do
          post :create, {item: valid_attributes}
          expect(response).to redirect_to(Item.last)
        end
      end
  
      context "with invalid params" do
        it "assigns a newly created but unsaved item as @item" do
          post :create, {item: invalid_attributes}
          expect(assigns(:item)).to be_a_new(Item)
        end
  
        it "re-renders the 'new' template" do
          post :create, {item: invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end
  
    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {name: "Updated Menu Item", price_dollars: "1.50"}
        }
  
        it "updates the requested item" do
          item = create(:item)
          put :update, {id: item.to_param, item: new_attributes}
          item.reload
          expect([item.name, item.price_dollars]).to eq [new_attributes[:name], new_attributes[:price_dollars]]
        end
  
        it "assigns the requested item as @item" do
          item = create(:item)
          put :update, {id: item.to_param, item: valid_attributes}
          expect(assigns(:item)).to eq(item)
        end
  
        it "redirects to the item" do
          item = create(:item)
          put :update, {id: item.to_param, item: valid_attributes}
          expect(response).to redirect_to(item)
        end
      end
  
      context "with invalid params" do
        it "assigns the item as @item" do
          item = create(:item)
          put :update, {id: item.to_param, item: invalid_attributes}
          expect(assigns(:item)).to eq(item)
        end
  
        it "re-renders the 'edit' template" do
          item = create(:item)
          put :update, {id: item.to_param, item: invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end
  
    describe "DELETE #destroy" do
      it "destroys the requested item" do
        item = create(:item)
        expect {
          delete :destroy, {id: item.to_param}
        }.to change(Item, :count).by(-1)
      end
  
      it "redirects to the items list" do
        item = create(:item)
        delete :destroy, {id: item.to_param}
        expect(response).to redirect_to(items_url)
      end
    end
    
  end
  
  context "When logged out" do
    let(:sign_in_url) {
      new_user_session_path
    }
    
    describe "GET #index" do
      it "redirects to login page" do
        get :index
        expect(response).to redirect_to(sign_in_url)
      end
    end
  
    describe "GET #show" do
      it "redirects to login page" do
        item = create(:item)
        get :show, {id: item.to_param}
        expect(response).to redirect_to(sign_in_url)
      end
    end
  
    describe "GET #new" do
      it "redirects to login page" do
        get :new
        expect(response).to redirect_to(sign_in_url)
      end
    end
  
    describe "GET #edit" do
      it "redirects to login page" do
        item = create(:item)
        get :edit, {id: item.to_param}
        expect(response).to redirect_to(sign_in_url)
      end
    end
  
    describe "POST #create" do
      context "with valid params" do
        it "does not create a new Item" do
          expect {
            post :create, {item: valid_attributes}
          }.to change(Item, :count).by(0)
        end
      end
  
      it "redirects to login page" do
        post :create, {item: valid_attributes}
        expect(response).to redirect_to(sign_in_url)
      end
    end
  
    describe "PUT #update" do
      let(:new_attributes) {
        {name: "Updated Menu Item", price_dollars: "1.50"}
      }
      
      context "with valid params" do  
        it "does not update the requested item" do
          item = create(:item)
          put :update, {id: item.to_param, item: new_attributes}
          item.reload
          expect([item.name, item.price_dollars]).not_to eq [new_attributes[:name], new_attributes[:price_dollars]]
        end
      end
  
      it "redirects to login page" do
        item = create(:item)
        put :update, {id: item.to_param, item: new_attributes}
        item.reload
        expect(response).to redirect_to(sign_in_url)
      end
    end
  
    describe "DELETE #destroy" do
      it "does not destroy the requested item" do
        item = create(:item)
        expect {
          delete :destroy, {id: item.to_param}
        }.to change(Item, :count).by(0)
      end
  
      it "redirects to login page" do
        item = create(:item)
        delete :destroy, {id: item.to_param}
        expect(response).to redirect_to(sign_in_url)
      end
    end
    
  end

end
