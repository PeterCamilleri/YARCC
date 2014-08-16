# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Runtime
module RCCK
  # Process an optional entry.
  class ZeroOrOne
    attr_reader :children

    def initialize(child)
      @children = [child]
    end

    # Attempt to parse this optional expression.
    # All parse methods return a true/false value to indicate success/failure.
    def parse(parse_info)
      @children[0].parse(parse_info)
      true
    end

  end

end