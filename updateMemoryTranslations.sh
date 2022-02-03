#!/bin/sh

echo '##########################';
echo '#    replace translation memory    #';
echo '##########################';

brew install gnumeric
ssconvert handbuch.xlsx handbuchcsv.csv
find handbuchcsv.csv -exec sed -i -r -E "s/include::([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::page$\2.adoc/ig;s/include::(\.\/|\.\.\/)?(\.\.\/)*_textblocks\/([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::partial$\4.adoc/ig;s/include::(\.\/|\.\.\/)?(\.\.\/)*(explanations|importants|instructions|notes|tables|tips|warnings)\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::partial$\5.adoc/ig;s/include::(\.\.\/)+([a-z0-9\-]+)\/([a-z0-9\-]+\/)*([A-Za-z0-9\_\-]+).adoc/include::\2:page$\4.adoc/ig;s/include::(\.\.\/)*([a-z0-9\-]+)\/([a-z0-9\-]+\/)*_textblocks\/(.+\/)*([A-Za-z0-9\_\-]+).adoc/include::\2:partial$\5.adoc/ig;s/image:(:)?\/?assets\/([A-Za-z0-9\_\-]+).(png|jpg|gif)/image:\1\2.\3/ig;s/image:(:)?([a-z0-9\-]+)\/([A-Za-z0-9\_\-]+\/)*assets\/([A-Za-z0-9\_\-]+).(png|jpg|gif)/image:\1\2:\4.\5/ig;s/include::.*\/_glossar\/([A-Za-z0-9\_\-]+).adoc/include::glossar:partial$\1.adoc/ig" {} \;

ln -s handbuchcsv.csv newxlsx
ssconvert newxlsx handbuch.xlsx