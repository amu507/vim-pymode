" Vim syntax file
" Language:	Python
" Maintainer:	Samuel Hoffstaetter <samuel@hoffstaetter.com>
" Updated:	2006-10-15
"		Added Python 2.4 features 2006 May 4 (Dmitry Vasiliev)
"
" Derived from python.vim by Neil Schemenauer <nas@python.ca>
"
" Options to control Python syntax highlighting:
"
" For highlighted numbers:
"
"    let python_highlight_numbers = 1
"
" For highlighted builtin functions:
"
"    let python_highlight_builtins = 1
"
" For highlighted standard exceptions:
"
"    let python_highlight_exceptions = 1
"
" Highlight erroneous whitespace:
"
"    let python_highlight_space_errors = 1
"
" If you want all possible Python highlighting (the same as setting the
" preceding options):
"
"    let python_highlight_all = 1
"

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let python_highlight_all = 1

syn keyword pythonStatement	break continue del
syn keyword pythonStatement	except exec finally
syn keyword pythonStatement	pass print raise
syn keyword pythonStatement	return try with
syn keyword pythonStatement	global assert
syn keyword pythonStatement	lambda yield

syn match   pythonDefStatement	/^\s*\%(def\|class\)/
  \ nextgroup=pythonFunction skipwhite

"fold empty 
syn region  pythonEmptyFold	start="\s*\n"
  \ end="\n\ze\s*\S" fold transparent keepend
"syn match   pythonEmptyFold /\%(\s*\n\)*/ fold transparent keepend

"fold import
"begin:	start with import or from
"end:	end with at least 1 \n 
"	As little as possible
"	not same as begin
"must contains pythonPreCondit for that keyword has higher priority
syn region  pythonImportFold	start="^\z(\s*\%(import\|from\)\>\)"
  \ end="\%(\s*\n\)\{-1,}\ze\%(\z1\)\@!" fold transparent
  \ contains=pythonPreCondit 

"fold Func 
"1.start with X*\s + def|class
"2.end with \n as much as possible 
"3.not begin as (X+1)*\s
"4.end witd \s*[[:alnum:]]or an empty line/#/""" after def can be end 
"def aaa():
"
"    print 1
"5.keepend or it will fold more than you want when def in a class 
"class a():
"    def b()  
"        pass
"print 1#this line will be fold for that it will find end of class after end of def
"	
"syn region  pythonFunctionFold	start="^\z(\s*\)\%(def\|class\)\>"
"  \ end="\%(\s*\n\)\+\ze\%(\z1\s\)\@!\s*[[:alnum:]]" fold transparent keepend

syn region  pythonFunctionFold	start="^\z(\s*\)\%(def\|class\)\>"
  \ end="\%(\s*\n\)\+\ze\%(\z1\s\)\@!\s*\S" fold transparent keepend

syn match   pythonFunction	"[a-zA-Z_][a-zA-Z0-9_]*" contained

syn match   pythonComment /#\%(.\%({{{\|}}}\)\@!\)*$/
  \ contains=pythonTodo,@Spell

syn keyword pythonRepeat	for while
syn keyword pythonConditional	if elif else
syn keyword pythonOperator	and in is not or
" AS will be a keyword in Python 3
syn keyword pythonPreCondit	import from as contained
syn keyword pythonTodo		TODO FIXME XXX contained

" Decorators (new in Python 2.4)
syn match   pythonDecorator	"@" display nextgroup=pythonFunction skipwhite

