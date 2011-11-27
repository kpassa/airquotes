module EstimatesHelper

  def input_unless_ignored(builder, program, field, opts = {})
    unless program.ignored?(field)
      builder.input(field, opts )
    end
  end

  def index_as_table(&block)
    content_tag :div, :class => "paginated_collection" do
      content_tag :div, :class => "pagination_information" do
        content_tag :div, :class => "paginated_collection_contents" do
          content_tag :div, :class => "index_content" do
            yield
          end
        end
      end
    end
  end

end
