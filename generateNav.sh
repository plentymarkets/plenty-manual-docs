#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#brew install jq
#jq '.willkommen' de.json
echo 'name: manual\ntitle: plentymarkets Handbuch\nversion: main\nnav:\n- modules/ROOT/nav.adoc' > adocOutput/de/antora.yml

for menuParent in $(jq -r 'keys_unsorted[]' de.json); do
    #Create first levels
    parentTitle=$(jq -r '."'${menuParent}'".title' de.json)
    sudo bash -c 'echo "* xref:"'"${menuParent}"'":"'"${menuParent}"'".adoc["'"${parentTitle}"'"]" >> adocOutput/de/modules/ROOT/nav.adoc'

    #create first children
    for child in $(jq -r '."'${menuParent}'".children | keys_unsorted[]' de.json); do
      title=$(jq -r '."'${menuParent}'".children."'${child}'".title' de.json)
      sudo bash -c 'echo "** xref:"'"${menuParent}"'":"'"${child}"'".adoc["'"${title}"'"]" >> adocOutput/de/modules/ROOT/nav.adoc'

      #create second children
      for secondChild in $(jq -r '."'${menuParent}'".children."'${child}'".children | keys_unsorted[]' de.json); do
          secondChildTitle=$(jq -r '."'${menuParent}'".children."'${child}'".children."'${secondChild}'".title' de.json)
          sudo bash -c 'echo "*** xref:"'"${menuParent}"'":"'"${secondChild}"'".adoc["'"${secondChildTitle}"'"]" >> adocOutput/de/modules/ROOT/nav.adoc'

          #create third children
          for thirdChild in $(jq -r '."'${menuParent}'".children."'${child}'".children."'${secondChild}'".children | keys_unsorted[]' de.json); do
              thirdChildTitle=$(jq -r '."'${menuParent}'".children."'${child}'".children."'${secondChild}'".children."'${thirdChild}'".title' de.json)
              sudo bash -c 'echo "**** xref:"'"${menuParent}"'":"'"${thirdChild}"'".adoc["'"${thirdChildTitle}"'"]" >> adocOutput/de/modules/ROOT/nav.adoc'

              #create fourth children
                  for fourthChild in $(jq -r '."'${menuParent}'".children."'${child}'".children."'${secondChild}'".children."'${thirdChild}'".children | keys_unsorted[]' de.json); do
                      fourthChildTitle=$(jq -r '."'${menuParent}'".children."'${child}'".children."'${secondChild}'".children."'${thirdChild}'".children."'${fourthChild}'".title' de.json)
                      sudo bash -c 'echo "***** xref:"'"${menuParent}"'":"'"${fourthChild}"'".adoc["'"${fourthChildTitle}"'"]" >> adocOutput/de/modules/ROOT/nav.adoc'
                  done

          done

      done

    done
done


#EN MENU
echo 'name: manual\ntitle: plentymarkets Handbuch\nversion: main\nnav:\n- modules/ROOT/nav.adoc' > adocOutput/en/antora.yml

for menuParent in $(jq -r 'keys_unsorted[]' en.json); do
    #Create first levels
    parentTitle=$(jq -r '."'${menuParent}'".title' en.json)
    sudo bash -c 'echo "* xref:"'"${menuParent}"'":"'"${menuParent}"'".adoc["'"${parentTitle}"'"]" >> adocOutput/en/modules/ROOT/nav.adoc'

    #create first children
    for child in $(jq -r '."'${menuParent}'".children | keys_unsorted[]' en.json); do
      title=$(jq -r '."'${menuParent}'".children."'${child}'".title' en.json)
      sudo bash -c 'echo "** xref:"'"${menuParent}"'":"'"${child}"'".adoc["'"${title}"'"]" >> adocOutput/en/modules/ROOT/nav.adoc'

      #create second children
      for secondChild in $(jq -r '."'${menuParent}'".children."'${child}'".children | keys_unsorted[]' en.json); do
          secondChildTitle=$(jq -r '."'${menuParent}'".children."'${child}'".children."'${secondChild}'".title' en.json)
          sudo bash -c 'echo "*** xref:"'"${menuParent}"'":"'"${secondChild}"'".adoc["'"${secondChildTitle}"'"]" >> adocOutput/en/modules/ROOT/nav.adoc'

          #create third children
          for thirdChild in $(jq -r '."'${menuParent}'".children."'${child}'".children."'${secondChild}'".children | keys_unsorted[]' en.json); do
              thirdChildTitle=$(jq -r '."'${menuParent}'".children."'${child}'".children."'${secondChild}'".children."'${thirdChild}'".title' en.json)
              sudo bash -c 'echo "**** xref:"'"${menuParent}"'":"'"${thirdChild}"'".adoc["'"${thirdChildTitle}"'"]" >> adocOutput/en/modules/ROOT/nav.adoc'

              #create fourth children
                  for fourthChild in $(jq -r '."'${menuParent}'".children."'${child}'".children."'${secondChild}'".children."'${thirdChild}'".children | keys_unsorted[]' en.json); do
                      fourthChildTitle=$(jq -r '."'${menuParent}'".children."'${child}'".children."'${secondChild}'".children."'${thirdChild}'".children."'${fourthChild}'".title' en.json)
                      sudo bash -c 'echo "***** xref:"'"${menuParent}"'":"'"${fourthChild}"'".adoc["'"${fourthChildTitle}"'"]" >> adocOutput/en/modules/ROOT/nav.adoc'
                  done

          done

      done

    done
done