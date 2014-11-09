require 'rubygems'
require 'bundler/setup'

require 'benchmark'

require 'csv'
require 'fastercsv'
require 'ccsv'
require 'csvscan2'
require 'excelsior'
require 'fasterer_csv'
require 'fastest-csv'
require 'lightcsv'
require 'rcsv'
require 'smarter_csv'

['csv/presidents.csv', 'csv/geoip.csv'].each do |file|
  puts "\nTesting #{file}\n\n"

  Benchmark.bm do |x|
    x.report('csv         ') do
      CSV.foreach(file) {|row| row}
    end

    if RUBY_VERSION < '1.9'
      x.report('fastercsv   ') do
        FasterCSV.foreach(file, :col_sep => ',') {|row| row}
      end
    end

    # Almost as slow as standard library.
    x.report('lightcsv    ') do
      LightCsv.foreach(file) {|row| row}
    end

    # https://github.com/halogenandtoast/excelsior/blob/master/ext/excelsior_reader/excelsior_reader.rl
    # https://github.com/halogenandtoast/excelsior
    # @note Ragel-based.
    x.report('excelsior   ') do
      File.open(file, 'r') do |io|
        Excelsior::Reader.rows(io) {|row| row}
      end
    end

    # https://github.com/evan/ccsv/blob/master/ext/ccsv.c
    # https://github.com/evan/ccsv
    # @note Includes its hopcsv fork. rcsvreader adds features.
    x.report('ccsv        ') do
      Ccsv.foreach(file) {|row| row}
    end

    x.report('csvscan2    ') do
      File.open(file, 'r') do |io|
        CSVScan.scan(io) {|row| row}
      end
    end

    # Errors if row length is greater than header length.
    begin
      x.report('fasterer-csv') do
        File.open(file, 'r') do |io|
          FastererCSV.parse(io)
        end
      end
    rescue
    end

    # https://github.com/brightcode/fastest-csv/blob/master/ext/csv_parser/parser.c
    # https://github.com/brightcode/fastest-csv
    x.report('fastest-csv ') do
      FastestCSV.foreach(file) {|row| row}
    end

    # Depends on libcsv.
    # https://github.com/fiksu/rcsv
    x.report('rcsv        ') do
      File.open(file, 'r') do |io|
        Rcsv.parse(io) {|row| row}
      end
    end

    # Slower than standard library.
    x.report('smarter_csv ') do
      SmarterCSV.process(file)
    end
  end
end
