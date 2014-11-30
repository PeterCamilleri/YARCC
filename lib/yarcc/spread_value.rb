# coding: utf-8
# The Ruby Compiler Construction Kit -- Support

# Additions to various classes to support the spread_value method.

class Symbol
  def spread_value(dest, value)
    dest[self] = value
  end
end

class Range
  def spread_value(dest, value)
    self.each do |key|
      dest[key] = value
    end
  end
end

class String
  def spread_value(dest, value)
    self.chars do |key|
      dest[key] = value
    end
  end
end

class Array
  def spread_value(dest, value)
    self.each do |key|
      key.spread_value(dest, value)
    end
  end
end

# For RCCK::CharSet.spread_value(dest, value) see char_set.rb
