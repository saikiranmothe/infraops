module DisplayHelper
  
  def scrap_word(text, char_count_limit, more_text = nil, more_link = nil,style='')
    # remove HTML tags
    text = text.to_s.gsub(/<\/?[^>]*>/, " ")
    # remove additional spaces
    text = text.to_s.gsub(/[ ]+/, " ")
    if text.length < char_count_limit
      return text
    end
    teaser = ""
    words = text.split(/ /)
    words.each do |word|
      if word.length > 0
        if (teaser + word).length > char_count_limit
          if more_text && more_link
            teaser = teaser + " " + link_to(more_text, more_link,:style=>style, :target=>"_blank")
          else
            teaser = teaser.strip + "..."
          end
          break;
        else
          teaser = teaser + word + " "
        end
      end
    end
    return teaser
  end

  def display_time(disp_time, class_name = nil)
    return distance_of_time_in_words_to_now(disp_time) + " ago"
    # return_str = ""
    # if ((Time.now - disp_time) < (6*24*60*60))
    #   return_str = distance_of_time_in_words_to_now(disp_time) + " ago"
    # else
    #   return_str = "#{disp_time.strftime('%m/%d/%y')}"
    # end
    # 
    # return content_tag("span", return_str, :class => (class_name.nil? ? "text-color-grey" : class_name))
  end
  
end