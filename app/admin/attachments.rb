# -*- coding: utf-8 -*-
ActiveAdmin.register Attachment do

  scope :for_active_products
  
  index :as => :grid do |attachment|
    link_to( image_tag( "pdf.png" ), attachment.payload.url ) +    
      content_tag( :h3, attachment.payload_file_name ) + 
      content_tag( :h3, sprintf( "%.2f MB",attachment.payload_file_size / 1.megabyte ) ) + 
      link_to( "eliminar", admin_attachment_path( attachment ), method: :delete, confirm: "Borrar este adjunto?" )
  end
  
end
