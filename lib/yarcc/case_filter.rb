# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Runtime

require_relative "case_filter_source"

module RCCK

  class CaseFilter
    attr_reader :children

    def initialize(child)
      @children = [child]
    end

    # Attempt to parse this expression in upper case.
    # All parse methods return a true/false value to indicate success/failure.
    def parse(parse_info)
      up_source = CaseFilterSource.new(parse_info.src)
      new_info = ParseInfo.new(parse_info.parser, up_source, parse_info.dst)
      @children[0].parse(new_info)
    end

  end

end