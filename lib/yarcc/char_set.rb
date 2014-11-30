# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Runtime
module RCCK

  # A terminal used to match input from a set of characters.
  class CharSet

    # Create a char set!
    def initialize(add, remove=[])
      @char_set = Hash.new(add == :any)
      process_specs(add, true) unless @char_set.default
      process_specs(remove, false)
    end

    def process_specs(specs, value)
      specs.spread_value(@char_set, value)
      self
    end

    # Enumerate all of the values that are included.
    def each(&block)
      fail "Forbidden operation" if @char_set.default

      if block_given?
        @char_set.each do |key, value|
          block.call(key) if value
        end
      else
        self.to_enum(:each)
      end
    end

    # Send char set data to the destination.
    def spread_value(dest, value)
      if @char_set.default && value
        dest.default = true

        @char_set.each do |key, char_set_value|
          dest[key] = false unless char_set_value
        end
      else
        self.each do |key|
          dest[key] = value
        end
      end
    end

    # Char set addition and subtraction
    def add!(source)
      fail "Cannot iterate over an 'any' char set" if @char_set.default
      source.spread_value(@char_set, true)
      self
    end

    def add(source)
      self.dup.dup_char_set.add!(source)
    end

    def remove!(source)
      source.spread_value(@char_set, false)
      self
    end

    def remove(source)
      self.dup.dup_char_set.remove!(source)
    end

    # Parsing routines and helpers
    def parse(parse_info)
      result = peek(parse_info)
      parse_info.skip if result
      result
    end

    def peek(parse_info)
      @char_set[parse_info.peek]
    end

    def dup_char_set
      @char_set = @char_set.dup
      self
    end
  end
end