" strings
syn region pythonString		start=+[uU]\='+ end=+'+ skip=+\\\\\|\\'+ contains=pythonEscape,@Spell
syn region pythonString		start=+[uU]\="+ end=+"+ skip=+\\\\\|\\"+ contains=pythonEscape,@Spell
"use extend
"\tdef aaa()
""""
"dddd
""""
"\t\tprint 1
syn region pythonString		start=+[uU]\="""+ end=+"""+ fold extend contains=pythonEscape,@Spell
syn region pythonString		start=+[uU]\='''+ end=+'''+ fold extend contains=pythonEscape,@Spell
syn region pythonRawString	start=+[uU]\=[rR]'+ end=+'+ skip=+\\\\\|\\'+ contains=@Spell
syn region pythonRawString	start=+[uU]\=[rR]"+ end=+"+ skip=+\\\\\|\\"+ contains=@Spell
syn region pythonRawString	start=+[uU]\=[rR]"""+ end=+"""+ contains=@Spell
syn region pythonRawString	start=+[uU]\=[rR]'''+ end=+'''+ contains=@Spell
syn match  pythonEscape		+\\[abfnrtv'"\\]+ contained
syn match  pythonEscape		"\\\o\{1,3}" contained
syn match  pythonEscape		"\\x\x\{2}" contained
syn match  pythonEscape		"\(\\u\x\{4}\|\\U\x\{8}\)" contained
syn match  pythonEscape		"\\$"

if exists("python_highlight_all")
  let python_highlight_numbers = 1
  let python_highlight_builtins = 1
  let python_highlight_exceptions = 1
"  let python_highlight_space_errors = 1
endif

if exists("python_highlight_numbers")
  " numbers (including longs and complex)
  syn match   pythonNumber	"\<0x\x\+[Ll]\=\>"
  syn match   pythonNumber	"\<\d\+[LljJ]\=\>"
  syn match   pythonNumber	"\.\d\+\([eE][+-]\=\d\+\)\=[jJ]\=\>"
  syn match   pythonNumber	"\<\d\+\.\([eE][+-]\=\d\+\)\=[jJ]\=\>"
  syn match   pythonNumber	"\<\d\+\.\d\+\([eE][+-]\=\d\+\)\=[jJ]\=\>"
endif

if exists("python_highlight_builtins")
  " builtin functions, types and objects, not really part of the syntax
  syn keyword pythonBuiltin	True False bool enumerate set frozenset help
  syn keyword pythonBuiltin	reversed sorted sum
  syn keyword pythonBuiltin	Ellipsis None NotImplemented __import__ abs
  syn keyword pythonBuiltin	apply buffer callable chr classmethod cmp
  syn keyword pythonBuiltin	coerce compile complex delattr dict dir divmod
  syn keyword pythonBuiltin	eval execfile file filter float getattr globals
  syn keyword pythonBuiltin	hasattr hash hex id input int intern isinstance
  syn keyword pythonBuiltin	issubclass iter len list locals long map max
  syn keyword pythonBuiltin	min object oct open ord pow property range
  syn keyword pythonBuiltin	raw_input reduce reload repr round setattr
  syn keyword pythonBuiltin	slice staticmethod str super tuple type unichr
  syn keyword pythonBuiltin	unicode vars xrange zip
endif

if exists("python_highlight_exceptions")
  " builtin exceptions and warnings
  syn keyword pythonException	ArithmeticError AssertionError AttributeError
  syn keyword pythonException	DeprecationWarning EOFError EnvironmentError
  syn keyword pythonException	Exception FloatingPointError IOError
  syn keyword pythonException	ImportError IndentationError IndexError
  syn keyword pythonException	KeyError KeyboardInterrupt LookupError
  syn keyword pythonException	MemoryError NameError NotImplementedError
  syn keyword pythonException	OSError OverflowError OverflowWarning
  syn keyword pythonException	ReferenceError RuntimeError RuntimeWarning
  syn keyword pythonException	StandardError StopIteration SyntaxError
  syn keyword pythonException	SyntaxWarning SystemError SystemExit TabError
  syn keyword pythonException	TypeError UnboundLocalError UnicodeError
  syn keyword pythonException	UnicodeEncodeError UnicodeDecodeError
  syn keyword pythonException	UnicodeTranslateError
  syn keyword pythonException	UserWarning ValueError Warning WindowsError
  syn keyword pythonException	ZeroDivisionError
endif

if exists("python_highlight_space_errors")
  " trailing whitespace
  syn match   pythonSpaceError   display excludenl "\S\s\+$"ms=s+1
  " mixed tabs and spaces
  syn match   pythonSpaceError   display " \+\t"
  syn match   pythonSpaceError   display "\t\+ "
endif

" This is fast but code inside triple quoted strings screws it up. It
" is impossible to fix because the only way to know if you are inside a
" triple quoted string is to start from the beginning of the file. If
" you have a fast machine you can try uncommenting the "sync minlines"
" and commenting out the rest.
"syn sync match pythonSync grouphere NONE "):$"
"syn sync maxlines=200
syn sync minlines=2000
syn sync linebreaks=1

if version >= 508 || !exists("did_python_syn_inits")
  if version <= 508
    let did_python_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default methods for highlighting.  Can be overridden later
  HiLink pythonStatement	Statement
  HiLink pythonDefStatement	Statement
  HiLink pythonFunction		Function
  HiLink pythonConditional	Conditional
  HiLink pythonRepeat		Repeat
  HiLink pythonString		String
  HiLink pythonRawString	String
  HiLink pythonEscape		Special
  HiLink pythonOperator		Operator
  HiLink pythonPreCondit	PreCondit
  HiLink pythonComment		Comment
  HiLink pythonTodo		Todo
  HiLink pythonDecorator	Define
  if exists("python_highlight_numbers")
    HiLink pythonNumber	Number
  endif
  if exists("python_highlight_builtins")
    HiLink pythonBuiltin	Function
  endif
  if exists("python_highlight_exceptions")
    HiLink pythonException	Exception
  endif
  if exists("python_highlight_space_errors")
    HiLink pythonSpaceError	Error
  endif

  delcommand HiLink
endif

let b:current_syntax = "python"

"def fold func beg==========================================
function! PyFoldText()
    let fs = v:foldstart
    let line = getline(fs)

    let has_numbers = &number || &relativenumber
    let nucolwidth = &fdc + has_numbers * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 6
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) + 1 
    return line . ' ' . repeat('-', fillcharcount) . ' ' . foldedlinecount
endfunction

"setlocal foldmethod=syntax
setlocal foldtext=PyFoldText()

augroup insert_mode_manual_fold
    autocmd!
    autocmd InsertEnter <buffer> setlocal foldmethod=manual
    autocmd BufLeave <buffer> setlocal foldmethod=manual
augroup END

function! PySyntaxFold(sCmd)
    if &l:foldmethod!=#"syntax"
	setlocal foldmethod=syntax
    endif
    echom a:sCmd
    return a:sCmd
endfunction
     
nnoremap <buffer><expr> zm PySyntaxFold('zm')
nnoremap <buffer><expr> zM PySyntaxFold('zM')
nnoremap <buffer><expr> zc PySyntaxFold('zc')
nnoremap <buffer><expr> zC PySyntaxFold('zC')
nnoremap <buffer><expr> <Space>  (foldclosed(line('.')) < 0) ? PySyntaxFold('zc') : 'zo'



" vim: ts=8
