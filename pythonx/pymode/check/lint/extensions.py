""" Load extensions. """

from os import listdir, path as op
from importlib import import_module

CURDIR = op.dirname(__file__)
LINTERS = dict()
PREFIX = 'pylama_'

for p in listdir(CURDIR):
	if p.startswith(PREFIX) and op.isdir(op.join(CURDIR, p)):
		name = p[len(PREFIX):]
		try:
			module = import_module('pymode.check.lint.%s%s'%(PREFIX, name))
			LINTERS[name] = getattr(module, 'Linter')()
		except ImportError:
			print "mf=",name,"errrrrrrrrrrrr"
			continue

