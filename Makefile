install:
	nimble install -d

build:
	make build-win

build-win:
	nim c --threads:on -d:release --tlsEmulation:off --app:lib --out:ebook_homebrew.pyd ./src/ebook_homebrew

build-linux:
	nim c --threads:on -d:release --tlsEmulation:off --app:lib --out:ebook_homebrew.so ./src/ebook_homebrew

example-run:
	(cp ebook_homebrew.pyd examples || cp ebook_homebrew.so examples) && \
	cd examples && \
	python with_nim.py

example-run-without:
	(cp ebook_homebrew.pyd examples || cp ebook_homebrew.so examples) && \
	cd examples && \
	python without_nim.py

benchmark:
	(cp ebook_homebrew.pyd examples || cp ebook_homebrew.so examples) && \
	cd examples && \
	python benchmark.py
