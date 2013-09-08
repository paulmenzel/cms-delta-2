module ContentsHelper



  def cetform content, content_element_type

      ausgabe   = ''

      value     = ''
      css       = ''

      identifier = "content_elements[add][#{content_element_type.id}]"
      
      ce = content.value(content_element_type.id, @locale)
      if ce 
        identifier = "content_elements[update][#{ce.id}]"
        value = ce.value
      end
  


      
    
    css << ' inline_documents' if content_element_type.inline_documents

    


    case content_element_type.simple_form
      when 'ContentType'

        content_type = @project.content_types.where(:intern => content_element_type.intern).first
        collection = []
        content_type.contents.each do |content|
          collection << [content.rep(@locale), content.id]
        end

        ausgabe = select_tag identifier, options_for_select(collection, value), :include_blank => true, :class => "input-block-level"


      when 'textarea'
        css << ' redactor' if content_element_type.wysiwyg
        css << ' html' if content_element_type.html
        ausgabe = text_area_tag identifier, value, :rows => content_element_type.rows, :class => "input-block-level #{css}"


      when 'boolean'
        ausgabe = ausgabe + hidden_field_tag( identifier, 'false') 
        ausgabe = ausgabe + check_box_tag( identifier, 'true', ((value.blank? || value == 'false') ? false : true) )
        ausgabe = raw ausgabe


      when 'date'
        ausgabe = raw "<div class='input-append date' data-date='#{value}' data-date-format='dd-mm-yyyy'>#{ text_field_tag identifier, value, :class =>  "span2 datepicker" }<span class='add-on muted'>#{Time.zone.now.to_date}</span></div>" 


      when 'time'
        ausgabe = raw "<div class='input-append time'>#{ text_field_tag identifier, value, :class =>  "span2 timepicker" }<span class='add-on muted'>#{Time.zone.now.strftime('%H:%M')}</span></div>" 


      else
        ausgabe = text_field_tag identifier, value, :class =>  "input-block-level"


    end
  
  
    return ausgabe
  end



end
