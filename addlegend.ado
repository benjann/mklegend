*! version 1.0.0  07jun2026  Ben Jann

program addlegend, rclass
    version 14
    _on_colon_parse `0'
    local 0 `"`s(before)'"'
     _parse comma dimexp 0 : 0
    syntax [, graph(name) PLOTs(numlist int >=1) nodraw Margin(passthru) * ]
    if `"`margin'"'!="" local margin graphregion(`margin')
    mklegend `dimexp', `options' : `s(after)'
    local legend `"`r(legend)'"'
    return add
    addplot `graph' `plots', `draw': `legend', norescaling legend(off) `margin'
end
