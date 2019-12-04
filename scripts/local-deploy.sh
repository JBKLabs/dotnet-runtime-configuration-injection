#!/bin/bash
CONFIGURATION=Release
FORMATTED_NAME_PREFIX=JBKnowledge.Extensions.RuntimeConfigurationInjection

if [[ -z "${LOCAL_NUGET_SOURCE}" ]]; then
  echo -e "Missing Local Nuget Source!\n\n"
  echo -e "Resolution:"
  echo -e "\t1. Create a local nuget source"
  echo -e "\t2. Export the path as LOCAL_NUGET_SOURCE"
  echo -e "\t3. Try again\n\n"
  echo -e "Please refer to the README for more detailed instructions."
  exit 1
fi


FULL_SOURCE_PATH=$LOCAL_NUGET_SOURCE/$FORMATTED_NAME_PREFIX/
COUNT=$(( 1 ))

for v in $(ls $FULL_SOURCE_PATH) ; do
  COUNT=$((COUNT + 1))
done

NEXT_VERSION="0.0.${COUNT}"

dotnet restore
dotnet publish -c $CONFIGURATION
nuget pack .nuspec -Properties Configuration=$CONFIGURATION -Version $NEXT_VERSION
nuget add $FORMATTED_NAME_PREFIX.$NEXT_VERSION.nupkg -s $LOCAL_NUGET_SOURCE

rm *.nupkg