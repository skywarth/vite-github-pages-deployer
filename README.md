# Vite Github Pages Deploy

Deploy your [Vite](https://vitejs.dev/guide/) application to Github Pages, at a glance. 
- No shenanigans such as committing the dist folder and pushing to a branch. 
- Clean deploy to Github Pages by utilizing actions and artifacts.
- Customizable with optional build path

```
- name: Vite Github Pages Deployer
  uses: skywarth/vite-github-pages-deployer@v1.0.1
```

Don't forget to release environment regarding the deploy:
```
# Name could be whatever you wish. It'll be visible publicly under the environments tab.
environment:
  name: demo
  url: ${{ steps.deployment.outputs.page_url }}
```

## Demo

Wanna see it in action? Sure thing, head on to this vue project to see it live: https://github.com/skywarth/country-routing-algorithm-demo-vue


## Parameters

### `public_base_path` (optional)
`Type: string`

[Public base path](https://vitejs.dev/guide/build.html#public-base-path) string for Vite, this affects the routing, history and asset links. Make sure to provide appropriately since Github Pages stores your app in a directory under a subdomain. If you plan on deploying to alternative platform such as Vercel, you should simply provide `/`. 

Under normal circumstances, you don't need to provide/override this parameter, action will set it to your repo name appropriately.

### `build_path`(optional)
`Type: string`

Which folder do you want your Github Page to use as root directory, after the build process. Simply it is your build output directory such as `./dist`. If your `vite` config exports to a folder other than `./dist`, then you should pass it as parameter.

### `artifact_name` (optional)
`Type: string`

Desired name for the exposed artifact. This name is visible in job and used as the artifacts name.


### `debug_mode` (optional)
`Type: string`
`Possible values: 'true'|'false'`

Controls the debug mode, string, `'true'` is for on. When turned on, it'll output certain information on certain steps. Mainly used for development, but use it as you please to inspect your env and variables.

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
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Vite Github Pages Deployer
        uses: skywarth/vite-github-pages-deployer@master

```

