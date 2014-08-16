# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Runtime
module RCCK

  # A parser grammar non-terminal entity.
  class Keyword
    attr_accessor :value

    # Set up this non-terminal entity.
    def initialize(value)
      @value = value
    end

    # Attempt to parse this keyword expression.
    # All parse methods return a true/false value to indicate success/failure.
    def parse(parse_info)
      save = parse_info.try
      #wip
      parse_info.accept
    end

  end

end
