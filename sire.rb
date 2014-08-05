# coding: utf-8
# Really simple program # 3
# A Simple Interactive Ruby Environment
# SIRE Version 0.2.7

require 'readline'
require 'pp'
require_relative 'lib/yarcc'
include Readline

class Object
  def classes
    begin
      klass = self

      begin
        klass = klass.class unless klass.instance_of?(Class)
        print klass
        klass = klass.superclass
        print " < " if klass
      end while klass

      puts
    end
  end
end

def q
  @done = true
  puts
  "Bye bye for now!"
end

def eval_puts(str)
  puts str
  eval str
end

puts "Welcome to SIRE for FlexArray"
puts "Simple Interactive Ruby Environment"
puts
puts "Use command 'q' to quit."
puts
@done = false

until @done
  begin
    line = readline('SIRE>', true)
    result = eval line
    pp result unless result.nil?
  rescue Interrupt
    @done = true
    puts
    puts
    pp "I'm done here!"
  rescue Exception => e
    puts
    puts "#{e.class} detected: #{e}"
    puts e.backtrace
    puts
  end
end

puts
