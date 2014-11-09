# CSV Benchmark

## Benchmark

    brew install libcsv
    bundle
    ruby benchmark.rb

Some libraries are fast but don't handle all errors or can't read all CSVs.

* presidents.csv: [See People Software](http://seepeoplesoftware.com/downloads/older-versions/11-sample-csv-file-of-us-presidents.html)
* geoip.csv: [MaxMind](http://www.maxmind.com/app/geolitecountry) (can also try this [larger file](http://www.maxmind.com/app/geolitecity))

## Compatibility

    ruby csv_spec.rb
