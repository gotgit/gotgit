<?xml version="1.0" encoding="UTF-8"?>
<map version="0.9.0">
<!-- This file is saved using a hacked version of FreeMind. visit: http://freemind-mmx.sourceforge.net -->
<!-- Orignal FreeMind, can download from http://freemind.sourceforge.net -->
<!-- This .mm file is CVS/SVN friendly, some atts are saved in .mmx file. (from ossxp.com) -->
<node COLOR="#000000" ID="ID_1688594004" 
	TEXT="gitbook&#xa;Git —— Door to the source&#xa;Git —— 通往源码之门">
<font NAME="Serif" SIZE="20"/>
<hook NAME="accessories/plugins/AutomaticLayout.properties"/>
<node COLOR="#0033ff" FOLDED="true" ID="ID_624306737" POSITION="right" 
	TEXT="书名">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" ID="ID_1092174402" 
	TEXT="gitbook&#xa;">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_1193189333" 
	TEXT="Git —— Door to the source&#xa;">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_1203888572" 
	TEXT="Git —— 通往源码之门">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_1049630472" POSITION="right" 
	TEXT="Linus 和 Git">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" ID="ID_1082274457" LINK="http://lkml.org/lkml/2005/4/8/9" 
	TEXT="lkml.org &gt; Lkml &gt; 2005 &gt; 4 &gt; 8 &gt; 9">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_122262429" 
	TEXT="                 ... It&apos;s not an SCM, it&apos;s a distribution and archival mechanism.  I bet you could make a reasonable SCM on top of it, though. Another way of looking at it is to say that it&apos;s really a content- addressable filesystem, used to track directory trees.">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_956365897" 
	TEXT="git is first and foremost a toolkit for writing VCS systems.">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_1873664526" POSITION="right" 
	TEXT="Git 单用户（solo）">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" FOLDED="true" ID="ID_292223221" 
	TEXT="Git 安装，讲述一下 git-command 和 git command 的历史渊源">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1480335390" 
	TEXT="老版本库的 Git ，是由一系列 git-command 命令组成的">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1364073742" 
	TEXT="好处是可以 tab 扩展">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1417387093" 
	TEXT="现在都封装在 git 命令中，调用 lib 下的 git-command">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_960656006" 
	TEXT="命令扩展也使用其它方式实现。">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_704007085" 
	TEXT="创建版本库如此简单">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1843077483" 
	TEXT="git init -&gt; git add -&gt; git ci">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_542215588" 
	TEXT="相比之下 svn 要使用不同工具，而且步骤还多： &#xa;svnadmin create -&gt; svn co -&gt; svn add -&gt; svn ci">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_982584316" 
	TEXT="意味着 git 命令本身就能够完成建库，提交的操作。不像其它版本库要分别使用不同的工具。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1385414587" 
	TEXT="如果你知道 ci 意味着 commit 或者 checkin，说明你已经有了足够多版本控制的经验。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1710798370" 
	TEXT="操作">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1892831577" 
	TEXT="git init: 创建版本库: 一条命令即可： git init">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_10862766" 
	TEXT="git add:">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_119273997" 
	TEXT="git ci:">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_23993051" 
	TEXT="git config: who are you">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1746332684" 
	TEXT="第一次提交引出的事">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_985533107" 
	TEXT="版本库和工作区在一起">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1263265365" 
	TEXT="各个版本控制系统，如何对工作区文件追踪">
<node COLOR="#111111" ID="ID_597170936" 
	TEXT="CVS 的特点： Entries 文件只记录本地文件的原始版本，没有内容。在提交的时候变更文件全部传输。"/>
<node COLOR="#111111" ID="ID_1773992798" 
	TEXT="SVN 的特点： 本地拥有一套完整的原始拷贝，这样提交的时候是 DELTA。"/>
<node COLOR="#111111" ID="ID_452460001" 
	TEXT="Starteam ：本地非常干净，nothing。服务器端进行跟踪，缺点是工作区目录更换或者操作系统重装，本地工作区的状态变为 Unknown，就是不知道服务器端的新，还是本地版本库新。"/>
<node COLOR="#111111" ID="ID_1714659849" 
	TEXT="Git 是一个 .git 目录，包含所有的数据，能够保证提交。。。"/>
<node COLOR="#111111" ID="ID_1506886601" 
	TEXT="不安全？ 当在后面看到克隆的章节，你就会直到有多安全了。&#xa;在写到这里的时候，我执行了：&#xa;git commit -m &quot;...&quot;&#xa;git push"/>
