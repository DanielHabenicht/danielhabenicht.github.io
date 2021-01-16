---
layout: post
title: "Use Windows Task Scheduler to Track when you are on the PC"
date: 2021-01-16 17:45:39 +0000
categories: [Automation]
tags: [windows, hassio]
---

You need 4 Task Scheduler Events: 
- On Workstation lock of any user
- On workstation unlock of <User>
- On event - Log: System, Source: Winlogon, Event ID: 7002
- At log on of <User>

Execute Script
