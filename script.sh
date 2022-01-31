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

cp -R ROOT-DE/* docs/de-de/modules/ROOT/

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

  #create the directories
  mkdir -p "docs/de-de/modules/$PLUGINS"
  mkdir -p "docs/de-de/modules/$PLUGINS/images"
  mkdir -p "docs/de-de/modules/$PLUGINS/examples"
  mkdir -p "docs/de-de/modules/$PLUGINS/pages"
  mkdir -p "docs/de-de/modules/$PLUGINS/partials"

  #moving root pages
  find gitRepo/de/ -maxdepth 1 -name "$PLUGINS.adoc" -exec cp {} "docs/de-de/modules/$PLUGINS/pages" \;
  
  if [ "${PLUGINS}" == "glossar" ]; then
    PLUGINPATH=${PLUGINPATH/glossar/_glossar/}
    find $PLUGINPATH -name '*.adoc' -exec cp {} "docs/de-de/modules/$PLUGINS/partials" \;
  else

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

  fi
done

echo '######################';
echo '#  generate ANTORA   #';
echo '######################';
echo 'name: manual\ntitle: plentymarkets Handbuch\nversion: main\nnav:\n- modules/ROOT/nav.adoc' > docs/de-de/antora.yml


find docs/de-de/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)\/(.*).html/include::example$\2.html/g' {} \;
find docs/de-de/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)\/(.*).txt/include::example$\2.txt/g' {} \;
find docs/de-de/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)_includes(.*)\/(.*).adoc/include::_includes:page$\3.adoc/g' {} \;

# find docs/de-de/modules/_includes/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)\/(.*).adoc/include::.\/\2.adoc/g' {} \;

# Replace special cases not covered by the general solution below
find docs/de-de/modules/artikel/partials/ -name 'artikel-einleitung.adoc' -exec sed -i -e "s/include::\.\.\/\.\.\/einleitung\/struktur.adoc/include::page\$struktur.adoc/ig" {} \;
find docs/de-de/modules/artikel/pages/ -name 'kategorien.adoc' -exec sed -i -e "s/include::\.\.\/webshop\/checkliste-kategorien-anzeige.adoc/include::page\$checkliste-kategorien-anzeige.adoc/ig" {} \;
find docs/de-de/modules/artikel/pages/ -name 'preise.adoc' -exec sed -i -e "s/include::\.\.\/import-export-anlage\/anlage\/verzeichnis.adoc/include::page\$verzeichnis.adoc/ig" {} \;
find docs/de-de/modules/artikel/pages/ -name 'preise.adoc' -exec sed -i -e "s/include::\.\.\/import-export-anlage\/anlage\/massenbearbeitung.adoc/include::page\$massenbearbeitung.adoc/ig" {} \;
find docs/de-de/modules/artikel/pages/ -name 'verfuegbarkeit.adoc' -exec sed -i -e "s/include::\.\.\/import-export-anlage\/anlage\/massenbearbeitung.adoc/include::page\$massenbearbeitung.adoc/ig" {} \;
find docs/de-de/modules/business-entscheidungen/pages/ -name 'benutzerkonten-zugaenge.adoc' -exec sed -i -e "s/include::\.\/systemadministration\/\_textblocks\/instructions\/benutzerkonto-erstellen.adoc/include::partial\$benutzerkonto-erstellen.adoc/ig" {} \;
find docs/de-de/modules/business-entscheidungen/pages/ -name 'benutzerkonten-zugaenge.adoc' -exec sed -i -e "s/include::\.\/systemadministration\/\_textblocks\/instructions\/rechte-vergeben.adoc/include::partial\$rechte-vergeben.adoc/ig" {} \;
find docs/de-de/modules/changelog/pages/ -name '2021-08-04.adoc' -exec sed -i -e "s/include::\.\/changelog\/_textblocks\/otto-master-file.adoc/include::partial\$otto-master-file.adoc/ig" {} \;
find docs/de-de/modules/daten/partials/ -name 'catalogues-faq.adoc' -exec sed -i -e "s/include::\.\.\/\.\.\/kataloge-verwalten\/katalog-formate\/artikel.adoc/include::page\$artikel.adoc/ig" {} \;
find docs/de-de/modules/maerkte/partials/ -name 'mirakl-market-setup.adoc' -exec sed -i -e "s/include::\.\.\/properties\/instructions\/properties-creation.adoc/include::partial\$properties-creation.adoc/ig" {} \;
find docs/de-de/modules/maerkte/partials/ -name 'mirakl-market-setup.adoc' -exec sed -i -e "s/include::\.\.\/properties\/instructions\/properties-creation-table.adoc/include::partial\$properties-creation-table.adoc/ig" {} \;

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

    # Glossary entry
    # find docs/de-de/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::.*\/_glossar\/([A-Za-z0-9\_\-]+).adoc/include::glossar:partial$\1.adoc/ig" {} \;

    # Combined string replace statement
    find docs/de-de/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::page$\2.adoc/ig;s/include::(\.\/|\.\.\/)?(\.\.\/)*_textblocks\/([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::partial$\4.adoc/ig;s/include::(\.\/|\.\.\/)?(\.\.\/)*(explanations|importants|instructions|notes|tables|tips|warnings)\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::partial$\5.adoc/ig;s/include::(\.\.\/)+([a-z0-9\-]+)\/([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::\2:page$\4.adoc/ig;s/include::(\.\.\/)*([a-z0-9\-]+)\/([a-z0-9\-]+\/)*_textblocks\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::\2:partial$\5.adoc/ig;s/image:(:)?\/?assets\/([A-Za-z0-9\_\-]+).(png|jpg|gif)/image:\1\2.\3/ig;s/image:(:)?([a-z0-9\-]+)\/([A-Za-z0-9\_\-]+\/)*assets\/([A-Za-z0-9\_\-]+).(png|jpg|gif)/image:\1\2:\4.\5/ig;s/include::.*\/_glossar\/([A-Za-z0-9\_\-]+).adoc/include::glossar:partial$\1.adoc/ig" {} \;
done

# find docs/de-de/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)_textblocks(.*)\/(.*).adoc/include::.\/\3.adoc/g' {} \;

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

cp -R ROOT-EN/* docs/en-gb/modules/ROOT/

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

  #create the directories
  mkdir -p "docs/en-gb/modules/$PLUGINS"
  mkdir -p "docs/en-gb/modules/$PLUGINS/images"
  mkdir -p "docs/en-gb/modules/$PLUGINS/examples"
  mkdir -p "docs/en-gb/modules/$PLUGINS/pages"
  mkdir -p "docs/en-gb/modules/$PLUGINS/partials"

  #moving root pages
  find gitRepo/en/ -maxdepth 1 -name "$PLUGINS.adoc" -exec cp {} "docs/en-gb/modules/$PLUGINS/pages" \;
  
  if [ "${PLUGINS}" == "glossary" ]; then
    PLUGINPATH=${PLUGINPATH/glossary/_glossary/}
    find $PLUGINPATH -name '*.adoc' -exec cp {} "docs/en-gb/modules/$PLUGINS/partials" \;
  else

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

  fi
done

echo '######################';
echo '#  generate ANTORA   #';
echo '######################';
echo 'name: manual\ntitle: plentymarkets Handbuch\nversion: main\nnav:\n- modules/ROOT/nav.adoc' > docs/en-gb/antora.yml

find docs/en-gb/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)\/(.*).html/include::example$\2.html/g' {} \;
find docs/en-gb/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)\/(.*).txt/include::example$\2.txt/g' {} \;
find docs/en-gb/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)_includes(.*)\/(.*).adoc/include::_includes:page$\3.adoc/g' {} \;

# find docs/en-gb/modules/_includes/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)\/(.*).adoc/include::.\/\2.adoc/g' {} \;

# Replace special cases not covered by the general solution below
find docs/en-gb/modules/business-decisions/pages/ -name 'user-accounts-access.adoc' -exec sed -i -e "s/include::\.\/system-administration\/_textblocks\/instructions\/benutzerkonto-erstellen-en_gb.adoc/include::partial\$benutzerkonto-erstellen-en_gb.adoc/ig" {} \;
find docs/en-gb/modules/business-decisions/pages/ -name 'user-accounts-access.adoc' -exec sed -i -e "s/include::system-administration\/_textblocks\/instructions\/rechte-vergen-en_gb.adoc/include::partial\$rechte-vergen-en_gb.adoc/ig" {} \;
find docs/en-gb/modules/item/pages/ -name 'availability.adoc' -exec sed -i -e "s/include::\.\.\/import-export-create\/create\/mass-processing.adoc/include::page\$mass-processing.adoc/ig" {} \;
find docs/en-gb/modules/item/pages/ -name 'categories.adoc' -exec sed -i -e "s/include::\.\.\/online-store\/checklist-categories-visibility.adoc/include::page\$checklist-categories-visibility.adoc/ig" {} \;
find docs/en-gb/modules/item/partials/ -name 'item-introduction.adoc' -exec sed -i -e "s/include::\.\.\/\.\.\/introduction\/structure.adoc/include::page\$structure.adoc/ig" {} \;
find docs/en-gb/modules/item/pages/ -name 'prices.adoc' -exec sed -i -e "s/include::\.\.\/import-export-create\/create\/directory.adoc/include::page\$directory.adoc/ig" {} \;
find docs/en-gb/modules/item/pages/ -name 'prices.adoc' -exec sed -i -e "s/include::\.\.\/import-export-create\/create\/mass-processing.adoc/include::page\$mass-processing.adoc/ig" {} \;
find docs/en-gb/modules/markets/partials/ -name 'prices.adoc' -exec sed -i -e "s/include::\.\.\/import-export-create\/create\/mass-processing.adoc/include::page\$mass-processing.adoc/ig" {} \;
find docs/en-gb/modules/markets/partials/ -name 'mirakl-market-setup.adoc' -exec sed -i -e "s/include::\.\.\/properties\/instructions\/properties-creation.adoc/include::partial\$properties-creation.adoc/ig" {} \;
find docs/en-gb/modules/markets/partials/ -name 'mirakl-market-setup.adoc' -exec sed -i -e "s/include::\.\.\/properties\/instructions\/properties-creation-table.adoc/include::partial\$properties-creation-table.adoc/ig" {} \;

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

    # Glossary entry
    # find docs/en-gb/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::.*\/_glossary\/([A-Za-z0-9\_\-]+).adoc/include::glossary:partial$\1.adoc/ig" {} \;

    # Combined string replace statement
    find docs/en-gb/modules/ -name '*.adoc' -exec sed -i -r -e "s/include::([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::page$\2.adoc/ig;s/include::(\.\/|\.\.\/)?(\.\.\/)*_textblocks\/([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::partial$\4.adoc/ig;s/include::(\.\/|\.\.\/)?(\.\.\/)*(explanations|importants|instructions|notes|tables|tips|warnings)\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::partial$\5.adoc/ig;s/include::(\.\.\/)+([a-z0-9\-]+)\/([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::\2:page$\4.adoc/ig;s/include::(\.\.\/)*([a-z0-9\-]+)\/([a-z0-9\-]+\/)*_textblocks\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::\2:partial$\5.adoc/ig;s/image:(:)?\/?assets\/([A-Za-z0-9\_\-]+).(png|jpg|gif)/image:\1\2.\3/ig;s/image:(:)?([a-z0-9\-]+)\/([A-Za-z0-9\_\-]+\/)*assets\/([A-Za-z0-9\_\-]+).(png|jpg|gif)/image:\1\2:\4.\5/ig;s/include::.*\/_glossary\/([A-Za-z0-9\_\-]+).adoc/include::glossary:partial$\1.adoc/ig" {} \;
done

# find docs/en-gb/ -name '*.adoc' -exec sed -i -r -e 's/include::(.*)_textblocks(.*)\/(.*).adoc/include::.\/\3.adoc/g' {} \;

echo '######################';
echo '#   Global actions   #';
echo '######################';
# Update links
#find docs/ -name '*.adoc' -exec sed -r -i -E "s/<<([a-zA-ZäöüÄÖÜß0-9\_\-]+)(\/.+)?\/([a-zA-ZäöüÄÖÜß0-9\_\-]+)(#([a-zA-ZäöüÄÖÜß0-9\_\-]+)?)?(, ?([ a-zA-ZäöüÄÖÜß0-9\_\-\(\)]*)?)>>/xref:\1:\3.adoc\4\[\7\]/g" {} \;

# Update tabs class
# find docs/ -name '*.adoc' -exec sed -i -r -e "s/\[\.tabs\]/\[tabs\]/ig" {} \;

# Global actions for all files
find docs/ -name '*.adoc' -exec sed -r -i -E "s/<<([a-zA-ZäöüÄÖÜß0-9\_\-]+)(\/.+)?\/([a-zA-ZäöüÄÖÜß0-9\_\-]+)(#([a-zA-ZäöüÄÖÜß0-9\_\-]+)?)?(, ?([ a-zA-ZäöüÄÖÜß0-9\_\-\(\)]*)?)>>/xref:\1:\3.adoc\4\[\7\]/g;s/\[\.tabs\]/\[tabs\]/ig" {} \;

# Update position header attribute
find docs/*/pages/ -name '*.adoc' -exec sed -i -r -e "s/:position:\s0/:index:\sfalse/ig;s/:position:\s[0-9]{5,}/:index: false/ig" {} \;

# Remove remaining position header attributes
find docs/*/pages/ -name '*.adoc' -exec sed -i -r -e "/:position:\s[0-9]+/d" {} \;

# Remove lang header attribute
find docs/*/pages/ -name '*.adoc' -exec sed -i -r -e "/:lang:\s[de|en]/d" {} \;

# Remove header include
find docs/*/pages/ -name '*.adoc' -exec sed -i -e "/include::{includedir}\/_header\.adoc\[\]/d" {} \;

# Remove url header attribute
find docs/*/pages/ -name '*.adoc' -exec sed -i -r -e "/:url:\s[a-z\/\-]+/d" {} \;

# Remove nav-alias attribute
find docs/*/pages/ -name '*.adoc' -exec sed -i -r -e "/:nav-alias:\s?[A-Za-zÄäÖöÜüß0-9\s\-]*/d" {} \;

# Delete backup files
find docs/ -name '*.adoc-e' -delete

#STARTING GENERATING THE MENU#

echo '######################';
echo '#    build nav       #';
echo '######################';
sh generateNav.sh