</node>
<node COLOR="#111111" ID="ID_1444487070" 
	TEXT="安全么？"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1820297000" 
	TEXT="是谁在提交">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_973970602" 
	TEXT="在之前我们提交的时候，警告用户没有设置">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_94490236" 
	TEXT="git config: who are you">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_584263022" 
	TEXT="然后我们看到提交日志中提交者 ID">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_133341825" 
	TEXT="可以随便修改COMMITOR 的 ID，这样操作是不是太随意了？ ">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_710169020" 
	TEXT="实际上有两个 ID，一个是 Auhor ID，一个是 Commit ID">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1096076984" 
	TEXT="Redmine 或者其它软件，要依靠 AuthorID 还是 Commit ID 建立用户映射，所以不要太随意了。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1274299345" 
	TEXT="Gerrit 软件，要要求提交的 CommitID 和认证用户的 email 进行比对，不允许随便使用邮件地址。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_675699123" 
	TEXT="有时我们要把补丁交给上游提交，会不会把作者信息丢失？ commit -s 。以及 Author ID 是否保持？">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_368253909" 
	TEXT="每次操作都要输入 -s 参数？ 别忘了别名。实际上 ci 也是 commit 的别名"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1644431487" 
	TEXT="命令别名">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_361541343" 
	TEXT="为什么没有 ci 命令？以及如何建立别名？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_113517486" 
	TEXT="为了不让提交日志变得太过臃肿，以免浪费更多的纸张和读者金钱，我在后面的演示中，都没有用到 -s ，以便让日志变得短小些。">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1457813025" 
	TEXT="git config 命令揭密">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_807991474" 
	TEXT="为什么前面出现 --global, --system ？">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_944003558" 
	TEXT="git config 缺省操作的三个 INI 文件。系统，用户级，版本库级">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_845868289" 
	TEXT="Git config: 通过环境变量设定，修改任意 INI 文件。参考 git-svn ">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1912771033" 
	TEXT="Git 库一定会比工作区大么？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_641031184" 
	TEXT="这个章节的题目可能有问题。你可能会说前几次提交由于版本库的文件压缩存储肯定要小，但长久来看是要大。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1465126220" 
	TEXT="我做一个颠覆你相像的操作。">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_910190138" 
	TEXT="一个大文件加入版本库">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1702602234" 
	TEXT="多个大文件加入版本库">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1424592507" 
	TEXT="Git 库的文件大小">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_181884990" 
	TEXT="这是为什么呢？">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1185169170" 
	TEXT="Git 是对内容进行跟踪，而非文件"/>
<node COLOR="#111111" ID="ID_773514279" 
	TEXT="不同文件只要内容相同，Git 库中的存储就是一个样"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1912474813" 
	TEXT="看看 Git 中的对象存储">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_764237996" 
	TEXT="blob"/>
<node COLOR="#111111" ID="ID_1507216590" 
	TEXT="tree"/>
<node COLOR="#111111" ID="ID_1984752119" 
	TEXT="commit"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1859556690" 
	TEXT="查看提交日志">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_645845907" 
	TEXT="提交编号 40 位 HASH">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1174815863" 
	TEXT="全局 ID 和全球 ID">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_137212180" 
	TEXT="SVN 是全局 ID，Hg 的递增版本库号，也是全局版本号（版本库范围内）"/>
<node COLOR="#111111" ID="ID_342617326" 
	TEXT="全球版本库号，源自 SHA1 算法"/>
<node COLOR="#111111" ID="ID_116337544" 
	TEXT="SHA1 哈希算法介绍以及冲突的可能性概率计算。"/>
</node>
<node COLOR="#990000" ID="ID_1043558081" 
	TEXT="执行 git log --graph 可以看到图形化的提交说明">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_405856168" 
	TEXT="这个图有个术语叫做 DAG，有向非环图。和 Subversion 的单向直线图不同。">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1562209254" 
	TEXT="画一下 Subversion 的单向图"/>
<node COLOR="#111111" ID="ID_459395000" 
	TEXT="画一下 Git 的DAG"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_262865429" 
	TEXT="现在的log 中显示的 DAG 太简单了，如何出现分叉？">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_727292959" 
	TEXT="git checkout xxx"/>
<node COLOR="#111111" ID="ID_1066530875" 
	TEXT="hack hack"/>
<node COLOR="#111111" ID="ID_907197904" 
	TEXT="git commit"/>
<node COLOR="#111111" ID="ID_107406814" 
	TEXT="git checkout master"/>
<node COLOR="#111111" ID="ID_907440231" 
	TEXT="git merge n"/>
