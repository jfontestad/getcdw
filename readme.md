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

    ## # A tibble: 1 x 1
    ##          report_name
    ##                <chr>
    ## 1 Shah, Tarak Rashmi

You can also pass a query from a file, for instance: `get_cdw("sql/filename.sql")`.

Table and column search
-----------------------

Look for tables with `find_tables()`:

``` r
# want the committees table, but don't remember the exact name:
find_tables("committee")
```

    ## # A tibble: 1 x 1
    ##           table_name
    ##                <chr>
    ## 1 d_bio_committee_mv

``` r
# or view all of the d_bio tables:
find_tables("d_bio")
```

    ## # A tibble: 24 x 1
    ##                       table_name
    ##                            <chr>
    ## 1      d_bio_student_activity_mv
    ## 2                 d_bio_sport_mv
    ## 3            d_bio_salutation_mv
    ## 4          d_bio_relationship_mv
    ## 5  d_bio_relationship_details_mv
    ## 6      d_bio_org_relationship_mv
    ## 7         d_bio_org_employees_mv
    ## 8                  d_bio_name_mv
    ## 9          d_bio_mailing_list_mv
    ## 10             d_bio_interest_mv
    ## # ... with 14 more rows

``` r
# all of the giving summary tables are like sf_something_summary_mv:
find_tables("^sf_.+_summary_mv$")
```

    ## # A tibble: 26 x 1
    ##                       table_name
    ##                            <chr>
    ## 1      sf_transaction_summary_mv
    ## 2         sf_prospect_summary_mv
    ## 3     sf_prospect_prp_summary_mv
    ## 4   sf_prospect_prpfy_summary_mv
    ## 5      sf_prospect_fy_summary_mv
    ## 6    sf_prospect_dept_summary_mv
    ## 7  sf_prospect_deptfy_summary_mv
    ## 8     sf_prospect_aog_summary_mv
    ## 9   sf_prospect_aogfy_summary_mv
    ## 10         sf_hh_corp_summary_mv
    ## # ... with 16 more rows

Or look for specific columns, either throughout the database or within a given table:

``` r
# what's the name of the household_id column in d_entity?
find_columns("household", table_name = "d_entity_mv")
```

    ## # A tibble: 1 x 4
    ##    table_name         column_name data_type data_length
    ##         <chr>               <chr>     <chr>       <dbl>
    ## 1 d_entity_mv household_entity_id    NUMBER          22

``` r
# where are all of the places degree information appears?
find_columns("degree")
```

    ## # A tibble: 695 x 4
    ##                       table_name          column_name data_type
    ##                            <chr>                <chr>     <chr>
    ## 1               d_bio_degrees_mv          degree_type      CHAR
    ## 2               d_bio_degrees_mv     degree_type_desc  VARCHAR2
    ## 3               d_bio_degrees_mv    degree_level_code      CHAR
    ## 4               d_bio_degrees_mv    degree_level_desc  VARCHAR2
    ## 5               d_bio_degrees_mv          degree_code  VARCHAR2
    ## 6               d_bio_degrees_mv          degree_desc  VARCHAR2
    ## 7               d_bio_degrees_mv          degree_year  VARCHAR2
    ## 8               d_bio_degrees_mv honorary_degree_code  VARCHAR2
    ## 9               d_bio_degrees_mv honorary_degree_desc  VARCHAR2
    ## 10 d_bio_relationship_details_mv    degree_major_year  VARCHAR2
    ## # ... with 685 more rows, and 1 more variables: data_length <dbl>

Code search
-----------

You can search through TMS tables to find codes:

``` r
# where/how do we record peace_corps participation?
find_codes("peace corps")
```

    ## # A tibble: 116 x 4
    ##     code                  description       table_name       view_name
    ##    <chr>                        <chr>            <chr>           <chr>
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
    ## # ... with 106 more rows

``` r
# interest in neuroscience may present itself in terms of a major/minor, 
# an explicit interest code, attendance at an event, etc. let's look for
# all possibilities:
find_codes("neuroscience")
```

    ## # A tibble: 16 x 4
    ##     code                              description            table_name
    ##    <chr>                                    <chr>                 <chr>
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
    ## # ... with 1 more variables: view_name <chr>

