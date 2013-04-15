module Liquid
  class Context
    def self.new(e = {}, s = {}, r = {}, err = true)
      super(e, s, r, true)
    end
  end
end
