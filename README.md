# Pathway

Pathway is a fast, easy-to-use series of bash scripts that dynamically
generate filepath aliases for the directories you spend the most time in with
minimal overhead.

### Installation

To install, run git clone in your home directory and make sure `pathway.sh`
is sourced in your `.bashrc`

### API

You can use Pathway from the command line with c-style arguments.

Command | Use
------- | -------
-c | Show all aliased filepaths
-r | Remove aliased filepaths and directory history
-s `alias_name` | Save dynamically generated aliases
-d `alias_name` | Delete dynamically generated aliases
-f | Freeze Pathway
-u | Unfreeze Pathway

### Compatability

This has been extensively tested on my Linux machine. I can't vouch for Mac or
PC, so feel free to make a PR if you find bugs.

### To-dos

* Optimize on-startup performance. Given that a user's most commonly traversed
filepaths will change over time, I don't need to be storing their history anyway.

* Allow user to blacklist certain filepaths and aliases to avoid collisions.
