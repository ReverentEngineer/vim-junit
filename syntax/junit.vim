if exists("b:current_syntax")
    finish
endif

syntax match JUnitPass "^.*failures = 0.*$"
syntax match JUnitFail "^.*failures = [1-9][0-9]*.*$"

syntax match JUnitPass '^.*(pass).*$'
syntax match JUnitFail '^.*(fail).*$'

highlight JUnitPass ctermfg=green
highlight JUnitFail ctermfg=red

let b:current_syntax = "junit"