``` r
# i just want to look for neuro-related event codes
find_codes("neuro", "^activity$")
```

    ## # A tibble: 2 x 4
    ##    code                              description table_name
    ##   <chr>                                    <chr>      <chr>
    ## 1  4617 L&S Olson Berkeley Science, Neuroscience   Activity
    ## 2  5781    LS Berk Science Neuroscience 11-28-12   Activity
    ## # ... with 1 more variables: view_name <chr>

dplyr backend
-------------

If you use dplyr, you can now query the data warehouse directly, rather than writing SQL and pulling data into a local data frame:

``` r
# you have to have dplyr loaded to use dplyr
library(dplyr)

# use src_oracle("DSNNAME") to connect to dsn DSNNAME
# for example: src_oracle("CDW2") or src_oracle("URELUAT")
cdw <- src_oracle()

# each table you reference is described using the dplyr's tbl() function
entity <- tbl(cdw, "cdw.d_entity_mv")
transactions <- tbl(cdw, "cdw.f_transaction_detail_mv")

# note that auto-complete works inside the dplyr verbs!
entity <- entity %>% select(entity_id, person_or_org)
entity
```

    ## Source:   query [?? x 2]
    ## Database: oracle 11.2.0.4.0 [tarak@URELUAT]
    ## 
    ##    entity_id person_or_org
    ##        <dbl>         <chr>
    ## 1     324212             P
    ## 2     294198             P
    ## 3     221450             P
    ## 4    3074563             P
    ## 5      15052             P
    ## 6      17665             P
    ## 7      20263             P
    ## 8     692410             P
    ## 9    3256615             P
    ## 10    839479             P
    ## # ... with more rows

``` r
# the top donors of 2001, along with whether they are people or organizations
transactions %>%
    filter(between(giving_record_dt,
                   to_date('01/01/2001', 'mm/dd/yyyy'),
                   to_date('12/31/2001', 'mm/dd/yyyy'))) %>%
    filter(pledged_basis_flg == "Y") %>%
    group_by(donor_entity_id_nbr) %>%
    summarise(giving = sum(benefit_dept_credited_amt)) %>%
    inner_join(entity, by = c("donor_entity_id_nbr" = "entity_id")) %>%
    arrange(desc(giving))
```

    ## Source:   query [?? x 3]
    ## Database: oracle 11.2.0.4.0 [tarak@URELUAT]
    ## 
    ##    donor_entity_id_nbr  giving entity_id person_or_org
    ##                  <dbl>   <dbl>     <dbl>         <chr>
    ## 1              2014421 6265183   2014421             O
    ## 2                 3422 6006000      3422             P
    ## 3                39830 6006000     39830             P
    ## 4                 1824 5150000      1824             P
    ## 5                18305 4124767     18305             P
    ## 6               677429 3159974    677429             P
    ## 7              2014324 3057653   2014324             O
    ## 8                29998 3054450     29998             P
    ## 9               507872 2779989    507872             P
    ## 10             2010868 2730269   2010868             O
    ## # ... with more rows

Parameterized Templates
-----------------------

The `parameterize_template` function allows you to turn templates that have \#\#highlighted\#\# variables into functions:

``` r
f <- parameterize_template("my name is ##name##")
f("tarak")
```

    ## [1] "my name is tarak"

``` r
# need named arguments when more than 1 parameter:
g <-parameterize_template("hi i'm ##name##, i am ##age## years old") 
g(name = "tarak", age = 36)
```

    ## [1] "hi i'm tarak, i am 36 years old"

`parameterize_template` is useful in creating reports because it allows you to write SQL with parameters, with the added benefit of the convenient function interface.

``` r
template <- "
select donor_entity_id_nbr, 
sum(benefit_dept_credited_amt) as giving
from cdw.f_transaction_detail_mv
where pledged_basis_flg = 'Y'
and giving_record_dt between to_date('##from_date##', 'mm/dd/yyyy') 
and to_date('##to_date##', 'mm/dd/yyyy')
group by donor_entity_id_nbr
having sum(benefit_dept_credited_amt) > 5000000"

top_donors_between <- parameterize_template(template)
report <- top_donors_between(from_date = "01/01/2001", to_date = "12/31/2001")
get_cdw(report)
```

    ## # A tibble: 4 x 2
    ##   donor_entity_id_nbr  giving
    ##                 <dbl>   <dbl>
    ## 1                3422 6006000
    ## 2               39830 6006000
    ## 3             2014421 6265183
    ## 4                1824 5150000

Just like with `get_cdw`, `parameterize_template` works with files also, for example `parameterize_template('sql/my-template.sql')`.
