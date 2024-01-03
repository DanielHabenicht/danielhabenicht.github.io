---
layout: post
title: "How to sign Android App Bundles in Azure Pipelines"
date: 2020-01-23T20:53:17
categories: [Android]
tags: [android, azure-pipelines]
slug: sign-android-app-bundles-azure-pipelines
---

The Standard Azure Pipelines [Android signing task][1] signs only `*.apk` files. But that`s not what google wants you to upload. 

<!--more-->

But there is a simple workaround based on this [Stackoverflow][2]:

```yaml
- task: AndroidSigning@2
  inputs:
    apkFiles: '**/*.aab'
    jarsign: true
    jarsignerKeystoreFile: 'yourkeystore.jks'
    jarsignerKeystorePassword: '$(yourSecretKeystorePassword)'
    jarsignerKeystoreAlias: 'yourkeystore.alias'
    jarsignerKeyPassword: '$(yourSecretKeyPassword)'
    # The two Arguments working there magic:
    jarsignerArguments: '-sigalg SHA256withRSA -digestalg SHA-256'
    zipalign: true
```
Simply add the right signing algorithm as options.

> You are wondering why it does not accept your Keystore file? It has to be a [secure file][3] (just upload it to `Pipelines > Library > Secure Files` and reference its name).


[1]: https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/build/android-signing?view=azure-devops
[2]: https://stackoverflow.com/a/54376038/9277073
[3]: https://docs.microsoft.com/en-us/azure/devops/pipelines/library/secure-files?view=azure-devops
