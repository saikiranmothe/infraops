class String

  # To get string of required length
  def req_length_string(min, max)
    req_string = (self.length < min) ? self.rjust(min,'O') : self
    req_string = (req_string.length > max) ? req_string[0,max] : req_string
    req_string
  end

end