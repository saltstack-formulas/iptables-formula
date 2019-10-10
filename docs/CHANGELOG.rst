
Changelog
=========

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
