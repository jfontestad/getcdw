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
    ## *              <chr>
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
    ## *              <chr>
    ## 1 d_bio_committee_mv

``` r
# or view all of the d_bio tables:
find_tables("d_bio")
```

    ## Source: local data frame [26 x 1]
    ## 
    ##                      table_name
    ## *                         <chr>
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
    ## *                        <chr>
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
    ## *       <chr>               <chr>     <chr>       <int>
    ## 1 d_entity_mv household_entity_id    NUMBER          22

``` r
# where are all of the places degree information appears?
find_columns("degree")
```

    ## Source: local data frame [668 x 4]
    ## 
    ##                 table_name                column_name data_type
    ## *                    <chr>                      <chr>     <chr>
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
    ## Variables not shown: data_length <int>.

Code search
-----------

You can search through TMS tables to find codes:

``` r
# where/how do we record peace_corps participation?
find_codes("peace corps")
```

    ## Source: local data frame [116 x 4]
    ## 
    ##     code                  description       table_name       view_name
    ## *  <chr>                        <chr>            <chr>           <chr>
    ## 1  PCAFG    Peace Corps - Afghanistan Student Activity tms_student_act
    ## 2   PCAR Peace Corps - African Region Student Activity tms_student_act
    ## 3  PCALB        Peace Corps - Albania Student Activity tms_student_act
    ## 4  PCARM        Peace Corps - Armenia Student Activity tms_student_act
    ## 5  PCBGD     Peace Corps - Bangladesh Student Activity tms_student_act
    ## 6  PCBLZ         Peace Corps - Belize Student Activity tms_student_act
    ## 7  PCBEN          Peace Corps - Benin Student Activity tms_student_act
    ## 8  PCBOL        Peace Corps - Bolivia Student Activity tms_student_act
    ## 9  PCBWA       Peace Corps - Botswana Student Activity tms_student_act
    ## 10 PCBRA         Peace Corps - Brazil Student Activity tms_student_act
    ## ..   ...                          ...              ...             ...

``` r
# interest in neuroscience may present itself in terms of a major/minor, 
# an explicit interest code, attendance at an event, etc. let's look for
# all possibilities:
find_codes("neuroscience")
```

    ## Source: local data frame [16 x 4]
    ## 
    ##     code                              description            table_name
    ## *  <chr>                                    <chr>                 <chr>
    ## 1   HWNI                   Neuroscience Institute       Accounting Dept
    ## 2   4617 L&S Olson Berkeley Science, Neuroscience              Activity
    ## 3   5781    LS Berk Science Neuroscience 11-28-12              Activity
    ## 4     NS                   Neuroscience Institute       Activity Source
    ## 5   HWNI                   Neuroscience Institute Allocation Department
    ## 6   GNSO                 *Neurosciences Institute     Allocation School
    ## 7   CPSN                    *Neurosciences Center         Campaign Code
    ## 8  78001        Behavioral & Systems Neuroscience         Concentration
    ## 9  78006                   Cognitive Neuroscience         Concentration
    ## 10  HWNI                Neuroscience Grad Program           Departments
    ## 11   NEU                             Neuroscience             Interests
    ## 12    NS                   Neuroscience Institute      Mail List Source
    ## 13   594                             Neuroscience                Majors
    ## 14    NS                   Neuroscience Institute                Office
    ## 15    NS                   Neuroscience Institute      Prospect Program
    ## 16    NS                   Neuroscience Institute             Unit Code
    ## Variables not shown: view_name <chr>.

``` r
# i just want to look for neuro-related event codes
find_codes("neuro", "^activity$")
```

    ## Source: local data frame [2 x 4]
    ## 
    ##    code                              description table_name
    ## * <int>                                    <chr>      <chr>
    ## 1  4617 L&S Olson Berkeley Science, Neuroscience   Activity
    ## 2  5781    LS Berk Science Neuroscience 11-28-12   Activity
    ## Variables not shown: view_name <chr>.
