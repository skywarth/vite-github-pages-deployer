# Vite Github Pages Deploy

<!-- ![GitHub all releases](https://img.shields.io/github/downloads/skywarth/vite-github-pages-deployer/total?style=for-the-badge) -->

Deploy your [Vite](https://vitejs.dev/guide/) application to Github Pages, at a glance. 
- No shenanigans such as committing the dist folder and pushing to a branch. 
- Clean deploy to Github Pages by utilizing actions and artifacts.
- Customizable with optional build path

```
- name: Vite Github Pages Deployer
  uses: skywarth/vite-github-pages-deployer@v1.1.0
```

## Usage Tidbits

### :mega: Don't forget to release environment regarding the deploy (see [outputs](#outputs) for details):
```
# Name could be whatever you wish. It'll be visible publicly under the environments tab.
environment:
  name: demo
  url: ${{ steps.deploy_to_pages.outputs.page_url }}
```

### :heavy_exclamation_mark: Set the proper permissions for the `GITHUB_TOKEN`

If you don't declare the proper permissions, you may receive ` Error: Ensure GITHUB_TOKEN has permission "id-token: write".` error. 

```
# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write
```

### :warning: Make sure `package-json.lock` is present

If `package_manager` input preference is set to `npm` (or default, unassigned), it will install dependencies using `npm ci` which utilizes `package-lock.json`. In this case make sure it is present in your project root.



## Demo

Wanna see it in action? Sure thing, head on to this vue project to see it live: https://github.com/skywarth/country-routing-algorithm-demo-vue


## Input Parameters

### `public_base_path` (optional)
`Type: string`
`Default: '/(your-repo-name)'`

[Public base path](https://vitejs.dev/guide/build.html#public-base-path) string for Vite, this affects the routing, history and asset links. Make sure to provide appropriately since Github Pages stores your app in a directory under a subdomain. If you plan on deploying to alternative platform such as Vercel, you should simply provide `/`. 

Under normal circumstances, you don't need to provide/override this parameter, action will set it to your repo name appropriately.

### `build_path`(optional)
`Type: string`
`Default: './dist'`

Which folder do you want your Github Page to use as root directory, after the build process. Simply it is your build output directory such as `./dist`. If your `vite` config exports to a folder other than `./dist`, then you should pass it as parameter.


### `install_phase_node_env`(optional)
`Type: string`
`Default: 'dev'`

`Example values:` `dev`,`production`,`test`,`staging`, `my-little-pony-env`

Node environment that will be used for the installation of dependencies. **It is imperative you use an environment that has 'vite' as dependency**. Commonly and naturally, that env is `dev`. 

:x: If you don't provide a NODE_ENV that has `vite` as dependency (check your package.json), you'll receive `sh: 1: vite: not found` during build phase.

### `build_phase_node_env` (optional)
`Type: string`
`Default: 'production'`

`Example values:` `dev`,`production`,`test`,`staging`, `my-little-pony-env`

Node environment that will be used for the build phase. You may provide any valid NODE_ENV value for this, since node builds tend to change for different environments (e.g: you hide debugging features from production).



### `artifact_name` (optional)
`Type: string`
`Default: 'github-pages'`

Desired name for the exposed artifact. This name is visible in job and used as the artifacts name.


### `package_manager` (optional)
`Type: string`
`Default: 'npm'`
`Possible values: 'npm'|'yarn'`

Indicate the package manager of preferrence. It'll be used for installing dependencies and building the `dist`. For example if you prefer/use `yarn` as your package manager for the project, then you may pass `package_manager: 'yarn'` as input which then will be used as `yarn install` and `yarn build`.

### `debug_mode` (optional)
`Type: string`
`Default: 'false'`
`Possible values: 'true'|'false'`

Controls the debug mode, string, `'true'` is for on. When turned on, it'll output certain information on certain steps. Mainly used for development, but use it as you please to inspect your env and variables.

<a name="outputs"></a>
## Outputs


### `github_pages_url`
`Type: string`
`Example value: 'https://skywarth.github.io/country-routing-algorithm-demo-vue/'`

This output value shall be used to acquire the github pages url following the deployment. It can be accessed like so: `${{ steps.deploy_to_pages.outputs.github_pages_url }}` (deploy_to_pages is the id of the step that you run Vite Github Pages Deployer).

It is expected to be used as a way to publish environment during the job, like so:
```
environment:
      name: demo
      url: ${{ steps.deploy_to_pages.outputs.github_pages_url }}
```

See [example workflow](#example-workflow) to grasp how to utilize this output




<a name="example-workflow"></a>
## Example workflow 
```
name: Vite Github Pages Deploy

on:
  # Runs on pushes targeting the default branch
  push:
    branches: ["master"]
  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write

# Allow only one concurrent deployment, skipping runs queued between the run in-progress and latest queued.
# However, do NOT cancel in-progress runs as we want to allow these production deployments to complete.
concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  # Build job
  build:
    runs-on: ubuntu-latest
    environment:
      name: demo
      url: ${{ steps.deploy_to_pages.outputs.github_pages_url }}
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Vite Github Pages Deployer
        uses: skywarth/vite-github-pages-deployer@master
        id: deploy_to_pages

```

## TODOs

- [X] ~~Output the deploy url for environment, see issue #2~~
- [X] ~~Spread the gospel.~~
  - [X] ~~[DEV.to post](https://dev.to/skywarth/deploying-your-vite-apps-to-github-pages-is-a-breeze-with-vite-github-pages-deployer-30c3)~~
  - [X] ~~Reddit (opensource, github, github action, ci/cd, vite, vue, react forums etc.).Blah, reddit was like, you know... Reddit.~~
  - [X] ~~Maybe a [medium.com post](https://medium.com/@yigitk.ersoy/introducing-vite-github-pages-deployer-a-better-way-to-showcase-your-vite-projects-fadbb93f3db9)... God I hate that place, it stinks.~~
- [ ] `env:
          NODE_ENV: production`
- [ ] Section for common errors and solutions.
- [X] ~~Option for defining package manager preference, see issue #1~~
- [ ] Table of Content 
- [ ] ~~Move bash scripts to a separate file for each section: build.sh, install.sh etc...~~
  - [ ] ~~Passing some parameters to it perhaps~~



<details><summary>Notes to self</summary>

- `${{github.action_path}}`: Gives you the dir for this action itself.

- `${{ github.workspace }}`: Gives you the dir of the project (E.g: /home/runner/work/country-routing-algorithm-demo-vue/country-routing-algorithm-demo-vue)

- When you import a sh file in the bash shell, it is only accessible during that step only. This is due to the fact that each step is a shell on its own.

- ~~Inside separate `sh` files, you can access input variables of the action by their respective uppercase name. For example:~~
  - Input definition:
    ```
    inputs: 
        package_manager:
        description: "Your preference of package manager: 'npm' and 'yarn' are possible values."
        required: false
        default: 'npm'
    ```
  - ~~Accessing this input **inside the action**: `${{ inputs.package_manager }}`~~
  - ~~Accessing this input **inside a `sh` file: `$PACKAGE_MANAGER`~~
    - Alternatively, you may pass env to the step to access it from a name of your liking:
      ```
      env:
        SOME_OTHER_NAME: ${{ inputs.package_manager }}
      ``` 

- If you run `sh` files in steps, don't expect each shell to share the environments. For example in one step you install dependencies in install.sh, in another step you build by build.sh. It won't work because installed libs are only available for the install.sh step. This is why `bash-files` failed, I consulted GPT but apparently there is no way of achieving it.


</details>

