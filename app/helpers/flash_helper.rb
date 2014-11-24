module FlashHelper
  
  ## This function will set a flash message depending up on the request type (ajax - xml http or direct http)
  ## example : store_flash_message("The message has been sent successfully", :success)
  def store_flash_message(message, type)
    if request.xhr?
      flash.now[type] = message
    else
      flash[type] = message
    end
  end
  
end
