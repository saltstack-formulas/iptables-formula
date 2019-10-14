.. _readme:

iptables
========

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/iptables-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/iptables-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

This formula manages your firewall using iptables with pillar configured rules.
Thanks to the nature of Pillars it is possible to write global and local settings (e.g. enable globally, configure locally)

.. contents:: **Table of Contents**

General notes
-------------

Pull requests are welcome for other platforms (or other improvements ofcourse!)

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

.. contents::
   :local:

Usage
-----

Default usage
^^^^^^^^^^^^^
All the configuration for the firewall is done via the pillar (see the pillar.example file).

Enable globally:

``pillars/firewall.sls``

.. code-block:: yaml

   firewall:
     enabled: True
     install: True  
     strict: True

Allow SSH:

``pillars/firewall/ssh.sls``

.. code-block:: yaml

   firewall:
     services:
       ssh:
         block_nomatch: False
         ips_allow:
           - 192.168.0.0/24
           - 10.0.2.2/32

Apply rules to specific interface:

.. code-block:: yaml

   firewall:
     services:
       ssh:
         interfaces:
           - eth0
           - eth1

Apply rules for multiple protocols:


.. code-block:: yaml

   firewall:
     services:
       ssh:
         protos:
           - udp
           - tcp

Allow an entire class such as your internal network:

.. code-block:: yaml

   whitelist:
     networks:
       ips_allow:
         - 10.0.0.0/8

Salt combines both and effectively enables your firewall and applies the rules.

Notes:

 * Setting install to True will install ``iptables`` and ``iptables-persistent`` for you
 * Strict mode means: Deny **everything** except explicitly allowed (use with care!)
 * block_nomatch: With non-strict mode adds in a "REJECT" rule below the accept rules, otherwise other traffic to that service is still allowed. Can be defined per-service or globally, defaults to False.
 * Service names can be either port numbers or service names (e.g. ssh, zabbix-agent, http) and are available for viewing/configuring in ``/etc/services``
 * If no ``ips_allow`` stanza is provided for any particular ruleset instead of not adding the rule the addition itself is scoped globally (0.0.0.0/0)

Using iptables.service
^^^^^^^^^^^^^^^^^^^^^^

Salt can't merge pillars, so you can only define ``firewall:services`` in once place. With the firewall.service state and stateconf, you can define pillars for different services and include and extend the iptables.service state with the ``parent`` parameter to enable a default firewall configuration with special rules for different services.

``pillars/otherservice.sls``

.. code-block:: yaml

   otherservice:
     firewall:
       services:
         http:
           block_nomatch: False
           ips_allow:
             - 0.0.0.0/0

``states/otherservice.sls``

.. code-block:: yaml

   #!stateconf yaml . jinja
   
   include:
     - iptables.service
   
   extend:
     iptables.service::sls_params:
       stateconf.set:
         - parent: otherservice

Using iptables.nat
^^^^^^^^^^^^^^^^^^

You can use nat for interface. This is supported for IPv4 alone. IPv6 deployments should not use NAT.

.. code-block:: yaml

   # Support nat
   # iptables -t nat -A POSTROUTING -o eth0 -s 192.168.18.0/24 -d 10.20.0.2 -j MASQUERADE

   nat:
     eth0:
       rules:
         '192.168.18.0/24':
           - 10.20.0.2

Configure the firewall using ``tables``
---------------------------------------

The state ``iptables.tables`` let's you configure your firewall iterating over pillars
defining rules and policies to add to the different tables (filter, mangle, nat) instead of using services.
This way, you can configure iptables the *classic way*. Note that you still need to include the ``iptables`` state.

To enable the 'tables' mode, set:

.. code-block:: yaml

   firewall:
     use_tables: True

and then add rules to configure iptables. Check the ``pillar.example``'s *table* section to see some examples.

IPv6 Support
------------

This formula supports IPv6 as long as it is activated with the option:

.. code-block:: yaml

   firewall:
     ipv6: True

Services and whitelists are supported under the sections ``services_ipv6`` and ``whitelist_ipv6``, as below:

.. code-block:: yaml

   services_ipv6:
     ssh:
       block_nomatch: False
       ips_allow:
         - 2a02:2028:773:d01:10a5:f34f:e7ff:f55b/64
         - 2a02:2028:773:d01:1814:28ef:e91b:70b8/64
   whitelist_ipv6:
     networks:
       ips_allow:
         - 2a02:2028:773:d01:1814:28ef:e91b:70b8/64

These sections are only processed if the ipv6 support is activated.

Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``iptables`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.

