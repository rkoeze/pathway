# Pathway

Pathway is a easy-to-use bash script that dynamically generates filepath
aliases for the directories you spend the most time in.

### Installation

To install, run git clone in your home directory and make sure `pathway.sh`
is sourced in your `.bashrc`

### To-dos

* Optimize on-startup performance. Given that a user's most commonly traversed
filepaths will change over time, I don't need to be storing their history anyway.

* Allow user to blacklist certain filepaths and aliases to avoid collisions.

* Add API docs.
