
Changelog
=========

`0.17.1 <https://github.com/saltstack-formulas/iptables-formula/compare/v0.17.0...v0.17.1>`_ (2020-01-02)
-------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **tables.sls:** chain and rule creation order (\ `80f6d5d <https://github.com/saltstack-formulas/iptables-formula/commit/80f6d5dfb2cd46b644dbdaab1f0cafd040f0ea13>`_\ )

`0.17.0 <https://github.com/saltstack-formulas/iptables-formula/compare/v0.16.1...v0.17.0>`_ (2019-12-30)
-------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **release.config.js:** use full commit hash in commit link [skip ci] (\ `6467f1c <https://github.com/saltstack-formulas/iptables-formula/commit/6467f1ce0b97ca59b1d3c818815d41cf571b16ae>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **gemfile:** restrict ``train`` gem version until upstream fix [skip ci] (\ `2b44567 <https://github.com/saltstack-formulas/iptables-formula/commit/2b4456745121de4616d8196bd1572acb78f04ea5>`_\ )
* **kitchen:** use ``debian-10-master-py3`` instead of ``develop`` [skip ci] (\ `eade7fb <https://github.com/saltstack-formulas/iptables-formula/commit/eade7fbe10815ad4f9795b0dc262fb5c5e1a2b91>`_\ )
* **kitchen:** use ``develop`` image until ``master`` is ready (\ ``amazonlinux``\ ) [skip ci] (\ `b9dc814 <https://github.com/saltstack-formulas/iptables-formula/commit/b9dc8143688facbec3082ea379e22d87787e6bb4>`_\ )
* **kitchen+travis:** upgrade matrix after ``2019.2.2`` release [skip ci] (\ `700b8bc <https://github.com/saltstack-formulas/iptables-formula/commit/700b8bc85cfa4e44064900fc52d46a6713da9e86>`_\ )
* **travis:** apply changes from build config validation [skip ci] (\ `7dbd6ae <https://github.com/saltstack-formulas/iptables-formula/commit/7dbd6ae0383a4d8e53b0ed187387384eb88a1ed4>`_\ )
* **travis:** opt-in to ``dpl v2`` to complete build config validation [skip ci] (\ `1e37eec <https://github.com/saltstack-formulas/iptables-formula/commit/1e37eec9ebbbf9867fc5fd9c8d5d1ac336f0785f>`_\ )
* **travis:** quote pathspecs used with ``git ls-files`` [skip ci] (\ `28e89bb <https://github.com/saltstack-formulas/iptables-formula/commit/28e89bbe5653f81b07d2f2d72f93d4b667c95905>`_\ )
* **travis:** run ``shellcheck`` during lint job [skip ci] (\ `7378266 <https://github.com/saltstack-formulas/iptables-formula/commit/73782668b6379962cb7fd2e5145dc1ca91848adb>`_\ )
* **travis:** update ``salt-lint`` config for ``v0.0.10`` [skip ci] (\ `aed0b09 <https://github.com/saltstack-formulas/iptables-formula/commit/aed0b095b3b6054e9c157d6e9a3a6e324641904a>`_\ )
* **travis:** use ``major.minor`` for ``semantic-release`` version [skip ci] (\ `88abf0d <https://github.com/saltstack-formulas/iptables-formula/commit/88abf0d062e2fc2a99289a6837da3880660b3f46>`_\ )
* **travis:** use build config validation (beta) [skip ci] (\ `665c3b3 <https://github.com/saltstack-formulas/iptables-formula/commit/665c3b3d18e504f5731ee99ba1dea13e977e7aee>`_\ )
* merge travis matrix, add ``salt-lint`` & ``rubocop`` to ``lint`` job (\ `e1bd1e6 <https://github.com/saltstack-formulas/iptables-formula/commit/e1bd1e6b4f393ce91b903826fb96398877ff8ca4>`_\ )

Documentation
^^^^^^^^^^^^^


* **contributing:** remove to use org-level file instead [skip ci] (\ `d1d6aa5 <https://github.com/saltstack-formulas/iptables-formula/commit/d1d6aa55555c45f27f817ca9cc62470da98e2b27>`_\ )
* **readme:** update link to ``CONTRIBUTING`` [skip ci] (\ `5f6564f <https://github.com/saltstack-formulas/iptables-formula/commit/5f6564f0543181db56c6a3d119ad4a5c98a8a40f>`_\ )

Features
^^^^^^^^


* **osfamilymap.yaml:** add gentoo package name (\ `8027ceb <https://github.com/saltstack-formulas/iptables-formula/commit/8027ceb9715f02b12c8f328c8fefca09819522c2>`_\ )

Performance Improvements
^^^^^^^^^^^^^^^^^^^^^^^^


* **travis:** improve ``salt-lint`` invocation [skip ci] (\ `d816236 <https://github.com/saltstack-formulas/iptables-formula/commit/d816236d53ed3a09b53cd8af69cecdec4f8fe412>`_\ )

`0.16.1 <https://github.com/saltstack-formulas/iptables-formula/compare/v0.16.0...v0.16.1>`_ (2019-10-10)
-------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **init.sls:** fix ``salt-lint`` errors (\ ` <https://github.com/saltstack-formulas/iptables-formula/commit/65369c5>`_\ )
* **service.sls:** fix ``salt-lint`` errors (\ ` <https://github.com/saltstack-formulas/iptables-formula/commit/49a2c62>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen:** change ``log_level`` to ``debug`` instead of ``info`` (\ ` <https://github.com/saltstack-formulas/iptables-formula/commit/21844a9>`_\ )
* **kitchen:** install required packages to bootstrapped ``opensuse`` [skip ci] (\ ` <https://github.com/saltstack-formulas/iptables-formula/commit/02b5b59>`_\ )
* **kitchen:** use bootstrapped ``opensuse`` images until ``2019.2.2`` [skip ci] (\ ` <https://github.com/saltstack-formulas/iptables-formula/commit/79c98ed>`_\ )
* **kitchen+travis:** replace EOL pre-salted images (\ ` <https://github.com/saltstack-formulas/iptables-formula/commit/98ee968>`_\ )
* **platform:** add ``arch-base-latest`` (\ ` <https://github.com/saltstack-formulas/iptables-formula/commit/2ba3a7c>`_\ )
* **yamllint:** add rule ``empty-values`` & use new ``yaml-files`` setting (\ ` <https://github.com/saltstack-formulas/iptables-formula/commit/8d94551>`_\ )
* merge travis matrix, add ``salt-lint`` & ``rubocop`` to ``lint`` job (\ ` <https://github.com/saltstack-formulas/iptables-formula/commit/4f0c67b>`_\ )
* use ``dist: bionic`` & apply ``opensuse-leap-15`` SCP error workaround (\ ` <https://github.com/saltstack-formulas/iptables-formula/commit/dccab80>`_\ )

`0.16.0 <https://github.com/saltstack-formulas/iptables-formula/compare/v0.15.0...v0.16.0>`_ (2019-08-10)
-------------------------------------------------------------------------------------------------------------

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen:** add remaining platforms from ``template-formula`` (\ `0d7e08d <https://github.com/saltstack-formulas/iptables-formula/commit/0d7e08d>`_\ )

Features
^^^^^^^^


* **yamllint:** include for this repo and apply rules throughout (\ `9721448 <https://github.com/saltstack-formulas/iptables-formula/commit/9721448>`_\ )

`0.15.0 <https://github.com/saltstack-formulas/iptables-formula/compare/v0.14.0...v0.15.0>`_ (2019-06-25)
-------------------------------------------------------------------------------------------------------------

Documentation
^^^^^^^^^^^^^


* fix rst formatting (\ `1318502 <https://github.com/saltstack-formulas/iptables-formula/commit/1318502>`_\ )

Features
^^^^^^^^


* allow to configure the firewall using a rules' dict (\ `e851e4f <https://github.com/saltstack-formulas/iptables-formula/commit/e851e4f>`_\ )

Styles
^^^^^^


* improve empty lines management (\ `be3a96a <https://github.com/saltstack-formulas/iptables-formula/commit/be3a96a>`_\ )

Tests
^^^^^


* improve travis matrix, remove unneeded gem entry (\ `6861fe0 <https://github.com/saltstack-formulas/iptables-formula/commit/6861fe0>`_\ )

`0.14.0 <https://github.com/saltstack-formulas/iptables-formula/compare/v0.13.0...v0.14.0>`_ (2019-06-11)
-------------------------------------------------------------------------------------------------------------

Features
^^^^^^^^


* semver-release (\ `32a7ba6 <https://github.com/saltstack-formulas/iptables-formula/commit/32a7ba6>`_\ ), closes `/github.com/saltstack-formulas/iptables-formula/pull/35#issuecomment-500583112 <https://github.com//github.com/saltstack-formulas/iptables-formula/pull/35/issues/issuecomment-500583112>`_
