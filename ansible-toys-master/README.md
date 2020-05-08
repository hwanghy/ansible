HOW TO GET FUN WITH THIS SHIT
=======

## Playbook

Playbooks are collected at [./playbook](./playbook) which separated as roles based.
Play the needed role as your purpose.

E.g:
 - use [./playbook/rsnapshot.yml](./playbook/rsnapshot.yml) to deploy rsnapshot
 - use [./playbook/innobackup.yml](./playbook/innobackup.yml) to deploy innobackup

## How to Deploy

Here are some rules must be followed:
- Before apply anything with `ansible`, PLEASE RUN FISRT WITH `--check` option
before actually apply
- Please be noticed that `--limit <host>` must be specified when running `ansible`
because the value of `hosts` at playbook is always `all`. Imaging that someday
you forgot that, this shit playbook will apply to all hosts, and we have to
eat our shit.


