# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Runtime
module RCCK
  # Process a list of alternatives, with success on the first passing item.
  class Alternative
    attr_reader :children

    def initialize(*children)
      @children = children
    end

    # Attempt to parse this alternative expression.
    # All parse methods return a true/false value to indicate success/failure.
    def parse(parse_info)
      @children.each do |child|
        return true if child.parse(parse_info)
      end

      false
    end

  end

end
