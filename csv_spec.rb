require 'bundler/setup'

require 'csv'
require 'test/unit'

require 'ccsv'
require 'csvscan2'
require 'excelsior'
require 'fastest-csv'
require 'rcsv'

module SharedExamples
  def fixture(basename)
    File.expand_path(File.join('fixtures', basename), __dir__)
  end

  def expected(filename, options = {})
    CSV.foreach(filename, options).to_a
  end

  def actual(filename)
    raise NotImplementedError
  end



  def test_bad_encoding
    filename = fixture('bad-encoding.csv')
    assert_equal(actual(filename), expected(filename, encoding: 'iso-8859-1:utf-8'))
  end

  def test_blank_field
    passes('blank-field.csv')
  end

  def test_blank_rows
    passes('blank-rows.csv')
  end

  def test_col_sep_in_field
    passes('col-sep-in-field.csv')
  end

  # @see https://github.com/halogenandtoast/excelsior/issues/6
  def test_escaped_quote
    passes('escaped-quote.csv')
  end

  def test_long_row
    passes('long-row.csv')
  end

  def test_ragged_rows
    passes('ragged-rows.csv')
  end

  def test_row_sep_in_field
    passes('row-sep-in-field.csv')
  end

  def passes(basename)
    filename = fixture(basename)
    assert_equal(expected(filename), actual(filename))
  end



  # @see https://github.com/halogenandtoast/excelsior/issues/3
  def test_empty_file
    passes_or_c_error('empty-file.csv', %w(TestCSVScan2 TestExcelsior), 'segfault')
  end

  def test_long_field
    passes_or_c_error('long-field.csv', %w(TestExcelsior), 'hangs')
  end

  def passes_or_c_error(basename, classes, message)
    filename = fixture(basename)
    if classes.include?(self.class.name)
      assert false, message
    else
      assert_equal(expected(filename), actual(filename))
    end
  end



  # @see https://github.com/halogenandtoast/excelsior/issues/1
  # @see https://github.com/halogenandtoast/excelsior/issues/5
  def test_no_col_sep
    fails('no-col-sep.csv', 'Illegal quoting in line 1.')
  end

  def test_unmatched_quote
    fails('unmatched-quote.csv', 'Unclosed quoted field on line 1.')
  end

  def test_unescaped_quote
    fails('unescaped-quote.csv', 'Illegal quoting in line 1.')
  end

  def test_unescaped_quote_in_quoted_field
    fails('unescaped-quote-in-quoted-field.csv', 'Missing or stray quote in line 1')
  end

  def test_whitespace_before_quoted_field
    fails('whitespace-before-quoted-field.csv', 'Illegal quoting in line 1.')
  end

  def fails(basename, message)
    filename = fixture(basename)
    error = assert_raises(CSV::MalformedCSVError) do
      expected(filename)
    end
    assert_equal message, error.message
    error = assert_raises(Rcsv::ParseError) do
      puts "\n#{actual(filename)}"
    end
    assert_includes [
      'Error when parsing malformed data', # Rcsv
    ], error.message
  end
end



class TestCSVScan2 < Test::Unit::TestCase
  include SharedExamples
  def actual(filename)
    File.open(filename, 'r') do |io|
      rows = []
      CSVScan.scan(io) {|row| rows << row}
      rows
    end
  end
end

if false
  class TestExcelsior < Test::Unit::TestCase
    include SharedExamples
    def actual(filename)
      File.open(filename, 'r') do |io|
        rows = []
        Excelsior::Reader.rows(io) {|row| rows << row}
        rows
      end
    end
  end

  class TestFastestCSV < Test::Unit::TestCase
    include SharedExamples
    def actual(filename)
      rows = []
      FastestCSV.foreach(filename) {|row| rows << row}
      rows
    end
  end

  class TestCcsv < Test::Unit::TestCase
    include SharedExamples
    def actual(filename)
      rows = []
      Ccsv.foreach(filename) {|row| rows << row}
      rows
    end
  end

  class TestRcsv < Test::Unit::TestCase
    include SharedExamples
    def actual(filename)
      File.open(filename, 'r') do |io|
        rows = []
        Rcsv.raw_parse(io, output_encoding: 'iso-8859-1') {|row| rows << row}
        rows
      end
    end
  end
end
