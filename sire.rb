# coding: utf-8
# A Simple Interactive Ruby Environment
# SIRE Version 0.3.0

require 'readline'
require 'pp'         # deprecated.

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
  puts str + "\n"
  eval str
end

puts "Welcome to SIRE for the RCCK"
puts "Simple Interactive Ruby Environment"
puts
puts "Use command 'q' to quit."
puts

eval_puts "require './lib/yarcc'"
eval_puts "require './lib/yarcc/flex_format'"
puts

eval_puts "@a = RCCK::ParserBootstrap.new"
puts

@done    = false
@running = false

until @done
  begin
    line = readline('SIRE>', true)
    @running = true
    result = eval line
    @running = false
    puts result unless line.length == 0
  rescue Interrupt => e
    if @running
      @running = false
      puts "\nExecution Interrupted!"
      puts "\n#{e.class} detected: #{e}\n"
      puts e.backtrace
    else
      puts "\nI'm outta here!'"
      @done = true
    end

    puts "\n"

  rescue Exception => e
    puts "\n#{e.class} detected: #{e}\n"
    puts e.backtrace
    puts
  end
end

puts "\n\n"
