---
title: Documentation Overview
description: How to read and use this documentation
sideNavGroup: basic
prevpage:
  title: About AngularDart
  url: /
nextpage:
  title: Setup for Development
  url: /guide/setup
---
This page describes the Angular documentation at a high level.
If you're new to Angular, you may want to visit [Learning Angular](/guide/learning-angular) first.

## Themes

The documentation is divided into major thematic sections, each
a collection of pages devoted to that theme.

<style>tr { vertical-align:top; }</style>

<table width="100%">
<col width="15%">
<col>
<tr>
  <td><b>Guide</b></td>
  <td markdown="1">
  Learn the Angular basics (you're already here!) like the
  [setup](guide/setup) for local development,
  [displaying data](guide/displaying-data) and
  accepting [user input](guide/user-input),
  building simple [forms](guide/forms),
  [injecting app services](guide/dependency-injection) into components,
  and using Angular's [template syntax](guide/template-syntax).
  </td>
</tr>
<tr>
  <td><b><a href="./tutorial">Tutorial</a></b></td>
  <td markdown="1">
  A step-by-step, immersive approach to learning Angular that
  introduces the major features of Angular in an app context.
  </td>
</tr>
<tr>
  <td><b><a href="./guide/attribute-directives">Advanced</a></b></td>
  <td markdown="1">
  In-depth analysis of Angular features and development practices.
  </td>
</tr>
<tr>
  <td><b><a href="{{site.api}}">API Reference</a></b></td>
  <td markdown="1">
  Choose **All** from the **PACKAGES** dropdown to see APIs defined by the
  Angular libraries and commonly used dart:* libraries.
  </td>
</tr>
</table>

A few early pages are written as tutorials and are clearly marked as such.
The rest of the pages highlight key points in code rather than explain each step necessary to build the sample.
You can always get the full source through the [sample repos]({{site.ghNgEx}})
{%- if site.branch != 'master' %}
(`{{site.branch}}` branch)
{%- endif %}.

## Code samples

Each page includes code snippets from a sample app that accompanies the page.
You can reuse these snippets in your apps.

Look for a link to a running version of that sample, often near the top of the page,
such as this {% example_ref architecture %} from the [Architecture](guide/architecture) page.

## Reference pages

* The [Glossary](/glossary) defines terms that Angular developers should know.
* The [Cheat Sheet](/cheatsheet) lists Angular syntax for common scenarios.
* The [API Reference]({{site.api}}) is the authority on every public-facing
  member of the Angular libraries.

## Feedback

Please tell us about any issues you find:

* For **documentation and example** issues, use the
  [site-angulardart issue
  tracker]({{site.repo.this}}/issues).
* To report issues with **AngularDart** itself, use the
  [Angular issue tracker](https://github.com/angulardart-community/angular/issues).
