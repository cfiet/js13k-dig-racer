CLOSURE_COMPILER=tools/closure-compiler/closure-compiler.jar
CLOSURE_LIBRARY=libs/closure-library/closure
CLOSURE_LIBRARY_THIRD_PARTY=libs/closure-library/third_party

TARGET_DIR=./out
JS_TARGET_DIR=$(TARGET_DIR)
JS_TARGET_NAME=app.min.js
JS_TARGET=$(JS_TARGET_DIR)/$(JS_TARGET_NAME)
JS_SRC=$(wildcard ./src/*.js ./src/*/*.js)

DIST_TARGET_SIZE=13312

JAVA=java

.DEFAULT_GOAL := build

.PHONY: clean distclean dist

clean:
	rm -fr out

distclean: clean
	rm -fr tools

$(CLOSURE_COMPILER): scripts/init.sh
	./scripts/init.sh
	touch $(CLOSURE_COMPILER)

$(CLOSURE_LIBRARY) $(CLOSURE_LIBRARY_THIRD_PARTY):
	git submodule init

$(JS_TARGET): $(CLOSURE_COMPILER) $(CLOSURE_LIBRARY) $(JS_SRC)
	$(JAVA) -jar $(CLOSURE_COMPILER) \
		--js=$(CLOSURE_LIBRARY)/goog/*.js \
		--js=$(CLOSURE_LIBRARY)/goog/**/*.js \
		--js=$(CLOSURE_LIBRARY_THIRD_PARTY)/closure/goog/*.js \
		--js=$(CLOSURE_LIBRARY_THIRD_PARTY)/closure/goog/**/*.js \
		--js=$(JS_SRC) \
		--js_output_file=out/app.min.js \
		--compilation_level=ADVANCED \
		--language_in=ECMASCRIPT_2018 \
		--language_out=ECMASCRIPT_2016 \
		--isolation_mode=NONE \
		--dependency_mode=STRICT \
		--entry_point=goog:game2019.index \
		--create_source_map=%outname%.sourcemap

out/%: assets/%
	cp $< $@

build: $(JS_TARGET) out/index.html

dist.zip: $(wildcard out/* out/**/*)
	cd out; \
	zip -9 -q -T -ll -X ../dist.zip *; \

dist: dist.zip
	@ _SIZE=$$(wc -c < dist.zip); \
		_SIZE_LEFT=$$(( $(DIST_TARGET_SIZE) - $${_SIZE} )); \
		echo "Bundle size: $${_SIZE} bytes. Up to $${_SIZE_LEFT} bytes left"; \
		if [ $${_SIZE_LEFT} -lt "0" ]; then exit 1; fi
