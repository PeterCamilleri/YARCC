# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Runtime
module RCCK

  # Used to read parse grammar source code from strings.
  class StringSource
    attr_accessor :posn

    def initialize(source_string)
      @posn = -1
      @source_string = source_string
      @length = @source_string.length
    end

    def peek
      if @posn < 0
        :bof
      elsif posn < @length
        @source_string[@posn]
      else
        :eof
      end
    end

    def get
      result = peek
      skip
      result
    end

    def skip
      @posn += 1
    end
  end

end
