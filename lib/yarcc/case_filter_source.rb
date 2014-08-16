# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Runtime
module RCCK

  # A wrapper for case insensitive parsing.
  class CaseFilterSource

    def initialize(source)
      @source = source
    end

    def peek
      @source.peek.upcase
    end

    def get
      @source.get.upcase
    end

    def posn
      @source.posn
    end

    def posn=(value)
      @source.posn = value
    end

  end
end
