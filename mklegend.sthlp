{smcl}
{* 07jun2026}{...}
{hi:help mklegend}{...}
{right:{browse "https://github.com/benjann/mklegend/"}}
{hline}

{title:Title}

{pstd}{hi:mklegend} {hline 2} Utility to create code for a custom legend


{title:Syntax}

{p 8 15 2}
    {cmd:mklegend} [{it:dimexp}]
    [{cmd:,} {it:{help mklegend##opts:options}} ]
    {cmd::} {it:keylist}

{p 8 15 2}
    {cmd:addlegend} [{it:dimexp}]
    [{cmd:,} {it:{help mklegend##aopts:addopts}}
    {it:{help mklegend##opts:options}} ]
    {cmd::} {it:keylist}

{pstd}
    where {it:dimeexp} is either

{p 8 15 2}
        {it:#_y} [{it:#_x} [{it:#_h} [{it:#_w}]]]

{pstd}
    or one or more elements of the form

{p 8 15 2}
    {{cmd:y}|{cmd:x}|{cmd:h}|{cmd:w}} [{cmd:=}] {it:#}

{pstd}
    and {it:keylist} is

{p 8 15 2}
    {it:key} [ {cmd:||} {it:key} [...]]

{pstd}
    and {it:key} is

{p 8 15 2}
    [{it:symboldef}]
    {cmd:"}{it:text}{cmd:"} [{cmd:"}{it:text}{cmd:"} [...]]
    [{cmd:,} {opt lskip(#)} {it:{help mklegend##sopts:symopts}}
    {it:{help mklegend##topts:txtopts}} ]

{pstd}
    and {it:symboldef} is {cmd:-} or

{p 8 15 2}
    {cmd:(}{it:symlist} [{cmd:,} {it:{help mklegend##sopts:symopts}}]{cmd:)}
    [{cmd:(}{it:symlist} [{cmd:,} {it:{help mklegend##sopts:symopts}}]{cmd:)} [...]]

{pstd}
    and {it:symlist} is

{p 8 15 2}
    [{it:symbol} [{it:symbol} [...]]]

{pstd}
    and {it:symbol} is

{p2colset 9 22 22 2}{...}
{p2col : {it:{help symbolstyle}}}marker
    {p_end}
{p2col : {opt line}}line
    {p_end}
{p2col : {opt rline}}double line
    {p_end}
{p2col : {opt area}}area
    {p_end}
{p2col : {opt bar}}bar
    {p_end}
{p2col : {opt cap}}capped line
    {p_end}
{p2col : {opt capsym}}line capped with symbols
    {p_end}


{synoptset 23 tabbed}{...}
{marker opts}{synopthdr:options}
{synoptline}
{syntab :{it:{help mklegend##options:Main}}}
{synopt :{cmdab:fr:ame}[{cmd:(}{it:{help mklegend##frame:subopts}}{cmd:)}]}draw
    frame around legend
    {p_end}
{synopt :{opt lskip(#)}}baseline skip between legend keys
    {p_end}

{marker sopts}{...}
{syntab :{it:{help mklegend##symopts:symopts}}}
{synopt :{opt y(#)}}vertical position of key (in units of Y-axis)
    {p_end}
{synopt :{opt x(#)}}horizontal position of key (in units of X-axis)
    {p_end}
{synopt :{opt h:eight(#)}}height of key's symbol (in units of Y-axis)
    {p_end}
{synopt :{opt w:idth(#)}}width of key's symbol (in units of X-axis)
    {p_end}
{synopt :{it:{help marker_options}}}options affecting look of markers
    {p_end}
{synopt :{it:{help line_options}}}options affecting look of lines
    {p_end}
{synopt :{it:{help area_options}}}options affecting look of areas
    {p_end}

{marker topts}{...}
{syntab :{it:{help mklegend##txtopts:txtopts}}}
{synopt :{opt ty(#)}}vertical position of text, relative to symbol
    {p_end}
{synopt :{opt tx(#)}}horizontal position of text, relative to symbol
    {p_end}
{synopt :{opth t:ext(textbox_options)}}options affecting look of text
    {p_end}
{synoptline}

{synoptset 23}{...}
{marker aopts}{...}
{synopt :{it:{help mklegend##addopts:addopts}}}Description{p_end}
{synoptset 23 tabbed}{...}
{synoptline}
{synopt :{opth m:argin(marginstyle)}}reset margin of graph region
    {p_end}
{synopt :{opt graph(graphname)}}name of graph to be modified
    {p_end}
{synopt :{opth plot:s(numlist)}}subgraph(s) to be modified
    {p_end}
{synopt :{opt nodraw}}do not update graph window
    {p_end}
{synoptline}


{title:Description}

{pstd}
    {cmd:mklegend} is a utility to create a do-it-yourself legend using
    {helpb twoway scatteri} rather than Stata's {helpb legend_option:legend()}
    option. The code created by {cmd:mklegend} is stored in {cmd:r(legend)}
    that can then be pasted into a {helpb twoway} command or an
    {helpb addplot_option:addplot()} option to draw the legend.

{pstd}
    In contrast to the {helpb legend_option:legend()} option, {cmd:mklegend}
    can combine multiple symbols in a single legend key, and the keys
    can be freely positioned on the plot.

{pstd}
    Use {it:dimexp} to specify basic settings such as the position of the legend
    and the size of the space allocated for the keys' symbols. The units of the
    dimensions specified in {it:dimexp} are the ones of the Y and X axes
    of the plot. {it:dimexp} can be specified using positional arguments

        {it:#_y} {it:#_x} {it:#_h} {it:#_w}

{pstd}
    or named arguments of the form

        {{cmd:y}|{cmd:x}|{cmd:h}|{cmd:w}} [{cmd:=}] {it:#}

{pstd}
    (or a mix of positional and named arguments). Omitted arguments will be set
    to {cmd:1}. Argument {cmd:y=}{it:#} (i.e. {it:#_y})
    sets the position of the first key only; subsequent keys will follow
    in steps depending on {helpb mklegend##lskip:lskip()}. The other
    arguments apply to all keys.

{pstd}
    Use options {helpb mklegend##y:y()}, {helpb mklegend##x:x()},
    {helpb mklegend##height:height()}, and {helpb mklegend##width:width()}
    within a {it:key} to override the settings from {it:dimexp} and make the
    new settings permanent so that they will also apply to subsequent keys. Use
    the options within {it:symboldef} to apply custom settings to (a part of) a
    key's symbol only, without affecting subsequent keys or the key's overall
    positioning.

{pstd}
    {cmd:addlegend} is a wrapper that calls {cmd:mklegend} to create a legend
    and then adds the legend to an existing graph using the {helpb addplot}
    command ({browse "https://doi.org/10.1177/1536867X1501500308":Jann 2015}). The
    legend from Stata's {helpb legend_option:legend()} option will be
    removed. {cmd:addlegend} requires {helpb addplot} to be installed on the
    system; type {cmd:ssc install addplot} to install {helpb addplot}. In essence,
    {cmd:addlegend} is equivalent to tying

        {com}. mklegend {txt:{it:arguments ...}}
        . addplot: `r(legend)', norescaling legend(off){txt}


{marker options}{...}
{title:Options}

{dlgtab:Main}

{marker frame}{...}
{phang}
    {cmd:frame}[{cmd:(}{it:subopts}{cmd:)}] draws a frame around the legend;
    {it:subopts} are {opt y(#)} and {opt x(#)} to set the position of the upper
    left corner of the frame, {opt h:eight(#)} and {opt w:idth(#)} to set the
    height and width of the frame, and {it:{help area_options}} to affect look
    of the fill and outline of the frame. By default, area options
    {cmd:astyle(foreground)} and {cmd:fcolor(white)} will be applied.

{pmore}
    Options {cmd:y()} and {cmd:height()} are in units of the Y-axis, {cmd:x()}
    and {cmd:width()} in units of the X-axis. If omitted, these options are set
    automatically depending on the position of the first key, the number of
    keys, the baseline skip, and the size of the key symbols. In most cases,
    you will need to set at least {cmd:width()} manually to get a good result.

{marker lskip}{...}
{phang}
    {opt lskip(#)} sets the baseline skip between legend keys as a factor of
    the symbol height; the default is {cmd:1.5}. Option {cmd:lskip()} has no
    effect on legend keys that are positioned explicitly using options
    {helpb mklegend##y:y()} and {helpb mklegend##x:x()}.

{phang}
    {it:symopts} are options affecting the positons of the legend keys and the
    rendering of the keys' symbols; see {help mklegend##symopts:below}.

{phang}
    {it:txtopts} are options affecting the rendering of the texts of the
    legend keys; see {help mklegend##txtopts:below}.

{marker symopts}{...}
{dlgtab:symopts}

{marker y}{...}
{phang}
    {opt y(#)} sets the vertical position of the legend key, in units of the
    Y-axis. To be precise, {cmd:y()} set the midpoint of the vertical space
    allocated for the key's symbol. If omitted, the position is set
    automatically based on the positon of the previous key.

{marker x}{...}
{phang}
    {opt x(#)} sets the horizontal position of the legend key, in units of the
    X-axis. To precise, {opt x()} sets the position of the left (right) edge of the
    space allocated for the key's symbol if {cmd:width()} is positive (negative).

{marker height}{...}
{phang}
    {opt height(#)} sets the height to be allocated for
    the legend key's symbol, in units of the Y-axis.

{marker width}{...}
{phang}
    {opt width(#)} sets the width to be allocated for
    the legend key's symbol, in units of the X-axis.

{phang}
    {it:marker_options} are options affecting look of the markers included
    in the legend key's symbol; see help {it:{help marker_options}}. If omitted,
    option {cmd:pstyle()} will be set automatically based on the order of the
    key.

{phang}
    {it:line_options} are options affecting look of the lines included
    in the legend key's symbol; see help {it:{help line_options}}.

{phang}
    {it:area_options} are options affecting look of the areas included
    in the legend key's symbol; see help {it:{help area_options}}.

{marker txtopts}{...}
{dlgtab:txtopts}

{phang}
    {opt ty(#)} sets the vertical offset of the text, relative to the key's
    symbol, in units of the Y-axis of the plot. The default is {cmd:0}.

{phang}
    {opt tx(#)} sets the horizontal offset of the text, relative to the key's
    symbol, in units of the X-axis of the plot. The default is to set
    the offset to 1.2 times the width of the key's symbol.

{phang}
    {opt text(textbox_options)} specifies options affecting look of the text,
    such as its size, color, or justification; see help
    {it:{help textbox_options}}. If omitted, options {cmd:placement()} and
    {cmd:justification()} are set automatically depending on the sign of
    {cmd:tx()}: {cmd:placement(east)} and {cmd:justification(left)} if positive;
    {cmd:placement(west)} and {cmd:justification(right)} if negative.

{marker addopts}{...}
{dlgtab:addopts}

{phang}
    {opt margin(marginstyle)} resets the margin of the graph region; see help
    {it:{help marginstyle}}. This is useful if you want to place the legend in
    the margin of the graph instead of in the plot region.

{phang}
    {opt graph(graphname)} selects the memory graph to be modified. The default
    is to modify the current (topmost) graph.

{phang}
    {opt plot:s(numlist)} selects the subgraph(s) to be modified. This is only
    relevant in case of a graph that has been created by {helpb graph combine}
    or the {helpb by_option:by()} option. The default is to modify all
    subgraphs found in the graph.

{phang}
    {opt nodraw} causes the graph data to be modified without updating the
    display in the graph window. Use {helpb graph display}
    to view the modified graph after applying {cmd:addlegend} with option
    {cmd:nodraw}.

{title:Examples}

{dlgtab:Basic example}

{pstd}
    The following example illustrates how to add a legend in a {helpb twoway} command.

        . {stata sysuse auto}
{p 8 12 2}
    . {stata `"mklegend 40 45, frame: (Oh X, msize(large)) "Observations" || (line) "Linear fit""'}
    {p_end}
{p 8 12 2}
    . {stata two (sc mpg turn, msize(large) ms(Oh)) (sc mpg turn, msize(large) ms(X) pstyle(p1)) (lfit mpg turn, pstyle(p2)) `r(legend)', legend(off)}
    {p_end}

{pstd}
    Note how {cmd:(Oh X)} has been used to create a composite symbol.

{dlgtab:Addplot option}

{pstd}
    The following example illustrates how to add a legend using the {helpb addplot_option:addplot()} option.

        . {stata sysuse auto}
{p 8 12 2}
    . {stata `"mklegend y=4600 h=200 x=145 w=5, frame(w(35)): () "data" || (area, astyle(ci)) (line, pstyle(p2)) "lopoly fit and 95% CI""'}
    {p_end}
{p 8 12 2}
    . {stata lpoly weight length, degree(1) ci legend(off) addplot(`r(legend)')}
    {p_end}

{pstd}
    Note how {cmd:()} has been used to select the plot's default marker symbol
    for the first legend key.

{dlgtab:Custom positioning of legend keys}

{pstd}
    The following example illustrates how the legend keys can be placed in different
    locations on the plot.

        . {stata sysuse auto}
{p 8 12 2}
    . {stata `"mklegend y=.0015 h=0.0001, lskip(0) color(%50): (bar) "Domestic", x(4840) w(-300) || (bar) "Foreign", x(1760) w(300)"'}
    {p_end}
{p 8 12 2}
    . {stata two (hist weight if foreign==0, psty(p1bar) color(%50)) (hist weight if foreign==1, psty(p2bar) color(%50)) `r(legend)', legend(off)}
    {p_end}

{pstd}
    Note how setting a negative {cmd:width()} flips the placement and justification
    of a key's text.

{dlgtab:Headings}

{pstd}
    To create a heading that is aligned with the keys' symbols, type

        {cmd:"}{it:text}{cmd:"} [{cmd:"}{it:text}{cmd:"} [...]]

{pstd}
    Alternatively, to create a heading that is aligned with the
    keys' texts, type

        {cmd:-} {cmd:"}{it:text}{cmd:"} [{cmd:"}{it:text}{cmd:"} [...]]

{pstd}
    The following example illustrates the difference.

        . {stata sysuse uslifeexp}
{p 8 12 2}
    . {stata `"mklegend 55 1960 2 5: "Heading aligned with symbol" || (line) () "female" || - "Heading aligned with text" || (line) () "male""'}
    {p_end}
{p 8 12 2}
    . {stata two (connect le_f le_m year) `r(legend)', legend(off)}
    {p_end}

{dlgtab:Add legend to existing graph}

{pstd}
    Command {cmd:addlegend} can be used to create a legend and add it directly
    to a graph that already exists in memory. {cmd:addlegend} makes use of
    command {helpb addplot}
    ({browse "https://doi.org/10.1177/1536867X1501500308":Jann 2015}), which
    needs to be installed on the system (type {cmd:ssc install addplot}). An
    example is as follows.

        . {stata sysuse auto}
{p 8 12 2}
    . {stata scatter mpg trunk weight}
    {p_end}
{p 8 12 2}
    . {stata `"addlegend y=35 x=4000 h=2 w=100, frame(w(900)): () "Mileage per gallon" || () "Trunk space""'}
    {p_end}

{pstd}
    Note that {cmd:addlegend} removes the existing default legend. In case of a graph
    that contains multiple subgraphs, use option {cmd:plot()} to select the subgraph
    to which the legend should be added. Example:

        . {stata sysuse auto}
{p 8 12 2}
    . {stata scatter mpg trunk weight, legend(off) name(weight, replace) nodraw}
    {p_end}
{p 8 12 2}
    . {stata scatter mpg trunk price, legend(off) name(price, replace) nodraw}
    {p_end}
{p 8 12 2}
    . {stata graph combine weight price}
    {p_end}
{p 8 12 2}
    . {stata `"addlegend y=37 x=3500 h=1.5 w=150, plot(1) frame(w(1700)): () "Mileage per gallon" || () "Trunk space""'}
    {p_end}

{dlgtab:Placing the legend outside of the plot region}

{pstd}
    A limitation of {cmd:mklegend} is that it can only place the legend within
    the plot region. A workaround is provided by the {helpb addplot} command,
    which allows adding elements to a plot using coordinates that lie outside
    of the range of the displayed axes. You must make sure, however, that there
    is sufficient space for the legend in the graph's margin. Here is an
    example.

        . {stata sysuse auto}
{p 8 12 2}
    . {stata scatter mpg trunk weight, legend(off)}
    {p_end}
{p 8 12 2}
    . {stata `"mklegend y=5 x=5100 h=2 w=100: () "Mileage per gallon" || () "Trunk space""'}
    {p_end}
{p 8 12 2}
    . {stata "addplot: `r(legend)', norescaling graphregion(margin(r=40))"}
    {p_end}

{pstd}
    The same result can be achieved by using option {cmd:margin()} in the
    {cmd:addlegend} command:

        . {stata sysuse auto}
{p 8 12 2}
    . {stata scatter mpg trunk weight}
    {p_end}
{p 8 12 2}
    . {stata `"addlegend y=5 x=5100 h=2 w=100, margin(r=40): () "Mileage per gallon" || () "Trunk space""'}
    {p_end}


{title:Returned results}

{pstd}
    {cmd:mklegend} and {cmd:addlegend} store the code of the legend in macro
    {cmd:r(legend)}. In addition, if option {cmd:frame} is specified, the
    coordinates of the frame will be stored in scalars {cmd:r(fs_y)},
    {cmd:r(fs_x)}, {cmd:r(fs_h)}, and {cmd:r(fs_w)}.


{title:References}

{phang}
    Jann, B. 2015. A note on adding objects to an existing twoway graph. The Stata Journal
    15(3): 751-755. {browse "https://doi.org/10.1177/1536867X1501500308"}
    {p_end}


{title:Author}

{pstd}
    Ben Jann, University of Bern, ben.jann@unibe.ch

{pstd}
    Thanks for citing this software as follows:

{pmore}
    Jann, B. 2026. mklegend: Stata utility to create code for a custom legend. Available from
    {browse "https://github.com/benjann/mklegend/"}.


{title:Also see}

{psee}
    Online:  help for
    {helpb graph twoway}, {helpb addplot} (from SSC)
