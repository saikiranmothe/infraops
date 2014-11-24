module Utilities
  class RandomString

    attr_accessor :string

    DEFAULT_LENGTH = 50

    def initialize(n = DEFAULT_LENGTH)
      # the available characters
      o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
      # random string
      @string  =  (0...n).map{ o[rand(o.length)] }.join
    end

    def self.alphanumeric(n = DEFAULT_LENGTH)
      # the available characters
      o =  [('a'..'z'),('A'..'Z'),('0'..'9'),['-','_']].map{|i| i.to_a}.flatten
      # random string
      @string  =  (0...n).map{ o[rand(o.length)] }.join
    end

  end
end
