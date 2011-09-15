#!/usr/bin/env python
# FILE: "/home/joze/.vim/plugin/httpvim.py"
# LAST MODIFICATION: "Mit, 18 Okt 2000 01:19:22 +0200 (joze)"
# (C) 2000 by Johannes Zellner, <johannes@zellner.org>
# $Id: httpvim.py,v 1.5 2000/10/25 13:03:16 joze Exp $
# vim:set ts=4 noet foldlevel=1:

import urllib
import urlparse
import htmllib
import formatter
import string
import mailcap
import cStringIO

global_anchor_begin = ''
global_anchor_end   = ''
global_caps         = mailcap.getcaps()

# [---]
class Page:

	'''Page: contains one document as raw data and eventually
	as parsed data (if content-type == text/html)'''

	def __init__(self, name, parsed_url):

		self.name = name
		self.bucket = '' # used to store file marks
		self.parsed_url = parsed_url

		# get scheme, host and location
		self.scheme, self.host, self.location = list(self.parsed_url)[0:3]

		# get base, may be overwritten by the documents base tag
		base = self.location
		pos = string.rfind(base, '/')
		if -1 != pos:
			# truncate the filename
			base = base[0:pos]
		if len(base) and '/' != base[-1]:
			base = base + '/'
		self.base = urlparse.urlunparse([self.scheme, self.host, base, '', '', ''])

		# possible: content-type = 'text/html; charset=iso-8859-1'
		self.content_type = string.strip(self.get_data())

		if not len(self.content_type):
			return # error

		if 'text/html' == self.content_type[0:9]:

			self.parser = Parser()

		elif 'text/plain' != self.content_type[0:10]:

			self.name = '' # signal that we don't want to keep this object
			global global_caps
			try:
				import tempfile
				import os
				tmp = tempfile.mktemp()
				match = mailcap.findmatch(global_caps, self.content_type, filename = tmp)
				if len(match[0]):
					# yup, call the mailcap handler
					stream = open(tmp, 'wb')
					stream.write(self.data)
					stream.close()
					os.system(match[0])
					os.unlink(tmp)
				else:
					print 'unable to handle content-type "' + self.content_type + '"'
			except:
				pass # ignore

	def get_data(self):

		''' actually read data, returns the content-type
		e.g. 'text/html' '''

		try:
			u = urllib.urlopen(self.name)
			self.data = u.read()
			u.close()
			self.mime = u.info()
			if self.mime.has_key('content-encoding'):
				if 'x-gzip' == self.mime['content-encoding']:
					try:
						import gzip
						strio = cStringIO.StringIO(self.data)
						self.data = gzip.GzipFile(None, 'rb', 9, strio).read()
					except:
						self.data = 'Gzip error'
			if not self.mime.has_key('content-type'):
				return 'text/html'
			else:
				return self.mime['content-type']
		except IOError:
			self.data = 'IOError'

		# error
		self.name = ''
		return ''

	def parsed_data(self, width):
		if 'text/html' == self.content_type[0:9]:
			new_base = self.parser.feed(self.data, width)
			if None != new_base and '' != new_base:
				self.base = new_base
			return self.parser.parsed_data()
		else:
			return string.split(self.data, '\n')

	def anchorlist(self):
		if 'text/html' == self.content_type[0:9]:
			return self.parser.anchorlist
		else:
			return []

	def anchor(self, number):

		''' return an absolute anchor
		'''

		alist = self.anchorlist()
		if number < 0 or number >= len(alist):
			return
		a, name, typ = alist[number]
		if not len(a):
			return self.name
		if a[0] == '/':
			# absolute url
			return urlparse.urlunparse([self.scheme, self.host, a, '', '', ''])
		else:
			u = urlparse.urlparse(a)
			if '' != u[0]:
				# scheme is present!
				return a
			else:
				# scheme is not present and it's a relative url
				return str(self.base) + str(a)

# [---]



