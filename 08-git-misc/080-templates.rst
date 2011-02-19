Git 模板
========

TEMPLATE DIRECTORY
------------------

::

  The template directory contains files and directories that will be copied to
  the `$GIT_DIR` after it is created.

  The template directory used will (in order):

   - The argument given with the `--template` option.

   - The contents of the `$GIT_TEMPLATE_DIR` environment variable.

   - The `init.templatedir` configuration variable.

   - The default template directory: `/usr/share/git-core/templates`.

  The default template directory includes some directory structure, some
  suggested "exclude patterns", and copies of sample "hook" files.
  The suggested patterns and hook files are all modifiable and extensible.


  * "git init --template=" with blank "template" parameter linked files
    under root directories to .git, which was a total nonsense.  Instead, it
    means "I do not want to use anything from the template directory".

   * "git init" can be told to look at init.templatedir configuration
     variable (obviously that has to come from either /etc/gitconfig or
     $HOME/.gitconfig).


  init.templatedir::
    Specify the directory from which templates will be copied.
    (See the "TEMPLATE DIRECTORY" section of linkgit:git-init[1].)


  git clone, git init both has --template=

commit-template
-----------------

  - "git commit" can use "-t templatefile" option and commit.template
    configuration variable to prime the commit message given to you in the
    editor.

commit.template::

  Specify a file to use as the template for new commit messages.
  "{tilde}/" is expanded to the value of `$HOME` and "{tilde}user/" to the
  specified user's home directory.
    


