---
title: "Set runtime variables for an Angular app in a Docker Container"
date: 2019-02-06T22:38:39
categories: [Docker, Angular]
tags: [docker, nginx, angular]
slug: angular-nginx-runtime-variables
authors:
  - DanielHabenicht
---

A guide for setting up runtime variables for an Angular App which is hosted in a Nginx Docker container (or any else).
What's special about this? It does not need another file to be loaded before bootstrapping the app, neither to be included via the docker run command.
It simply lets you set variables in your angular app via Environment variables passed to docker by `docker run --rm -e "TEST_ENV=This really works!" -it <image_name>`.

<!-- more -->

> At the moment this is only tested with debian based docker images like `nginx`, `alpine` images **do not work** currently!

Other guides always want you to load a special file at the app startup.[^1] [^2] This does not only defer the startup time by one web request but also makes it harder to just fire up a docker container, as you will have to include the file somehow, by building your own image or mounting it at startup.

Try it out right now by running: `docker run --rm -p 8080:80 -e "TEST_ENV=This really works!" -it danielhabenicht/docker-angular-runtime-variables`. Change the variable to your liking and navigate to [https://localhost:8080](https://localhost:8080).

## How does it work?

Basically this solution uses a script that substitutes the variables in some or all files (you can choose) with those given by the environment at container startup and then run the commands given to it.

### 1. Create the script

Those two scripts do just that. There are two variations as it depends on your needs to manipulate one or multiple files. A combination of both may also work for use cases where some variables are mandatory and other aren't. Go ahead and copy one of them to your project for now!

#### a) For one file only

This script utilizes the `envsubst` command to replace the variables given. _Throws no error_ if the variable is undefined.

```sh title="<a href='https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/substitute_env_variables.sh'>substitute_env_variables.sh</a>"
--8<-- "https://raw.githubusercontent.com/DanielHabenicht/docker-angular-runtime-variables/master/substitute_env_variables.sh"
```

#### b) For multiple files

Uses some custom `grep`/`sed` logic to replace the variables given. _Throws an error_ if a variable is undefined.

```sh title="<a href='https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/substitute_env_variables_multi.sh'>substitute_env_variables_multi.sh</a>"
--8<-- "https://raw.githubusercontent.com/DanielHabenicht/docker-angular-runtime-variables/master/substitute_env_variables_multi.sh"
```

### 2. Prepare your angular app

This is kind of hacky but also the most straight forward way:

1. Add the `<script>` Tag to your `index.html` as shown below.

   <script src="https://gist-it.appspot.com/https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/src/index.html"></script>

   ```html title="<a href='https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/src/index.html'>index.html</a>"
   --8<--
   "https://raw.githubusercontent.com/DanielHabenicht/docker-angular-runtime-variables/master/src/index.html"
   ```

2. Create a `runtimeEnvironment.ts` file in your `src/environments` folder and paste the content.

   ```typescript title="<a href='https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/src/environments/runtimeEnvironment.ts'>runtimeEnvironment.ts</a>"
   --8<-- "https://raw.githubusercontent.com/DanielHabenicht/docker-angular-runtime-variables/master/src/environments/runtimeEnvironment.ts"
   ```

!!! info

    We do not use the `environment.ts` file as this does induce some errors with advanced angular apps (especially if use in `.forRoot()` functions), for example:

    ```
    Error during template compile of 'environment.ts'
    Reference to a local (non-export) symbols are not supported in decorators but 'ENV' was referenced
    ```

### 3. Stitch everything together in Docker

While building your docker image you have to copy the script you choose earlier and set the executable rights. Then define it as your entry point and do not forget to specify the path of the file you want to update with the environment variables.

!!! warning

    The Bash script should have `LF` line endings, otherwise Docker will fail with `exec user process caused "no such file or directory"`
    If you you are not sure if you have LF ending in your git repository, check out this guide: [https://stackoverflow.com/a/33424884/9277073](https://stackoverflow.com/a/33424884/9277073)

```dockerfile title="<a href='https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/Dockerfile'>Dockerfile</a>"
--8<-- "https://raw.githubusercontent.com/DanielHabenicht/docker-angular-runtime-variables/master/Dockerfile"
```

### 4. Use the Variables in you app

Include the `runtimeEnvironment` in your angular components, services, pipes etc.. For example:

```typescript title="<a href='https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/src/app/app.component.ts'>src/app/app.component.ts</a>"
--8<-- "https://raw.githubusercontent.com/DanielHabenicht/docker-angular-runtime-variables/master/src/app/app.component.ts"
```

```html title="<a href='https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/src/app/app.component.html'>src/app/app.component.html</a>"
--8<--
"https://raw.githubusercontent.com/DanielHabenicht/docker-angular-runtime-variables/master/src/app/app.component.html"
```

Thanks for reading. Hope you enjoyed it. ;)

## Appendix - Unit Tests with karma

> From [https://stackoverflow.com/a/19263750/9277073](https://stackoverflow.com/a/19263750/9277073)

If you are using the environment variables during your tests you have to mock them by configuring a globals.js and adding it to your test files:

1. Create a globals.js with your `ENV` variable.

   ```js title="<a href='https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/src/globals.js'>src/globals.js</a>"
   --8<-- "https://raw.githubusercontent.com/DanielHabenicht/docker-angular-runtime-variables/master/src/globals.js"
   ```

2. Link the `globals.js` in your karma.config.js, by specifying `files: ["globals.js]`

   ```js title="<a href='https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/src/karma.conf.js'>src/karma.conf.js</a>"
   --8<-- "https://raw.githubusercontent.com/DanielHabenicht/docker-angular-runtime-variables/master/src/karma.conf.js"
   ```

[^1]: https://juristr.com/blog/2018/01/ng-app-runtime-config/
[^2]: https://www.technouz.com/4746/how-to-use-run-time-environment-variables-in-angular/
