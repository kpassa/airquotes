# -*- coding: utf-8 -*-
module ApplicationHelper

  def include_stylesheet(*sources)
    content_for :head do
      stylesheet_link_tag( *sources )
    end
  end

  def body_class
    logged_in? ? "logged_in" : "logged_out"
  end

  def estimates_menu
    menu = ''.html_safe
    Product.active.where( :country_id => current_user.country ).group_by(&:program_id).each do |program_id, products|
      menu += content_tag :li, :class =>  "has_nested", :id => "cotizaciones" do
        menu_item = ''
        program = Program.find(program_id)
        menu_item += link_to( "+ #{program.name}", "#" )
        menu_item += content_tag :ul do
          products.map(&:coverage).inject('') { |str, coverage| str += content_tag( :li, link_to( coverage.name, new_estimate_path( program_id: program.id, coverage_id: coverage ) ) ) }.html_safe
        end
        menu_item.html_safe
      end
    end
    menu.html_safe
  end

end
