module EstimatesHelper

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

  def full_name_including_maiden_name(client)
    if client.gender == "femenino"
      if !client.maiden_name || client.maiden_name.empty?
        client.full_name
      else
        client.full_name + " (apellido de soltera: #{client.maiden_name})"
      end
    else
      client.full_name
    end
  end

end
