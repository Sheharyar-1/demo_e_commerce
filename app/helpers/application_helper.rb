module ApplicationHelper
  def current_order
    if session[:order_id]
      order = current_user.order.find_by(id: session[:order_id])
      if order.nil? || order.placed?
        order = current_user.order.new
        session[:order_id] = order.id
      end
    else
      order = current_user.order.new
      session[:order_id] = order.id
    end
    order
  end
  
end
