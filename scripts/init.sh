#! /bin/sh

CLOSURE_COMPILER_URL=https://dl.google.com/closure-compiler/compiler-latest.zip
CLOSURE_TARGET_DIR=tools/closure-compiler

if [ ! -d "${CLOSURE_TARGET_DIR}" ]; then
	mkdir -p tools/closure-compiler
fi

cd tools/closure-compiler
if [ ! -f "closure-latest.zip" ]; then
	echo "Downloading latest closure compiler"

	curl ${CLOSURE_COMPILER_URL} --output closure-latest.zip

	if [ $? -ne 0 ]; then
		echo "Failed to download closure compiler"
		exit 1
	fi
fi

if [ ! -f "./closure-compiler-v*.jar" ]; then
	unzip -oq closure-latest.zip
	if [ $? -ne 0 ]; then
		echo "Failed to unzip closure compiler"
		exit 1
	fi
fi

if [ ! -f ./closure-compiler.jar ]; then
	ln -s closure-compiler-v*.jar ./closure-compiler.jar
fi

if [ ! -d "libs/closure-library/closure" ]; then
	git submodule init

	if [ $? -ne 0 ]; then
		echo "Failed to initialize closure-library"
		exit 1
	fi
fi
