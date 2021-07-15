# AngularDart Community Website/Documentation

![Firebase Hosting](https://github.com/angulardart-community/site-angulardart/actions/workflows/firebase-hosting-merge.yml/badge.svg?branch=ready-for-publish)

> The official [repo](https://github.com/angulardart/angular) has been archived and doesn't allow any changes, hence I created this fork so that we, the AngularDart community, can work on improvements by ourselves (and perhaps have our own documentation site?).
> 
> Feel free to create & submit **ANY** issues and pull requests! Nothing is too small to fix, even just a typo :)

The [AngularDart](https://angulardart-community.web.app) **community-maintained** documentation site, built with [Jekyll][] and hosted on [Firebase Hosting][Firebase].

[We welcome contributions](CONTRIBUTING.md), and we're [first-timer
friendly](http://www.firsttimersonly.com)!

Our main focus now is to keep the version of the website up-to-date with the latest version of AngularDart, but as stated above, feel free to submit anything. See the [migration guide](MIGRATION.md) for more info!

For simple changes (such as to CSS and text), you probably don't need to build this site. Often you can make changes using the GitHub UI.

If you want/need to build, read on.

## Before you build this site

~~Windows users might find themselves having trouble building this site because they can't run `.sh` files. We're currently migrating the workflows from using [`gulpjs`]() to Dart's [`grinder`](https://pub.dev/packages/grinder), which will do everything in Dart and resolve this problem. Sorry Windows users! (and how about considering using linux in the meantime?)~~ We just migrated (most) workflows to Dart, so Windows users should be able to build the site now. But seriously, considering switching to Linux?

Also, if you do a full-site build, it takes up about 2 ~ 5GB of space. Hard Drive Lives Matter!

### 1. Get the prerequisites

Install the following tools if you don't have them already.

- **nodejs and npm** nodejs should be v12.x, other versions have not been tested
- **[Ruby][]** 2.6 is the recommended version; other versions, like 2.7, will throw a bunch of warnings but are definitely usable
- **[Dart][]** (what do you expect then?) all versions after 2.5 is fine
- **[Chrome][]** v63 or later, or literally any web browser

> IMPORTANT: Follow the installation instructions for each of the tools
carefully. In particular, configure your shell/environment so
that the tools are available in every terminal/command window you create.

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

### 3. Create a folder at your **HOME** directory

Create a folder at your home directory called `tmp`. This is used for some logging. Our scripts can automatically create that folder for you if it doesn't exists.

## Building this site

```bash
npm install
bundle install
pub global activate grinder # Not required but highly recommended
```
If this is your first time building this site, run a full build:
```bash
dart run grinder build --refresh=all
```
Alternatively run the following if you have activated `grinder`:
```bash
grind build --refresh=all
```
The generated site is in the `publish` folder. Run the following to view the site in your browser:
```bash
npx superstatic --port 5000
```
Open [localhost:5000](http://localhost:5000/), and there it is!

Once you've built the site once, you can run the following to build, serve, and have a watcher at the same time:
```bash
jekyll serve --livereload
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
