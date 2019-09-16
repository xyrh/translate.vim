function! s:BaiduFunc(str)
python << EOF

#coding=utf8

import httplib
import md5
import urllib
import random
import json
import vim

appid = '20180313000134817'
secretKey = '5SJzjaXchmpkXox4L5qX'
httpClient = None
myurl = '/api/trans/vip/translate'
q = vim.eval("a:str")
fromLang = 'en'
toLang = 'zh'
salt = random.randint(32768, 65536)
sign = appid+q+str(salt)+secretKey
m1 = md5.new()
m1.update(sign)
sign = m1.hexdigest()
myurl = myurl+'?appid='+appid+'&q='+urllib.quote(q)+'&from='+fromLang+'&to='+toLang+'&salt='+str(salt)+'&sign='+sign
 
try:
	httpClient = httplib.HTTPConnection('api.fanyi.baidu.com')
	httpClient.request('GET', myurl)
	response = httpClient.getresponse()
	print json.loads(response.read())['trans_result'][0]['dst']
except Exception, e:
	print e
finally:
	if httpClient:
		httpClient.close()
EOF
endfunction

command! -n=1 Baidu call <SID>BaiduFunc('<args>')
nnoremap <silent> <C-h> :Baidu <C-R><C-W><CR>
