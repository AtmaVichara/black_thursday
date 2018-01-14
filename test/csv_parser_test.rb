require_relative 'test_helper'
require_relative '../lib/csv_parser'

class CsvParserTest < Minitest::Test

  include CsvParser

  def test_it_opens_csv_files
    row = parser('./test/fixtures/merchants_sample.csv').readline

    assert_instance_of CSV::Row, row
    assert_equal "12334141", row[:id]
    assert_equal "jejum", row[:name]
    assert_equal "2007-06-25", row[:created_at]
    assert_equal "2015-09-09", row[:updated_at]
  end

end
