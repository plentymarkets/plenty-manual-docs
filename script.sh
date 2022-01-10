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

if [ -d docs ]; then
  rm -rf docs
fi

mkdir docs

echo '######################';
echo '#    build doc DE    #';
echo '######################';

mkdir docs/de-de
mkdir docs/de-de/modules
mkdir docs/de-de/modules/ROOT
mkdir docs/de-de/modules/ROOT/images
mkdir docs/de-de/modules/ROOT/pages
mkdir docs/de-de/modules/ROOT/partials

cp -R ROOT-DE docs/de-de/modules/ROOT/

#create includes files
mkdir -p "docs/de-de/modules/_includes/pages"
mkdir -p "docs/de-de/modules/_includes/examples"
mkdir -p "docs/de-de/modules/_includes/images"

find gitRepo/de/_includes/ -name '*.adoc' -exec cp {} "docs/de-de/modules/_includes/pages" \;
cp -R gitRepo/de/_includes/_pdf docs/de-de/modules/_includes/examples
cp -R gitRepo/de/_includes/_plugin docs/de-de/modules/_includes/examples

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
  mkdir -p "docs/de-de/modules/$PLUGINS"
  mkdir -p "docs/de-de/modules/$PLUGINS/images"
  mkdir -p "docs/de-de/modules/$PLUGINS/examples"
  mkdir -p "docs/de-de/modules/$PLUGINS/pages"
  mkdir -p "docs/de-de/modules/$PLUGINS/partials"

  #moving textblocks
  find $PLUGINPATH -path '*/_textblocks/*' -name '*.adoc' -exec cp {} "docs/de-de/modules/$PLUGINS/partials" \;
  #moving pages
  find $PLUGINPATH -not -path '*/_textblocks/*' -name '*.adoc' -exec cp {} "docs/de-de/modules/$PLUGINS/pages" \;
  #moving html & txt files
  find $PLUGINPATH -name '*.html' -exec cp {} "docs/de-de/modules/$PLUGINS/examples" \;
  find $PLUGINPATH -name '*.txt' -exec cp {} "docs/de-de/modules/$PLUGINS/examples" \;
  #moving assets files
  find $PLUGINPATH \( -name '*.png' -o -name '*.jpg' -o -name '*.gif' \) -exec cp {} "docs/de-de/modules/$PLUGINS/images" \;
  ARRAY+=(${PLUGINS})
done

echo '######################';
echo '#  generate ANTORA   #';
echo '######################';
echo 'name: manual\ntitle: plentymarkets Handbuch\nversion: main\nnav:\n- modules/ROOT/nav.adoc' > docs/de-de/antora.yml


find docs/de-de/ -name '*.adoc' -exec sed -i -e '/include::{includedir}\/_header.adoc\[\]/d' {} \;
find docs/de-de/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)\/(.*).html/include::example$\2.html/g' {} \;
find docs/de-de/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)\/(.*).txt/include::example$\2.txt/g' {} \;
find docs/de-de/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)_includes(.*)\/(.*).adoc/include::_includes:page$\3.adoc/g' {} \;

# find docs/de-de/modules/_includes/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)\/(.*).adoc/include::.\/\2.adoc/g' {} \;


