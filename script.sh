#!/bin/sh

echo '##########################';
echo '#    set up workspace    #';
echo '##########################';

if [ -d gitRepo ]; then
  rm -rf gitRepo
fi

git clone "https://github.com/plentymarkets/manual" gitRepo

if [ -d build ]; then
  rm -rf build
fi

if [ -d adocOutput ]; then
  rm -rf adocOutput
fi

mkdir adocOutput

echo '######################';
echo '#    build doc DE    #';
echo '######################';

mkdir adocOutput/de
mkdir adocOutput/de/modules
mkdir adocOutput/de/modules/ROOT
mkdir adocOutput/de/modules/ROOT/images
mkdir adocOutput/de/modules/ROOT/pages
mkdir adocOutput/de/modules/ROOT/partials

#create includes files
mkdir -p "adocOutput/de/modules/_includes/pages"
mkdir -p "adocOutput/de/modules/_includes/examples"
mkdir -p "adocOutput/de/modules/_includes/images"

find gitRepo/de/ -name '*.adoc' -exec cp {} "adocOutput/de/modules/_includes/pages" \;
cp -R gitRepo/de/_includes/_pdf adocOutput/de/modules/_includes/examples
cp -R gitRepo/de/_includes/_plugin adocOutput/de/modules/_includes/examples

