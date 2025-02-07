# Vite GitHub Pages Deployer

<!-- ![GitHub all releases](https://img.shields.io/github/downloads/skywarth/vite-github-pages-deployer/total?style=for-the-badge) -->

Deploy your [Vite](https://vitejs.dev/guide/) application to Github Pages, at a glance. 
- No shenanigans such as committing the dist folder and pushing to a branch. 
- Clean deploy to GitHub Pages by utilizing actions and artifacts.
- Customizable with optional build path
- Can be used with any frontend framework as long as you use `vite` as your `build` tool. Vue, React, Svelte... You name it!

```
- name: Vite Github Pages Deployer
  uses: skywarth/vite-github-pages-deployer@v1.4.0
```


## Table of Contents

1. [Usage](#usage)
2. [Example Workflow](#example-workflow)
3. [Demo](#demo)
4. [Input Parameters](#input-parameters)
5. [Outputs](#outputs)
6. [Common errors and mistakes](#common-errors)
7. [TODOs](#todos)


<a name="usage"></a>
## 1. Usage :checkered_flag:

You can use this action simply by adding it to your action's `yaml` files appropriately. 

### 1.1 Add the usage step :triangular_flag_on_post:

Make sure to place this step after your 'checkout' step.

```yaml
- name: Vite Github Pages Deployer
  uses: skywarth/vite-github-pages-deployer@v1.4.0
  id: deploy_to_pages
```

### 1.2 Release environment :outbox_tray:

You have to place the environment section right before the `steps`. This enables the release of environment, under the environments tab. 

```yaml
environment:
  name: demo
  url: ${{ steps.deploy_to_pages.outputs.github_pages_url }}
```

### 1.3 Set the permissions for the action  :shipit:

You need to set the proper permission for the action, in order to successfully release environment and artifact. If you don't you may receive permission errors.

Permission declaration can be placed anywhere before `jobs:` section.

```yaml
# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write
```

### 1.4 Enjoy! :tada:


<a name="example-workflow"></a>
## 2. Example workflow :rocket:

If you don't know what to do, what actions are, or where to place the code pieces in the [usage](#usage) section, then follow these steps:

1. Create an action file at this path: `./.github/workflows/vite-github-pages-deploy.yml`. So in essence create a `.github` folder at your project root, and create a `yml` file in there.
2. Copy the code below and paste it into the action you've just created, then save.
3. Done. On your next push to `master` branch, or your next manual run from actions tab, this action will run and your project will be deployed to github pages.


```yaml
name: Vite Github Pages Deploy

on:
  # Runs on pushes targeting the default branch
  push:
    branches: ["master", "main"]
  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write

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


<a name="demo"></a>
## 3. Demo :moyai:

Want to see it in action? Sure thing, head on to this vue project to see it live: https://github.com/skywarth/country-routing-algorithm-demo-vue


<a name="input-parameters"></a>
## 4. Input Parameters :wrench:

### `public_base_path` (optional)
| Type     | Default                                      | Example Values     |
|----------|----------------------------------------------|--------------------|
| `string` | `/{your-repo-name}` OR `/` if you have CNAME | `/my-vite-project` |


[Public base path](https://vitejs.dev/guide/build.html#public-base-path) string for Vite, this affects the routing, history and asset links. Make sure to provide appropriately since GitHub Pages stores your app in a directory under a subdomain. If you plan on deploying to alternative platform such as Vercel, you should simply provide `/`.

Under normal circumstances, you don't need to provide/override this parameter, action will set it to your repo name appropriately.

#### Here's how `public_base_path` is resolved:

- If `public_base_path` parameter/input is provided, it will be used regardless.
- If `public_base_path` parameter/input is **NOT** provided:
  - If the repository root has `CNAME` file for GitHub Pages Custom Domain setup, then `public_base_path` default value will resolve to `/`
  - If the repository root does **NOT** have `CNAME`, `public_base_path` default value will resolve to `/{your-repo-name}`

<a name="public-base-path-ack"></a>
#### Acknowledgement 

See the suggestion for the CNAME expansion [here](https://github.com/skywarth/vite-github-pages-deployer/issues/5)

Grateful to the [Greg Sadetsky](https://github.com/gregsadetsky) for his proposition on alternating default value of this input. Also, thankful for his collaboration on explaining GitHub pages custom domain setting and testing phase of these changes.

<br>


### `build_path`(optional)
| Type     | Default  | Example Values                       |
|----------|----------|--------------------------------------|
| `string` | `./dist` | - `./deploy`<br/> - `./dist/browser` |

Which folder do you want your GitHub Page to use as root directory, after the build process. Simply it is your build output directory such as `./dist`. If your `vite` config exports to a folder other than `./dist`, then you should pass it as parameter.


### `install_phase_node_env`(optional)
| Type     | Default | Example Values                                                                             |
|----------|---------|--------------------------------------------------------------------------------------------|
| `string` | `dev`   | - `dev` <br/> - `production` <br/> - `staging` <br/> - `test` <br/> - `my-little-pony-env` |


Node environment that will be used for the installation of dependencies. **It is imperative you use an environment that has 'vite' as dependency**. Commonly and naturally, that env is `dev`.

:x: If you don't provide a NODE_ENV that has `vite` as dependency (check your package.json), you'll receive `sh: 1: vite: not found` during build phase.

### `build_phase_node_env` (optional)
| Type     | Default      | Example Values                                                                             |
|----------|--------------|--------------------------------------------------------------------------------------------|
| `string` | `production` | - `dev` <br/> - `production` <br/> - `staging` <br/> - `test` <br/> - `my-little-pony-env` |



Node environment that will be used for the build phase. You may provide any valid NODE_ENV value for this, since node builds tend to change for different environments (e.g: you hide debugging features from production).



### `artifact_name` (optional)
| Type     | Default        | Example Values                                        |
|----------|----------------|-------------------------------------------------------|
| `string` | `github-pages` | - `what-a-cool-artifact` <br/> - `ah-yes-ze-artifact` |

Desired name for the exposed artifact. This name is visible in job and used as the artifacts name.


### `package_manager` (optional)
| Type     | Default | Example Values         |
|----------|---------|------------------------|
| `string` | `npm`   | - `npm` <br/> - `yarn` |

Indicate the package manager of preferrence. It'll be used for installing dependencies and building the `dist`. For example if you prefer/use `yarn` as your package manager for the project, then you may pass `package_manager: 'yarn'` as input which then will be used as `yarn install` and `yarn build`.


### `working_path` (optional)
| Type     | Default   | Example Values               |
|----------|-----------|------------------------------|
| `string` | `./`      | - './app' <br/> `./example` |


Specifies the directory where the install, build, and deploy commands should be executed.

**Example:**

If your project structure looks like this:

```text
app/
  package.json
  ...
README.md
```

You can set the `working_path` to `./app` to ensure the commands run in the correct directory:

```yaml
with:
  working_path: ./app
```


### `debug_mode` (optional)
| Type     | Default   | Example Values               |
|----------|-----------|------------------------------|
| `string` | `'false'` | - `'true'` <br/> - `'false'` |


Controls the debug mode, string, `'true'` is for on. When turned on, it'll output certain information on certain steps. Mainly used for development, but use it as you please to inspect your env and variables.


<a name="outputs"></a>
## 5. Outputs :pushpin:


### `github_pages_url`
| Type     | Example Values                                                       |
|----------|----------------------------------------------------------------------|
| `string` | - `'https://skywarth.github.io/country-routing-algorithm-demo-vue/'` |


This output value shall be used to acquire the github pages url following the deployment. It can be accessed like so: `${{ steps.deploy_to_pages.outputs.github_pages_url }}` (deploy_to_pages is the id of the step that you run Vite Github Pages Deployer).

It is expected to be used as a way to publish environment during the job, like so:
```
environment:
      name: demo
      url: ${{ steps.deploy_to_pages.outputs.github_pages_url }}
```

See [example workflow](#example-workflow) to grasp how to utilize this output




<a name="common-errors"></a>
## 6. Common errors and mistakes :sos: :name_badge:

### 6.1 Not releasing the environment

**Error:** `Environment URL '' is not a valid http(s) URL, so it will not be shown as a link in the workflow graph.`

**Cause:** Environment declaration is missing from the action, you should add it to your action `yaml` file in order to both solve the error/warning and to display the released environment in the `environments` tab in the repository.

**Solution:** Add the following to your action:
```yaml
environment:
  # Name could be whatever you wish. It'll be visible publicly under the environments tab.
  name: demo
  url: ${{ steps.deploy_to_pages.outputs.github_pages_url }}
```

:warning: Remember, `deploy_to_pages` name should be identical to the `id` of the step that you run the `Vite GitHub pages deployer`. See the [example workflow](#example-workflow) for details. 


### 6.2 Missing permission requirements for `GITHUB_TOKEN`

**Error:** `Error: Ensure GITHUB_TOKEN has permission "id-token: write".`

**Cause:** Permission wasn't set as indicated in the [usage](#usage) section. If proper permissions are not granted to the action, it won't be able to create artifacts or create environments.

**Solution:** Add the following code about permissions to your action `yaml` file.

```
# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write
```

See the [example workflow](#example-workflow) if you're not sure where to place it.


### 6.3 `package-lock.json` is not present when using `npm` as package manager preferrence.

**Error:** `The `npm ci` command can only install with an existing package-lock.json...`

**Cause:** If `package_manager` input preference is set to `npm` (or default, unassigned), it will install dependencies using `npm ci` which utilizes `package-lock.json`. In this case make sure `package-lock.json` is present in your project root.

**Solution:** Add your `package-lock.json` file to your project. If it's in the directory but doesn't appear in the repository, check your gitignore file and remove it from gitignore. Alternatively, you may set `yarn` as your preferred package manager for dependency installation via `package_manager` parameter input of the action.


<a name="todos"></a>
## 7. TODOs

- [X] ~~Output the deploy url for environment, see issue #2~~
- [X] ~~Spread the gospel.~~
  - [X] ~~[DEV.to post](https://dev.to/skywarth/deploying-your-vite-apps-to-github-pages-is-a-breeze-with-vite-github-pages-deployer-30c3)~~
  - [X] ~~Reddit (opensource, github, github action, ci/cd, vite, vue, react forums etc.).Blah, reddit was like, you know... Reddit.~~
  - [X] ~~Maybe a [medium.com post](https://medium.com/@yigitk.ersoy/introducing-vite-github-pages-deployer-a-better-way-to-showcase-your-vite-projects-fadbb93f3db9)... God I hate that place, it stinks.~~
- [X] ~~NODE_ENV options/params~~
  - [X] ~~Install phase NODE_ENV~~
  - [X] ~~Build phase NODE_ENV~~
- [X] ~~Section for common errors and solutions. (Dismantle tidbits)~~
- [X] ~~Make README more eye-candy~~
  - [X] ~~Table for each input/param (type, default etc.)~~
  - [X] ~~Icons for emphasis~~
- [X] ~~Option for defining package manager preference, see issue #1~~
- [X] Table of Content
- [ ] ~~Move bash scripts to a separate file for each section: build.sh, install.sh etc...~~ (not feasible, see the branch `bash-files`)
  - [ ] ~~Passing some parameters to it perhaps~~ (not feasible, see the branch `bash-files`)

### Something is lacking ?

Is there something you require, does this action fail to meet your expectations or it lacks certain futures that prevent you from using it ? Open up an issue, and we add it to the roadmap/TODOs. Contributions are welcome.


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





