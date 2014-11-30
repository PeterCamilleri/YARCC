# coding: utf-8
# The Ruby Compiler Construction Kit -- Support

class Object
  # Convert the object into an array of strings for debugging, logging etc.
  # Typical usage:  puts obj.ff
  def ff
    result = [""]
    _ff(result, '', inc: ' ')
    result
  end

  # The flex format worker bee.
  def _ff(buffer, pad, progress)
    buffer[-1] << "#{self.class_family}"
    vars = self.instance_variables.sort
    new_pad = pad + progress[:inc]

    if vars.empty?
      buffer << "#{new_pad}Value = #{self.inspect}"
    else
      buffer << "#{new_pad}Variables:"

      vars.each do | name |
        buffer << "#{new_pad}#{name.to_s} is "
        instance_variable_get(name)._ff(buffer, new_pad, progress)
      end
    end
  end

  # Return the classes in this object.
  def class_family
    begin
      result, klass = '', self

      begin
        klass = klass.class unless klass.instance_of?(Class)
        result << klass.to_s
        klass = klass.superclass
        result << "<" if klass
      end while klass

      result
    end
  end
end

class Hash
  # The flex format worker bee.
  def _ff(buffer, pad, progress)
    pad += progress[:inc]
    buffer[-1] << "Hash = {"

    if default_proc
      buffer << "#{pad}default proc => "
      default_proc._ff(buffer, pad + progress[:inc], progress)
    else
      buffer << "#{pad}default => "
      default._ff(buffer, pad + progress[:inc], progress)
    end

    first = true

    self.each do |k,v|
      buffer[-1] << "," unless first
      first = false

      buffer << "#{pad}#{k.inspect} => "
      v._ff(buffer, pad + progress[:inc], progress)
    end

    buffer[-1] << "}"
  end
end

class Array
  # The flex format worker bee.
  def _ff(buffer, pad, progress)
    buffer[-1] << "Array = ["
    first_pass = true
    pad += progress[:inc]

    self.each do |v|
      buffer[-1] << "," unless first_pass
      first_pass = false

      buffer << pad.dup
      v._ff(buffer, pad + progress[:inc], progress)
    end

    buffer[-1] << "]"
  end
end

module SimpleFlexFormat
  # The flex format worker bee.
  def _ff(buffer, _pad, _progress)
    buffer[-1] << "#{self.class.inspect} #{self.inspect}"
  end
end

class String;  include SimpleFlexFormat; end
class Symbol;  include SimpleFlexFormat; end
class Numeric; include SimpleFlexFormat; end

module MinimumFlexFormat
  # The flex format worker bee.
  def _ff(buffer, _pad, _progress)
    buffer[-1] << "#{self.inspect}"
  end
end

class NilClass;   include MinimumFlexFormat; end
class TrueClass;  include MinimumFlexFormat; end
class FalseClass; include MinimumFlexFormat; end

# RCCK Specific Formatting Methods.

module RCCK
  class NonTerminal
    # The flex format worker bee.
    def _ff(buffer, pad, progress)
      buffer[-1] << "#{self.class_family}"
      pad += progress[:inc]
      buffer << "#{pad}<#{@name}> = "

      if progress[:non_term]
        buffer[-1] << "..."
      else
        progress[:non_term] = true
        @value._ff(buffer, pad + progress[:inc], progress)
        progress[:non_term] = false
      end
    end
  end
end
