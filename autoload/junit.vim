scriptencoding utf-8

if exists(':JUnit') == 0
    runtime plugin/junit.vim
endif


function! s:RenderJUnitFile(filename) abort
	python3 << EOF
import junit
import vim
filename = vim.eval("a:filename")

with open(filename) as f:
	result = junit.load(f)
	for suite in result['testsuites']:
		vim.command("silent put = '%s (tests = %s, failures = %s)'" 
			% (suite['name'], suite['tests'], suite['failures']))
		for case in suite['testcases']:
			if len(case['failures']) > 0:
				status = 'fail'
			else:
				status = 'pass'
			vim.command("silent put = '\t%s (%s)'" % (case['name'], status))
EOF
endfunction

function! s:FindJUnitFiles() abort
	if !exists("g:junit_path_expr")
		let g:junit_path_expr = "**/*junit.xml"
	endif
	return split(globpath(".", g:junit_path_expr), "\n")
endfunction

function! s:RenderTests(junit_files) abort
	let junitwinnr = bufwinnr(s:JUnitBufName())
	if junitwinnr != -1
		exe 'wincmd '.junitwinnr
		setlocal modifiable
		exe "%delete"
		echom a:junit_files
		for filename in a:junit_files
			call s:RenderJUnitFile(filename)
		endfor
		setlocal nomodifiable
	endif
endfunction

function! s:CloseWindow() abort
	let junitwinnr = bufwinnr(s:JUnitBufName())
	if junitwinnr != -1
		exe 'wincmd '.junitwinnr
		close
	endif		
endfunction

function! s:OpenWindow() abort
	let junit_files = s:FindJUnitFiles()
	if g:junit_position =~# 'vertical'
        let mode = 'vertical '
	else
        let mode = ''
	endif
    exe 'silent keepalt ' . g:junit_position . g:junit_size . 'split ' . s:JUnitBufName()
    exe 'silent ' . mode . 'resize ' . g:junit_size

	call s:InitWindow()
	call s:RenderTests(junit_files)
endfunction

function! s:InitWindow() abort
    setlocal filetype=junit
    setlocal noreadonly
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal textwidth=0
    setlocal nolist
    setlocal winfixwidth
    setlocal nospell
    setlocal nofoldenable
    setlocal foldcolumn=0
    setlocal foldmethod&
    setlocal foldexpr&
    silent! setlocal signcolumn=no

endfunction

function! s:JUnitBufName() abort
    if !exists('t:junit_buf_name')
        let t:junit_buf_name = 'JUnit'
    endif
    return t:junit_buf_name
endfunction

function! junit#ToggleWindow() abort
	let junitwinnr = bufwinnr("^".s:JUnitBufName()."$")
	 if junitwinnr != -1
        call s:CloseWindow()
        return
    endif  
	call s:OpenWindow()
endfunction
