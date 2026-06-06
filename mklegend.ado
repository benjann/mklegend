*! version 1.0.0  06jun2026  Ben Jann

program mklegend, rclass
    version 14
    _on_colon_parse `0'
    local 0 `"`s(before)'"'
    
    // parse s(after)
    mata: keys_expand() // returns key_n, key_#
    
    // parse dimlist
    _parse comma dimexp 0 : 0
    mata: parse_dimexp()
    gettoken Y      dimexp : dimexp
    gettoken X      dimexp : dimexp
    gettoken HEIGHT dimexp : dimexp
    gettoken WIDTH         : dimexp
    
    // parse options
    syntax [, FRame FRame2(str) lskip(real 1.5)/*
        */ y(numlist max=1) x(numlist max=1)/*
        */ Height(numlist max=1) Width(numlist max=1)/*
        */ ty(real 0) tx(numlist max=1) Text(str)/*
        */ PSTYle(passthru) * ]
    parse_topts, `text'
    foreach opt in y x height width {
        if "``opt''"!="" continue
        local OPT = strupper("`opt'")
        local `opt' ``OPT''
    }
    
    // create frame
    if `"`frame'`frame2'"'!="" {
        local frame frame
        parse_frame, `frame2'
        local fr_sgn = cond(`lskip'<0, -1, 1)
        local fr_pad = 2 * (`lskip' - `fr_sgn') * `height' + `fr_sgn' * `height'
        if abs(`fr_pad')<abs(2.5 * `height') {
            local fr_pad = `fr_sgn' * 2.5 * `height'
        }
        if "`fr_y'"=="" local fr_y = `y' + `fr_pad'/2
        if "`fr_h'"=="" local fr_h = (`key_n'-1) * `lskip' * `height' + `fr_pad'
        if "`fr_x'"=="" local fr_x = `x' - .5 * `width'
        if "`fr_w'"=="" local fr_w = 6 * `width'
        local fr_b = `fr_y' - `fr_h'
        local fr_r = `fr_x' + `fr_w'
        local legend (scatteri `fr_b' `fr_x' `fr_b' `fr_r' `fr_y' `fr_r'/*
            */ `fr_y' `fr_x', recast(area) `fr_opts')
    }
    
    // create keys
    local p 0
    forv i=1/`key_n' {
        parse_key `p' `y' `x' `height' `width' `lskip' `"`pstyle'"'/*
            */`"`options'"' `ty' "`tx'" `"`place'"' `"`just'"' `"`topts'"'/*
            */ `key_`i'' // returns plots, p, y, x, ...
        local legend `legend' `plots'
    }
    
    // return result
    return local legend `"`legend'"'
    if "`frame'"!="" {
        return scalar fr_w = `fr_h'
        return scalar fr_h = `fr_w'
        return scalar fr_x = `fr_x'
        return scalar fr_y = `fr_y'
    }
end

program parse_topts
    syntax [, PLACEment(passthru) Justification(passthru) * ]
    c_local place `placement'
    c_local just `justification'
    c_local topts `options'
end

program parse_frame
    syntax [, y(numlist max=1) x(numlist max=1)/*
        */ Height(numlist max=1) Width(numlist max=1)/*
        */ ASTYle(passthru) FColor(passthru) * ]
    if `"`astyle'"'=="" local astyle astyle(foreground)
    if `"`fcolor'"'=="" local fcolor fcolor(white)
    c_local fr_y `y'
    c_local fr_x `x'
    c_local fr_h `height'
    c_local fr_w `width'
    c_local fr_opts `astyle' `fcolor' `options'
end

