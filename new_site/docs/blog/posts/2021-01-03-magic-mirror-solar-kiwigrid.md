---
layout: post
title: "Display your Solar installation number on MagicMirror"
date: 2021-01-03T17:53:17
categories: [RaspberryPi]
tags: [magicmirror]
slug: magic-mirror-solar-kiwigrid
authors:
  - DanielHabenicht
---

Display your local solar system numbers (SolarWatt/KiwiGrid), like power drawn from the mains or your solar array, on your magicmirror. 

<!--more-->

> This guide assumes that you already installed your MagicMirror, if not set it up with this [guide](https://docs.magicmirror.builders/getting-started/installation.html).

The finished Interface will look something like this, but lets get started!





First query your local network for your KiwiGrid Instance, you can probe it via a link like `http://192.***.***.***/rest/kiwigrid/wizard/devices`. It should answer with all properties it has.
(You can also reach it via the SolarWatt WebPortal, follow [this guide]())

Second install the module [`MMM-json`](https://github.com/DanielHabenicht/MMM-json).

```bash
#  Clone the repository into MagicMirror/modules directory and install the dependencies
cd ./modules
git clone https://github.com/DanielHabenicht/MMM-json.git
npm install
```


Copy and edit the config for the module, to display the values you like. 
You can find some documentation of the response [here](https://www.loxwiki.eu/display/LOX/Solarwatt+MyReserve)
```jsonc
{
	module: 'MMM-json',
	position: 'bottom_left',
	config: {
		url: "https://jsonplaceholder.typicode.com/users",
		header: "Solar",
		headerIcon: "fa-sun",
		values: [
			{
				title: "Ladezustand",
				query:  "$..items[?(@.guid=='urn:solarwatt:myreserve:bc:a42c134g32769')].tagValues.StateOfCharge.value",
				suffix: "%"
			},
			{
				title: "Aus dem Netz",
				query: "$..items[?(@.guid=='3217ae6c-06b5-45ee-9879-9c5cf5117372')].tagValues.PowerConsumedFromGrid.value",
				suffix: "kWh",
				numberDevisor: 1000
			},
			{
					title: "Solarstrom",
					query: "$..items[?(@.guid=='f2a0f25d-4b23-4097-a6dd-f77b2eaf91ee')].tagValues.PowerProduced.value",
					suffix: "kWh",
					numberDevisor: 1000
			}
		]
	}
 },
```

More interesing Links: 
https://forum.iobroker.net/topic/14065/adapter-energymanager-eon-aura-bzw-solarwatt/46
