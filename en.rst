Got Git
########

--- written by Jiang Xin, 2011.

I wrote this book in Chinese from 2010.10 till 2011.2. Parts of this book is from my works on some Git related open source projects, such as hacks on Topgit, Gitosis, Gitolite, repo (from Android project); Gistore a backup tools which I am inspired by etckeeper.

I translated the preface, Table of Contents, some figures of this book from Chinese into English, to help the people in English understanding the outline of this book. Sorry for my poor English. :(


Preface
###########

Version Control (SCM) is the art of changes management, no matter whether the changes are from the same person or from a team.
Version control system in the first place, must faithfully record the changes, and it could help people restore any historical revision or revert any historical changes. But as the most important part, the version control system could make the team members work together. Git is one of the best version control systems in the world.

My interests in version control system is from my practice on personal knowledge management. The core of my personal knowledge management is writing documents using maintainable format, and backup the documents in version control system. As to the maintainable document formats, they could be DocBook, FreeMind, reStructuredText, asciidoc and etc. I even hacked FreeMind to fit with version control system better, such as store VCS unfriendly node properties outside the .mm files into a .mmx file. This is my first open source activity, and the hacked FreeMind is hosted in as FreeMind-MMX. After chosen the proper document format, comes with the storage problem. Though a version control system can backup each historical commit, but how to avoid data loses if version control system corrupted? Git with its new design of the distributed operation model provides the best solution. Using Git, my knowledge base can be distributed by cloning it onto to different disks, or different hosts, and the synchronization between the repositories is simple, just through the push and pull operations. Data security has been greatly improved when using Git. With the care of the version control system, my mindmap (in FreeMind format) of Git becomes more and more clear over the time, and eventually becomes the prototype of the book.

Version control can determine the success of the project, even life of a company. During my experiences on promoting open source project management tools and consulting, I have seen so many teams failed, because of bad version control management. such as project postpone, fixed bugs reappear, can't locate bug in codes, no matter what version control system they used, open source or commercial.

Takes my company as a example, we are doing some open source projects customization services. In the begining, we use SVN (Subversion) for code management, but the vendor branch model is hard to use. More hacks we do, more difficulties it is to rebase onto new upstream version. We are confused at that time, then we meet with DVCS (distributed version control system).

My first attempt on DVCS is Hg (Mercurial), with the help of MQ (a Hg plugin). It works fine for our working model, but if two or more programmers involved in one project, conflicts on MQ patches make us crazy. Latter we tried Git with the help of Topgit, all problems gone.

...

Organization of this book
**************************

This book is divided into nine parts with 41 chapters and appendices.

Part 1 is an overview of Git, and it is divided into three chapters. In Chapter 1, is the overview of the history of version control systems. In Chapter 2, I show over 10 examples of Git, and I wish the readers could fall in love with Git for these highlights. Chapter 3 introduces the installation and configurations of Git in the three main platforms: Linux, Mac OS X and Windows. When I wrote this book, 70% of the time is under the Debian Linux operating system, so Linux users should have no obstacles for running the examples in this book. At the end of 2010, after learning that there will be a publisher give me money for the first print for this book, I asked for money from my wife AQiao and bought my first MacBook Pro, so there are the contents on Git usages on Mac and new Topgit hacks for Mac OS X. When cooperated with the editors of this book, I have to use MS Word, so part of the work is on Windows running as a VirtualBox virtual machine in Mac OS X. Even with limited resources, Git in Cygwin environment still works perfect.

Part 2 and Part 3 describes the basic operation of Git, and they are the foundation and core of the book, take up about 40% of this book. Why this two parts call 'Git Solo' and 'Git harmony'? The names are from my habits from my earlier training experiences for Subversion. 'SOLO' stands for working with version control by one self. 'Harmony' refers to working with version control as a team. In part 2, I mixed the Git magic (design principles) with the operations, because only know the truth (Git principle), people can use it freely (resolve Git puzzles). In part 3, introduces milestones, branches, and how to resolve conflicts, etc.

Part 4 talks about the working models of Git. In addition to the traditional centralized and distributed model, Chapter 22 introduces Topgit in detail, it will help hackers on other projects and for customization projects. In this chapter also describes some of my Topgit improvements, they are developed in Topgit way. Chapter 23-25 handle multiple repositories for one project. Chapter 25 describes an new innovate solution introduced by Android project, it named repo. I hacked to make repo works with Git server directly without the help of Gerrit. Chapter 26 introduces git-svn, with the help of git-svn, nobody knows the commit to SVN is from a Git user.

Part 5 is focus on Git server. In deed, this part is the first part I've written, because my customers need details in Gitolite set up, while my training PPT only provides outline, so comes with Chapter 30. Chapter 32 introduces Gerrit, a special central model for Git.

Chapter 6 describes the migration of Git repository. Chapter 34 shows details for CVS repositories migrate to Git repositories, and the chapter is also helpful for CVS to SVN. Other version control systems are also covered, such as SVN and Hg. Latter in this part, a Git to Git powerful tools is covered, it's git-filter-branch.

Part 7 introduces other applications of Git, such as etckeeper, Gistore, and others. I developed Gistore for files backup with the inspiration of etckeeper.

Part 8 covered miscellaneous features of Git. The first chapter in this part is helpful for cross platform team.

...

part 1: Meet Git
###################

Chapter 1: Version Control History
***********************************

1.1       The Dark Age                              [1]
=======================================================

The dark age wasn't so dark, there were `diff` and `patch` at least. In this section, diff and patch will be introduced by examples.

1.2       CVS -- Leads to SCM explosion             [4]
=======================================================

CVS history and CVS implement model.

  .. figure:: images/en/fig-01-01-cvs-arch.png
     :scale: 70

     Fig 1-1


1.3       SVN -- A superior central SCM             [6]
=======================================================

SVN history and SVN implement model.

  .. figure:: images/en/fig-01-02-svn-arch.png
     :scale: 70

     Fig 1-2


1.4       Git -- Second masterpiece by Linus        [9]
=======================================================

Git history.

Chapter 2: Fall in love with Git
***********************************

Git hightlights by examples.

2.1       Backup my work on a daily basis          [11]
=======================================================

During the writing of the book, everyday's work at the end of a day will be pushed to the server, then the pushed commits will be mirrored to a outside server in the data center automatically.

  .. figure:: images/en/fig-02-01-work-backup.png
     :scale: 65

     Fig 2-1


2.2       Works with others at diff. location      [12]
=======================================================

How I synchoronize my work between different locations during the writing of this book, such as at home and at my office. 

  .. figure:: images/en/fig-02-02-workflow.png
     :scale: 65

     Fig 2-2


2.3       On Site version control                  [13]
=======================================================

2.4       No control dir everywhere                [15]
=======================================================

One single .git directory, comparing with SVN's .svn in each subdirs.

Git has another useful command: `git grep`.

2.5       Rewrite commit log                       [16]
=======================================================

`git commit --amend`

2.6       Regrets                                  [16]
=======================================================

`git reset` and `git rebase -i`

2.7       Better change sets                       [17]
=======================================================

Stage works like commit change set.

2.8       Better differences                       [18]
=======================================================

`git diff --cached`

2.9       Save work progess                        [19]
=======================================================

`git stash`

2.10      Commit while traveling with git-svn      [20]
=======================================================

`git-svn`, nobody knows your commit throught git.

2.11      Pager everywhere                         [20]
=======================================================

No longer needs PIPE LESS ( `| less` ) after commands.

2.12      Fast                                     [21]
=======================================================

Smart protocol.


Chapter 3: Install Git
**************************

3.1       Install Git under Linux                  [23]
=======================================================

3.1.1        Install using pkg mgmt system         [23]
-------------------------------------------------------

3.1.2        Install from source code.             [24]
-------------------------------------------------------

3.1.3        Install from Git repository           [25]
-------------------------------------------------------

3.1.4        Bash completion                       [26]
-------------------------------------------------------

3.1.5        Chinese character support             [26]
-------------------------------------------------------

Works excellent in UTF8 environment, but may fail in other locales.

If Linux is in other locale, such as zh_CN.GBK, in this case :

* Commit log.

  Characters other then English CAN be used in commit log, only if do some proper settings. After add some proper settings, there will be a embed encoding directive in the commit object.

* Filename.

  CAN NOT use non-English characters as filename, because tree object is not encoded in UTF8.

3.2       Install Git under Mac OS X               [28]
=======================================================

3.2.1        Install from binary package           [28]
-------------------------------------------------------

3.2.2        Install Xcode.                        [29]
-------------------------------------------------------

Download Xcode is not rquired, as there was a copy in Mac OS X installer DVD already.

  .. figure:: images/en/fig-03-03-xcode-install.png
     :scale: 65

     Fig 3-3


3.2.3        Install using Homebrew                [30]
-------------------------------------------------------

3.2.4        Install from Git repository           [31]
-------------------------------------------------------

3.2.5        Bash completion                       [32]
-------------------------------------------------------

3.2.6        Install other utils                   [32]
-------------------------------------------------------

3.2.7        Chinese character support             [33]
-------------------------------------------------------

Works fine just like in Linux with UTF8 locale.

3.3       Install Git under Windows Cygwin         [33]
=======================================================

3.3.1        Install Cygwin.                       [34]
-------------------------------------------------------

In the case of lowbandwidth (like me), setting up a cygwin mirror with the help of apt-cacher-ng in Debian could be helpful.

  .. figure:: images/en/fig-03-07-cygwin-5-mirror.png
     :scale: 100

     Fig 3-7


3.3.2        Install Git                           [40]
-------------------------------------------------------

How to use cygwin package management program (setup.exe) --- to find and install git.

  .. figure:: images/en/fig-03-13-cygwin-8-search-git-install.png
     :scale: 100

     Fig 3-13


3.3.3        Cygwin configuration and usage        [42]
-------------------------------------------------------

3.3.4        Chinese characters support for Cygwin Git        [44]
------------------------------------------------------------------

Works fine, just like in linux with UTF8 locale.

3.3.5        SSH access for Cygwin Git             [45]
-------------------------------------------------------

Current cygwin's ssh doesn't work on some situations, in this section I will introduce how to integrate Cygwin Git with putty's plink or pagent.

3.4       Install Git under Windows msysGit        [51]
=======================================================

3.4.1        Install msysGit                       [51]
-------------------------------------------------------

3.4.2        msysGit configuration and usage       [54]
-------------------------------------------------------

3.4.3        Chinese language in msysGit shell     [55]
-------------------------------------------------------

3.4.4        Chinese language support for msysGit  [57]
-------------------------------------------------------

Insufficient support.

* Logs may work if `i18n.commitEncoding` and `i18n.logOutputEncoding` are set, but meanwhile other tools like TortoiseGit cannot show logs properly. 
* Chinese character cannot be used as filenames , because of characters in tree object are encoded in zh_CN.GBK, not UTF-8. 


3.4.5        Using SSH protocol                    [58]
-------------------------------------------------------

3.4.6        TortoiseGit Installation and usage    [58]
-------------------------------------------------------

3.4.7        Chinese language support for TortoiseGit       [62]
-----------------------------------------------------------------

As "bad" as msysGit, and it's log process is not compatible with msysGit.

Part 2: Git Solo
####################################

Play with Git by one self, so I call this part "Git solo".

Chapter 4: Git Initial
***********************************

4.1       Repository initial and the first commit  [63]
=======================================================

git init, git add, git commit...

4.2       Think out: why there is a .git directory?    [66]
===========================================================

Compare Git's .git directory with CVS's CVS directories, SVN's .svn directories, and StarTeam's server-side tracking implementations.

4.3       Think out: different git config level        [69]
===========================================================

Run `git config --system -e` to see where is your system config file.

4.4       Think out: who is commiting?                 [71]
===========================================================


4.5       Think out: change name freely, is it safe?   [73]
===========================================================

Setup user.name and user.email once, and make it stable.

For example Redmine will map the committer to one of it user accounts, if the committer username or email changed, the map will be broken.

  .. figure:: images/en/fig-04-01-redmine-user-config.png
     :scale: 60

     Fig 4-1

Another example is Gerrit, wrong user.name and user.email settings will make commits to Gerrit denied.

4.6       Think out: what is command alias?            [75]
===========================================================

4.7       Backup this chapter's work               [76]
=======================================================

Chapter 5: Git Stage
***********************************

5.1       Why modifications don't commit directly?   [77]
==========================================================

5.2       Understand Git Stage                     [83]
=======================================================



.. figure:: images/en/fig-05-01-git-stage.png
   :scale: 90

   Fig 5-1


5.3       Magic in Git Diff                        [86]
=======================================================

.. figure:: images/en/fig-05-02-git-diff.png
   :scale: 90

   Fig 5-2


5.4       Do not use git commit -a                 [90]
=======================================================

5.5       I'll be back                             [90]
=======================================================

git stage save.

Chapter 6: Git Objects
***********************************

6.1       Git object exploration                   [92]
=======================================================

Object database:

  .. figure:: images/en/fig-06-01-git-objects.png
     :scale: 90

     Fig 6-1

Git implementation detail:

  .. figure:: images/en/fig-06-02-git-repos-detail.png
     :scale: 90

     Fig 6-2



6.2       Think out: What is SHA1, how it generate?    [98]
===========================================================

6.3       Think out: commit IDs not a series of nums? [100]
===========================================================

Chapter 7: Git Reset
***********************************

7.1       Mystery of branch cursor                [103]
=======================================================

How git reset will affect branches, index and working directory.

  .. figure:: images/en/fig-07-01-git-reset.png
     :scale: 80

     Fig 7-1


7.2       Rollback incorrect reset using reflog   [105]
=======================================================

7.3       Deep into git reset                     [107]
=======================================================

Chapter 8: Git Checkout
***********************************

8.1       Checkout is HEAD reset                  [110]
=======================================================

How git checkout affect HEAD, index, and working directory.

  .. figure:: images/en/fig-08-01-git-checkout.png
     :scale: 80

     Fig 8-1


8.2       Detached HEAD                           [113]
=======================================================

8.3       Deep into git checkout                  [114]
=======================================================

Chapter 9: Restore Work Progress
***********************************

9.1       I'm back                                [117]
=======================================================

9.2       Use git stash                           [120]
=======================================================

9.3       Mystery in git stash                    [121]
=======================================================

Chapter 10: Basic Operation of Git
***********************************

10.1      Take a snap                             [128]
=======================================================

Take a snap using `git tag`.

10.2      Delete files                            [128]
=======================================================

10.3      Recover deleted files                   [132]
=======================================================

10.4      Move files                              [133]
=======================================================

10.5      Hello World program                     [135]
=======================================================

10.6      Add interactive: git add -i             [137]
=======================================================

10.7      Hello world: New problem                [140]
=======================================================

10.8      Ignoring Files                          [141]
=======================================================


Chapter 11: Travel within Git History
**************************************

11.1      gitk                                    [146]
=======================================================

11.2      gitg                                    [147]
=======================================================

11.3      qgit                                    [153]
=======================================================

11.4      Command line tools                      [158]
=======================================================

The following sections will use this Git repository:

  git://github.com/ossxp-com/gitdemo-commit-tree.git

View this git repository using gitg.

  .. figure:: images/en/fig-11-19-gitg-demo-commit-tree.png
     :scale: 80

     Fig 11-19

A more clear commit tree of this git repository.

  .. figure:: images/en/fig-11-20-commit-tree.png
     :scale: 100

     Fig 11-20


11.4.1      Revision presentation：git rev-parse  [160]
-------------------------------------------------------

Mark the commit tree with short commit ID, which is convenient for the following research on git rev-parse and git rev-list.

  .. figure:: images/en/fig-11-21-commit-tree-with-id.png
     :scale: 100

     Fig 11-21


11.4.2      Revision list：git rev-list           [163]
-------------------------------------------------------


11.4.3      git log                               [166]
-------------------------------------------------------

11.4.4      git diff                              [170]
-------------------------------------------------------

11.4.5      git blame                             [171]
-------------------------------------------------------

11.4.6      git bisect                            [172]
-------------------------------------------------------

Mark the commit tree with color for git bisect research. Note: red represents bad, and blue represents good.

  .. figure:: images/en/fig-11-22-commit-tree-bisect.png
     :scale: 100

     Fig 11-22


11.4.7      Get revison copy                      [177]
-------------------------------------------------------


Chapter 12: Change History
***********************************

12.1      Withdraw one step                       [178]
=======================================================

12.2      Withdraw multiple steps                 [181]
=======================================================

12.3      Back to future                          [182]
=======================================================

"Back to future" is my favorite movie. In this section I will show side effect of changing history, and how to change history using 3 different ways.

  .. figure:: images/en/fig-12-01-back-to-future.png
     :scale: 60

     Fig 12-1

This section contains 3 parts, and each part has 2 scenes.

* The current commit tree:

  .. figure:: images/en/fig-12-02-git-rebase-orig.png
     :scale: 100

     Fig 12-2

* Scene 1: change history (throw awy "bad" commit D) like the following commit tree using one type of time machine.

  .. figure:: images/en/fig-12-03-git-rebase-c.png
     :scale: 100

     Fig 12-3

* Scene 2: change history (merge commits C and D) like the commit tree below using another type of time machine.

  .. figure:: images/en/fig-12-04-git-rebase-cd.png
     :scale: 100

     Fig 12-4


12.3.1      Time machine v1                       [184]
-------------------------------------------------------

The first type of the time machine is `git cherry-pick` :

* After scene 1, the history looks like:

  .. figure:: images/en/fig-12-05-git-rebase-graph.png
     :scale: 80

     Fig 12-5

* After scene 2, the history looks like:

  .. figure:: images/en/fig-12-06-git-rebase-graph-gitk.png
     :scale: 90

     Fig 12-6


12.3.2      Time machine v2                       [189]
-------------------------------------------------------

The second type of time machine is `git rebase`.

12.3.3      Time machine v3                       [194]
-------------------------------------------------------

The third type of time machine is `git rebase -i`.

12.4      Throw away history                      [198]
=======================================================

Throw away history using `git commit-tree` and `git rebase`.

After threw away commits before commit A:

  .. figure:: images/en/fig-12-07-git-rebase-purge-history-graph.png
     :scale: 90

     Fig 12-7


12.5      Revert commit                           [200]
=======================================================

Chapter 13: Git Clone
***********************************

13.1      Eggs in different baskets               [203]
=======================================================

Don't put all your eggs in one basket. Create multiple baskets for your repository using `git clone`.

  .. figure:: images/en/fig-13-01-git-clone-pull-push.png
     :scale: 100

     Fig 13-1


13.2      Neighborhood workspace                  [204]
=======================================================

Exchange data between neighborhook workspace. `git pull` works but `git push` cause trouble.

  .. figure:: images/en/fig-13-02-git-clone-1.png
     :scale: 100

     Fig 13-2


13.3      Bare repository from clone              [208]
=======================================================

Clone as a bare repository, then exchange data with it. `git push` works for this case.

  .. figure:: images/en/fig-13-03-git-clone-2.png
     :scale: 100

     Fig 13-3


13.4      Bare repository from initial            [209]
=======================================================

Initiate a bare repository, then exchange data with it.

  .. figure:: images/en/fig-13-04-git-clone-3.png
     :scale: 100

     Fig 13-4


Chapter 14: You are Git Admin
***********************************

14.1      Where are objects and refs?             [213]
=======================================================

14.2      Temporary objects of stage operations   [215]
=======================================================

14.3      Trash objects from reset operation      [217]
=======================================================

14.4      Git housekeeper: git-gc                 [219]
=======================================================

14.5      Automatic Git housekeeper               [223]
=======================================================

When `git gc --auto` runs, git will check directory `.git/objects/17`, if there are over 27 loose objects in it.

Why using subdir "17", not others? I suppose Mr. Junio C Hamano show special respect to Linus as he's been elected as 17th most important person for the 20 century. Am I right?

Part 3: Git harmoney
####################################

This part will focus on multiple users' cooperation, so I call this part "Git harmoney".

Chapter 15: Git protocol and cooperation
**********************************************

How does the smart protocol work:

  .. figure:: images/en/fig-15-01-git-smart-protocol.png
     :scale: 100

     Fig 15-1


15.1      Git Protocol                            [225]
=======================================================

15.2      Cooperation simulat. with file protocol [227]
=======================================================

15.3      Force non-fast-forward push             [229]
=======================================================

15.4      Merge then push                         [233]
=======================================================

15.5      Disallow non-fast-forward push          [234]
=======================================================

Chapter 16: Resolve conflicts
***********************************

16.1      Merge during git pull                   [236]
=======================================================

When encounter a non-fast-forward push, a fetch-merge-push operation like the following should be done.

  .. figure:: images/en/fig-16-01-git-merge-pull-1.png
     :scale: 100

     Fig 16-1

  .. figure:: images/en/fig-16-02-git-merge-pull-2.png
     :scale: 100

     Fig 16-2

  .. figure:: images/en/fig-16-03-git-merge-pull-3.png
     :scale: 100

     Fig 16-3

  .. figure:: images/en/fig-16-04-git-merge-pull-4.png
     :scale: 100

     Fig 16-4


16.2      Merge lesson 1：merge automatically     [238]
=======================================================

16.2.1      Modify different files                [238]
-------------------------------------------------------

16.2.2      Modify different locations of one file [241]
--------------------------------------------------------

16.2.3      One change filename and other change contents  [242]
----------------------------------------------------------------

16.3      Merge lesson 2: logical conflicts       [244]
=======================================================

16.4      Merge lesson 3: resolve real conflicts  [245]
=======================================================

16.4.1      Resolve by hands                      [248]
-------------------------------------------------------

16.4.2      Resolve using GUI tools               [249]
-------------------------------------------------------

How to resolve conflict with the help of kdiff3.

  .. figure:: images/en/fig-16-05-kdiff3-1.png
     :scale: 80

     Fig 16-5

  .. figure:: images/en/fig-16-06-kdiff3-2.png
     :scale: 80

     Fig 16-6

  .. figure:: images/en/fig-16-07-kdiff3-3.png
     :scale: 80

     Fig 16-7

  .. figure:: images/en/fig-16-08-kdiff3-4.png
     :scale: 80

     Fig 16-8

  .. figure:: images/en/fig-16-09-kdiff3-5.png
     :scale: 80

     Fig 16-9


16.5      Merge lesson 4: tree conflict           [254]
=======================================================

When two commits both change the name of the same file, merge will end up with a conflict.
This section introduces how to resolve this kind of conflicts either by hands or by tools.

16.5.1      Resolve tree conflict by hands        [256]
-------------------------------------------------------

16.5.2      Resolve tree conflict interactively   [257]
-------------------------------------------------------

16.6      Merge Strategy                          [259]
=======================================================

16.7      Merge related configuration             [260]
=======================================================

Chapter 17: Git Milestone
***********************************

17.1      Show milestone                          [264]
=======================================================

17.2      Create milestone                        [266]
=======================================================

17.2.1      Lightweight tag                       [267]
-------------------------------------------------------

17.2.2      Tag with notes                        [268]
-------------------------------------------------------

17.2.3      Tag with signature                    [270]
-------------------------------------------------------

17.3      Delete milestones                       [273]
=======================================================

17.4      Do not change tags freely               [274]
=======================================================

17.5      Share milestones                        [274]
=======================================================

17.6      Delete remote milestones                [278]
=======================================================

17.7      Milestone naming rules                  [278]
=======================================================

Chapter 18: Git Branch
***********************************

18.1      Headache from branch management         [285]
=======================================================

The following examples are from my subversion training courses, but they also can be used for Git.


18.1.1      Release branch                        [286]
-------------------------------------------------------

Problem: bugfix without the help of release branch.

  .. figure:: images/en/fig-18-01-branch-release-branch-question.png
     :scale: 70

     Fig 18-1

Resolution: use release/bugfix branch.

  .. figure:: images/en/fig-18-02-branch-release-branch-answer.png
     :scale: 70

     Fig 18-2


18.1.2      Feature branch                        [288]
-------------------------------------------------------

Problem: features developments mixed in one branch could cause chaos and withdraw some features also cause headache.

  .. figure:: images/en/fig-18-03-branch-feature-branch-question.png
     :scale: 70

     Fig 18-1

Resolution: use feature branches to seperate each feature development.

  .. figure:: images/en/fig-18-04-branch-feature-branch-answer.png
     :scale: 70

     Fig 18-4


18.1.3      Vendor branch                         [290]
-------------------------------------------------------

Problem: hacks against other project using vendor branch.

  .. figure:: images/en/fig-18-05-branch-vendor-branch.png
     :scale: 100

     Fig 18-5

Resolution: Git with the help of Topgit. Talk about it later.

18.2      Overview of git branch command          [291]
=======================================================

18.3      Hello World Project                     [291]
=======================================================

18.4      Develop based on feature branch         [293]
=======================================================

18.4.1      Create branch: user1/getopt           [293]
-------------------------------------------------------

18.4.2      Create branch: user2/i18n             [295]
-------------------------------------------------------

After user2 create user2/i18n branch, the repository looks like:

  .. figure:: images/en/fig-18-06-branch-i18n-initial.png
     :scale: 100

     Fig 18-6


18.4.3      Developer user1 complete              [296]
-------------------------------------------------------

18.4.4      Merge user1/getopt to master          [298]
-------------------------------------------------------

18.5      Develop based on release branch         [299]
=======================================================

18.5.1      Create release branch                 [299]
-------------------------------------------------------

18.5.2      Developer user1 works in release br.  [301]
-------------------------------------------------------

18.5.3      Developer user2 works in release br.  [302]
-------------------------------------------------------

18.5.4      Developer user2 merge and push        [303]
-------------------------------------------------------

18.5.5      Release branch fixes to master        [305]
-------------------------------------------------------

18.6      Rebase                                  [309]
=======================================================

18.6.1      Feature branch user2/i18n complete    [309]
-------------------------------------------------------

When user2 finished the development of the feature in branch user2/i18n, master branch also had some commits. The repository looks like:

  .. figure:: images/en/fig-18-07-branch-i18n-complete.png
     :scale: 100

     Fig 18-7


18.6.2      Branch user2/i18n rebase              [311]
-------------------------------------------------------

If branch user2/i18n merges with master, there will be a new commit (merge commit), which adds more code review tasks. The repository after merge looks like:

  .. figure:: images/en/fig-18-08-branch-i18n-merge.png
     :scale: 100

     Fig 18-8

Rebase before push at some situations is hightly recommended. The repository after rebase would look like:

  .. figure:: images/en/fig-18-10-branch-i18n-rebase.png
     :scale: 100

     Fig 18-10


Chapter 19: Remote repository
***********************************

19.1      Remote branch                           [320]
=======================================================

19.2      Branch tracking                         [323]
=======================================================

19.3      Remote repository                       [326]
=======================================================

19.4      PUSH, PULL with remote repository       [329]
=======================================================

19.5      Tag and remote repository               [331]
=======================================================

19.6      Branch and tag security                 [331]
=======================================================

Chapter 20: Works with patches
***********************************

20.1      Create patches                          [333]
=======================================================

20.2      Apply patches                           [335]
=======================================================

20.3      StGit and Quilt                         [337]
=======================================================

20.3.1      StGit                                 [337]
-------------------------------------------------------

20.3.2      Quilt                                 [341]
-------------------------------------------------------


Part 4: Git model
####################################

Chapter 21: Classic Git Model
***********************************

21.1      Central Cooperation Model               [343]
=======================================================

Central cooperation model: multiple users works with one shared repository.

  .. figure:: images/en/fig-21-01-central-model.png
     :scale: 100

     Fig 21-1


21.1.1      Work with central model               [345]
-------------------------------------------------------

Work flow 1: all users work on one branch in the shared repository.

  .. figure:: images/en/fig-21-02-central-model-workflow-1.png
     :scale: 80

     Fig 21-2

Work flow 2: each person create his/her own branch, then merge into master branch.

  .. figure:: images/en/fig-21-03-central-model-workflow-2.png
     :scale: 80

     Fig 21-3


21.1.2      Special cental model: Gerrit          [346]
-------------------------------------------------------

Discuss Gerrit later.

21.2      Pyramid Cooperation Model               [347]
=======================================================

Distributed Model looks like a pyramid hierarchy:

  .. figure:: images/en/fig-21-04-distrabute-model.png
     :scale: 100

     Fig 21-4


21.2.1      Contributer open readonly repository  [348]
-------------------------------------------------------

21.2.2      Contribute using patches              [349]
-------------------------------------------------------

Chapter 22: Topgit Model
***********************************

22.1      Three SCM Milestone of Myself           [351]
=======================================================

Three SCM milestones of myself for the past several years:

1. SVN + vendor branch.

  works like:

  .. figure:: images/en/fig-22-01-topgit-branch-vendor-branch.png
     :scale: 100

     Fig 22-1

2. Hg + MQ

3. Git + Topgit


22.2      Mystery of Topgit                       [353]
=======================================================

When using Git+Topgit hacks other projects, the feature branches may look like:

  .. figure:: images/en/fig-22-02-topgit-topic-branch.png
     :scale: 100

     Fig 22-2

And there wll be a base branch for each feature branch, all the topic base branches look like:

  .. figure:: images/en/fig-22-03-topgit-topic-base-branch.png
     :scale: 100

     Fig 22-3


22.3      Topgit Installation                     [354]
=======================================================

22.4      Topgit Usage                            [355]
=======================================================


22.5      Hack Topgit in Topgit way               [367]
=======================================================

I hacked Topgit in Topgit way, all the topgit features look like:

  .. figure:: images/en/fig-22-05-topgit-hacks.png
     :scale: 80

     Fig 22-5

URL of my hacked topgit: http://github.com/ossxp-com/topgit


22.6      Notes of Topgit                         [372]
=======================================================

Chapter 23: Submodule Model
***********************************

23.1      Create Submodule
=======================================================

23.2      Clone repository with submodule         [377]
=======================================================

23.3      Work inside submodule and update        [378]
=======================================================

23.4      Hidden submodule                        [381]
=======================================================

23.5      Submodule management                    [384]
=======================================================

Chapter 24: Subtree merge
***********************************

24.1      Import external repository              [386]
=======================================================

24.2      Subtree merge                           [388]
=======================================================

24.3      Track upstream with subtree merge       [391]
=======================================================

24.4      Subtree split                           [392]
=======================================================

24.5      git-subtree Plugin                      [392]
=======================================================

Chapter 25: Android Multiple repositories Cooperation
******************************************************

25.1      About repo                              [396]
=======================================================

Workflow of repo:

  .. figure:: images/en/fig-25-01-repo-workflow.png
     :scale: 90

     Fig 25-1


25.2      Install repo                            [397]
=======================================================

25.3      repo and manifest initial               [398]
=======================================================

25.4      Manifest repository and manifest file   [400]
=======================================================

25.5      Sync projects                           [401]
=======================================================

25.6      Setup Android repositories mirror       [402]
=======================================================

25.7      Repo commands                           [405]
=======================================================

25.8      Repo Workflow                           [412]
=======================================================

25.9      Use repo in your project                [412]
=======================================================

25.9.1      Model 1: Repo with Gerrit             [412]
-------------------------------------------------------

25.9.2      Model 2: Repo without Gerrit          [413]
-------------------------------------------------------

25.9.3      Model 3: Improved Repo without Gerrit [414]
-------------------------------------------------------

I hacked repo, and the improved repo can work directly with Git repository without the control of Gerrit.

URL of my hacked repo : http://github.com/ossxp-com/repo


Chapter 26: Git-SVN Model
***********************************

26.1      git-svn workflow                        [423]
=======================================================

Workflow of git-svn:

  .. figure:: images/en/fig-26-01-git-svn-workflow.png
     :scale: 90

     Fig 26-1


26.2      Mystery of git-svn                      [430]
=======================================================

26.2.1      Git config and references extension   [430]
-------------------------------------------------------

26.2.2      Map between Git and SVN branches      [432]
-------------------------------------------------------

26.2.3      Other auxiliary files                 [434]
-------------------------------------------------------

26.3      Various git-svn clone methods           [434]
=======================================================

26.4      Share git-svn clone with others         [437]
=======================================================

26.5      Limitation of git-svn                   [439]
=======================================================


Part 5: Git Server
####################################

Chapter 27: Using HTTP Protocol
***********************************

27.1      Dumb HTTP protocol                      [440]
=======================================================

27.2      Smart HTTP protocol                     [443]
=======================================================

27.3      Gitweb                                  [445]
=======================================================

27.3.1      Install Gitweb                        [445]
-------------------------------------------------------

27.3.2      Gitweb configuration                  [446]
-------------------------------------------------------

27.3.3      Repository settings for Gitweb        [447]
-------------------------------------------------------


Chapter 28: Using Git Protocol
***********************************

28.1      Git protocol                            [449]
=======================================================

28.2      Run Git protocol using inetd            [449]
=======================================================

28.3      Run Git protocol using runit            [450]
=======================================================

Chapter 29: Using SSH Protocol
***********************************

29.1      SSH protocol                            [452]
=======================================================

29.2      SSH services seteup comparation         [452]
=======================================================

29.3      SSH public key authentication           [454]
=======================================================

29.4      SSH host configuration                  [455]
=======================================================

Chapter 30: Gitolite
***********************************

My hacked Gitolite is at: http://github.com/ossxp-com/gitolite

30.1      Install Gitolite                        [458]
=======================================================

30.1.1      Create special account on server      [458]
-------------------------------------------------------

30.1.2      Gitolite Install and upgrade          [459]
-------------------------------------------------------

30.1.3      About SSH host alias                  [462]
-------------------------------------------------------

30.1.4      Other install methods                 [463]
-------------------------------------------------------

30.2      Gitolite Admin                          [464]
=======================================================

30.2.1      Clone gitolite-admin repository       [464]
-------------------------------------------------------

30.2.2      Add new users                         [465]
-------------------------------------------------------

30.2.3      Authorizations                        [467]
-------------------------------------------------------

30.3      Gitolite authorization detail           [468]
=======================================================

30.3.1      Authorization rules                   [468]
-------------------------------------------------------

30.3.2      Define user and repository groups     [469]
-------------------------------------------------------

30.3.3      Repository ACL                        [470]
-------------------------------------------------------

30.3.4      Gitolite implementation               [472]
-------------------------------------------------------

30.4      Repository authorization cases          [473]
=======================================================

30.4.1      Authorize for whole repository        [473]
-------------------------------------------------------

30.4.2      Authorize for wildcard repository     [474]
-------------------------------------------------------

30.4.3      Users owned repository                [475]
-------------------------------------------------------

30.4.4      Auth for refs: classic model          [476]
-------------------------------------------------------

30.4.5      Auth for refs: extension model        [477]
-------------------------------------------------------

30.4.6      Auth for refs: deny rules             [478]
-------------------------------------------------------

30.4.7      Branch in user namespace              [478]
-------------------------------------------------------

30.4.8      Authorization for path based write    [479]
-------------------------------------------------------

30.5      Create new repository                   [479]
=======================================================

30.5.1      Create after update admin repository  [480]
-------------------------------------------------------

30.5.2      Push to create                        [481]
-------------------------------------------------------

30.5.3      Create directly on server             [482]
-------------------------------------------------------

30.6      Gitolite Hacks                          [483]
=======================================================

My hacked Gitolite is at: http://github.com/ossxp-com/gitolite


30.7      Other Gitolite features                 [483]
=======================================================

30.7.1      Repositories mirror                   [483]
-------------------------------------------------------

30.7.2      Gitweb and Git daemon integration     [486]
-------------------------------------------------------

30.7.3      Other features and references         [487]
-------------------------------------------------------

Chapter 31: Gitosis
***********************************

My hacked Gitosis is at: http://github.com/ossxp-com/gitosis

31.1      Install Gitosis                         [490]
=======================================================

31.1.1      Installation                          [490]
-------------------------------------------------------

31.1.2      Setup special user account            [491]
-------------------------------------------------------

31.1.3      Initial Gitosis serivces              [491]
-------------------------------------------------------

31.2      Gitosis administration                  [492]
=======================================================

31.2.1      Clone gitolit-admin repository        [492]
-------------------------------------------------------

31.2.2      Add new user                          [493]
-------------------------------------------------------

31.2.3      Authorizations                        [494]
-------------------------------------------------------

31.3      Gitosis authorization detail            [495]
=======================================================

31.3.1      Gitosis default configurations        [495]
-------------------------------------------------------

31.3.2      Adminstration of gitosis-admin repos  [496]
-------------------------------------------------------

31.3.3      Define user groups and authoriztions  [496]
-------------------------------------------------------

31.3.4      Gitweb integration                    [498]
-------------------------------------------------------

31.4      Create new repository                   [498]
=======================================================

31.5      Light-weight service setup              [499]
=======================================================

Chapter 32: Gerrit
***********************************

32.1      Mystery of Gerrit                       [502]
=======================================================

32.2      Setup Gerrit server                     [506]
=======================================================

32.3      Gerrit configurations                   [512]
=======================================================

32.4      Access Gerrit database                  [513]
=======================================================

32.5      Register as Gerrit administrator        [515]
=======================================================

32.6      Access SSH admin interface              [518]
=======================================================

32.7      Setup new project                       [520]
=======================================================

32.8      Import Git repository                   [524]
=======================================================

32.9      Setup review workflow                   [526]
=======================================================

32.10        Work with Gerrit                     [529]
=======================================================

32.10.1    Developer works in local repos         [530]
-------------------------------------------------------

32.10.2    Push to Gerrit server                  [531]
-------------------------------------------------------

32.10.3    Review new submit changeset            [531]
-------------------------------------------------------

32.10.4    Review task tests failed               [534]
-------------------------------------------------------

32.10.5    Resend review task                     [536]
-------------------------------------------------------

32.10.6    New review changeset tests passed      [537]
-------------------------------------------------------

.. figure:: images/en/fig-32-28-gerrit-review-9-review-patchset-merged.png
   :scale: 80

   Fig 32-28: review task after publish


32.10.7    Update from remote server              [539]
-------------------------------------------------------

32.11        More Gerrit references               [540]
=======================================================

Chapter 33: Git Hosting
***********************************

33.1      Github                                  [541]
=======================================================

33.2      Gitorious                               [543]
=======================================================


Part 6: Migrate to Git
####################################

Chapter 34: CVS to Git
***********************************

34.1      Install cvs2svn（including cvs2git）    [546]
=======================================================

34.1.1      Install cvs2svn under Linux           [546]
-------------------------------------------------------

34.1.2      Install cvs2svn under Mac OS X        [547]
-------------------------------------------------------

34.2      Preparations for repository migration   [547]
=======================================================

34.3      Repository migration                    [550]
=======================================================

34.4      Postcheck after migration               [555]
=======================================================

Chapter 35: Others SCM Migration
***********************************

35.1      SVN to Git                              [557]
=======================================================

35.2      Hg to Git                               [558]
=======================================================

35.3      Git fast-import                         [561]
=======================================================

35.4      Git repository refactor                 [567]
=======================================================

35.4.1      Environment filter                    [569]
-------------------------------------------------------

35.4.2      Tree filter                           [570]
-------------------------------------------------------

35.4.3      Index filter                          [570]
-------------------------------------------------------

35.4.4      Parent filter                         [570]
-------------------------------------------------------

35.4.5      Message filter                        [571]
-------------------------------------------------------

35.4.6      Commit filter                         [571]
-------------------------------------------------------

35.4.7      Tag name filter                       [573]
-------------------------------------------------------

35.4.8      Subdirectory filter                   [573]
-------------------------------------------------------


Part 7: Git Other Usage
####################################

Chapter 36: etckeeper
***********************************

36.1      Install etckeeper                       [575]
=======================================================

36.2      Configure etckeeper                     [575]
=======================================================

36.3      Use etckeeper                           [576]
=======================================================

Chapter 37: Gistore
***********************************

Gistore = Git + Store.

Gistore is a backup tool based on Git. I contribute the code at http://github.com/ossxp-com/gistore.

37.1      Install Gistore                         [577]
=======================================================

37.1.1      Install Gistore from source           [577]
-------------------------------------------------------

37.1.2      Install Gistore using easy_install    [578]
-------------------------------------------------------

37.2      Use Gistore                             [579]
=======================================================

37.2.1      Create backup repository              [580]
-------------------------------------------------------

37.2.2      Gistore configuration                 [580]
-------------------------------------------------------

37.2.3      Gistore backup item management        [582]
-------------------------------------------------------

37.2.4      Run backup task                       [583]
-------------------------------------------------------

37.2.5      View backup log                       [583]
-------------------------------------------------------

37.2.6      View and restore backup database      [585]
-------------------------------------------------------

37.2.7      Backup rollback and settings          [586]
-------------------------------------------------------

37.2.8      Register backup task alias            [588]
-------------------------------------------------------

37.2.9      Backup using crontab                  [588]
-------------------------------------------------------

37.3      Mirroring Gistore backup repository     [589]
=======================================================

Chapter 38: Patch file binary extension
************************************************

38.1      Binary support for Git repository       [590]
=======================================================

38.2      Binary support for common directory     [594]
=======================================================

38.3      Git style diff support in other tools   [596]
=======================================================

Chapter 39: Cloud storage
***********************************

39.1      Current cloud storage problem           [598]
=======================================================

39.2      Features of Git style cloud storage     [599]
=======================================================


Part 8: MISC
####################################

Chapter 40: Cross OS Git operation
***********************************

This figure is from http://www.survs.com/results/33Q0OZZE/MV653KSPI2.

  .. figure:: images/en/fig-40-1-git-survs-os.png
     :scale: 80

     Fig 40-1


40.1      Character set problems                  [602]
=======================================================

How to use non-English character in commit log and as filename.

40.2      Filename Case sensitive and insens.     [603]
=======================================================

Cross platform project, should set `core.ignorecase` to true after `git clone`.

40.3      End of line problems                    [604]
=======================================================

Two type of EOL: LF and CR+LF.


Chapter 41: Git special features
***********************************

41.1      Attributes                              [609]
=======================================================

41.1.1      Attributes defination                 [609]
-------------------------------------------------------

41.1.2      Attribute files and file priority     [610]
-------------------------------------------------------

41.1.3      Common attributes                     [612]
-------------------------------------------------------

41.2      Hooks and templates                     [619]
=======================================================

41.2.1      Git hooks                             [619]
-------------------------------------------------------

41.2.2      Git templates                         [625]
-------------------------------------------------------

41.3      Sparse checkout and shallow clone       [626]
=======================================================

41.3.1      Sparse checkout                       [626]
-------------------------------------------------------

41.3.2      Shallow clone                         [629]
-------------------------------------------------------

41.4      Grafts and replace                      [631]
=======================================================

41.4.1      Git grafts                            [631]
-------------------------------------------------------

41.4.2      Git replace                           [632]
-------------------------------------------------------

41.5      Git Notes                               [633]
=======================================================

Git notes used in github.com:

  .. figure:: images/en/fig-41-1-github-notes.png
     :scale: 70

     Fig 41-1


41.5.1      Mystery of git notes                  [634]
-------------------------------------------------------

41.5.2      Git notes subcommands                 [637]
-------------------------------------------------------

41.5.3      Git notes related configuration       [638]
-------------------------------------------------------


Part 9: Appendix
####################################

Git Commands Index
************************

Git and CVS, face to face
******************************

Git and SVN, face to face
******************************

Git and Hg, face to face
******************************
