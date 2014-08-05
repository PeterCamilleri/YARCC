require_relative '../lib/yarcc'
require          'minitest/autorun'

class YARCCTester < MiniTest::Unit::TestCase
  $do_this_only_one_time = "" unless defined? $do_this_only_one_time

  def initialize(*all)
    if $do_this_only_one_time != __FILE__
      puts
      puts "Running test file: #{File.split(__FILE__)[1]}"
      $do_this_only_one_time = __FILE__
    end

    super(*all)
  end


end