---
projects: ["leanCNC"]
title: Overview
subtitle: A stripped-down 4x8ft CNC build
date: 2017-06-22
tags: ["grbl","fabrication"]
categories: ["cnc"]
weight: 10
---

{{< img src="/img/leancnc-logo.png" caption="" >}}

Ever since recently working at a maker space startup, I wanted to design and build a CNC machine. During my 
tenure at tekSPACY I had the opportunity to build a 1000x1000mm X-Carve kit. I may easily recommend the range 
of [Inventables](https://www.inventables.com/) DIY kits for those just starting with CNC.

<!--more-->

The X-Carve is a high quality kit and very well documented and supported, but I wanted a machine that would
more appropriate for my needs, namely:

- Be able to cut a full 1220x2440mm (4'x8') sheet of Supawood (MDF) or plywood
- Also cut soft-ish sheet metal, such as aluminium or brass
- Beafier motors and spindle, and hence upgraded electronics
- WiFi connectivity
- Be able to produce flat-pack furniture, like the designs of [Opendesk.cc](https://www.opendesk.cc/)

## Goals

I also decided that I want to contribute back to the open source/hardware community that has made so much
of my professional life possible. Therefore the stated secondary goals for this project are:

- Document and publish the design & build process
- Use and promote open source software, based on either Grbl or Smoothieware
- Make use of locally available materials (where possible)
- Stick to a budget of about ZAR50 000, that is about USD3,850

## Design

- Base & leveling
- Linear motion
- Electronics
- Software

## Build

The build shall be conducted as follows:

1. [The base]({{< ref "project/leanCNC/leanCNC-base.md" >}})
2. Y-axis
3. X-axis
4. Spindle
5. Controller & power supply
6. Base board & levelling

## References

I drew inspiration from the work of the following people:

### Frank Howarth
Frank's series of informative and entertaining CNC build videos on his 
[Frank Makes](https://www.youtube.com/playlist?list=PLZqh4Qx3PPHka0hxFPcKI475XsxOgrkJb)
Youtube channel is a must see for all CNC enthusiasts.


