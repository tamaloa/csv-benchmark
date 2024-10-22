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



```
$ ruby -v
ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [x86_64-linux]

$ ruby benchmark.rb

Testing csv/geoip.csv

       user     system      total        real
csv           1.071429   0.000000   1.071429 (  1.072142)
lightcsv      0.611070   0.003797   0.614867 (  0.615105)
ccsv          0.053633   0.000000   0.053633 (  0.053660)
fastcsv       0.091331   0.003932   0.095263 (  0.095299)
fastest-csv   0.060950   0.004018   0.064968 (  0.064996)
rcsv          0.071841   0.007987   0.079828 (  0.079866)
smarter_csv   3.459755   0.016035   3.475790 (  3.477682)
```

For following versions:

```
Gems included by the bundle:
  * bamfcsv (0.3.2)
  * ccsv (1.1.0)
  * csv (3.3.0)
  * excelsior (0.1.0)
  * fastcsv (0.0.7)
  * fastercsv (1.5.5)
  * fasterer-csv (2.1.0)
  * fastest-csv (0.0.4)
  * lightcsv (0.2.4)
  * rcsv (0.3.1)
  * smarter_csv (1.12.1)
```

Test files from [original repository](https://github.com/vonconrad/csv-benchmark):

* presidents.csv: [See People Software](http://seepeoplesoftware.com/downloads/older-versions/11-sample-csv-file-of-us-presidents.html)
* geoip.csv: [MaxMind](http://www.maxmind.com/app/geolitecountry) (can also try this [larger file](http://www.maxmind.com/app/geolitecity))

## Compatibility

Tests the fastcsv, rcsv, bamfcsv, excelsior, fastest-csv and ccsv CSV implementations:

    ruby csv_spec.rb
