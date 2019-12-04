#!/bin/bash
CONFIGURATION=Release
FORMATTED_NAME_PREFIX=JBKnowledge.Extensions.RuntimeConfigurationInjection
PACKAGE_SOURCE="github.com/jbklabs"
BUMP="${1,,}"
LAST_VERSION=$(git describe --tags $(git rev-list --tags --max-count=1))
LAST_MAJOR=$(echo $LAST_VERSION | cut -d. -f1)
LAST_MINOR=$(echo $LAST_VERSION | cut -d. -f2)
LAST_PATCH=$(echo $LAST_VERSION | cut -d. -f3)
NEXT_VERSION=none
DATE=$(date '+%Y-%m-%d')

if [[ -z "$(nuget sources list | grep $PACKAGE_SOURCE)" ]]; then
  echo -e "Unabled to find nuget source '$PACKAGE_SOURCE'."
  read -p "Would you like to configure it now? [Yn] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "Operation Cancelled."
    exit 1
  elif [[ ! -z $REPLY && ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Invalid response."
    exit 1
  fi

  read -p "Enter your GitHub Username: " GITHUB_USER
  read -p "Enter your GitHub PAT: " GITHUB_PAT
  nuget sources Add -Name "$PACKAGE_SOURCE" -Source "https://nuget.pkg.github.com/JBKLabs/index.json" -UserName $GITHUB_USER -Password $GITHUB_PAT
fi

if [[ "$BUMP" == "major" ]]; then
  NEXT_MAJOR=$[LAST_MAJOR+1]
  NEXT_VERSION="$NEXT_MAJOR.0.0"
elif [[ "$BUMP" == "minor" ]]; then
  NEXT_MINOR=$[LAST_MINOR+1]
  NEXT_VERSION="$LAST_MAJOR.$NEXT_MINOR.0"
elif [[ "$BUMP" == "patch" ]]; then
  NEXT_PATCH=$[LAST_PATCH+1]
  NEXT_VERSION="$LAST_MAJOR.$LAST_MINOR.$NEXT_PATCH"
fi

if [[ "$NEXT_VERSION" == "none" ]]; then
  if [[ -z "$1" ]]; then
    echo -e "Missing version increment\n"
  else
    echo -e "Invalid increment: $1\n"
  fi
  echo -e "Usage:"
  echo -e "\tpublish major\n\t\t1.x.y --> 2.0.0"
  echo -e "\tpublish minor\n\t\tx.1.y --> x.2.0"
  echo -e "\tpublish patch\n\t\tx.y.1 --> x.y.2"
  exit 1
fi

echo "$LAST_VERSION --> $NEXT_VERSION"

read -p "Proceed with publishing? [yN] " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ || -z "$REPLY" ]]; then
  echo -e "Operation cancelled."
  exit 1
elif [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo -e "Invalid response."
  exit 1
fi

dotnet restore
dotnet publish -c $CONFIGURATION
nuget pack .nuspec -Properties Configuration=$CONFIGURATION -Version $NEXT_VERSION

sed -i -e "s/## Unreleased/## Unreleased\n\n\## [$NEXT_VERSION\] - $DATE/" CHANGELOG.md
git add CHANGELOG.md
git commit -m "prepare $NEXT_VERSION"
git push

git tag $NEXT_VERSION
git push origin $NEXT_VERSION

nuget push $FORMATTED_NAME_PREFIX.$NEXT_VERSION.nupkg -Source $PACKAGE_SOURCE

rm *.nupkg