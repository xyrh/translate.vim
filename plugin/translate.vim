let s:cmd = expand('<sfile>:h:h').'/bin/'.'translate.py'

function! TranslateState(channel, msg)
python << EOF
#coding=utf8
import vim
print vim.eval("a:msg").decode('unicode-escape')
EOF
endfunction

function! s:BaiduNormalFunc(str)
	let cmd = s:cmd . ' ' . a:str
	call job_start(cmd, {'out_cb': 'TranslateState'})
endfunction

function! s:BaiduVisualFunc()
    try
        let a_save = @a
        normal! gv"ay
		let cmd = printf("%s \"%s\"", s:cmd, @a)
		let strings =  substitute(cmd,"\n", " ", "g")
		call job_start(strings, {'out_cb': 'TranslateState'})
    finally
        let @a = a_save
    endtry
endfunction

function! TranslateComp(lead, line, pos)
	return expand("<cword>")
endfunction

command! -nargs=1 -complete=custom,TranslateComp NB call <SID>BaiduNormalFunc('<args>')
command! -nargs=0 VB call <SID>BaiduVisualFunc()
