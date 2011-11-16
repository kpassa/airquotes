class Letter < ActiveRecord::Base
  belongs_to :program
  has_one :estimate

  # Returns letter text in HTML format
  def html( vars = {}, &block )
    header_html( vars ) + body_html( vars, &block ) + footer_html( vars )
  end

  def header_html( vars )
    self.class.render_string( header, vars )
  end

  def body_html( vars, &block )
    self.class.render_string( body_1 + yield + body_2 , vars )
  end

  def footer_html( vars )
    self.class.render_string( footer.to_s, vars )
  end

  def self.render_string(string, params)  
    erb = string.to_s
    params.keys.each do |key|
      erb.gsub!(/<(#{key})>/,"<%= #{key} %>")
    end

    view = ActionView::Base.new(ActionController::Base.view_paths, {})  
  
    class << view  
      include ApplicationHelper, FeeCalcsHelper
    end
    
    view.render(:inline => erb, :locals => params)
  end


end
