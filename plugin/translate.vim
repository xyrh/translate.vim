scriptencoding utf-8
let s:cmd = expand('<sfile>:h:h').'/bin/'.'translate.py'

function! TranslateState(channel, msg)
python << EOF
#coding=utf8
import vim
print vim.eval("a:msg").decode('unicode-escape')
EOF
endfunction

function! s:BaiduFunc(str)
	let cmd = s:cmd . ' ' . a:str
	call job_start(cmd, {'out_cb': 'TranslateState'})
endfunction

function! TranslateComp(lead, line, pos)
	return expand("<cword>")
endfunction

command! -nargs=1 -complete=custom,TranslateComp B call <SID>BaiduFunc('<args>')
