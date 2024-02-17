---
layout: post
title: "Use Windows Task Scheduler to Track when you are on the PC"
date: 2021-01-16 17:45:39 +0000
categories: [Automation]
tags: [windows, hassio]
---

Beginning with [Manim](https://github.com/ManimCommunity/manim/) and don't know what the angles are supposed to mean?

Skip below for a copy paste example with some useful default values.

```python
# These are the defalt values, applying them should do nothing.
self.move_camera(phi=0 * DEGREES, theta=-90 * DEGREES, gamma=0 * DEGREES)
self.wait()

# Simple Move around x axis (which means it will stay put)
self.move_camera(phi=-45 * DEGREES)
self.wait()
self.move_camera(phi=45 * DEGREES)
self.wait()
# To be able to differ Theta and gamma angle changes we do not reset phi

# Simple Move around z axis (which means it will stay put)
self.move_camera(theta=-45 * DEGREES)
self.wait()
self.move_camera(theta=-135 * DEGREES)
self.wait()
self.move_camera(theta=-90 * DEGREES)
self.wait()

# Simple Move around y axis (which means it will stay put)
self.move_camera(gamma=-45 * DEGREES)
self.wait()
self.move_camera(gamma=45 * DEGREES)
self.wait()
self.move_camera(gamma=0 * DEGREES)
self.wait()

# Get a 3D View on Coordinate system
self.move_camera(phi=-45 * DEGREES, theta=-135 * DEGREES, gamma=-45 * DEGREES)

# Get a 3D View on Coordinate system
self.move_camera(phi=-45 * DEGREES, theta=-45 * DEGREES, gamma=45 * DEGREES)
```
