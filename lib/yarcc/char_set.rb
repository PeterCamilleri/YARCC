# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Runtime
module RCCK

  # A terminal used to match input from a set of characters.
  class CharSet

    # Create a char set!
    def initialize(add, remove=[])
      @any      = add == :any
      @char_set = Hash.new(@any)

      process_specs(add, true) unless @any
      process_specs(remove, false)
    end

    def process_specs(specs, value)
      specs.each do |spec|
        if spec.is_a?(Symbol)
          @char_set[spec] = value
        elsif spec.is_a?(Range)
          process_range(spec, value)
        else
          process_chars(spec, value)
        end
      end
    end

    def process_range(range,value)
      range.each do |c|
        @char_set[c] = value
      end
    end

    def process_chars(string, value)
      string.chars do |c|
        @char_set[c] = value
      end
    end

    # Enumerate all of the values that are included.
    def each(&block)
      fail "Forbidden operation" if @any

      if block_given?
        @char_set.each do |k,v|
          block.call(k) if v
        end
      else
        self.to_enum(:each)
      end
    end

    # Char set addition and subtraction
    def add!(a_set)
      fail "Forbidden operation" if @any

      a_set.each do |k|
        @char_set[k] = true
      end

      self
    end

    def add(a_set)
      self.dup.add!(a_set)
    end

    def remove!(a_set)
      a_set.each do |k|
        @char_set[k] = false
      end

      self
    end

    def remove(a_set)
      self.dup.remove!(a_set)
    end

    # Parsing routines and helpers
    def parse(parse_info)
      result = peek(parse_info)
      parse_info.dst.skip if result
      result
    end

    def peek(parse_info)
      @char_set[parse_info.dst.peek]
    end
  end
end