</node>
<node COLOR="#990000" ID="ID_477153885" 
	TEXT="git  log --stat 可以看到更改信息">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_987877181" 
	TEXT="git log --pretty=oneline 可以看到精简提交日志">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_256019094" 
	TEXT="git log --pretty=fuller 可以看到真相">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_248303804" 
	TEXT="修改和提交">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1450380777" 
	TEXT="修改包括：编辑，删除，重命名">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1573325640" 
	TEXT="如何提交？ git add">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_373068541" 
	TEXT="关于 Stage 的故事">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_617927665" 
	TEXT="Multiple stage: stash">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_578368319" 
	TEXT="我们知道 stage 的内容已经加入到 Git 对象库里了，但是由于没有提交，因此暂存区是不稳定的可以随时用 git reset 命令撤销。">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_570563852" 
	TEXT="撤销操作">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1296515440" 
	TEXT="如果 git add 和 git rm 操作尚未提交，如何撤销？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_774476671" 
	TEXT="但是第一次建库，不是这么操作的，而要 git rm --cached ">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_339684205" 
	TEXT="撤销已经提交的操作。git reset ， --soft, --hard, ...">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_771150047" 
	TEXT="最新提交的撤销： git ci --amend">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1128240825" 
	TEXT="提交撤销的原理：分支游标">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1629350594" 
	TEXT="分支是 refs/heads 下的文件（引用）"/>
<node COLOR="#111111" ID="ID_1239615245" 
	TEXT="引用指向一个提交"/>
<node COLOR="#111111" ID="ID_879042389" 
	TEXT="分支的历史是和相关的。"/>
</node>
</node>
<node COLOR="#00b439" ID="ID_1758115602" 
	TEXT="Tag 和分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_180033128" POSITION="right" 
	TEXT="Git 命令索引">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" ID="ID_28351420" 
	TEXT="git add">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_435176842" 
	TEXT="git commit">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_9244198" 
	TEXT="git log">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_217477366" 
	TEXT="git ">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_705771263" POSITION="right" 
	TEXT="Git 安装">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" FOLDED="true" ID="ID_1536404812" 
	TEXT="源码">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1213896275" 
	TEXT="  $ make configure ;# as yourself&#xa;  $ ./configure --prefix=/usr ;# as yourself&#xa;  $ make all doc ;# as yourself&#xa;  # make install install-doc install-html;# as root&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_179605721" POSITION="right" 
	TEXT="Git 命令">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" ID="ID_1469239031" 
	TEXT="cherry-pick 相当于？">
<edge STYLE="bezier" WIDTH="thin"/>
<arrowlink DESTINATION="ID_1058278190" ENDARROW="Default" ENDINCLINATION="83;0;" ID="Arrow_ID_1065913453" STARTARROW="None" STARTINCLINATION="83;0;"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1058278190" 
	TEXT="format-patch, am">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1808607422" 
	TEXT="gerrit-cherry-pick 代码">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_45902321" 
	TEXT="    read commit changeid &lt;&quot;$TODO&quot;&#xa;    git rev-parse HEAD^0 &gt;&quot;$STATE/head_before&quot;&#xa;    git format-patch \&#xa;        -k --stdout --full-index --ignore-if-in-upstream \&#xa;        $commit^..$commit |&#xa;    git am $git_am_opt --rebasing --resolvemsg=&quot;$RESOLVEMSG&quot; || exit&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_1921897980" POSITION="right" 
	TEXT="Git 使用">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" ID="ID_930503296" 
	TEXT="gerrit/Document/user-signedoffby.html">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_408637332" POSITION="right" 
	TEXT="git-svn">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" FOLDED="true" ID="ID_1574682617" 
	TEXT="Sam Vilain">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_800016832" LINK="http://utsl.gen.nz/talks/git-svn/intro.html" 
	TEXT="utsl.gen.nz &gt; Talks &gt; Git-svn &gt; Intro">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1466756722" 
	TEXT="An introduction to git-svn for Subversion/SVK users and deserters">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" ID="ID_556438600" 
	TEXT="Eric Wong">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_1871970362" POSITION="right" 
	TEXT="Git 托管">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" ID="ID_883947475" 
	TEXT="repo.or.cz, Gitorious or GitHub">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_1450558845" POSITION="right" 
	TEXT="Git 提交的签名？">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" ID="ID_1915223334" 
	TEXT="commit c03c1f798d5f865331428e88c7d19b15471d25a8&#xa;Author: Alexander Gavrilov &lt;angavrilov@gmail.com&gt;&#xa;Date:   Fri Oct 9 11:01:04 2009 +0400&#xa;&#xa;    git-svn: Avoid spurious errors when rewriteRoot is used.&#xa;    &#xa;    After doing a rebase, git-svn checks that the SVN URL&#xa;    is what it expects. However, it does not account for&#xa;    rewriteRoot, which is a legitimate way for the URL&#xa;    to change. This produces a lot of spurious errors.&#xa;    &#xa;    [ew: fixed line wrapping]&#xa;    &#xa;    Signed-off-by: Alexander Gavrilov &lt;angavrilov@gmail.com&gt;&#xa;    Acked-by: Eric Wong &lt;normalperson@yhbt.net&gt;&#xa;">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1785081420" 
	TEXT="Git 工作流">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1415733365" LINK="http://git.kernel.org/?p=git/git.git" 
	TEXT="git.kernel.org &gt; ?p=git &gt; Git.git;a=blob plain;f=Documentation &gt; SubmittingPatches;hb=master">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
</node>
</node>
</map>
