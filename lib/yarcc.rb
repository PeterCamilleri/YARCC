# coding: utf-8
# The Ruby Compiler Construction Kit -- Parser Bootstrap.

# This sub-project exists primarily as a means to scope out and understand
# the task of creating a generalized parser for parsers. As such it is in
# the end, throw-away code.

require_relative "yarcc/file_source"
require_relative "yarcc/string_source"
require_relative "yarcc/case_filter"
require_relative "yarcc/branch_buffer"
require_relative "yarcc/parse_info"

require_relative "yarcc/non_terminal"
require_relative "yarcc/seq"
require_relative "yarcc/alt"
require_relative "yarcc/zero_or_one"
require_relative "yarcc/zero_or_more"
require_relative "yarcc/one_or_more"

require_relative "yarcc/literal"
require_relative "yarcc/keyword"
require_relative "yarcc/char_set"

module RCCK

  # A hard-wired parser for parser scripts.
  class ParserBootstrap
    attr_reader :description
    attr_reader :version
    attr_reader :target

    # Set up a hardwired instance of the parser
    def initialize
      # Internal setup.
      @description   = "A bootstrap parser for compiling parsers."
      @version       = "V 0.0.5"
      @non_terminals = {}

      # Load the predefined character sets first.
      # The following set names are predefined.
      # EOF       is Special: Detected when the source has just been exhausted.
      # BOF       is Special: Detected when the source has just been opened.
      # EOL       is ['\xA;' '\xD;' EOF]
      # BOL       is [BOF EOL]
      # BREAK     is [' ' '\x9;' BOF EOL]
      # ANY       is Anything at all!
      # PRINTABLE is [ANY - '\x00;'..'\x1F;' '\x7F;']
      # ALPHA     is ['A'..'Z' 'a'..'z']            This definition needs work!
      # UPPER     is ['A'..'Z']                     This definition needs work!
      # DIGIT     is ['0'..'9']
      # HEX       is [DIGIT 'A'..'F' 'a'..'f']
      # OCTAL     is ['0'..'7']
      # BINARY    is ['0'  '1']

      set_char_set('ANY',       CharSet.new(:any))
      set_char_set('PRINTABLE', CharSet.new(:any, ["\x00".."\x1F", "\x7F"]))

      set_char_set('ALPHA',     CharSet.new(['A'..'Z', 'a'..'z']))
      set_char_set('UPPER',     CharSet.new(['A'..'Z']))

      set_char_set('DIGIT',     CharSet.new(['0'..'9']))
      set_char_set('HEX',       CharSet.new(['0'..'9', 'ABCDEFabcdef']))
      set_char_set('OCTAL',     CharSet.new(['0'..'7']))
      set_char_set('BINARY',    CharSet.new(['01']))

      set_char_set('EOF',       CharSet.new(["\x1A", :eof]))
      set_char_set('BOF',       CharSet.new([:bof]))
      set_char_set('EOL',       CharSet.new(["\x0A\x0D", :eof]))
      set_char_set('BOL',       CharSet.new(["\x0A\x0D", :eof, :bof]))

      set_char_set('BREAK',     CharSet.new([" \x09\x0A\x0D", :eof, :bof]))

      # Bootstrap the parser for parsers.
      #<parse tree>   = ?<init action> <parse tree header> ?<open action>
      #                 +<statement> "END" ?<close action>;
      (@target = non_terminal('parse tree')).value =
        Sequence.new(
          ZeroOrOne.new(
            non_terminal('init action')),
          non_terminal('parse tree header'),
          ZeroOrOne.new(
            non_terminal('open action')),
          OneOrMore.new(
            non_terminal('statement')),
          Keyword.new('END'),
          ZeroOrOne.new(
            non_terminal('close action')))

      #<init action> <open action> <close action> = <action>;
      non_terminal('init action').value =
        non_terminal('action')

      non_terminal('open action').value =
        non_terminal('action')

      non_terminal('close action').value =
        non_terminal('action')

      #<parse tree header> = "PARSE_TREE" <version> <description>
      #                      ?("OPTIONS" +<option>) ';';
      non_terminal('parse tree header').value =
        Sequence.new(
          Keyword.new('PARSE_TREE'),
          non_terminal('version'),
          non_terminal('description'),
          ZeroOrOne.new(
            Sequence.new(
              Keyword.new('OPTIONS'),
              OneOrMore.new(
                non_terminal('option')))),
          Literal.new(';'));

      #<version> <description> = <string>;
      non_terminal('version').value =
        non_terminal('string')

      non_terminal('description').value =
        non_terminal('string')

      #<option> = "INDENT" | "NO_INDENT"
      non_terminal('option').value =
        Alternative.new(
          Keyword.new("INDENT"),
          Keyword.new("NO_INDENT"))

      #Work in progress...
    end

    # Compile the parse grammar into Ruby.
    # All parse methods return a true/false value to indicate success/failure.
    def parse(src, dst)
      parse_info = ParseInfo.new(self, src, BranchBuffer.new)

      if @target.parse(parse_info)
        parse_info.dst.write_out(dst)
      end
    end

    # Helper methods.
    def non_terminal(name)
      @non_terminals[name] ||= NonTerminal.new(name)
    end

    def get_char_set(name)
      @non_terminals[name]
    end

    def set_char_set(name, value)
      fail "Invalid redefinition of #{@name}" if @value
      fail "Invalid value for char set #{@name}" unless value.is_a?(CharSet)
      @non_terminals[name] = value
    end

  end

end





