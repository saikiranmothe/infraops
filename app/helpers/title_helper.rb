module TitleHelper
  
  def set_heading(heading)
    @heading = heading
  end
  
  def set_title(title)
    @title = title
  end
  
  def title
    @title || "Q-Dash"
  end
  
end
