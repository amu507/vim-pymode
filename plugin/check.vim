function! CheckPy(...)
	let lstRet=[]
python << EOF
import pymode.check 
from vimenv import env
RESULT_FORMAT="%s|%s|%s\n"
sPathAll=env.var('expand("%:p")')
sPath=env.var('expand("%:t:r")')
code='\n'.join(env.curbuf) + '\n'
params=env.var("g:pymode_lint_options_pylint")
errors=pymode.check.run(sPathAll,code,params)
lstRet=[]
for err in errors:
	lstRet.append(RESULT_FORMAT%(sPathAll,err._info['lnum'],err._info['text']))
env.effqf("".join(lstRet))
env.signeffqf(lstRet)
EOF
endfunction

