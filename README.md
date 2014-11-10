# CSV Benchmark

## Benchmark

    brew install libcsv
    bundle
    ruby benchmark.rb

Evaluates:

* [rcsv](https://github.com/fiksu/rcsv): the fastest and [least buggy](https://github.com/fiksu/rcsv/issues)
* [excelsior](https://github.com/halogenandtoast/excelsior): fails several edges cases
* [fastest-csv](https://github.com/brightcode/fastest-csv): incorrectly parses multiline fields
* [ccsv](https://github.com/evan/ccsv): incorrectly parses quoted fields, including multiline fields
* [bamfcsv](https://github.com/jondistad/bamfcsv): faster than standard library, but not as fast as the above
* [lightcsv](https://github.com/tmtm/lightcsv): as slow as standard library
* [smarter_csv](https://github.com/tilo/smarter_csv): slower than standard library
* [fasterer-csv](https://github.com/gnovos/fasterer-csv): fails on valid input

Test files from:

* presidents.csv: [See People Software](http://seepeoplesoftware.com/downloads/older-versions/11-sample-csv-file-of-us-presidents.html)
* geoip.csv: [MaxMind](http://www.maxmind.com/app/geolitecountry) (can also try this [larger file](http://www.maxmind.com/app/geolitecity))

## Compatibility

    ruby csv_spec.rb
