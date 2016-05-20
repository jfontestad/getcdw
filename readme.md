getcdw
================

getcdw is a tool to make it easier to query the `CADS` data warehouse from R.

You can install getcdw from github:

``` r
devtools::install_github("tarakc02/getcdw")
```

Queries
-------

You can type a query:

``` r
# dplyr just prints the returned data.frames prettier
library(dplyr)
library(getcdw)

get_cdw("select report_name from cdw.d_entity_mv where entity_id = 640993")
```

    ## Source: local data frame [1 x 1]
    ## 
    ##          report_name
    ##                (chr)
    ## 1 Shah, Tarak Rashmi

You can also pass a query from a file, for instance: `get_cdw("sql/filename.sql")`.

Table and column search
-----------------------

Look for tables with `find_tables()`:

``` r
# want the committees table, but don't remember the exact name:
find_tables("committee")
```

    ## Source: local data frame [1 x 1]
    ## 
    ##           table_name
    ##                (chr)
    ## 1 d_bio_committee_mv

``` r
# or view all of the d_bio tables:
find_tables("d_bio")
```

    ## Source: local data frame [26 x 1]
    ## 
    ##                      table_name
    ##                           (chr)
    ## 1             d_bio_activity_mv
    ## 2              d_bio_address_mv
    ## 3          d_bio_affiliation_mv
    ## 4    d_bio_awards_and_honors_mv
    ## 5            d_bio_committee_mv
    ## 6              d_bio_contact_mv
    ## 7     d_bio_covering_account_mv
    ## 8              d_bio_degrees_mv
    ## 9  d_bio_demographic_profile_mv
    ## 10            d_bio_econtact_mv
    ## ..                          ...

``` r
# all of the giving summary tables are like sf_something_summary_mv:
find_tables("^sf_.+_summary_mv$")
```

    ## Source: local data frame [26 x 1]
    ## 
    ##                     table_name
    ##                          (chr)
    ## 1     sf_allocation_summary_mv
    ## 2   sf_entity_aogfy_summary_mv
    ## 3     sf_entity_aog_summary_mv
    ## 4  sf_entity_deptfy_summary_mv
    ## 5    sf_entity_dept_summary_mv
    ## 6      sf_entity_fy_summary_mv
    ## 7   sf_entity_prpfy_summary_mv
    ## 8     sf_entity_prp_summary_mv
    ## 9         sf_entity_summary_mv
    ## 10 sf_hh_corp_aogfy_summary_mv
    ## ..                         ...

Or look for specific columns, either throughout the database or within a given table:

``` r
# what's the name of the household_id column in d_entity?
find_columns("household", table_name = "d_entity_mv")
```

    ## Source: local data frame [1 x 4]
    ## 
    ##    table_name         column_name data_type data_length
    ##         (chr)               (chr)     (chr)       (int)
    ## 1 d_entity_mv household_entity_id    NUMBER          22

``` r
# where are all of the places degree information appears?
find_columns("degree")
```

    ## Source: local data frame [668 x 4]
    ## 
    ##                 table_name                column_name data_type
    ##                      (chr)                      (chr)     (chr)
    ## 1  cads_events_download_mv          degree_major_year  VARCHAR2
    ## 2  cads_events_download_mv   ungrad_degree_holder_flg      CHAR
    ## 3  cads_events_download_mv graduate_degree_holder_flg      CHAR
    ## 4         d_bio_degrees_mv                degree_type      CHAR
    ## 5         d_bio_degrees_mv           degree_type_desc  VARCHAR2
    ## 6         d_bio_degrees_mv          degree_level_code      CHAR
    ## 7         d_bio_degrees_mv          degree_level_desc  VARCHAR2
    ## 8         d_bio_degrees_mv                degree_code  VARCHAR2
    ## 9         d_bio_degrees_mv                degree_desc  VARCHAR2
    ## 10        d_bio_degrees_mv                degree_year  VARCHAR2
    ## ..                     ...                        ...       ...
    ## Variables not shown: data_length (int)

``` r
# continue filtering in dplyr if necessary:
find_columns("degree") %>% filter(table_name != "d_bio_degrees_mv")
```

    ## Source: local data frame [659 x 4]
    ## 
    ##                       table_name                column_name data_type
    ##                            (chr)                      (chr)     (chr)
    ## 1        cads_events_download_mv          degree_major_year  VARCHAR2
    ## 2        cads_events_download_mv   ungrad_degree_holder_flg      CHAR
    ## 3        cads_events_download_mv graduate_degree_holder_flg      CHAR
    ## 4  d_bio_relationship_details_mv          degree_major_year  VARCHAR2
    ## 5                    d_entity_mv         degree2_stop_dt_id  VARCHAR2
    ## 6                    d_entity_mv            degree2_stop_dt      DATE
    ## 7                    d_entity_mv         degree2_grad_dt_id  VARCHAR2
    ## 8                    d_entity_mv            degree2_grad_dt      DATE
    ## 9                    d_entity_mv   degree2_institution_code  VARCHAR2
    ## 10                   d_entity_mv   degree2_institution_name  VARCHAR2
    ## ..                           ...                        ...       ...
    ## Variables not shown: data_length (int)
