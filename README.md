SP6 - Simple Perl 6 templating toolkit
======================================

Example
-------

    perl6 -Ilib bin/sp6-gen.p6 --templ_dir=../BrnoPM-Web/templ/ --templ=index.sp6 --inside=inc/html.sp6

How it works
------------

    > perl6 -Ilib bin/sp6-gen.p6 --templ_dir=t/templ --debug include.sp6
    Template fpath: 't/templ/include.sp6'
    code: "Qc ｢aa \{include 'inc/include-inner.sp6'} cc｣;"
    Template fpath: 't/templ/inc/include-inner.sp6'
    code: "Qc ｢inner-text｣;"
    output:
    aa inner-text cc


Know issues
-----------

Characters '｢' and '｣' are forbidden.
