# Changelog

## [0.17.4](https://github.com/saltstack-formulas/iptables-formula/compare/v0.17.3...v0.17.4) (2021-04-20)


### Code Refactoring

* **tables.sls:** remove dictsort from tables.sls ([05a274c](https://github.com/saltstack-formulas/iptables-formula/commit/05a274c076d9f721e4617392bd109bd3f9843d6a))


### Continuous Integration

* **commitlint:** ensure `upstream/master` uses main repo URL [skip ci] ([b52ce7c](https://github.com/saltstack-formulas/iptables-formula/commit/b52ce7c4962d97a1717f676d391bb98e3ef32a66))
* **gemfile.lock:** add to repo with updated `Gemfile` [skip ci] ([451d962](https://github.com/saltstack-formulas/iptables-formula/commit/451d96289c60fe86564879d372ddeb3440eddb6e))
* **gemfile+lock:** use `ssf` customised `kitchen-docker` repo [skip ci] ([64172a6](https://github.com/saltstack-formulas/iptables-formula/commit/64172a6d43eabee00fb744e8c1092b2cf29c80ab))
* **gitlab-ci:** add `rubocop` linter (with `allow_failure`) [skip ci] ([085a5e1](https://github.com/saltstack-formulas/iptables-formula/commit/085a5e1b96041f68b1ccf256cf6cd865097219ab))
* **gitlab-ci:** use GitLab CI as Travis CI replacement ([9296214](https://github.com/saltstack-formulas/iptables-formula/commit/9296214f3a1ce6a33a8abc9e0d2da5545aeb10ea))
* **kitchen:** use `saltimages` Docker Hub where available [skip ci] ([addd5eb](https://github.com/saltstack-formulas/iptables-formula/commit/addd5eb131b226e45f57f9a9595542a294c27aeb))
* **kitchen+ci:** use latest pre-salted images (after CVE) [skip ci] ([5da8dea](https://github.com/saltstack-formulas/iptables-formula/commit/5da8dea68c0b4db3fffce9755f297c9e0d804511))
* **kitchen+gitlab-ci:** use latest pre-salted images [skip ci] ([81ef17a](https://github.com/saltstack-formulas/iptables-formula/commit/81ef17a414e2b2363a0207b62bae103e2dd0b9a2))
* **kitchen+travis:** remove `master-py2-arch-base-latest` [skip ci] ([50e7bdb](https://github.com/saltstack-formulas/iptables-formula/commit/50e7bdba07ac9573d60348d21beb71cc0bcbf61d))
* **pre-commit:** add to formula [skip ci] ([57e9a8d](https://github.com/saltstack-formulas/iptables-formula/commit/57e9a8dc45dec8224f5eae8426f7e5be2fea1a5a))
* **pre-commit:** enable/disable `rstcheck` as relevant [skip ci] ([4d88838](https://github.com/saltstack-formulas/iptables-formula/commit/4d88838522cf72f97f3cce376006d4eec9d2d33f))
* **pre-commit:** finalise `rstcheck` configuration [skip ci] ([a296994](https://github.com/saltstack-formulas/iptables-formula/commit/a296994d2b9596d724805123364871afaea0c264))
* **pre-commit:** update hook for `rubocop` [skip ci] ([4307f44](https://github.com/saltstack-formulas/iptables-formula/commit/4307f44feca9779a3bdf62344f5b63e8a9b54427))
* **travis:** add notifications => zulip [skip ci] ([908960d](https://github.com/saltstack-formulas/iptables-formula/commit/908960dae8f78c3175796d5febf3b1083fbd579c))
* **workflows/commitlint:** add to repo [skip ci] ([eab93ae](https://github.com/saltstack-formulas/iptables-formula/commit/eab93ae0c6a896f77e95b00e58be87dadb5716cc))


### Tests

* standardise use of `share` suite & `_mapdata` state [skip ci] ([5862d7a](https://github.com/saltstack-formulas/iptables-formula/commit/5862d7a9f21eda3a70627e5ea6b0c8fd5a6c3874))
* **rubocop:** fix all violations (or use `disable`/`enable`) ([24f34a1](https://github.com/saltstack-formulas/iptables-formula/commit/24f34a176ca038f66f3cbf7629878ba03119d561))

## [0.17.3](https://github.com/saltstack-formulas/iptables-formula/compare/v0.17.2...v0.17.3) (2020-04-17)


### Bug Fixes

* **init:** ensure save takes place for `enable_reject_policy` ([8f3d3d1](https://github.com/saltstack-formulas/iptables-formula/commit/8f3d3d19068d0c124efdc1c9b88412cec51ff339))

## [0.17.2](https://github.com/saltstack-formulas/iptables-formula/compare/v0.17.1...v0.17.2) (2020-03-30)


### Bug Fixes

* **debian:** ensure `netbase` package is installed ([801b087](https://github.com/saltstack-formulas/iptables-formula/commit/801b0879da2771cd60e0842b611572eceb1b5f95)), closes [/travis-ci.org/github/myii/iptables-formula/jobs/665529089#L1222-L1229](https://github.com//travis-ci.org/github/myii/iptables-formula/jobs/665529089/issues/L1222-L1229)


### Continuous Integration

* **kitchen:** avoid using bootstrap for `master` instances [skip ci] ([138d5b0](https://github.com/saltstack-formulas/iptables-formula/commit/138d5b05c4fb77820515c3a6dd51dd2f79f8b68c))

## [0.17.1](https://github.com/saltstack-formulas/iptables-formula/compare/v0.17.0...v0.17.1) (2020-01-02)


### Bug Fixes

* **tables.sls:** chain and rule creation order ([80f6d5d](https://github.com/saltstack-formulas/iptables-formula/commit/80f6d5dfb2cd46b644dbdaab1f0cafd040f0ea13))

# [0.17.0](https://github.com/saltstack-formulas/iptables-formula/compare/v0.16.1...v0.17.0) (2019-12-30)


### Bug Fixes

* **release.config.js:** use full commit hash in commit link [skip ci] ([6467f1c](https://github.com/saltstack-formulas/iptables-formula/commit/6467f1ce0b97ca59b1d3c818815d41cf571b16ae))


### Continuous Integration

* **gemfile:** restrict `train` gem version until upstream fix [skip ci] ([2b44567](https://github.com/saltstack-formulas/iptables-formula/commit/2b4456745121de4616d8196bd1572acb78f04ea5))
* **kitchen:** use `debian-10-master-py3` instead of `develop` [skip ci] ([eade7fb](https://github.com/saltstack-formulas/iptables-formula/commit/eade7fbe10815ad4f9795b0dc262fb5c5e1a2b91))
* **kitchen:** use `develop` image until `master` is ready (`amazonlinux`) [skip ci] ([b9dc814](https://github.com/saltstack-formulas/iptables-formula/commit/b9dc8143688facbec3082ea379e22d87787e6bb4))
* **kitchen+travis:** upgrade matrix after `2019.2.2` release [skip ci] ([700b8bc](https://github.com/saltstack-formulas/iptables-formula/commit/700b8bc85cfa4e44064900fc52d46a6713da9e86))
* **travis:** apply changes from build config validation [skip ci] ([7dbd6ae](https://github.com/saltstack-formulas/iptables-formula/commit/7dbd6ae0383a4d8e53b0ed187387384eb88a1ed4))
* **travis:** opt-in to `dpl v2` to complete build config validation [skip ci] ([1e37eec](https://github.com/saltstack-formulas/iptables-formula/commit/1e37eec9ebbbf9867fc5fd9c8d5d1ac336f0785f))
* **travis:** quote pathspecs used with `git ls-files` [skip ci] ([28e89bb](https://github.com/saltstack-formulas/iptables-formula/commit/28e89bbe5653f81b07d2f2d72f93d4b667c95905))
* **travis:** run `shellcheck` during lint job [skip ci] ([7378266](https://github.com/saltstack-formulas/iptables-formula/commit/73782668b6379962cb7fd2e5145dc1ca91848adb))
* **travis:** update `salt-lint` config for `v0.0.10` [skip ci] ([aed0b09](https://github.com/saltstack-formulas/iptables-formula/commit/aed0b095b3b6054e9c157d6e9a3a6e324641904a))
* **travis:** use `major.minor` for `semantic-release` version [skip ci] ([88abf0d](https://github.com/saltstack-formulas/iptables-formula/commit/88abf0d062e2fc2a99289a6837da3880660b3f46))
* **travis:** use build config validation (beta) [skip ci] ([665c3b3](https://github.com/saltstack-formulas/iptables-formula/commit/665c3b3d18e504f5731ee99ba1dea13e977e7aee))
* merge travis matrix, add `salt-lint` & `rubocop` to `lint` job ([e1bd1e6](https://github.com/saltstack-formulas/iptables-formula/commit/e1bd1e6b4f393ce91b903826fb96398877ff8ca4))


### Documentation

* **contributing:** remove to use org-level file instead [skip ci] ([d1d6aa5](https://github.com/saltstack-formulas/iptables-formula/commit/d1d6aa55555c45f27f817ca9cc62470da98e2b27))
* **readme:** update link to `CONTRIBUTING` [skip ci] ([5f6564f](https://github.com/saltstack-formulas/iptables-formula/commit/5f6564f0543181db56c6a3d119ad4a5c98a8a40f))


### Features

* **osfamilymap.yaml:** add gentoo package name ([8027ceb](https://github.com/saltstack-formulas/iptables-formula/commit/8027ceb9715f02b12c8f328c8fefca09819522c2))


### Performance Improvements

* **travis:** improve `salt-lint` invocation [skip ci] ([d816236](https://github.com/saltstack-formulas/iptables-formula/commit/d816236d53ed3a09b53cd8af69cecdec4f8fe412))

## [0.16.1](https://github.com/saltstack-formulas/iptables-formula/compare/v0.16.0...v0.16.1) (2019-10-10)


### Bug Fixes

* **init.sls:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/iptables-formula/commit/65369c5))
* **service.sls:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/iptables-formula/commit/49a2c62))


### Continuous Integration

* **kitchen:** change `log_level` to `debug` instead of `info` ([](https://github.com/saltstack-formulas/iptables-formula/commit/21844a9))
* **kitchen:** install required packages to bootstrapped `opensuse` [skip ci] ([](https://github.com/saltstack-formulas/iptables-formula/commit/02b5b59))
* **kitchen:** use bootstrapped `opensuse` images until `2019.2.2` [skip ci] ([](https://github.com/saltstack-formulas/iptables-formula/commit/79c98ed))
* **kitchen+travis:** replace EOL pre-salted images ([](https://github.com/saltstack-formulas/iptables-formula/commit/98ee968))
* **platform:** add `arch-base-latest` ([](https://github.com/saltstack-formulas/iptables-formula/commit/2ba3a7c))
* **yamllint:** add rule `empty-values` & use new `yaml-files` setting ([](https://github.com/saltstack-formulas/iptables-formula/commit/8d94551))
* merge travis matrix, add `salt-lint` & `rubocop` to `lint` job ([](https://github.com/saltstack-formulas/iptables-formula/commit/4f0c67b))
* use `dist: bionic` & apply `opensuse-leap-15` SCP error workaround ([](https://github.com/saltstack-formulas/iptables-formula/commit/dccab80))

# [0.16.0](https://github.com/saltstack-formulas/iptables-formula/compare/v0.15.0...v0.16.0) (2019-08-10)


### Continuous Integration

* **kitchen:** add remaining platforms from `template-formula` ([0d7e08d](https://github.com/saltstack-formulas/iptables-formula/commit/0d7e08d))


### Features

* **yamllint:** include for this repo and apply rules throughout ([9721448](https://github.com/saltstack-formulas/iptables-formula/commit/9721448))

# [0.15.0](https://github.com/saltstack-formulas/iptables-formula/compare/v0.14.0...v0.15.0) (2019-06-25)


### Documentation

* fix rst formatting ([1318502](https://github.com/saltstack-formulas/iptables-formula/commit/1318502))


### Features

* allow to configure the firewall using a rules' dict ([e851e4f](https://github.com/saltstack-formulas/iptables-formula/commit/e851e4f))


### Styles

* improve empty lines management ([be3a96a](https://github.com/saltstack-formulas/iptables-formula/commit/be3a96a))


### Tests

* improve travis matrix, remove unneeded gem entry ([6861fe0](https://github.com/saltstack-formulas/iptables-formula/commit/6861fe0))

# [0.14.0](https://github.com/saltstack-formulas/iptables-formula/compare/v0.13.0...v0.14.0) (2019-06-11)


### Features

* semver-release ([32a7ba6](https://github.com/saltstack-formulas/iptables-formula/commit/32a7ba6)), closes [/github.com/saltstack-formulas/iptables-formula/pull/35#issuecomment-500583112](https://github.com//github.com/saltstack-formulas/iptables-formula/pull/35/issues/issuecomment-500583112)
