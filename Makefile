test2: go-pear.phar
	cmd /c test2.bat

2:
	@python 2.py

1:
	@python 1.py

go-pear.phar:
	curl -O 'http://pear.php.net/go-pear.phar'

test:
	cmd /c test.bat

test0:
	php -d detect_unicode=0 go-pear.phar

readme: README.md
README.md: README.org
	docker run -v `pwd`:/source jagregory/pandoc --from=org --to=markdown --output=$@ $<
	doctoc --gitlab --title '' $@
