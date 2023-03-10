# AngularDart Community Website/Documentation

[![AngularDart Chat](https://img.shields.io/gitter/room/angulardart/community?color=blue&label=angulardart%2Fcommunity&logo=matrix)](https://gitter.im/angulardart/community)
[![Jekyll CI](https://img.shields.io/github/workflow/status/angulardart-community/site-angulardart/Jekyll%20CI)](https://github.com/angulardart-community/site-angulardart/actions/workflows/ci.yml)
![Firebase Hosting](https://img.shields.io/github/workflow/status/angulardart-community/site-angulardart/Publish%20Website?label=release)

> The official [repo](https://github.com/angulardart/angular) has been archived and doesn't allow any changes, hence I created this fork so that we, the AngularDart community, can work on improvements by ourselves (and perhaps have our own documentation site?).
> 
> Feel free to create & submit **ANY** issues and pull requests! Nothing is too small to fix, even just a typo :)

> A more modern and up-to-date [new website](https://github.com/angulardart-community/website) is on its way!

The [AngularDart](https://angulardart-community.web.app) **community-maintained** documentation site, built with [Jekyll][] and hosted on [Firebase Hosting][Firebase].

[We welcome contributions](CONTRIBUTING.md), and we're [first-timer
friendly](http://www.firsttimersonly.com)!

Our main focus now is to keep the version of the website up-to-date with the latest version of AngularDart, but as stated above, feel free to submit anything. See the [migration guide](MIGRATION.md) for more info!

For simple changes (such as to CSS and text), you probably don't need to build this site. Often you can make changes using the GitHub UI.

If your change involves code samples, adds/removes pages, or affects navigation, you'll need to build and test your work before submitting. If you want or need to build the site, follow the steps below.

## Before you build this site

~~Windows users might find themselves having trouble building this site because they can't run `.sh` files. We're currently migrating the workflows from using [`gulpjs`]() to Dart's [`grinder`](https://pub.dev/packages/grinder), which will do everything in Dart and resolve this problem. Sorry Windows users! (and how about considering using linux in the meantime?)~~ We have migrated (most) workflows to Dart and Docker, so Windows users should be able to build the site now. But seriously, considering switching to Linux?

Also, if you do a full-site build, it takes up about 2~3GB of space. Hard Drive Lives Matter!

### 1. Get the prerequisites

Install the following tools if you don't have them already.

- **Docker**. We use Docker for local development and building the site. 
  Install it from https://docs.docker.com/get-docker/.
- **GNU Make**. On Windows the easiest way to install Make is `choco install make`
  using command prompt or powershell as an admin. 
  Other options include using a [subsystem][wsl].


### 2. Clone this repo _and_ its submodule

> NOTE: This repo has a git _submodule_, which affects how you clone it.

To **clone this repo** ([site-angulardart][]), follow the instructions given in the
GitHub help on [Cloning a repository][], and _choose one_ of the following
submodule-cloning techniques:

- Clone this repo and its submodule _at the same_, use the
  `--recurse-submodules` option:<br>
  `git clone --recurse-submodules https://github.com/angulardart-community/site-angulardart.git`
- If you've already cloned this repo without its submodule, then run
  this command from the repo root:<br>
  `git submodule update --init --remote`

> IMPORTANT:
> Whenever you update your repo, update the submodule as well:<br>
> `git pull; git submodule update --init --remote`

#### Some common problems that might occur during this process (Linux/Mac only; for Windows please open an issue):

1. `dart pub get` getting stuck for hours, usually on `dart_style`.
   
   Solution: before running all the steps above, run the following in the project root:
   ```
   pub global activate webdev
   pub global activate dartdoc
   pub get
   ```

## Building this site

1. (Optional) Build the container image from scratch. If you don't have the hard drive space to do so or you just want to quickly see how it looks, you can skip this step and use the image we provide on GitHub. However, if you're changing dependencies, you must run this step to update the dependencies in the image.
   ```bash
   make setup
   ```
2. Serve the site locally (via `docker compose`).
   ```bash
   make up
   ```
3. View your changes in the browser by navigating to `http://localhost:5000`.
   > **Note:** Unless you're editing files under `site-shared`, 
   > you can safely ignore `ERROR: directory is already being watched` messages. 
   > For details, see [#1363](https://github.com/flutter/website/issues/1363).
4. Make your changes to the local repo. 

   The site will rebuild and the browser will autoreload to reflect the changes. 

   > **Tip:** If you aren't seeing the changes you expect (e.g. src/_data), 
   > `ctrl-C` out of your running dev server and rebuild the site from scratch 
   > using the following commands:
   > ```bash
   > $ make down && make clean && make up
   > ```
5. When you've finished developing, shut down the Docker container:
   ```bash
   $ make down
   ```

For more advance usage, see below

> NOTE: Getting `jekyll | Error:  Too many open files` under MacOS or Linux?
>   One way to resolve this is to add the following to your `.bashrc`:
>
>      ulimit -n 8192
>
>   and then reboot your machine.

## Other useful `grinder` tasks

To see the full list of workflow commands available, run `grind --help`. Below are a few handy ones that you'll likely use to make your life easier. (More coming soon!)
```bash
grind clean # Clean build artifacts
```

[Chrome]: https://www.google.ca/chrome
[Cloning a repository]: https://help.github.com/articles/cloning-a-repository
[Dart]: https://www.dartlang.org/install
[Dart install]: https://www.dartlang.org/install
[Firebase]: https://firebase.google.com/products/hosting/
[first-timers-only SVG]: https://img.shields.io/badge/first--timers--only-friendly-blue.svg?style=flat-square
[first-timers-only]: http://www.firsttimersonly.com/
[Jekyll]: https://jekyllrb.com/
[nvm]: https://github.com/creationix/nvm#installation
[rvm]: https://rvm.io/rvm/install#installation
[Ruby]: https://www.ruby-lang.org/en/documentation/installation/
[site-angulardart]: https://github.com/dart-lang/site-angulardart
[site-www]: https://github.com/dart-lang/site-www
[angulardart.dev]: https://angulardart.dev
