---
layout: post
title: "Set runtime variables for an Angular app in a Docker Container"
date: 2019-02-06 22:38:39 +0000
categories: [Docker, Angular]
tags: [docker, nginx, angular]
---

A guide for setting up runtime variables for an Angular App which is hosted in a Nginx Docker container (or any else).
What's special about this? It does not need another file to be loaded before bootstrapping the app, neither to be included via the docker run command.
It simply lets you set variables in you angular app via Environment variables passed to docker by `docker run -e TEST_ENV="This really works!" -it <image_name>`.

<!--more-->

> At the moment this is only tested with debian based docker images like `nginx`, `alpine` images **do not work** currently!

Other guides always want you to load a special file at the app startup. [[1]] [[2]] This does not only defer the startup time by one web request but also makes it harder to just fire up a docker container, as you will have to include the file by building your own image or mounting it at startup first.

Try it out right now by running: `docker run -e "TEST_ENV=This really works!" -it danielhabenicht/docker-angular-runtime-variables`

## How does it work

My solution is to create a script that substitutes the variables in some or all files (you can choose) with those given by the environment on container startup and then run the commands given to it.

### 1. Create the script

Those two scripts do just that. There are two variations as it depends on you if you need to manipulate one or multiple files. Go ahead and copy one of them to your project!

#### a) For one file only

<script src="http://gist-it.appspot.com/https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/substitute_env_variables.sh"></script>

#### b) For multiple files

<script src="http://gist-it.appspot.com/https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/substitute_env_variables_multi.sh"></script>

### 2. Prepare your angular app

1. Add the `<script>` Tag to your `index.html` as shown below.

   <script src="http://gist-it.appspot.com/https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/src/index.html"></script>

2. Create a `runtimeEnvironment.ts` file in your `src/environments` folder, copy the content.

   <script src="http://gist-it.appspot.com/https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/src/environments/runtimeEnvironment.ts"></script>

   > We do not use the `environment.ts` file as this does induce some errors with advanced angular apps (espescially if use in `.forRoot()` functions), for example:
   >
   > ```
   > Error during template compile of 'environment.ts'
   > Reference to a local (non-export) symbols are not supported in decorators but 'ENV' was referenced
   > ```

### 3. Stitch everything together in Docker

Copy the script you choosen earlier into the docker image and set the executable rights. Then define it as your entrypoint and do not forget to specify the path of the file you want to update with the environment variables.

<script src="http://gist-it.appspot.com/https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/Dockerfile"></script>

### 4. Use the Variables in you app

Include the `runtimeEnvironment` in your angular components, services, pipes etc.. For example:

<script src="http://gist-it.appspot.com/https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/src/app/app.component.ts"></script>

<script src="http://gist-it.appspot.com/https://github.com/DanielHabenicht/docker-angular-runtime-variables/blob/master/src/app/app.component.html"></script>

## Appendix 1 - Unit Tests with karma

If you are using the environment variables during your tests you have to mock them by configuring a globals.js and adding it to your test files:

1. Create globals.js

2. Link it in your karma.config.js

[1]: https://juristr.com/blog/2018/01/ng-app-runtime-config/
[2]: https://www.technouz.com/4746/how-to-use-run-time-environment-variables-in-angular/
