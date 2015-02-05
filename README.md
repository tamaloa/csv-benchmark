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
excelsior    35.370000   0.860000  36.230000 ( 36.601276)
ccsv         15.890000   0.680000  16.570000 ( 16.685589)
fastcsv      18.840000   0.760000  19.600000 ( 19.680719)
fastest-csv  15.310000   0.740000  16.050000 ( 16.108917)
rcsv         22.290000   1.260000  23.550000 ( 24.238066)
```

Test files from [original repository](https://github.com/vonconrad/csv-benchmark):

* presidents.csv: [See People Software](http://seepeoplesoftware.com/downloads/older-versions/11-sample-csv-file-of-us-presidents.html)
* geoip.csv: [MaxMind](http://www.maxmind.com/app/geolitecountry) (can also try this [larger file](http://www.maxmind.com/app/geolitecity))

## Compatibility

Tests the fastcsv, rcsv, bamfcsv, excelsior, fastest-csv and ccsv CSV implementations:

    ruby csv_spec.rb
