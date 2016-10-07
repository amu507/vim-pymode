from lint.extensions import LINTERS
from errors import DUPLICATES, Error
from collections import defaultdict

def run(path='', code=None, params=None,linters=["pylint"]):
	errors=[]
	try:
		with CodeContext(code, path) as ctx:
			code = ctx.code
			for lname in linters:
				linter=LINTERS[lname]
				for er in linter.run(
						path,
						code=code,
						ignore=set(),
						select=set(),
						params=params):
					errors.append(Error(filename=path, linter=lname, **er))

	except IOError as e:
		print "IOError %s"%e
	except SyntaxError as e:
		print "SyntaxError %s"%e
	except Exception as e:
		import traceback
		print traceback.format_exc()
	errors = list(remove_duplicates(errors))
	return errors

def remove_duplicates(errors):
	""" Remove same errors from others linters. """
	passed = defaultdict(list)
	for error in errors:
		key = error.linter, error.number
		if key in DUPLICATES:
			if key in passed[error.lnum]:
				continue
			passed[error.lnum] = DUPLICATES[key]
		yield error


class CodeContext(object):

	""" Read file if code is None. """

	def __init__(self, code, path):
		""" Init context. """
		self.code = code
		self.path = path
		self._file = None

	def __enter__(self):
		""" Open file and read a code. """
		if self.code is None:
			self._file = open(self.path, 'rU')
			self.code = self._file.read()
		return self

	def __exit__(self, t, value, traceback):
		""" Close opened file. """
		if self._file is not None:
			self._file.close()