program parse_key
    gettoken p        0 : 0
    gettoken Y        0 : 0
    gettoken X        0 : 0
    gettoken HEIGHT   0 : 0
    gettoken WIDTH    0 : 0
    gettoken LSKIP    0 : 0
    gettoken PSTYLE   0 : 0
    gettoken OPTIONS  0 : 0
    gettoken TY       0 : 0
    gettoken TX       0 : 0
    gettoken PLACE    0 : 0
    gettoken JUST     0 : 0
    gettoken TOPTS    0 : 0
    _parse comma txt  0 : 0
    syntax [, lskip(numlist max=1) /*
        */ y(numlist max=1) x(numlist max=1)/*
        */ Height(numlist max=1) Width(numlist max=1)/*
        */ ty(numlist max=1) tx(numlist max=1) Text(str)/*
        */ PSTYle(passthru) * ]
    parse_topts, `text'
    foreach opt in y x height width lskip pstyle ty tx place just {
        if "``opt''"!="" continue
        local OPT = strupper("`opt'")
        local `opt' ``OPT''
    }
    local options `OPTIONS' `options'
    local topts `TOPTS' `topts'
    
    // collect symbols
    gettoken next : txt
    if `"`next'"'=="-" {
        gettoken next txt : txt
        local sym_n  0
        local hassym 1
    }
    else {
        local i 0
        while (1) {
            gettoken next : txt, match(par)
            if `"`par'"'!="" {
                local ++i
                gettoken sym_`i' txt : txt, match(par)
                continue
            }
            continue, break
        }
        local sym_n `i'
        if `sym_n' {
            local hassym 1
            local p = mod(`++p'-1, 15) + 1
        }
        else local hassym 0
    }
    
    // plot symbols
    local plots
    forv i=1/`sym_n' {
        parse_sym `p' `y' `x' `height' `width' `"`pstyle'"' `"`options'"'/*
            */ `sym_`i''
        local plots `plots' `plot'
    }
    
    // collect label
    parse_txt `txt' // returns txt
    
    // plot label
    if "`tx'"=="" local TX = 1.2 * `width'
    else          local TX `tx'
    if `hassym' {
        local Y = `y' + `ty'
        local X = `x' + `TX'
    }
    else {
        local Y = `y'
        local X = `x'
    }
    if `"`place'"'=="" {
        if `TX'<0 local place place(w)
        else      local place place(e)
    }
    if `"`just'"'=="" {
        if `TX'<0 local just just(right)
        else      local just just(left)
    }
    local topts `place' `just' `topts'
    local plots `plots' (scatteri `Y' `X', ms(i)/*
        */ text(`Y' `X' `txt', `topts'))
    
    // returns
    local y = `y' - `height' * `lskip'
    foreach opt in p y x height width lskip ty tx {
        c_local `opt' ``opt''
    }
    c_local plots `plots'
end

program parse_sym
    gettoken p       0 : 0
    gettoken Y       0 : 0
    gettoken X       0 : 0
    gettoken HEIGHT  0 : 0
    gettoken WIDTH   0 : 0
    gettoken PSTYLE  0 : 0
    gettoken OPTIONS 0 : 0
    _parse comma SYM 0 : 0
    if !`: list sizeof SYM' local SYM `""""'
    syntax [, Y(numlist max=1) X(numlist max=1)/*
        */ Height(numlist max=1) Width(numlist max=1)/*
        */ PSTYle(passthru) * ]
    foreach opt in y x height width pstyle {
        if "``opt''"!="" continue
        local OPT = strupper("`opt'")
        local `opt' ``OPT''
    }
    local options `OPTIONS' `options'
    local plots
    foreach sym of local SYM {
        local ptype ""
        if inlist(`"`sym'"',"line","cap","capsym") {
            local l = `x'
            local r = `x' + `width'
            if `"`sym'"'=="line"     local plot recast(line)
            else if `"`sym'"'=="cap" local plot recast(connect) ms(|)
            else                     local plot recast(connect)
            local plot scatteri `y' `l' `y' `r', `plot'
        }
        else if inlist(`"`sym'"',"area","bar","rline") {
            local l = `x'
            local r = `x' + `width'
            local b = `y' - 0.5 * `height'
            local t = `y' + 0.5 * `height'
            if `"`sym'"'=="rline" {
                local plot scatteri `t' `l' `t' `r' . . `b' `l' `b' `r',/*
                    */ recast(line) cmissing(n)
            }
            else {
                local ptype "`sym'"
                local plot scatteri `b' `l' `b' `r' `t' `r' `t' `l',/*
                    */ recast(area)
            }
        }
        else {
            local c = `x' + 0.5 * `width'
            local plot ms(`sym')
            if `"`sym'"'=="" local plot
            local plot scatteri `y' `c', `plot'
        }
        if `"`pstyle'"'=="" local PSTYLE pstyle(p`p'`ptype')
        else                local PSTYLE `pstyle'
        local OPTIONS `PSTYLE' `options'
        local plots `plots' (`plot' `OPTIONS')
    }
    c_local plot `plots'
end

program parse_txt
    c_local txt `"`0'"'
    while (`"`0'"'!="") {
        gettoken tok 0 : 0, qed(qed)
        if `qed' continue
        di as err `"{bf:`tok'} found where quoted text expected"'
        exit 198
    }
end

version 14
mata:
mata set matastrict on

void parse_dimexp()
{
    real scalar      i, j
    string scalar    s, tok
    string rowvector S
    transmorphic     t
    
    S = J(1, 4, "1") // default
    s = st_local("dimexp")
    t = tokeninit(" ", "=")
    tokenset(t, s)
    j = 0
    while ((tok = tokenget(t))!="") {
        j++
        // positional argument
        if (strtoreal(tok)<.) {
            if (j>4) {
                errprintf("too many arguments in {it:dimexp}\n")
                exit(198)
            }
            S[j] = tok
            continue
        }
        // named argument
        i = 0
        if      (tok=="y") i = 1
        else if (tok=="x") i = 2
        else if (tok=="h") i = 3
        else if (tok=="w") i = 4
        if (i) {
            if (tokenpeek(t)=="=") (void) tokenget(t) // remove "="
            S[i] = tokenget(t)
            if (strtoreal(S[i])>=.) {
                errprintf("invalid argument in {it:dimexp}\n")
                exit(198)
            }
            continue
        }
        // invalid argument
        errprintf("invalid argument in {it:dimexp}\n")
        exit(198)
    }
    st_local("dimexp", invtokens(S))
}

void keys_expand()
{
    real scalar   i, a, b
    string scalar s, tok
    transmorphic  t
    
    s = st_global("s(after)")
    t = tokeninit("", "||", (`""""', `"`""'"', "()"))
    tokenset(t, s)
    i = b = 0
    while ((tok = tokenget(t))!="") {
        if (tok=="||") {
            a = b + 1
            b = tokenoffset(t)
            tok = strtrim(substr(s, a, b-a-2))
            if (tok!="") {
                i++
                st_local("key_"+strofreal(i), tok)
            }
            continue
        }
    }
    a = b + 1
    tok = strtrim(substr(s, a, .))
    if (tok!="") {
        i++
        st_local("key_"+strofreal(i), tok)
    }
    st_local("key_n", strofreal(i))
}

end

