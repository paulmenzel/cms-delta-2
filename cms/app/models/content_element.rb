class ContentElement < ActiveRecord::Base

  include ActionView::Helpers::NumberHelper


  belongs_to :content
  belongs_to :content_element_type
  
  
  scope :lang, ->(lang) { where(:language => lang) unless lang.nil? }
  
  
  validates_presence_of :value






    def html
    
      value = self.value
    
      value.gsub!(/\[img:(\d+)(?:\:(\d+))(?:\:(left|right))\]/).each do |doc|
        
        match,id,width,align = $&,$1,$2,$3
        
        doc = replaceImage(id, width, align)
    
      end
    
      value.gsub!(/\[img:(\d+)(?:\:(\d+))\]/).each do |doc|
        
        match,id,width = $&,$1,$2
        
        doc = replaceImage(id, width)
    
      end
    
      value.gsub!(/\[img:(\d+)\]/).each do |doc|
        
        match,id = $&,$1
        
        doc = replaceImage(id)
    
      end
      
      if self.content_element_type.markdown
        return Kramdown::Document.new(value, :auto_ids => false).to_html.html_safe
      else
        return value.html_safe
      end
    
    end
    
    
    def replaceImage(id, width = false, align = false)
      doc = ''

      if document = Document.where('documents.id = ?', id).first

        case document.document_content_type
          when /\Aimage/
            alt     = ''
            popup   = document.document.url(:popup)

            if width
              url = "/uploads/#{document.project.intern}/documents/#{document.id}/width#{width}/#{File.basename(document.document.path(:original))}"
              # width (gesetzt)
            else
              url = document.document.url(:original)
              width = document.width
            end
            # siehe Client
            doc = "<img src=\"#{url}\" alt=\"#{alt}\" width=\"#{width}\" data-popup=\"#{popup}\" #{' class="img'+align+'" ' if align } >"

          when /\Aapplication\/pdf\z/
            alt = '&darr; PDF download'

            doc = "<a title=\"#{alt}\" href=\"#{document.document.url(:original)}\" type=\"application/pdf\"><strong>#{alt}</strong> (#{ number_to_human_size( document.document_file_size) })</a>"              
          else
            doc = ''
        end
        
        doc
        
      end

      return doc

    end







end
