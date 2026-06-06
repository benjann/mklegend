# mklegend
Stata utility to create code for a custom legend

`mklegend` is a utility to create a do-it-yourself legend using 
`twoway scatteri` rather than Stata's `legend()` option. The code created by `mklegend`
is stored in `r(legend)` that can then be pasted into a `twoway` command or an
`addplot()` option to draw the legend.

In contrast to the `legend()` option, `mklegend` can combine multiple symbols
in a single legend key, and the keys can be freely positioned on the plot.

To install `mklegend` from GitHub, type

    . net install mklegend, replace from(https://raw.githubusercontent.com/benjann/mklegend/main/)

---

Examples:

The following example illustrates how create a legend using `mklegend` and then
include it in a `twoway` command.

    sysuse auto
    mklegend 40 45, frame: ///
           (Oh X, msize(large)) "Observations" ///
        || (line)               "Linear fit"
    twoway (sc mpg turn, msize(large) ms(Oh)) ///
        (sc mpg turn, msize(large) ms(X) pstyle(p1)) ///
        (lfit mpg turn, pstyle(p2)) ///
        `r(legend)', legend(off)

![example 1](/images/1.png)

The following example illustrates how to add a legend using the `addplot()` option.

    sysuse auto
    mklegend y=4600 h=200 x=145 w=5, frame(w(35)): ///
           () "data" ///
        || (area, astyle(ci)) (line, pstyle(p2)) "lopoly fit and 95% CI"
    lpoly weight length, degree(1) ci legend(off) addplot(`r(legend)')

![example 2](/images/2.png)

The following example illustrates how the legend keys can be placed in different
locations on the plot.

    sysuse auto
    mklegend y=.0015 h=0.0001, lskip(0) color(%50): ///
           (bar) "Domestic", x(4840) w(-300) ///
        || (bar) "Foreign", x(1760) w(300)
    two (hist weight if foreign==0, psty(p1bar) color(%50)) ///
        (hist weight if foreign==1, psty(p2bar) color(%50)) ///
        `r(legend)', legend(off)

![example 3](/images/3.png)

The following example illustrates how headings can be created.

    sysuse uslifeexp
    mklegend 55 1960 2 5: ///
           "Heading aligned with symbol" ///
        || (line) () "female" ///
        || - "Heading aligned with text" ///
        || (line) () "male"
    two (connect le_f le_m year) `r(legend)', legend(off)

![example 4](/images/4.png)

The `addplot` command ([Jann 2015](https://doi.org/10.1177/1536867X1501500308); type
`ssc install addplot` to install the command) can be used to add a legend
after a graph has been created. This can be useful, for example,
if a graph has been created using `graph combine`, as in the following example.

    sysuse auto
    scatter mpg trunk weight, legend(off) name(weight, replace)
    scatter mpg trunk price, legend(off) name(price, replace)
    graph combine weight price
    mklegend y=37 x=3500 h=1.5 w=150, frame(w(1700)): ///
           () "Mileage per gallon" ///
        || () "Trunk space"
    addplot 1: `r(legend)', norescaling

![example 5](/images/5.png)

A limitation of `mklegend` is that it can only place the legend within the
plot region. A workaround is provided by the `addplot` command:

    sysuse auto
    scatter mpg trunk weight, legend(off) graphregion(margin(r=40))
    mklegend y=5 x=5100 h=2 w=100: () "Mileage per gallon" || () "Trunk space"
    addplot: `r(legend)', norescaling

![example 6](/images/6.png)

---

Main changes:

    06jun2026 (version 1.0.1)
    - areas were not plotted correctly in Stata 14; this is fixed

    06jun2026 (version 1.0.0)
    - released on GitHub
