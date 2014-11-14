# CSV Benchmark

## Benchmark

    brew install libcsv
    bundle
    ruby benchmark.rb
    ruby benchmark.rb <csv file>
    ruby benchmark.rb --only-fast
    ruby benchmark.rb --only-fastest

Evaluates:

* [fastcsv](https://github.com/opennorth/fastcsv): fast and full CSV support
* [rcsv](https://github.com/fiksu/rcsv): fast, but differs in behavior from Ruby's `CSV`
* [excelsior](https://github.com/halogenandtoast/excelsior): fast, but fails several edges cases
* [fastest-csv](https://github.com/brightcode/fastest-csv): fast, but incorrectly parses multiline fields
* [ccsv](https://github.com/evan/ccsv): fast, but incorrectly parses quoted fields, including multiline fields
* [bamfcsv](https://github.com/jondistad/bamfcsv): not as fast, but best error handling
* [lightcsv](https://github.com/tmtm/lightcsv): as slow as standard library
* [smarter_csv](https://github.com/tilo/smarter_csv): slower than standard library
* [fasterer-csv](https://github.com/gnovos/fasterer-csv): errors on valid input

Output from running only fastest on [OpenlyLocal](http://www.openlylocal.com/)'s [1.2G CSV of council spending](http://www.openlylocal.com/councils/spending.csv.zip) (83MB ZIP):

```
user         system      total     real
csv          84.990000   0.930000  85.920000 ( 85.998271)
excelsior    37.750000   0.640000  38.390000 ( 38.447401)
ccsv         16.640000   0.700000  17.340000 ( 17.364485)
fastcsv      14.710000   0.700000  15.410000 ( 15.422187)
fastest-csv  15.670000   0.820000  16.490000 ( 16.519444)
rcsv         19.300000   0.950000  20.250000 ( 20.268348)
```

Test files from [original repository](https://github.com/vonconrad/csv-benchmark):

* presidents.csv: [See People Software](http://seepeoplesoftware.com/downloads/older-versions/11-sample-csv-file-of-us-presidents.html)
* geoip.csv: [MaxMind](http://www.maxmind.com/app/geolitecountry) (can also try this [larger file](http://www.maxmind.com/app/geolitecity))

## Compatibility

Tests the fastcsv, rcsv, bamfcsv, excelsior, fastest-csv and ccsv CSV implementations:

    ruby csv_spec.rb
