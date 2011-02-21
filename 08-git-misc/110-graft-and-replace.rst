提交嫁接
================

git-filter-branch and .git/info/graft
----------------------------------------

::

  *NOTE*: This command honors `.git/info/grafts`. If you have any grafts
  defined, running this command will make them permanent.


  info/grafts::
    This file records fake commit ancestry information, to
    pretend the set of parents a commit has is different
    from how the commit was actually created.  One record
    per line describes a commit and its fake parents by
    listing their 40-byte hexadecimal object names separated
    by a space and terminated by a newline.


  [[def_grafts]]grafts::
    Grafts enables two otherwise different lines of development to be joined
    together by recording fake ancestry information for commits. This way
    you can make git pretend the set of <<def_parent,parents>> a <<def_commit,commit>> has
    is different from what was recorded when the commit was
    created. Configured via the `.git/info/grafts` file.
    


git-replace(1)
----------------

::


  NAME
  ----
  git-replace - Create, list, delete refs to replace objects

  SYNOPSIS
  --------
  [verse]
  'git replace' [-f] <object> <replacement>
  'git replace' -d <object>...
  'git replace' -l [<pattern>]

  DESCRIPTION
  -----------
  Adds a 'replace' reference in `.git/refs/replace/`

  The name of the 'replace' reference is the SHA1 of the object that is
  replaced. The content of the 'replace' reference is the SHA1 of the
  replacement object.

  Unless `-f` is given, the 'replace' reference must not yet exist in
  `.git/refs/replace/` directory.

  Replacement references will be used by default by all git commands
  except those doing reachability traversal (prune, pack transfer and
  fsck).

  It is possible to disable use of replacement references for any
  command using the `--no-replace-objects` option just after 'git'.

  For example if commit 'foo' has been replaced by commit 'bar':

  ------------------------------------------------
  $ git --no-replace-objects cat-file commit foo
  ------------------------------------------------

  shows information about commit 'foo', while:

  ------------------------------------------------
  $ git cat-file commit foo
  ------------------------------------------------

  shows information about commit 'bar'.

  The 'GIT_NO_REPLACE_OBJECTS' environment variable can be set to
  achieve the same effect as the `--no-replace-objects` option.

  OPTIONS
  -------
  -f::
    If an existing replace ref for the same object exists, it will
    be overwritten (instead of failing).

  -d::
    Delete existing replace refs for the given objects.

  -l <pattern>::
    List replace refs for objects that match the given pattern (or
    all if no pattern is given).
    Typing "git replace" without arguments, also lists all replace
    refs.

  BUGS
  ----
  Comparing blobs or trees that have been replaced with those that
  replace them will not work properly. And using `git reset --hard` to
  go back to a replaced commit will move the branch to the replacement
  commit instead of the replaced commit.

  There may be other problems when using 'git rev-list' related to
  pending objects. And of course things may break if an object of one
  type is replaced by an object of another type (for example a blob
  replaced by a commit).

  SEE ALSO
  --------
  linkgit:git-tag[1]
  linkgit:git-branch[1]
  linkgit:git[1]

  Author
  ------
  Written by Christian Couder <chriscool@tuxfamily.org> and Junio C
  Hamano <gitster@pobox.com>, based on 'git tag' by Kristian Hogsberg
  <krh@redhat.com> and Carlos Rica <jasampler@gmail.com>.

  Documentation
  --------------
  Documentation by Christian Couder <chriscool@tuxfamily.org> and the
  git-list <git@vger.kernel.org>, based on 'git tag' documentation.

  GIT
  ---
  Part of the linkgit:git[1] suite
