require 'rubygems'
require 'bundler/setup'

require 'benchmark'

require 'csv'
require 'fastercsv'
require 'bamfcsv'
require 'ccsv'
require 'fastcsv'
require 'excelsior'
require 'fasterer_csv'
require 'fastest-csv'
require 'lightcsv'
require 'rcsv'
require 'smarter_csv'

only_fastest = ARGV.delete('--only-fastest')
include_slow = ARGV.delete('--include-slow')

files = if ARGV.empty?
  ['csv/geoip.csv']
else
  ARGV
end

files.each do |file|
  puts "\nTesting #{file}\n\n"

  Benchmark.bm do |x|
    if only_fastest
      puts "Skipping csv (too slow)"
    else
      x.report('csv         ') do
        CSV.foreach(file) {|row| row}
      end
    end

    if RUBY_VERSION < '1.9'
      x.report('fastercsv   ') do
        FasterCSV.foreach(file, :col_sep => ',') {|row| row}
      end
    end

    if include_slow
      # Almost as slow as standard library.
      x.report('lightcsv    ') do
        LightCsv.foreach(file) {|row| row}
      end
    else
      puts "Skipping lightcsv (too slow)"
    end

    # Fast. Ragel-based. :header option.
    # https://github.com/halogenandtoast/excelsior/issues
    # https://github.com/halogenandtoast/excelsior/blob/master/ext/excelsior_reader/excelsior_reader.rl
    # https://github.com/halogenandtoast/excelsior
    x.report('excelsior   ') do
      File.open(file, 'r') do |io|
        Excelsior::Reader.rows(io) {|row| row}
      end
    end

    # Reads the entire file at once, which is not memory efficient, and it's
    # not as fast as the five fastest, though much faster than others.
    # https://github.com/jondistad/bamfcsv
    x.report('bamfcsv     ') do
      BAMFCSV.read(file)
    end

    # Fast. Merged in hopcsv. Enhanced by rcsvreader. Can only read files.
    # @see https://github.com/evan/ccsv/issues
    # https://github.com/evan/ccsv/blob/master/ext/ccsv.c
    # https://github.com/evan/ccsv
    x.report('ccsv        ') do
      Ccsv.foreach(file) {|row| row}
    end

    # Fast.
    x.report('fastcsv     ') do
      File.open(file, 'r') do |io|
        FastCSV.raw_parse(io) {|row| row}
      end
    end

    # Errors if a row's length is greater than the header's length.
    begin
      x.report('fasterer-csv') do
        File.open(file, 'r') do |io|
          FastererCSV.parse(io)
        end
      end
    rescue => e
      puts e
    end

    # Fast.
    # @see https://github.com/brightcode/fastest-csv/issues
    # https://github.com/brightcode/fastest-csv/blob/master/ext/csv_parser/parser.c
    # https://github.com/brightcode/fastest-csv
    x.report('fastest-csv ') do
      FastestCSV.foreach(file) {|row| row}
    end

    # Fast. Depends on libcsv, which can't set row_sep.
    # @see https://github.com/fiksu/rcsv/issues
    # https://github.com/fiksu/rcsv
    x.report('rcsv        ') do
      File.open(file, 'r') do |io|
        Rcsv.raw_parse(io) {|row| row}
      end
    end

    if include_slow
      # Slower than standard library.
      x.report('smarter_csv ') do
        SmarterCSV.process(file)
      end
    else
      puts "Skipping smarter_csv (too slow)"
    end
  end
end
