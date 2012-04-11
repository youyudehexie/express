
DOCS = docs/*.md
HTMLDOCS = $(DOCS:.md=.html)
MANTASTIC = http://mantastic.herokuapp.com
REPORTER = dot

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER)

test-acceptance:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter spec \
		test/acceptance/*.js

express.1: express.md
	curl -sF page=@$< $(MANTASTIC) > $@

express.md:
	rm -f $@
	dox --raw < lib/application.js | support/md > $@
	dox --raw < lib/request.js | support/md >> $@
	dox --raw < lib/response.js | support/md >> $@

docs: $(HTMLDOCS)
	@ echo "... generating TOC"
	@./support/toc.js docs/guide.html

%.html: %.md
	@echo "... $< -> $@"
	@markdown $< \
	  | cat docs/layout/head.html - docs/layout/foot.html \
	  > $@

test-cov: lib-cov
	@EXPRESS_COV=1 $(MAKE) test REPORTER=html-cov > coverage.html

lib-cov:
	@jscoverage lib lib-cov

site:
	rm -fr /tmp/docs \
	  && cp -fr docs /tmp/docs \
	  && git checkout gh-pages \
  	&& cp -fr /tmp/docs/* . \
		&& echo "done"

benchmark:
	@./support/bench

docclean:
	rm -f docs/*.{1,html}
	rm -f express.{1,md}

.PHONY: site test benchmark docs docclean test-acceptance
