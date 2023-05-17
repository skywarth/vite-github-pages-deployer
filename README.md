# Vite Github Pages Deploy

## Parameters

### `public_base_path`
`Type: string`

Public base path string for vite/vue, this affects the routing, history and asset links. Make sure to provide appropriately since Github Pages stores your app in a directory under a subdomain. If you plan on deploying to alternative platform such as Vercel, you should simply provide `/`. 

Under normal circumstances, you don't need to provide/override this parameter, action will set it to your repo name appropriately.

### `build_path`
`Type: string`

Which folder do you want your Github Page to use as root directory, after the build process. Simply it is your build output directory such as `./dist`. If your `vite` config exports to a folder other than `./dist`, then you should pass it as parameter.

### `deploy_environment_name`
`Type: string`

Desired name for the Deployment environment. This name will be visible in environment tab. Set it to something cool if you want to.


### `debug_mode`
`Type: boolean`

Controls the debug mode, boolean, true is for on. When turned on, it'll output certain information on certain steps. Mainly used for development, but use it as you please to inspect your env and variables.
