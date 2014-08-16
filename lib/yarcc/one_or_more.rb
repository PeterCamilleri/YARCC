# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Runtime
module RCCK
  # Process an optional entry occurring 1 or more times.
  class OneOrMore
    attr_reader :children

    def initialize(child)
      @children = [child]
    end

    # Attempt to parse this optional expression.
    # All parse methods return a true/false value to indicate success/failure.
    def parse(parse_info)
      result = false
      result = true while @children[0].parse(parse_info)
      result
    end

  end

end