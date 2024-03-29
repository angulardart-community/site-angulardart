---
title: Versions
description: The versions that this documentation and its examples use.
---
{% assign pubPkgUrl = 'https://pub.dev/packages' -%}
This site's documentation and examples use the
[{{site.data.pkg-vers.SDK.vers}}]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/{{site.data.pkg-vers.SDK.vers}}){:.no-automatic-external}
release of the [Dart SDK]({{site.dartlang}}/tools/sdk){:.no-automatic-external},
with the **current** package versions listed in **bold** below.
Previous and next versions of packages are also shown when they exist.

Since migration to the newest version(s) is still in progress, some documentations or examples might still be in the previous version(s).

<style>#pkgs span.pad { padding-right: 0.2em }</style>
{:#pkgs}
{% for pkgDataPair in site.data.pkg-vers -%}
{%- assign name = pkgDataPair[0] -%}
{%- assign info = pkgDataPair[1] -%}
{%- if name != 'SDK' %}

{% comment %}
  We need the <div> below to wrap the entire dd content.
{% endcomment -%}
{{name}}
  : <div markdown="1">
  {%- if site.prev-url and info.prev-vers %}
  - <span class="pad">{{info.prev-vers}}</span>
    (<a href="{{pubPkgUrl}}/{{info.prev-name | default: name}}/versions/{{info.prev-vers}}#-changelog-tab-"
        class="no-automatic-external">package</a>
    {%- if info.no-angular-prefix and info.doc-path -%}
      ,&nbsp;<a href="{{site.prev-url}}/{{info.doc-path}}" class="no-automatic-external">docs</a>
    {%- else %}
      ,&nbsp;<a href="{{site.prev-url}}/angular/{{info.doc-path}}" class="no-automatic-external">docs</a>
    {%- endif -%}
    )
  {%- endif -%}
  {%- if info.vers %}
  - <span class="pad">**{{info.vers}}**</span>
    (<a href="{{pubPkgUrl}}/{{name}}/versions/{{info.vers}}#-changelog-tab-"
        class="no-automatic-external">package</a>
    {%- if info.doc-path -%}
      ,&nbsp;<a href="/{{info.doc-path}}">docs</a>
    {%- endif -%}
    )
  {%- endif -%}
  {%- if site.dev-url and info.next-vers %}
  - <span class="pad">{{info.next-vers}}</span>
    (<a href="{{pubPkgUrl}}/{{info.next-name | default: name}}/versions/{{info.next-vers}}#-changelog-tab-"
        class="no-automatic-external">package</a>
    {%- if info.doc-path -%}
      ,&nbsp;<a href="{{site.dev-url}}/{{info.doc-path}}" class="no-automatic-external">docs</a>
    {%- endif -%}
    )
  {%- endif -%}
  {%- comment %}
    Because of the way element-inlined markdown is processed, we can't explicitly close the div.
    But the markdown processor closes the div for us.
  {% endcomment -%}
{%- endif -%}
{%- endfor %}

## Angular alpha and beta releases are production quality

Google thoroughly tests each version of AngularDart—even alpha releases—to
ensure that our mission-critical apps that depend on Angular continue to
work well.

The _alpha_ label indicates that the API is changing,
and that the release (or a release after it) might break your code.

<aside class="alert alert-warning" markdown="1">
**[Let us know if you find
issues.](https://github.com/dart-lang/angular/issues/new)**
Google's [test and development
environment](https://testing.googleblog.com/2014/01/the-google-test-and-development_21.html)
is different from the usual Dart environment,
so sometimes we miss issues with configuration or testing.
</aside>

For more information, see the documentation for
the [pub version scheme.]({{site.dartlang}}/tools/pub/versioning)
