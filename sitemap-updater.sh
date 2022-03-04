#!/bin/sh

echo '##########################';
echo '#    reading sitemap     #';
echo '##########################';
function update_sitemap {
  locations=($(awk -F"[<>]" '/loc/{print $3}' $1))
  rm -rf $1
  declare -r XML_FILE=$1
  echo '<?xml version="1.0" encoding="UTF-8"?>
  <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' >> ${XML_FILE}
  for i in ${!locations[*]}
  do
    urlObj=(${locations[i]//main\// })
    moduleObj=(${urlObj[1]//\// })
    moduleName=${moduleObj[0]}
    pageObj=(${moduleObj[1]//.html/ })
    pageName=${pageObj[0]}

    ##   :page-index: false
      echo ${locations[i]} ${moduleName} ${pageName}
      if grep -q ':page-index: false' $2/${moduleName}/pages/${pageName}.adoc
      then
          echo 'Exists'
      else
          currentDate=`date +"%Y-%m-%dT%T"`
          echo 'DOESNT exists'
          echo "<url>" >> ${XML_FILE}
          echo "<loc>"${locations[i]}"</loc>" >> ${XML_FILE}
          echo "<lastmod>"${currentDate}"</lastmod>" >> ${XML_FILE}
          echo "</url>" >> ${XML_FILE}
      fi
  done
  echo '</urlset>' >> ${XML_FILE}
}

update_sitemap "build/de-de/sitemap.xml" "docs/de-de/modules"
update_sitemap "build/en-gb/sitemap.xml" "docs/en-gb/modules"