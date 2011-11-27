module FeeCalcsHelper
  def indices2coords( i, j )
    FeeCalc.indices2coords( i, j )
  end

  def coords2indices( coords )
    FeeCalc.coords2indices( coords )
  end

  def row_tag(i, first_col, &block)
    row_class = nil
    if first_col =~ /<(header|subheading|total|)>/
      row_class = $~[1]
    end
    content_tag( :tr, :class => row_class, &block )
  end

  def table_cell(content,i,j,currency_symbol="Q")
    if content == "?"
      content_tag :td, :class => "data_cell" do
        content_tag( :span, currency_symbol, :class => "currency_symbol" ) +
          content_tag( :span, "?" + indices2coords( i, j ), :class => "amount" )
      end
    elsif content == "?total"
      content_tag :td, :class => "total_cell" do
        content_tag( :span, currency_symbol, :class => "currency_symbol" ) +
          content_tag( :span, "?total:" + ('a'..'z').to_a[j], :class => "amount" )
      end
    else
      content_tag :td, content
    end

  end
end
