SP6 - Simple Raku templates
===========================

Examples
--------

    > cat t/templ/base.sp6 ; echo
    foobar
    > raku -Ilib bin/sp6 --templ_dir=t/templ -e='aa {include "base.sp6"} bb'
    aa foobar bb

    > cat t/templ/inside-outher.sp6  ; echo
    outherA {main_part} outherB
    > raku -Ilib bin/sp6 --templ_dir=t/templ -e='aa {include "base.sp6"} bb' --inside=inside-outher.sp6
    outherA aa foobar bb outherB

    raku -Ilib bin/sp6 --templ_dir=../BrnoPM-Web/templ/ --templ=index.sp6 --inside=inc/html.sp6

How it works
------------

    > raku -Ilib bin/sp6 --templ_dir=t/templ --debug include.sp6
    Template fpath: 't/templ/include.sp6'
    code: "Qc ｢aa \{include 'inc/include-inner.sp6'} cc｣;"
    Template fpath: 't/templ/inc/include-inner.sp6'
    code: "Qc ｢inner-text｣;"
    output:
    aa inner-text cc


Know issues
-----------

Characters '｢' and '｣' are forbidden.
