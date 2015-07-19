require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:item) {
    create :item
  }
  
  let(:line_item) {
    build :line_item
  }
  
  let(:valid_attributes) {
    {line_items_attributes:[{item_id: item.id, quantity: 2}]}
  }

  let(:invalid_attributes) {
    {line_items_attributes:[{item_id: "foo", quantity: "nothing here"}]}
  }

  let(:order) {create :order, line_items: [line_item]  }

  context "When logged in" do
    
    login_user
    
    describe "GET #index" do
      it "assigns all orders as @orders" do
        get :index
        expect(assigns(:orders)).to eq([order])
      end
    end
  
    describe "GET #show" do
      it "assigns the requested order as @order" do
        get :show, {id: order.to_param}
        expect(assigns(:order)).to eq(order)
      end
    end
  
    describe "GET #new" do
      it "assigns a new order as @order" do
        get :new, {}
        expect(assigns(:order)).to be_a_new(Order)
      end
    end
  
    describe "GET #edit" do
      it "assigns the requested order as @order" do
        get :edit, {id: order.to_param}
        expect(assigns(:order)).to eq(order)
      end
    end
  
    describe "POST #create" do
      context "with valid params" do
        it "creates a new Order" do
          expect {
            post :create, {order: valid_attributes}
          }.to change(Order, :count).by(1)
        end
  
        it "assigns a newly created order as @order" do
          post :create, {order: valid_attributes}
          expect(assigns(:order)).to be_a(Order)
          expect(assigns(:order)).to be_persisted
        end
  
        it "redirects to the created order" do
          post :create, {order: valid_attributes}
          expect(response).to redirect_to(Order.last)
        end
      end
  
      context "with invalid params" do
        it "assigns a newly created but unsaved order as @order" do
          post :create, {order: invalid_attributes}
          expect(assigns(:order)).to be_a_new(Order)
        end
  
        it "re-renders the 'new' template" do
          post :create, {order: invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end
  
    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {line_items_attributes:[{id: line_item.id, item_id: item.id, quantity: 4}]}
        }
  
        it "updates the requested order" do
          line_item.save
          put :update, {id: order.to_param, order: new_attributes}
          order.reload
          expect(order.line_items.first.item_id).to eq new_attributes[:line_items_attributes][0][:item_id]
          expect(order.line_items.first.quantity).to eq new_attributes[:line_items_attributes][0][:quantity]
        end
  
        it "assigns the requested order as @order" do
          put :update, {id: order.to_param, order: valid_attributes}
          expect(assigns(:order)).to eq(order)
        end
  
        it "redirects to the order" do
          put :update, {id: order.to_param, order: valid_attributes}
          expect(response).to redirect_to(order)
        end
      end
  
      context "with invalid params" do
        let(:new_invalid_attributes) {
          {line_items_attributes:[{id: line_item.id, item_id: item.id, quantity: 0}]}
        }
        it "assigns the order as @order" do
          put :update, {id: order.to_param, order: invalid_attributes}
          expect(assigns(:order)).to eq(order)
        end
  
        it "re-renders the 'edit' template" do
          put :update, {id: order.to_param, order: new_invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end
  
    describe "DELETE #destroy" do
      it "destroys the requested order" do
        order #Let block doesn't happen until asked for
        expect {
          delete :destroy, {id: order.to_param}
        }.to change(Order, :count).by(-1)
      end
  
      it "redirects to the orders list" do
        delete :destroy, {id: order.to_param}
        expect(response).to redirect_to(orders_url)
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
        get :show, {id: order.to_param}
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
        get :edit, {id: order.to_param}
        expect(response).to redirect_to(sign_in_url)
      end
    end
  
    describe "POST #create" do
      context "with valid params" do
        it "does not create a new Order" do
          expect {
            post :create, {order: valid_attributes}
          }.to change(Order, :count).by(0)
        end
      end
  
      it "redirects to login page" do
        post :create, {order: valid_attributes}
        expect(response).to redirect_to(sign_in_url)
      end
    end
  
    describe "PUT #update" do
      let(:new_attributes) {
        {line_items_attributes:[{item_id: item.id, quantity: 4}]}
      }
      
      context "with valid params" do  
        it "does not update the requested order" do
          put :update, {id: order.to_param, order: new_attributes}
          order.reload
          expect(order.line_items.first.item_id).not_to eq new_attributes[:line_items_attributes][0][:item_id]
          expect(order.line_items.first.quantity).not_to eq new_attributes[:line_items_attributes][0][:quantity]
        end
      end
  
      it "redirects to login page" do
        put :update, {id: order.to_param, order: new_attributes}
        expect(response).to redirect_to(sign_in_url)
      end
    end
  
    describe "DELETE #destroy" do
      it "does not destroy the requested order" do
        order
        expect {
          delete :destroy, {id: order.to_param}
        }.to change(Order, :count).by(0)
      end
  
      it "redirects to login page" do
        delete :destroy, {id: order.to_param}
        expect(response).to redirect_to(sign_in_url)
      end
    end
    
  end
end
