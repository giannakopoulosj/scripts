https://unix.stackexchange.com/questions/378270/find-command-enumerate-output-and-allow-selection

When I use find, it often finds multiple results like

find -name pom.xml
./projectA/pom.xml
./projectB/pom.xml
./projectC/pom.xml
I often want to select only a specific result, (e.g edit ./projectB/pom.xml). Is there a way to enumerate find output and select a file to pass into another application? like:

find <print line nums?> -name pom.xml
1 ./projectA/pom.xml
2 ./projectB/pom.xml
3 ./projectC/pom.xml

!! | <get 2nd entry> | xargs myEditor
?

select file in $(find -name pom.xml); do
  $EDITOR "$file"
  break
done

--( IFS=$'\n'; select file in $(find -maxdepth 2 -name '*.txt'); do echo "$file"; done; )
