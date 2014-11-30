# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Runtime
module RCCK
  # A structure used to carry around compiler state info.
  class ParseInfo
    attr_reader :parser, :src, :dst

    def initialize(parser, src, dst)
      @parser, @src, @dst = parser, src, dst
    end

    # Set a progress point while parsing
    # Returns the source position to be saved.
    def try
      @dst.branch
      @src.posn
    end

    # The changes were a success, accept them.
    def accept
      @dst.merge
      true
    end

    # The changes did not work out, roll them back.
    def reject(saved)
      @dst.drop
      @src.posn = saved
      false
    end

    # Proxies for the parser.
    # Oh my... There don't seem to be any...
    # Why are we carting this thing around anyway?
    # I'm sure something will turn up.

    # Proxies for the source.
    define_method(:get)  {@src.get}
    define_method(:peek) {@src.peek}
    define_method(:skip) {@src.skip}

    # Proxies for the destination.
    define_method(:<<)   {|line| @dst << line}
    define_method(:last) {@dst.last}
  end
end