" vim-awk — syntax highlighting for the AWK language (awkrs dialect)
"
" A standalone AWK grammar covering POSIX awk plus the gawk / mawk extensions
" that awkrs implements (union CLI). Hand-curated from the AWK language surface:
" pattern/action rules, special patterns (BEGIN/END), field references, regex
" literals, built-in variables, and built-in functions. Everything links to
" standard highlight groups, so every colorscheme covers it.
"
" Verified against awkrs 0.4.14 — pattern / action engine
" (POSIX / gawk / mawk-style union CLI).

if exists('b:current_syntax')
  finish
endif

syntax case match
syntax sync minlines=50

" ---------------------------------------------------------------------------
" Comments / shebang
" ---------------------------------------------------------------------------
syntax keyword awkTodo contained TODO FIXME XXX NOTE HACK
syntax match   awkComment "#.*$" contains=awkTodo,@Spell
syntax match   awkShebang "\%^#!.*$"

" ---------------------------------------------------------------------------
" Numbers
" ---------------------------------------------------------------------------
syntax match awkNumber "\<\d\+\>"
syntax match awkNumber "\<0[xX]\x\+\>"
syntax match awkFloat  "\<\d\+\.\d*\%([eE][-+]\?\d\+\)\?\>"
syntax match awkFloat  "\.\d\+\%([eE][-+]\?\d\+\)\?\>"
syntax match awkFloat  "\<\d\+[eE][-+]\?\d\+\>"

" ---------------------------------------------------------------------------
" Field references ($0 $1 ... $NF $(expr))
" ---------------------------------------------------------------------------
syntax match awkFieldRef "\$\d\+"
syntax match awkFieldRef "\$NF\>"
syntax match awkFieldRef "\$\h\w*"
syntax match awkFieldRef "\$("

" ---------------------------------------------------------------------------
" Strings
" ---------------------------------------------------------------------------
syntax match  awkStringEscape contained "\\."
syntax region awkString start=+"+ skip=+\\"+ end=+"+ contains=awkStringEscape,@Spell

" ---------------------------------------------------------------------------
" Regex literals /.../  (ERE — extended regular expressions)
" ---------------------------------------------------------------------------
syntax match  awkRegexBind "!\?\~"
syntax region awkRegex start=+/+ skip=+\\/+ end=+/+ oneline contains=awkRegexEscape
syntax match  awkRegexEscape contained "\\."

" ---------------------------------------------------------------------------
" Keywords — control flow & statements
" ---------------------------------------------------------------------------
syntax keyword awkControl if else while for do break continue next nextfile exit return delete in
syntax keyword awkStatement print printf getline
syntax keyword awkFunctionDef function func
syntax keyword awkOperatorKw in

" Special pattern blocks (BEGIN / END and the gawk BEGINFILE / ENDFILE).
syntax keyword awkPattern BEGIN END BEGINFILE ENDFILE

" ---------------------------------------------------------------------------
" Built-in variables
" ---------------------------------------------------------------------------
syntax keyword awkBuiltinVar NR NF FS OFS ORS RS FILENAME FNR RSTART RLENGTH
syntax keyword awkBuiltinVar SUBSEP ARGC ARGV ENVIRON CONVFMT OFMT
" gawk extensions awkrs honors in its union CLI.
syntax keyword awkBuiltinVar FPAT FIELDWIDTHS IGNORECASE RT PROCINFO FUNCTAB SYMTAB TEXTDOMAIN ERRNO BINMODE LINT

" ---------------------------------------------------------------------------
" Built-in functions
" ---------------------------------------------------------------------------
" String functions
syntax keyword awkFunction length substr index split sub gsub match sprintf tolower toupper
syntax keyword awkFunction gensub patsplit
" Arithmetic functions
syntax keyword awkFunction sin cos atan2 exp log sqrt int rand srand
" I/O and system functions
syntax keyword awkFunction system close fflush
" gawk time / bit / misc functions awkrs accepts in union mode
syntax keyword awkFunction systime strftime mktime
syntax keyword awkFunction and or xor compl lshift rshift
syntax keyword awkFunction typeof isarray

" ---------------------------------------------------------------------------
" Operators
" ---------------------------------------------------------------------------
" Note: `/` is deliberately omitted here — it is lexically ambiguous between
" division and a regex-literal delimiter, and the awkRegex region claims it so
" `/pattern/` highlights as a regex. Division `a/b` is left as plain text.
syntax match awkOperator "+\|-\|\*\|%\|\^"
syntax match awkOperator "++\|--"
syntax match awkOperator "==\|!=\|<=\|>=\|<\|>"
syntax match awkOperator "&&\|||\|!"
syntax match awkOperator "=\|+=\|-=\|\*=\|/=\|%=\|\^="
syntax match awkOperator "?\|:"

" ---------------------------------------------------------------------------
" Highlight links
" ---------------------------------------------------------------------------
highlight default link awkComment      Comment
highlight default link awkShebang       PreProc
highlight default link awkTodo          Todo
highlight default link awkNumber        Number
highlight default link awkFloat         Float
highlight default link awkFieldRef      Identifier
highlight default link awkString        String
highlight default link awkStringEscape  SpecialChar
highlight default link awkRegex         String
highlight default link awkRegexEscape   SpecialChar
highlight default link awkRegexBind     Operator
highlight default link awkControl       Statement
highlight default link awkStatement     Statement
highlight default link awkFunctionDef   Keyword
highlight default link awkOperatorKw    Operator
highlight default link awkPattern       PreProc
highlight default link awkBuiltinVar    Special
highlight default link awkFunction      Function
highlight default link awkOperator      Operator

let b:current_syntax = 'awk'