# [---]
class Parser(htmllib.HTMLParser):

	def __init__(self):
		htmllib.HTMLParser.__init__(self, formatter.AbstractFormatter(UrlWriter()))
		# htmllib.HTMLParser.__init__(self, formatter.AbstractFormatter(formatter.DumbWriter()))
		self.maxcol = -1

	def __reset(self, width):
		self.maxcol = width
		self.formatter.writer.reset(width)
		self.anchorlist = []

	def anchor_bgn(self, href, name, typ):
		self.anchorlist.append((href, name, typ))
		global global_anchor_begin
		self.handle_data(global_anchor_begin)

	def anchor_end(self):
		global global_anchor_end
		mark = '[' + str(len(self.anchorlist)) + ']'
		self.handle_data(mark + global_anchor_end)

	# parses the raw data and returns the value of the
	# href attribute of the <base> tag (which can be '')
	def feed(self, data, width):

		'''parses the raw data and returns the value of the
		href attribute of the <base> tag (which can be '') '''

		if self.maxcol != width:
			# reformat only if the width has changed
			self.__reset(width)
			htmllib.HTMLParser.feed(self, data)

		return self.base

	def parsed_data(self):
		return self.formatter.writer.parsed_data()

	# [-- alignment --]
	# def start_center(self, attrs) : self.formatter.push_alignment('center')
	# def end_center  (self)        : self.formatter.pop_alignment()

	# [-- style --]
	def start_body  (self, attrs) : self.formatter.push_style('body')
	def end_body    (self)        : self.formatter.pop_style()
	# def start_table (self, attrs) : self.formatter.push_style('table')
	# def end_table   (self)        : self.formatter.pop_style()
	# def start_tr    (self, attrs) : self.formatter.push_style('tr')
	# def end_tr      (self)        : self.formatter.pop_style()
	# def start_td    (self, attrs) : self.formatter.push_style('td')
	# def end_td      (self)        : self.formatter.pop_style()
# [---]



class UrlWriter(formatter.NullWriter):

	def __init__(self):
		formatter.NullWriter.__init__(self)
		self.reset(-1)

	# [-- AUXILIARY FUNCTIONS --]
	def parsed_data(self):
		if not len(self.__parsed_data):
			self.__parsed_data = string.split(self.stream.getvalue(), '\n')
		return self.__parsed_data

	def reset(self, width):
		self.maxcol        = width
		self.stream        = cStringIO.StringIO()
		self.__parsed_data = []
		self.margin        = 0
		self.col           = 0

	def cr(self, n = 1):
		self.stream.write('\n' * n)
		self.col = 0

	def insert_margin(self, x = ' '):
		if self.col < self.margin:
			self.stream.write(x * (self.margin - self.col))
			self.col = self.margin

	# [-- FUNCTIONS AS DEFINED BY THE BASE CLASS --]
	def flush(self):
		insert_margin()
		pass
	def new_alignment(self, align):
		# print '*** new_alignment', align
		pass
	def new_font(self, font): pass
	def new_margin(self, margin, level):
		if None == margin:
			self.margin = 0
		else:
			self.margin = 2 * level
	def new_spacing(self, spacing):
		# print '*** new_spacing', spacing
		pass
	def new_styles(self, styles):
		# print '*** new_styles', styles
		if len(styles) and 'body' == styles[0]:
			self.reset(self.maxcol)
	def send_paragraph(self, blankline):
		self.cr(blankline)
	def send_line_break(self):
		self.cr()
	def send_hor_rule(self, *args, **kw):
		self.stream.write('\n' + '-' * self.maxcol)
		self.cr()
	def send_label_data(self, data):
		self.insert_margin()
		self.stream.write(data + ' ')
	def send_flowing_data(self, data):
		if not data:
			return
		self.insert_margin()
		col    = self.col
		margin = self.margin
		write  = self.stream.write
		maxcol = self.maxcol
		for word in string.split(data):
			# TODO need this ?
			# if '\t' == char:
			#     char = ' '
			# filtering dos eol
			# if '\r' == char:
			#     continue
			length = len(word) + 1
			col = col + length
			if col >= maxcol:
				write('\n' + ' ' * margin)
				col = margin + length
			write(word + ' ')
		self.col = col
	def send_literal_data(self, data):
		if not data:
			return
		self.stream.write(data)
		newline = string.rfind(data, '\n')
		if -1 != newline:
			self.col = newline
		else:
			self.col = self.col + len(data)



