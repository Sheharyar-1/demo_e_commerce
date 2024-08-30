class CartsController < ApplicationController
  def show
    @order_items = current_order.order_items
  end

  def placed
    @order = current_order

    if @order.in_progress?
      customer = find_or_create_customer(@order.user.email)

      @order.update(order_params.merge(status: :placed))
      
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        customer: customer.id,
        line_items: @order.order_items.map do |item|
          {
            price_data: {
              currency: 'usd',
              product_data: {
                name: item.product.name,
              },
              unit_amount: (item.unit_price * 100).to_i,
            },
            quantity: item.quantity,
          }
        end,
        mode: 'payment',
        success_url: success_carts_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: cancel_carts_url,
      )

      redirect_to session.url, allow_other_host: true
    else
      redirect_to carts_path, alert: 'Order cannot be placed.'
    end
  end

  def success
    redirect_to root_path, notice: 'Payment successful! Thank you for your order.'
  end  

  def cancel
    redirect_to carts_path, alert: 'Payment was cancelled. Please try again.'
  end

  def address
    @order = current_order
  end

  private

  def order_params
    params.require(:order).permit(:shipping, :billing)
  end

  def find_or_create_customer(email)
    existing_customers = Stripe::Customer.list(email: email).data

    if existing_customers.any?
      existing_customers.first
    else
      Stripe::Customer.create(
        email: email,
        name: @order.user.name,
      )
    end
  end
end
