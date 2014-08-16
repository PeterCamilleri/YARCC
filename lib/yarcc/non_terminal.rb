# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Runtime
module RCCK

  # A parser grammar non-terminal entity.
  class NonTerminal
    attr_accessor :name
    attr_reader   :value

    def value=(obj)
      fail "Invalid redefinition of <#{@name}>" if @value
      @value = obj
    end

    # Set up this non-terminal entity.
    def initialize(name, value=nil)
      @name, @value = name, value
    end

    def parse(parse_info)
      value.parse(parse_info)
    end
  end

end
