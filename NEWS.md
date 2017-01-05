# getcdw 0.1.0.9000

* Added a `NEWS.md` file to track changes to the package.
* getcdw now uses a single database connection that stays open, which saves about .7 seconds per query. See issue #10 for details.
* Added `connect` to create standalone database connections.
