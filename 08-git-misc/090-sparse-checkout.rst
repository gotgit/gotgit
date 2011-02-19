稀疏检出
================

Git 1.7.0:

 * "sparse checkout" feature allows only part of the work tree to be
   checked out.




core.sparseCheckout::
  Enable "sparse checkout" feature. See section "Sparse checkout" in
  linkgit:git-read-tree[1] for more information.


Sparse checkout
---------------

"Sparse checkout" allows to sparsely populate working directory.
It uses skip-worktree bit (see linkgit:git-update-index[1]) to tell
Git whether a file on working directory is worth looking at.
    
"git read-tree" and other merge-based commands ("git merge", "git
checkout"...) can help maintaining skip-worktree bitmap and working
directory update. `$GIT_DIR/info/sparse-checkout` is used to
define the skip-worktree reference bitmap. When "git read-tree" needs
to update working directory, it will reset skip-worktree bit in index
based on this file, which uses the same syntax as .gitignore files.
If an entry matches a pattern in this file, skip-worktree will be
set on that entry. Otherwise, skip-worktree will be unset.

Then it compares the new skip-worktree value with the previous one. If
skip-worktree turns from unset to set, it will add the corresponding
file back. If it turns from set to unset, that file will be removed.

While `$GIT_DIR/info/sparse-checkout` is usually used to specify what
files are in. You can also specify what files are _not_ in, using
negate patterns. For example, to remove file "unwanted":



!unwanted
------------

Another tricky thing is fully repopulating working directory when you
no longer want sparse checkout. You cannot just disable "sparse
checkout" because skip-worktree are still in the index and you working
directory is still sparsely populated. You should re-populate working
directory with the `$GIT_DIR/info/sparse-checkout` file content as
follows:

xxxxxx
-------

Then you can disable sparse checkout. Sparse checkout support in "git
read-tree" and similar commands is disabled by default. You need to
turn `core.sparseCheckout` on in order to have sparse checkout
support.


