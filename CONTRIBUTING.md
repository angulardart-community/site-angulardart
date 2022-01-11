# Contributing :blue_heart:

Thanks for thinking about helping with AngularDart!
Here are a couple of ways that you can contribute:

* [Migrate](MIGRATION.md) the docs to the latest version! [MAIN FOCUS]
* Documentation of the documentation improvement
  * This refers to every documentation in **this** repo, like this one you're reading right now.
  * Please don't hesitate to [report](https://github.com/angulardart-community/site-angulardart/issues/new) any ambiguity or confusion that you might have! :)
* [Report issues](https://github.com/angulardart-community/site-angulardart/issues/new).
* Fix issues (especially ones with the label
  **[help wanted](https://github.com/angulardart-community/site-angulardart/issues?utf8=%E2%9C%93&q=is%3Aopen%20is%3Aissue%20label%3A%22help%20wanted%22%20)**).
  * Right now, it's recommended to first solve every open issue from the [original repo](https://github.com/dart-lang/site-angulardart/issues) one by one. When you want to work on one, create a new issue at this repo with the same title and description, and add "From dart-lang/site-angulardart#(issue number)" to the end with some additional comments, if any. For example, "From dart-lang/site-angulardart#169"
  * (Despite everything said above, new issues/suggestions are definitely welcome and please don't hesitate to subit them!)
  * If this is your first contribution—_welcome!_—check out issues that are 
  labeled **[beginner](https://github.com/angulardart-community/site-angulardart/issues?utf8=%E2%9C%93&q=is%3Aissue%20is%3Aopen%20label%3A%22help%20wanted%22%20label%3Abeginner%20)**.
  Beginner issues may or may not be easy to fix.
  Sometimes they're issues we don't have the expertise to fix ourselves,
  and we'd love to work with a contributor who has the right skills.
  * We use the usual [GitHub pull
    request](https://help.github.com/articles/about-pull-requests/) process.
  * We recommend following the [Google Developer Documentation Style
    Guide](https://developers.google.com/style/), though you don't have to.
* Submitting a pull request
  * Every pull request **must** has a corresponding issue! If yours does not, create one and say something like "I'm working on it" at the end so that other people someone is tackling it. If you don't know how to reference an issue in your pull request message, see the [Github docs](https://docs.github.com/en/github/writing-on-github/working-with-advanced-formatting/autolinked-references-and-urls#issues-and-pull-requests).
* Automating workflows
  * We're gradually migrating the workflow utility from `gulpjs` to Dart's `grinder`. It's recommended to understand JS for this situation. The files are in the [tool](tool/grind.dart). Due to the nature of this project, it's better for a single person ([I](@GZGavinZhao)) to work on it rather than multiple people contributing together, since different people can write drastically different code where only the person who wrote it can understand. If you really want to, please **COMMENT YOUR CODE**. However, feel free to shout out if you see some flaws or mistakes.
* New articles
  * Create an issue and briefly talk about what you would like to write or what article you would like to include, and why.

To avoid wasting your time, talk with us before you make any nontrivial
pull request. The [issue tracker](https://github.com/angulardart-community/site-angulardart/issues)
is a good way to track your progress publicly, but we can also communicate
other ways such as [Gitter](https://gitter.im/angulardart/community).

<!-- Put link to dart-lang/site-www and other receptive repos here?-->

## Resources

### Markdown, Jekyll, Liquid

It's recommended to have some basic Markdown knowledge. [Jekyll](https://jekyllrb.com) and [Liquid](https://shopify.github.io/liquid/) are not required but really useful.

### Updating docs & articles

These are located in the [src](src) folder. The directory structure is based on the table of contents you see on the left side of the website. If you get confused, just talk to us what article and which part you want to change, and we can help you with that. :)

### Updating examples

The examples are mostly located in the folder [examples/ng](examples/ng). If you're updating one, please actually run the example to make sure that nothing breaks!

## Others

For more information on contributing to Dart, see the
[dart-lang/sdk Contributing page](https://github.com/dart-lang/sdk/wiki/Contributing).

[angulardart-community]: https://angulardart.dev