arraylength=${#ARRAY[@]}


for i in "${ARRAY[@]}";
  do
    # Matches all cases: include::(\.\.\/)*(([a-z0-9\-]+)\/){0,1}(_textblocks\/){0,1}(.+).adoc

    # Same module & Page
    # find docs/de-de/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::page$\2.adoc/ig" {} \;

    # Same module & Partial
    # find docs/de-de/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::(\.\/|\.\.\/)?(\.\.\/)*_textblocks\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::partial$\4.adoc/ig" {} \;

    # Same module & Partial referencing another partial
    # find docs/de-de/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::(\.\/|\.\.\/)?(\.\.\/)*(explanations|importants|instructions|notes|tables|tips|warnings)\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::partial$\5.adoc/ig" {} \;

    # Same module & Image
    # find docs/de-de/modules/ -name '*.adoc' -exec sed -i -r -e "s/image:(:)?\/?assets\/([A-Za-z0-9\_\-]+).(png|jpg|gif)/image:\1\2.\3/ig" {} \;

    # Different module & Page
    # find docs/de-de/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::(\.\.\/)+([a-z0-9\-]+)\/([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::\2:page$\4.adoc/ig" {} \;

    # Different module & Partial
    # find docs/de-de/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::(\.\.\/)*([a-z0-9\-]+)\/([a-z0-9\-]+\/)*_textblocks\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::\2:partial$\5.adoc/ig" {} \;

    # Different module & Image
    # find docs/de-de/modules/ -name '*.adoc' -exec sed -i -r -e "s/image:(:)?([a-z0-9\-]+)\/([A-Za-z0-9\_\-]+\/)*assets\/([A-Za-z0-9\_\-]+).(png|jpg|gif)/image:\1\2:\4.\5/ig" {} \;

    # Combined string replace statement
    find docs/de-de/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::page$\2.adoc/ig;s/include::(\.\/|\.\.\/)?(\.\.\/)*_textblocks\/([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::partial$\4.adoc/ig;s/include::(\.\/|\.\.\/)?(\.\.\/)*(explanations|importants|instructions|notes|tables|tips|warnings)\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::partial$\5.adoc/ig;s/include::(\.\.\/)+([a-z0-9\-]+)\/([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::\2:page$\4.adoc/ig;s/include::(\.\.\/)*([a-z0-9\-]+)\/([a-z0-9\-]+\/)*_textblocks\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::\2:partial$\5.adoc/ig;s/image:(:)?\/?assets\/([A-Za-z0-9\_\-]+).(png|jpg|gif)/image:\1\2.\3/ig;s/image:(:)?([a-z0-9\-]+)\/([A-Za-z0-9\_\-]+\/)*assets\/([A-Za-z0-9\_\-]+).(png|jpg|gif)/image:\1\2:\4.\5/ig" {} \;
done

# find docs/de-de/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)_textblocks(.*)\/(.*).adoc/include::.\/\3.adoc/g' {} \;

# Delete backup files
find docs/de-de/ -name '*.adoc-e' -delete

#STARTING GENERATING EN DOCS#

echo '######################';
echo '#    build doc EN    #';
echo '######################';

mkdir docs/en-gb
mkdir docs/en-gb/modules
mkdir docs/en-gb/modules/ROOT
mkdir docs/en-gb/modules/ROOT/images
mkdir docs/en-gb/modules/ROOT/pages
mkdir docs/en-gb/modules/ROOT/partials

cp -R ROOT-EN docs/en-gb/modules/ROOT/

#create includes files
mkdir -p "docs/en-gb/modules/_includes/pages"
mkdir -p "docs/en-gb/modules/_includes/examples"
mkdir -p "docs/en-gb/modules/_includes/images"

find gitRepo/en/_includes/ -name '*.adoc' -exec cp {} "docs/en-gb/modules/_includes/pages" \;
cp -R gitRepo/en/_includes/_pdf docs/en-gb/modules/_includes/examples
cp -R gitRepo/en/_includes/_plugin docs/en-gb/modules/_includes/examples

ARRAY=()
#navigate through all pages
for FILE in gitRepo/en/*.adoc;
  do
  #  echo $FILE
  PLUGINS1=${FILE%.[^.]*}
  PLUGINS=${PLUGINS1/gitRepo\/en\//}
  PLUGINPATH=${FILE/.adoc/}
  #echo $PLUGINPATH

  if [ "${PLUGINS}" == "glossary" ]; then
    PLUGINS="_glossary"
    PLUGINPATH=${PLUGINPATH/glossary/_glossary/}
  fi

  #create the directories
  mkdir -p "docs/en-gb/modules/$PLUGINS"
  mkdir -p "docs/en-gb/modules/$PLUGINS/images"
  mkdir -p "docs/en-gb/modules/$PLUGINS/examples"
  mkdir -p "docs/en-gb/modules/$PLUGINS/pages"
  mkdir -p "docs/en-gb/modules/$PLUGINS/partials"

  #moving textblocks
  find $PLUGINPATH -path '*/_textblocks/*' -name '*.adoc' -exec cp {} "docs/en-gb/modules/$PLUGINS/partials" \;
  #moving pages
  find $PLUGINPATH -not -path '*/_textblocks/*' -name '*.adoc' -exec cp {} "docs/en-gb/modules/$PLUGINS/pages" \;
  #moving html & txt files
  find $PLUGINPATH -name '*.html' -exec cp {} "docs/en-gb/modules/$PLUGINS/examples" \;
  find $PLUGINPATH -name '*.txt' -exec cp {} "docs/en-gb/modules/$PLUGINS/examples" \;
  #moving assets files
  find $PLUGINPATH \( -name '*.png' -o -name '*.jpg' -o -name '*.gif' \) -exec cp {} "docs/en-gb/modules/$PLUGINS/images" \;
  ARRAY+=(${PLUGINS})
done

echo '######################';
echo '#  generate ANTORA   #';
echo '######################';
echo 'name: manual\ntitle: plentymarkets Handbuch\nversion: main\nnav:\n- modules/ROOT/nav.adoc' > docs/en-gb/antora.yml

find docs/en-gb/ -name '*.adoc' -exec sed -i -e '/include::{includedir}\/_header.adoc\[\]/d' {} \;
find docs/en-gb/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)\/(.*).html/include::example$\2.html/g' {} \;
find docs/en-gb/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)\/(.*).txt/include::example$\2.txt/g' {} \;
find docs/en-gb/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)_includes(.*)\/(.*).adoc/include::_includes:page$\3.adoc/g' {} \;

# find docs/en-gb/modules/_includes/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)\/(.*).adoc/include::.\/\2.adoc/g' {} \;


arraylength=${#ARRAY[@]}


for i in "${ARRAY[@]}";
  do
    # Matches all cases: include::(\.\.\/)*(([a-z0-9\-]+)\/){0,1}(_textblocks\/){0,1}(.+).adoc

    # Same module & Page
    # find docs/en-gb/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::page$\2.adoc/ig" {} \;

    # Same module & Partial
    # find docs/en-gb/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::(\.\/|\.\.\/)?(\.\.\/)*_textblocks\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::partial$\4.adoc/ig" {} \;

    # Same module & Partial referencing another partial
    # find docs/en-gb/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::(\.\/|\.\.\/)?(\.\.\/)*(explanations|importants|instructions|notes|tables|tips|warnings)\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::partial$\5.adoc/ig" {} \;

    # Same module & Image
    # find docs/en-gb/modules/ -name '*.adoc' -exec sed -i -r -e "s/image:(:)?\/?assets\/([A-Za-z0-9\_\-]+).(png|jpg|gif)/image:\1\2.\3/ig" {} \;

    # Different module & Page
    # find docs/en-gb/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::(\.\.\/)+([a-z0-9\-]+)\/([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::\2:page$\4.adoc/ig" {} \;

    # Different module & Partial
    # find docs/en-gb/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::(\.\.\/)*([a-z0-9\-]+)\/([a-z0-9\-]+\/)*_textblocks\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::\2:partial$\5.adoc/ig" {} \;

    # Different module & Image
    # find docs/en-gb/modules/ -name '*.adoc' -exec sed -i -r -e "s/image:(:)?([a-z0-9\-]+)\/([A-Za-z0-9\_\-]+\/)*assets\/([A-Za-z0-9\_\-]+).(png|jpg|gif)/image:\1\2:\4.\5/ig" {} \;

    # Combined string replace statement
    find docs/en-gb/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::page$\2.adoc/ig;s/include::(\.\/|\.\.\/)?(\.\.\/)*_textblocks\/([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::partial$\4.adoc/ig;s/include::(\.\/|\.\.\/)?(\.\.\/)*(explanations|importants|instructions|notes|tables|tips|warnings)\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::partial$\5.adoc/ig;s/include::(\.\.\/)+([a-z0-9\-]+)\/([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::\2:page$\4.adoc/ig;s/include::(\.\.\/)*([a-z0-9\-]+)\/([a-z0-9\-]+\/)*_textblocks\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::\2:partial$\5.adoc/ig;s/image:(:)?\/?assets\/([A-Za-z0-9\_\-]+).(png|jpg|gif)/image:\1\2.\3/ig;s/image:(:)?([a-z0-9\-]+)\/([A-Za-z0-9\_\-]+\/)*assets\/([A-Za-z0-9\_\-]+).(png|jpg|gif)/image:\1\2:\4.\5/ig" {} \;
done

# find docs/en-gb/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)_textblocks(.*)\/(.*).adoc/include::.\/\3.adoc/g' {} \;

# Update links
echo '######################';
echo '#   updating links   #';
echo '######################';
find docs/ -name '*.adoc' -exec sed -i -e -E "s/<<([A-Za-z0-9\_\-]+)(\/.+)?\/([A-Za-z0-9\_\-]+)(#([A-Za-z0-9\_\-]+)?)?(, ?(.*)?)>>/xref:\1:\3.adoc\4\[\7\]/ig" {} \;
# Delete backup files
find docs/en-gb/ -name '*.adoc-e' -delete

#STARTING GENERATING THE MENU#

echo '######################';
echo '#    build nav       #';
echo '######################';
sh generateNav.sh