class UrlHistory:
	def __init__(self):
		self.urls = []
		self.pos = 0
	def append(self, url):
		if len(self.urls) > self.pos + 1:
			# truncate at the current position
			self.urls = self.urls[0:self.pos + 1]
		if not len(self.urls) or self.urls[self.pos] != url:
			# avoid consecutive duplicates
			self.urls.append(url)
		self.pos = len(self.urls) - 1
	def prev(self):
		if not len(self.urls):
			return ''
		if self.pos > 0:
			self.pos = self.pos - 1
		return self.urls[self.pos]
	def next(self):
		if not len(self.urls):
			return ''
		if self.pos < len(self.urls) - 1:
			self.pos = self.pos + 1
		return self.urls[self.pos]
# [---]



# [---]
class UrlPageList:
	def __init__(self, anchor_beg, anchor_end):   # initialize, only done once
		global global_anchor_begin, global_anchor_end
		global_anchor_begin = anchor_beg
		global_anchor_end   = anchor_end
		self.pages          = {}
		self.current_url    = ''
		self.urlhistory     = UrlHistory()

	def __call__(self, url, width, inhibit_history):

		''' request a page, either existing or new
		'''

		# if url is empty: redisplay the current page
		if (None == url or '' == url) and '' != self.current_url:
			url = self.current_url

		# check, if we must create the page first
		parsed = urlparse.urlparse(url)

		# get a base url w/o name #
		# we don't can use an existing page, if only the name differs.
		# we use the url w/o the name `url_' to refer to this page.
		mutable = list(parsed)
		mutable[-1] = ''
		url_ = urlparse.urlunparse(mutable)

		if not self.pages.has_key(url_):

			# the page is not yet present. Create it now
			page = Page(url, parsed)
			if '' != page.name:
				# append as url_ to the list of pages
				self.pages[url_] = page
			else:
				# failed: redisplay current page
				url_ = self.current_url

		if not inhibit_history:
			self.urlhistory.append(url_)
		self.current_url = url_

		return self.pages[url_].parsed_data(width)

	def __len__(self):                            # return the number of cached pages
		return len(self.pages)

	def __getitem__(self, key):                   # not used currently
		if self.pages.has_key[key]:
			return self.pages[key]
		else:
			return None

	def __delitem__(self, key):                   # delete page with key
		if self.pages.has_key(key):
			del self.pages[key]

	def current_is_valid(self):
		return '' != self.current_url and self.pages.has_key(self.current_url)

	def anchor(self, number):                     # [1 - last] based access (anchors of current page)
		if self.current_is_valid():
			return self.pages[self.current_url].anchor(number - 1)

	def current(self):                            # name of currently displayed url
		return self.current_url

	def redisplay(self, width):                   # redisplay parsed data (do /not/ reload)
		return self.__call__(self.current_url, width, 1)

	def reload(self, width):                      # reload / redisplay
		self.__delitem__(self.current_url)
		return self.redisplay(width)

	def urls(self):                               # return name of cached urls (sorted)
		urls = self.pages.keys()
		urls.sort()
		return urls

	def history(self):                            # return the history list (unsorted)
		urls = self.urlhistory.urls
		urls.reverse()
		return urls

	def back(self, width):                        # `back button': display the previous page
		return self.__call__(self.urlhistory.prev(), width, 1)

	def forward(self, width):                     # `forward button': display the next page
		return self.__call__(self.urlhistory.next(), width, 1)

	def headers(self, key):                       # dump http headers
		if self.pages.has_key(key):
			for key, value in self.pages[key].mime.items():
				print key, value

	def save_data_to_current(self, data):
		if self.current_is_valid():
			self.pages[self.current_url].bucket = data

	def get_data_from_current(self):
		if self.current_is_valid():
			return self.pages[self.current_url].bucket
		else:
			return ''
# [---]

