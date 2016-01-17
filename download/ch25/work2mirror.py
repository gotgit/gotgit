#!/usr/bin/python
# -*- coding: utf-8 -*-

import os, sys, shutil

cwd = os.path.abspath( os.path.dirname( __file__ ) )
repodir = os.path.join( cwd, '.repo' )
S_repo = 'repo'
TRASHDIR = 'old_work_tree'

if not os.path.exists( os.path.join(repodir, S_repo) ):
    print >> sys.stderr, "Must run under repo work_dir root."
    sys.exit(1)

sys.path.insert( 0, os.path.join(repodir, S_repo) )
from manifest_xml import XmlManifest

manifest = XmlManifest( repodir )

if manifest.IsMirror:
    print >> sys.stderr, "Already mirror, exit."
    sys.exit(1)

trash = os.path.join( cwd, TRASHDIR )

for project in manifest.projects.itervalues():
    # 移动旧的版本库路径到镜像模式下新的版本库路径
    newgitdir = os.path.join( cwd, '%s.git' % project.name )
    if os.path.exists( project.gitdir ) and project.gitdir != newgitdir:
        if not os.path.exists( os.path.dirname(newgitdir) ):
            os.makedirs( os.path.dirname(newgitdir) )
        print "Rename %s to %s." % (project.gitdir, newgitdir)
        os.rename( project.gitdir, newgitdir )

    # 移动工作区到待删除目录
    if project.worktree and os.path.exists( project.worktree ):
        newworktree = os.path.join( trash, project.relpath )
        if not os.path.exists( os.path.dirname(newworktree) ):
            os.makedirs( os.path.dirname(newworktree) )
        print "Move old worktree %s to %s." % (project.worktree, newworktree )
        os.rename( project.worktree, newworktree )

    if os.path.exists ( os.path.join( newgitdir, 'config' ) ):
        # 修改版本库的配置
        os.chdir( newgitdir )
        os.system( "git config core.bare true" )
        os.system( "git config remote.korg.fetch '+refs/heads/*:refs/heads/*'" )

        # 删除 remotes 分支，因为作为版本库镜像不需要 remote 分支
        if os.path.exists ( os.path.join( newgitdir, 'refs', 'remotes' ) ):
            print "Delete " + os.path.join( newgitdir, 'refs', 'remotes' )
            shutil.rmtree( os.path.join( newgitdir, 'refs', 'remotes' ) )

# 设置 menifest 为镜像
mp = manifest.manifestProject
mp.config.SetString('repo.mirror', 'true')


