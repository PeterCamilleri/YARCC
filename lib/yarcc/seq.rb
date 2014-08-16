# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Runtime
module RCCK
  # Process a sequence of syntax elements, all of which are required.
  class Sequence
    attr_reader :children

    def initialize(*children)
      @children = children
    end

    # Attempt to parse this sequence expression.
    # All parse methods return a true/false value to indicate success/failure.
    def parse(parse_info)
      save = parse_info.try

      @children.each do |child|
        return parse_info.reject(save) unless child.parse(parse_info)
      end

      parse_info.accept
    end
  end
end