ARRAY=()
#navigate through all pages
for FILE in gitRepo/de/*.adoc;
  do
  #  echo $FILE
  PLUGINS1=${FILE%.[^.]*}
  PLUGINS=${PLUGINS1/gitRepo\/de\//}
  PLUGINPATH=${FILE/.adoc/}
  #echo $PLUGINPATH

  if [ "${PLUGINS}" == "glossar" ]; then
    PLUGINS="_glossar"
    PLUGINPATH=${PLUGINPATH/glossar/_glossar/}
  fi

  #create the directories
  mkdir -p "adocOutput/de/modules/$PLUGINS"
  mkdir -p "adocOutput/de/modules/$PLUGINS/images"
  mkdir -p "adocOutput/de/modules/$PLUGINS/examples"
  mkdir -p "adocOutput/de/modules/$PLUGINS/pages"
  mkdir -p "adocOutput/de/modules/$PLUGINS/partials"

  #moving pages
  find $PLUGINPATH -name '*.adoc' -exec cp {} "adocOutput/de/modules/$PLUGINS/pages" \;
  #moving html & txt files
  find $PLUGINPATH -name '*.html' -exec cp {} "adocOutput/de/modules/$PLUGINS/examples" \;
  find $PLUGINPATH -name '*.txt' -exec cp {} "adocOutput/de/modules/$PLUGINS/examples" \;
  #moving assets files
  find $PLUGINPATH \( -name '*.png' -o -name '*.jpg' -o -name '*.gif' \) -exec cp {} "adocOutput/de/modules/$PLUGINS/images" \;
  ARRAY+=(${PLUGINS})
done

echo '######################';
echo '#  generate ANTORA   #';
echo '######################';
echo 'name: manual\ntitle: plentymarkets Handbuch\nversion: main\nnav:\n- modules/ROOT/nav.adoc' > adocOutput/de/antora.yml

arraylength=${#ARRAY[@]}


for i in "${ARRAY[@]}";
  do
    echo "s/include::(.*)${i}(.*)\/(.*).adoc/include::${i}:page$\3.adoc/g"
    find adocOutput/de/modules/ -name '*.adoc' -exec sed -i -e -r "s/include::(.*)${i}(.*)\/(.*).adoc/include::${i}:page$\3.adoc/g" {} \;
done

find adocOutput/de/ -name '*.adoc' -exec sed -i -e 's/a\|include/include/g' {} \;
find adocOutput/de/ -name '*.adoc' -exec sed -i -e 's/include::{includedir}\/_header.adoc\[\]//g' {} \;
find adocOutput/de/ -name '*.adoc' -exec sed -i -e -r 's/include::(.*)\/(.*).html/include::example$\2.html/g' {} \;
find adocOutput/de/ -name '*.adoc' -exec sed -i -e -r 's/include::(.*)\/(.*).txt/include::example$\2.txt/g' {} \;
find adocOutput/de/ -name '*.adoc' -exec sed -i -e -r 's/include::(.*)_includes(.*)\/(.*).adoc/include::_includes:page$\3.adoc/g' {} \;
find adocOutput/de/ -name '*.adoc' -exec sed -i -e -r 's/include::(.*)_textblocks(.*)\/(.*).adoc/include::.\/\3.adoc/g' {} \;

find adocOutput/de/modules/_includes/ -name '*.adoc' -exec sed -i -e -r 's/include::(.*)\/(.*).adoc/include::.\/\2.adoc/g' {} \;

#STARTING GENERATING EN DOCS#

echo '######################';
echo '#    build doc DE    #';
echo '######################';

mkdir adocOutput/en
mkdir adocOutput/en/modules
mkdir adocOutput/en/modules/ROOT
mkdir adocOutput/en/modules/ROOT/images
mkdir adocOutput/en/modules/ROOT/pages
mkdir adocOutput/en/modules/ROOT/partials

#create includes files
mkdir -p "adocOutput/en/modules/_includes/pages"
mkdir -p "adocOutput/en/modules/_includes/examples"
mkdir -p "adocOutput/en/modules/_includes/images"

find gitRepo/en/ -name '*.adoc' -exec cp {} "adocOutput/en/modules/_includes/pages" \;
cp -R gitRepo/en/_includes/_pdf adocOutput/en/modules/_includes/examples
cp -R gitRepo/en/_includes/_plugin adocOutput/en/modules/_includes/examples

ARRAY=()
#navigate through all pages
for FILE in gitRepo/en/*.adoc;
  do
  #  echo $FILE
  PLUGINS1=${FILE%.[^.]*}
  PLUGINS=${PLUGINS1/gitRepo\/en\//}
  PLUGINPATH=${FILE/.adoc/}
  #echo $PLUGINPATH

  if [ "${PLUGINS}" == "glossar" ]; then
    PLUGINS="_glossar"
    PLUGINPATH=${PLUGINPATH/glossar/_glossar/}
  fi

  #create the directories
  mkdir -p "adocOutput/en/modules/$PLUGINS"
  mkdir -p "adocOutput/en/modules/$PLUGINS/images"
  mkdir -p "adocOutput/en/modules/$PLUGINS/examples"
  mkdir -p "adocOutput/en/modules/$PLUGINS/pages"
  mkdir -p "adocOutput/en/modules/$PLUGINS/partials"

  #moving pages
  find $PLUGINPATH -name '*.adoc' -exec cp {} "adocOutput/en/modules/$PLUGINS/pages" \;
  #moving html & txt files
  find $PLUGINPATH -name '*.html' -exec cp {} "adocOutput/en/modules/$PLUGINS/examples" \;
  find $PLUGINPATH -name '*.txt' -exec cp {} "adocOutput/en/modules/$PLUGINS/examples" \;
  #moving assets files
  find $PLUGINPATH \( -name '*.png' -o -name '*.jpg' -o -name '*.gif' \) -exec cp {} "adocOutput/en/modules/$PLUGINS/images" \;
  ARRAY+=(${PLUGINS})
done

echo '######################';
echo '#  generate ANTORA   #';
echo '######################';
echo 'name: manual\ntitle: plentymarkets Handbuch\nversion: main\nnav:\n- modules/ROOT/nav.adoc' > adocOutput/en/antora.yml

arraylength=${#ARRAY[@]}


for i in "${ARRAY[@]}";
  do
    echo "s/include::(.*)${i}(.*)\/(.*).adoc/include::${i}:page$\3.adoc/g"
    find adocOutput/en/modules/ -name '*.adoc' -exec sed -i -e -r "s/include::(.*)${i}(.*)\/(.*).adoc/include::${i}:page$\3.adoc/g" {} \;
done

find adocOutput/en/ -name '*.adoc' -exec sed -i -e 's/a\|include/include/g' {} \;
find adocOutput/en/ -name '*.adoc' -exec sed -i -e 's/include::{includedir}\/_header.adoc\[\]//g' {} \;
find adocOutput/en/ -name '*.adoc' -exec sed -i -e -r 's/include::(.*)\/(.*).html/include::example$\2.html/g' {} \;
find adocOutput/en/ -name '*.adoc' -exec sed -i -e -r 's/include::(.*)\/(.*).txt/include::example$\2.txt/g' {} \;
find adocOutput/en/ -name '*.adoc' -exec sed -i -e -r 's/include::(.*)_includes(.*)\/(.*).adoc/include::_includes:page$\3.adoc/g' {} \;
find adocOutput/en/ -name '*.adoc' -exec sed -i -e -r 's/include::(.*)_textblocks(.*)\/(.*).adoc/include::.\/\3.adoc/g' {} \;

find adocOutput/en/modules/_includes/ -name '*.adoc' -exec sed -i -e -r 's/include::(.*)\/(.*).adoc/include::.\/\2.adoc/g' {} \;

#STARTING GENERATING THE MENU#

echo '######################';
echo '#    build nav       #';
echo '######################';
sh generateNav.sh
