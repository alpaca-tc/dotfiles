#
# refe/Makefile
#

version = 0.8.0
rubysrcdir = $(HOME)/s/ruby
datadir    = $(HOME)/share
siteroot   = $(HOME)/var/i.loveruby.net/tree
wcdir      = $(HOME)/c

default: update

update:
	update-version --version=$(version) lib/refe/info.rb

updatedb:
	rm -rf $(REFE_DATA_DIR)
	mkrefe_rubyrefm    src/man-rd-ja/*.rd
	mkrefe_extrefm     src/extrefm.rd
	mkrefe_mfrelation  $(rubysrcdir)
	mkrefe_rubysrc     $(rubysrcdir)

fetch: rubyrefm extrefm

rubyrefm: src
	ruby misc/fetch-rubyrefm.rb > src/man-rd-ja.tar.gz
	rm -rf src/man-rd-ja
	gzip -dc src/man-rd-ja.tar.gz | tar xf - -C src

extrefm: src
	ruby misc/fetch-extrefm.rb > src/extrefm.rd

src:
	mkdir -p src

dist:
	version=$(version) sh misc/dist.sh

site:
	install-html --template=$(datadir)/template/basic.tmpl.ja web/refe.html.ja $(siteroot)/ja/prog
	install-html --template=$(datadir)/template/basic.tmpl.en web/refe.html.en $(siteroot)/en

import:
	remove-cvsid docutils $(wcdir)/docutils/lineinput.rb > lib/refe/lineinput.rb
	remove-cvsid docutils $(wcdir)/docutils/multilangdoc.rb > lib/refe/multilangdoc.rb
	remove-cvsid amstd $(wcdir)/amstd/stringio.rb > test/mystringio.rb
