# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Runtime
module RCCK
  # Process an action element.
  class Action
    def children
      []
    end

    def initialize(&block)
      @block = block
    end

    # Attempt to parse this sequence expression.
    # All parse methods return a true/false value to indicate success/failure.
    def parse(parse_info)
      block.call(parse_info)
    end
  end
end
