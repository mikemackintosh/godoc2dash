#!/usr/bin/env bash
echo "godoc2dash"
echo "#####################"

echo "Documentation will:"
SOURCE=$1
echo -e "\tbe generated from: ${SOURCE}"

TARGET=$2
echo -e "\tand save to: ${TARGET}"
DOCSDIR=$TARGET.docset/Contents/Resources/Documents/
mkdir -p $DOCSDIR
cp docs.css $DOCSDIR/

echo -e "\n\nGenerating package list..."
packages=$(go list $SOURCE/...)

echo "Generating Package Icon..."
cp icon.png $TARGET.docset/icon.png
sips -z 32 32 $TARGET.docset/icon.png

echo "Generating Package Details..."
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
	<key>CFBundleIdentifier</key>
	<string>${TARGET}</string>
	<key>CFBundleName</key>
	<string>${TARGET}</string>
	<key>DocSetPlatformFamily</key>
	<string>${TARGET}</string>
	<key>isDashDocset</key>
	<true/>
</dict>
</plist>" > ${TARGET}.docset/Contents/Info.plist


echo "Generating Package Database..."
rm -rf ${TARGET}.docset/Contents/Resources/docSet.dsidx
sqlite3 ${TARGET}.docset/Contents/Resources/docSet.dsidx "CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
sqlite3 ${TARGET}.docset/Contents/Resources/docSet.dsidx "CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);"

echo "Generating Documentation..."
for pkg in $(echo $packages); do
  packagedir=$(echo $pkg | sed "s:${SOURCE}::g")
  echo -e "\tfor package ${packagedir}"
  newdir=$(dirname $packagedir)
  name=$(basename $packagedir)

  mkdir -p $DOCSDIR/$newdir
	cp docs.css $DOCSDIR/$newdir/
  godoc -html $pkg > $DOCSDIR/${newdir}/${name}.html

	echo '<link rel="stylesheet" type="text/css" href="docs.css">' >> $DOCSDIR/${newdir}/${name}.html

  type="Package"

  sqlite3 ${TARGET}.docset/Contents/Resources/docSet.dsidx "  INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('${newdir}/${name}', '${type}', '${packagedir}.html');"
done

echo -e "\nDone!\n\n"
