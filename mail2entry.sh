#!/bin/sh

(


#          & atomContributor*
#          & atomLink*
#          & atomRights?
#          & atomSource?
#          & atomSummary?
#          & extensionElement*)


  echo "<entry>"

  echo "  <author>"
  echo "    <name><!-- From --></name>"
  echo "    <email><!-- From --></email>"
  #echo "    <uri><!-- nil --></uri>"
  echo "  </author>"

  echo "  <id><!-- Message-ID --></id>"

  echo "  <title><!-- Subject --></title>"

  echo "  <published><!-- Date --></published>"

  echo "  <updated><!-- Date --></updated>"

  echo "  <category term='<!-- Keywords, Comment -->'/>"

  

  echo "  <content>"
  echo "<![CDATA["
  sed -e '1,/^$/d' "${message}"  #FIXME: escape ']]>'
  echo "]]>"
  echo "  </content>"

  echo "</entry>"
)
