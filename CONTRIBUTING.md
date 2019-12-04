## Developing Locally

* create a directory on your machine to serve as a local nuget package source, e.g. `~/.local/nuget`
* run `nuget sources Add -Name local -Source <absolute path>`. 
  * e.g. `nuget sources Add -Name local -Source C:\Users\bmaule\.local\nuget`
* run the provided `scripts/local-deploy.sh` to push a new version to your local source
* open up an API project and install the newest version from your local source

## Dependency Versions

When declaring new dependencies, make sure you do the following:

* verify the dependency + version are compatible with core 2.2
* verify the changes persist to the `.csproj` file
* **manually** update the `.nuspec` file

## Deploying

* Create a Personal Access Token (PAT) on GitHub.com with the following scopes:

![](./assets/github-publish-scopes.png)

In a terminal, run:

* `./scripts/publish.sh <major|minor|patch>`
