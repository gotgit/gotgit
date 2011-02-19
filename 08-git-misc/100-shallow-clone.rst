浅克隆
================

Git 1.5.0:

Shallow clones
-------------------

::

   - There is a partial support for 'shallow' repositories that
     keeps only recent history.  A 'shallow clone' is created by
     specifying how deep that truncated history should be
     (e.g. "git clone --depth 5 git://some.where/repo.git").

     Currently a shallow repository has number of limitations:


     - Cloning and fetching _from_ a shallow clone are not
       supported (nor tested -- so they might work by accident but
       they are not expected to).

     - Pushing from nor into a shallow clone are not expected to
       work.

     - Merging inside a shallow repository would work as long as a
       merge base is found in the recent history, but otherwise it
       will be like merging unrelated histories and may result in
       huge conflicts.

     but this would be more than adequate for people who want to
     look at near the tip of a big project with a deep history and
     send patches in e-mail format.

fetch-options.txt
-------------------

::

  --depth=<depth>::
    Deepen the history of a 'shallow' repository created by
    `git clone` with `--depth=<depth>` option (see linkgit:git-clone[1])
    by the specified number of commits. 
    


git-clone
-----------

::

  --depth <depth>::
    Create a 'shallow' clone with a history truncated to the
    specified number of revisions.  A shallow repository has a
    number of limitations (you cannot clone or fetch from
    it, nor push from nor into it), but is adequate if you 
    are only interested in the recent history of a large project
    with a long history, and would want to send in fixes
    as patches.


technical/shallow.txt
-------------------------

::

  Def.: Shallow commits do have parents, but not in the shallow
  repo, and therefore grafts are introduced pretending that
  these commits have no parents.

  The basic idea is to write the SHA1s of shallow commits into
  $GIT_DIR/shallow, and handle its contents like the contents
  of $GIT_DIR/info/grafts (with the difference that shallow
  cannot contain parent information).

  This information is stored in a new file instead of grafts, or
  even the config, since the user should not touch that file
  at all (even throughout development of the shallow clone, it
  was never manually edited!).

  Each line contains exactly one SHA1. When read, a commit_graft
  will be constructed, which has nr_parent < 0 to make it easier
  to discern from user provided grafts.

  Since fsck-objects relies on the library to read the objects,
  it honours shallow commits automatically.

  There are some unfinished ends of the whole shallow business:

  - maybe we have to force non-thin packs when fetching into a
    shallow repo (ATM they are forced non-thin).

  - A special handling of a shallow upstream is needed. At some
    stage, upload-pack has to check if it sends a shallow commit,
    and it should send that information early (or fail, if the
    client does not support shallow repositories). There is no
    support at all for this in this patch series.

  - Instead of locking $GIT_DIR/shallow at the start, just
    the timestamp of it is noted, and when it comes to writing it,
    a check is performed if the mtime is still the same, dying if
    it is not.

  - It is unclear how "push into/from a shallow repo" should behave.

  - If you deepen a history, you'd want to get the tags of the
    newly stored (but older!) commits. This does not work right now.

  To make a shallow clone, you can call "git-clone --depth 20 repo".
  The result contains only commit chains with a length of at most 20.
  It also writes an appropriate $GIT_DIR/shallow.

  You can deepen a shallow repository with "git-fetch --depth 20
  repo branch", which will fetch branch from repo, but stop at depth
  20, updating $GIT_DIR/shallow.
