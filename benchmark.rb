require 'rubygems'
require 'bundler/setup'

require 'benchmark'

require 'csv'
require 'fastercsv'
require 'bamfcsv'
require 'ccsv'
require 'csvscan2'
require 'excelsior'
require 'fasterer_csv'
require 'fastest-csv'
require 'lightcsv'
require 'rcsv'
require 'smarter_csv'

only_fast = ARGV.include?('--only-fast')

['csv/presidents.csv', 'csv/geoip.csv'].each do |file|
  puts "\nTesting #{file}\n\n"

  Benchmark.bm do |x|
    unless only_fast
      x.report('csv         ') do
        CSV.foreach(file) {|row| row}
      end
    end

    if RUBY_VERSION < '1.9'
      x.report('fastercsv   ') do
        FasterCSV.foreach(file, :col_sep => ',') {|row| row}
      end
    end

    # Almost as slow as standard library.
    unless only_fast
      x.report('lightcsv    ') do
        LightCsv.foreach(file) {|row| row}
      end
    end

    # Fast. Ragel-based.
    # https://github.com/halogenandtoast/excelsior/blob/master/ext/excelsior_reader/excelsior_reader.rl
    # https://github.com/halogenandtoast/excelsior
    x.report('excelsior   ') do
      File.open(file, 'r') do |io|
        Excelsior::Reader.rows(io) {|row| row}
      end
    end

    # Reads the entire file at once, which is not memory efficient, and it's
    # not as fast as the five fastest.
    # https://github.com/jondistad/bamfcsv
    x.report('bamfcsv     ') do
      BAMFCSV.read(file)
    end

    # Fast. Includes its hopcsv fork. rcsvreader adds features.
    # https://github.com/evan/ccsv/blob/master/ext/ccsv.c
    # https://github.com/evan/ccsv
    x.report('ccsv        ') do
      Ccsv.foreach(file) {|row| row}
    end

    # Fast.
    x.report('csvscan2    ') do
      File.open(file, 'r') do |io|
        CSVScan.scan(io) {|row| row}
      end
    end

    unless only_fast
      # Errors if row length is greater than header length.
      begin
        x.report('fasterer-csv') do
          File.open(file, 'r') do |io|
            FastererCSV.parse(io)
          end
        end
      rescue
      end
    end

    # Fast.
    # https://github.com/brightcode/fastest-csv/blob/master/ext/csv_parser/parser.c
    # https://github.com/brightcode/fastest-csv
    x.report('fastest-csv ') do
      FastestCSV.foreach(file) {|row| row}
    end

    # Fast, but depends on libcsv.
    # https://github.com/fiksu/rcsv
    x.report('rcsv        ') do
      File.open(file, 'r') do |io|
        Rcsv.parse(io) {|row| row}
      end
    end

    unless only_fast
      # Slower than standard library.
      x.report('smarter_csv ') do
        SmarterCSV.process(file)
      end
    end
  end
end
