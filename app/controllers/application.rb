# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  def med_format_date date
    date.strftime("%b %d, %y")
  end

  
  def reverse_order?
    if params[:reverse_order]
      if @order_by == 'desc'
        @order_by = 'asc'
      else @order_by = 'desc'
      end
    end
  end

end
