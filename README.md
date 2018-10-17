# Keycloak - Ansible #

An ansible role that sets up a modest keycloak server/user
(running standalone cluster, local h2 datastore, default settings),
and user on a FreeBSD Box (tested on 11.2). This role will
setup Java 8 (including the necessary mount points if they don't
already exist), and setup a keycloak server optimized for
running in a local environment.

## PreReqs ##

A FreeBSD System with:

  * python-2.7 installed.
  * bash installed.
  * A way to download/transfer files to the FreeBSD Box.

## Usage ##

  * Run the playbook against the FreeBSD Host.
  * Set: `keycloak_enable="YES"` in `/etc/rc.conf`.
  * Create a keycloak user initially: `sudo su keycloak /srv/keycloak/bin/keycloak-add-user.sh -u username -p password`.
  * Startup Keycloak: `sudo service keycloak start`
