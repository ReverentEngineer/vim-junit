if &compatible || exists('g:loaded_junit')
    finish
endif

if !exists("g:junit_position")
	let g:junit_position = "vertical"
endif


if !exists("g:junit_size")
	let g:junit_size = 40
endif

command! JUnit execute junit#ToggleWindow()
