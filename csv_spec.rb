require 'bundler/setup'

require 'csv'
require 'test/unit'

require 'bamfcsv'
require 'ccsv'
require 'fastcsv'
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

  def encoded(filename, encoding)
    actual(filename)
  end



  def test_bad_encoding
    encoding = 'iso-8859-1:utf-8'
    filename = fixture('bad-encoding.csv')
    assert_equal(expected(filename, encoding: encoding), encoded(filename, encoding))
  end

  def test_blank_field
    passes('blank-field.csv')
  end

  def test_blank_rows
    passes('blank-rows.csv')
  end

  def test_crlf
    passes('crlf.csv')
  end

  def test_col_sep_in_field
    passes('col-sep-in-field.csv')
  end

  def test_escaped_quote
    passes('escaped-quote.csv')
  end

  def test_long_row
    passes('long-row.csv') do |filename,message|
      assert(expected(filename) == actual(filename), message)
    end
  end

  def test_no_row_sep
    passes('no-row-sep.csv')
  end

  def test_ragged_rows
    passes('ragged-rows.csv')
  end

  def test_row_sep_in_field
    passes('row-sep-in-field.csv')
  end

  def test_trailing_col_sep
    passes('trailing-col-sep.csv')
  end

  def test_whitespace_around_unquoted_field
    passes('whitespace-around-unquoted-field.csv')
  end

  def passes(basename, message = nil)
    filename = fixture(basename)
    if block_given?
      yield(filename, message)
    else
      assert_equal(expected(filename), actual(filename), message)
    end
  end



  def test_empty_file
    passes_or_c_error('empty-file.csv', %w(TestExcelsior), 'segfault')
  end

  def test_long_field
    passes_or_c_error('long-field.csv', %w(TestExcelsior), 'hangs') do |filename,message|
      assert(expected(filename) == actual(filename), message)
    end
  end

  def passes_or_c_error(basename, classes, c_error_message, message = nil)
    filename = fixture(basename)
    if classes.include?(self.class.name)
      assert false, c_error_message
    elsif block_given?
      yield(filename, message)
    else
      assert_equal(expected(filename), actual(filename), message)
    end
  end



  def test_no_col_sep
    fails('no-col-sep.csv', ['Illegal quoting in line 1.', "Illegal quoting on line 1, cell 1: Quoted cell must open with '\"'"]) # BAMFCSV
  end

  def test_unmatched_quote
    fails('unmatched-quote.csv', ['Unclosed quoted field on line 1.', "Illegal quoting on line 1, cell 3: File ends without closing '\"'"]) # BAMFCSV
  end

  def test_unescaped_quote
    fails('unescaped-quote.csv', ['Illegal quoting in line 1.', "Illegal quoting on line 1, cell 1: Quoted cell must open with '\"'"]) # BAMFCSV
  end

  def test_unescaped_quote_in_quoted_field
    fails('unescaped-quote-in-quoted-field.csv', ['Missing or stray quote in line 1', 'Illegal quoting in line 1.', "Illegal quoting on line 1, cell 1"]) # FastCSV, BAMFCSV
  end

  def test_whitespace_after_quoted_field
    fails('whitespace-after-quoted-field.csv', ['Unclosed quoted field on line 1.', 'Illegal quoting in line 1.', "Illegal quoting on line 1, cell 2"]) # FastCSV, BAMFCSV
  end

  def test_whitespace_before_quoted_field
    fails('whitespace-before-quoted-field.csv', ['Illegal quoting in line 1.', "Illegal quoting on line 1, cell 3: Quoted cell must open with '\"'"]) # BAMFCSV
  end

  def fails(basename, error_messages)
    filename = fixture(basename)
    error = assert_raises(CSV::MalformedCSVError) do
      expected(filename)
    end
    assert_equal error_messages[0], error.message
    error = assert_raises(FastCSV::MalformedCSVError, BAMFCSV::MalformedCSVError, Rcsv::ParseError) do
      puts "\n#{actual(filename)}"
    end
    assert_includes error_messages + ['Error when parsing malformed data'], error.message # Rcsv
  end
end



class TestBAMFCSV < Test::Unit::TestCase
  include SharedExamples
  def actual(filename)
    BAMFCSV.read(filename)
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

class TestFastCSV < Test::Unit::TestCase
  include SharedExamples
  def actual(filename, options = {})
    File.open(filename, 'r') do |io|
      rows = []
      FastCSV.raw_parse(io, options) {|row| rows << row}
      rows
    end
  end

  def encoded(filename, encoding)
    actual(filename, encoding: encoding)
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

class TestRcsv < Test::Unit::TestCase
  include SharedExamples
  def actual(filename, options = {})
    File.open(filename, 'r') do |io|
      rows = []
      Rcsv.raw_parse(io, options) {|row| rows << row}
      rows
    end
  end

  def encoded(filename, encoding)
    actual(filename, output_encoding: encoding.split(':')[0])
  end
end
