#/bin/sh
cd ..
echo $PWD
haxelib run flow build mac
BUNDLE_DIR=$PWD/bin/mac64/haxe-modiqus-test.app/Contents
cd $BUNDLE_DIR/MacOS
echo $PWD
install_name_tool -change \
	@executable_path/lib/CsoundLib64 \
	@executable_path/../Frameworks/CsoundLib64 \
	haxe-modiqus-test
./haxe-modiqus-test


