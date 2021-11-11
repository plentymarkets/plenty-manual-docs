echo '##########################';
echo '#    set up workspace    #';
echo '##########################';

if [ -d gitRepo ]; then
  rm -rf gitRepo
fi

git clone "https://github.com/plentymarkets/manual" gitRepo

if [ -d adocOutput ]; then
  rm -rf adocOutput
fi

mkdir adocOutput

echo '######################';
echo '#    build doc DE    #';
echo '######################';


mkdir adocOutput/de
mkdir adocOutput/de/modules
echo 'name: manual\ntitle: plentymarkets Handbuch\nversion: main\nnav:\n- modules/ROOT/nav.adoc' > adocOutput/de/antora.yml
mkdir adocOutput/de/modules/ROOT
mkdir adocOutput/de/modules/ROOT/images
mkdir adocOutput/de/modules/ROOT/pages
mkdir adocOutput/de/modules/ROOT/partials

#navigate through all pages
cd gitRepo/de
for FILE in *.adoc;
  do
  echo ${FILE%.[^.]*};
  cp $FILE ../../adocOutput/de/modules/ROOT/pages;
  #move textblocks
  mv ${FILE%.[^.]*}/_textblocks ../../adocOutput/de/modules/ROOT/partials/${FILE%.[^.]*}
  mv ${FILE%.[^.]*}/assets ../../adocOutput/de/modules/ROOT/images/${FILE%.[^.]*}
  cp -R ${FILE%.[^.]*} ../../adocOutput/de/modules/ROOT/pages;
  #generate the menu
   echo "* ${FILE%.[^.]*}" >> ../../adocOutput/de/modules/ROOT/nav.adoc
   for FILE1 in ${FILE%.[^.]*}/*.adoc
    do
    echo "** xref:${FILE1}[${FILE1%.[^.]*}]" >> ../../adocOutput/de/modules/ROOT/nav.adoc
   done
done

