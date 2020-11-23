# Notes for maintainers

In general, do not only rely on these notes, but also study the official homebrew documentation.

## Generating the source cache

1. `git clone -b <release> https://github.com/FairRootGroup/FairSoft`
2. `cmake -S FairSoft -B /tmp/build -C FairSoft/FairSoftConfig.cmake`
3. `cmake --build /tmp/build --target source-cache -j 12`

This should create a source cache tarball in `/tmp/build`.

## Building the bottles (binary packages)

1. Start in a fresh shell, make yourself aware, if you have any profile loaded that may affect a neutral build
2. Run `brew update`
3. Adress all issues reported by `brew doctor` until system *ready for brewing*.
4. Make sure `xcode-select -p` points to `/Library/Developer/Command Line Tools`
5. Check, if `brew config` reflects the expected environment
6. `brew uninstall fairsoft@20.11`
7. `brew install --build-bottle fairsoft@20.11`
8. `brew bottle fairsoft@20.11`

This should generate a snippet for the formula and generate the bottle file. Note: See the next section for the correct bottle filenames, the `brew bottle` command print one `-` character too much.

## Hosting bottles and source cache

Both the source caches and the brew bottles are currently hosted on `lxwww75.gsi.de:/data.local1/packages` which is visible to the outside world as `https://alfa-ci.gsi.de/packages`.

```
lxwww75:/data.local1/packages/
├── fairsoft@20.11-nov20.big_sur.bottle.tar.gz
├── fairsoft@20.11-nov20.catalina.bottle.tar.gz
├── FairSoft_source_cache_full_e38f617.tar.gz
└── FairSoft_source_cache_full_nov20.tar.gz -> FairSoft_source_cache_full_e38f617.tar.gz
```

## Structure of the homebrew-fairsoft tap

```
homebrew-fairsoft
├── Aliases
│   └── fairsoft -> ../Formula/fairsoft@20.11.rb
├── Formula
│   └── fairsoft@20.11.rb
├── LICENSE
├── maintainerdocs.md
└── README.md
```

* A patch release shall be performend by updating the existing formula for this release
* A new major.minor release shall have a new versioned formula in the `Formula` directory
* The `fairsoft` alias shall always point to the latest major.minor release
