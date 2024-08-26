require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:order) { create(:order, user: user) }
  let(:product) { create(:product) }
  let(:order_item) { create(:order_item, order: order, product: product, quantity:3) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:current_order).and_return(order)
  end

  describe 'POST #create' do
    context 'when quantity does not exceed stock' do
      it 'adds the item to the cart and reduces stock' do
        post :create, params: { order_item: { product_id: product.id, quantity: 3 } }

        expect(order.order_items.count).to eq(1)
        expect(order.order_items.first.quantity).to eq(3)
        expect(product.reload.stock).to eq(47)
      end
    end

    context 'when quantity exceeds stock' do
      it 'does not add the item to the cart' do
        post :create, params: { order_item: { product_id: product.id, quantity: 55 } }

        expect(order.order_items.count).to eq(0)
        expect(product.reload.stock).to eq(50)
        expect(response).to redirect_to(product_path(product, order_item_product_id: product.id))
      end
    end
  end

  describe 'PUT #update' do
    context 'when updating quantity within available stock' do
      it 'updates the order item and the stock' do
        put :update, params: { id: order_item.id, order_item: { quantity: 4 } }

        expect(order_item.reload.quantity).to eq(4)
        expect(product.reload.stock).to eq(49)
        expect(response).to redirect_to(carts_path)
      end
    end

    context 'when updating quantity beyond available stock' do
      it 'does not update the order item' do
        put :update, params: { id: order_item.id, order_item: { quantity: 55 } }

        expect(order_item.reload.quantity).to eq(3)
        expect(product.reload.stock).to eq(50)
        expect(response).to redirect_to(carts_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'removes the order item and restores stock' do
      delete :destroy, params: { id: order_item.id }, format: :js

      expect(order.order_items.count).to eq(0)
      expect(product.reload.stock).to eq(53)
    end
  end
end
