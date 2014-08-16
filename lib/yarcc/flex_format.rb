# Flex Format -- A flexible, configurable pretty formatting facility.

class Object
  # Convert the object into an array of strings for debugging, logging etc.
  # Typical usage:  puts obj.ff
  def ff
    result = [""]
    _ff(result, '', inc: ' ')
    result
  end

  def _ff(buffer, pad, progress)
    buffer[-1] << "#{self.class_family}"

    vars = self.instance_variables.sort

    if vars.empty?
      buffer[-1] << " Value = #{self.inspect}"
    else
      buffer << "#{pad}Variables"

      vars.each do | name |
        buffer << "#{pad} #{name.to_s} is "
        var = instance_variable_get(name)
        var._ff(buffer, pad + progress[:inc], progress)
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
  def _ff(buffer, pad, progress)
    buffer[-1] << "Hash = {"
    first = true
    pad += progress[:inc]

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
  def _ff(buffer, _pad, _progress)
    buffer[-1] << "#{self.class.inspect} #{self.inspect}"
  end
end

class String;  include SimpleFlexFormat; end
class Numeric; include SimpleFlexFormat; end

module MinimumFlexFormat
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
