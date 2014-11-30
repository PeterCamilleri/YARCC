# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Runtime
module RCCK
  # A class of text buffers with branching, merging, and roll-back.
  class BranchBuffer
    # Setup the branching buffer.
    def initialize(pad)
      @pad = pad
      @pad_step = 2
      @buffers = [[]]
    end

    # Some spaces for indenting.
    define_method(:padding) {' ' * (@pad + @pad_step * depth)}

    # How many levels of branching are there?
    define_method(:depth) {@buffers.length - 1}

    # Is the buffer merged to a flat file?
    define_method(:merged?) {depth == 0}

    # Get the last line generated.
    define_method(:last) {@buffers[0][-1]}

    # Read in some boilerplate source text. This text is not padded.
    def read_in(src_name)
      File.open(src_name) do |src_file|
        while line = src_file.gets
          @buffers[0] << line
        end
      end
    end

    # Write out the generated code to the destination file.
    def write_out(dest_name)
      fail "Invalid action: Nesting #{depth} instead of 1." unless merged?

      File.open(dest_name, 'w') do |dest_file|
        @buffers[0].each do | line |
          dest_file.puts(line)
        end
      end
    end

    # Fork a new branch of tentative code.
    define_method(:fork) {@buffers.insert(0, [])}

    # Merge the current branch with its parent.
    def merge
      fail "Invalid action: No buffers to merge." if merged?
      top = @buffers[0]
      @buffers = @buffers[1..-1]

      top.each do |line|
        @buffers[0] << line
      end
    end

    # Drop the current branch of code and revert to the parent.
    def drop
      fail "Invalid action: Cannot drop all buffers." if merged?
      @buffers = @buffers[1..-1]
    end

    # Append a line of text to the current branch.
    define_method(:<<) {|line| @buffers[0] << (padding + line)}

    # Get the last line of the current branch.
    define_method(:last) {@buffers[0][-1]}
  end
end