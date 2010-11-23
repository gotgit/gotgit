<?xml version="1.0" encoding="UTF-8"?>
<map version="0.9.0">
<!-- This file is saved using a hacked version of FreeMind. visit: http://freemind-mmx.sourceforge.net -->
<!-- Orignal FreeMind, can download from http://freemind.sourceforge.net -->
<!-- This .mm file is CVS/SVN friendly, some atts are saved in .mmx file. (from ossxp.com) -->
<node COLOR="#000000" ID="ID_1688594004" 
	TEXT="gitbook&#xa;Git —— Door to the source&#xa;Git —— 通往源码之门&#xa;Git——版本控制之美">
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
	TEXT="Git 基础（单用户（solo）">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" ID="ID_937140096" 
	TEXT="本章概述，介绍最基本的命令：xxx，以及。。。奥秘">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
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
<node COLOR="#990000" FOLDED="true" ID="ID_1385414587" 
	TEXT="如果你知道 ci 意味着 commit 或者 checkin，说明你已经有了足够多版本控制的经验。">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1964143096" 
	TEXT="设置别名到系统配置（可被所有用户共享）">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_410030232" 
	TEXT="git config --system alias.st status">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1945963504" 
	TEXT="git config --system alias.ci commit">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_206766388" 
	TEXT="git config --system alias.co checkout">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1178596489" 
	TEXT="git config --system alias.br branch">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
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
<node COLOR="#111111" FOLDED="true" ID="ID_94490236" 
	TEXT="git config: who are you">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1435650245" 
	TEXT="我是谁">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1572381566" 
	TEXT="$ git config --global user.name &quot;Your Name&quot;&#xa;$ git config --global user.email yourname@example.com"/>
<node COLOR="#111111" ID="ID_902927583" 
	TEXT="最终会显示在提交者姓名中"/>
</node>
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
<node COLOR="#990000" FOLDED="true" ID="ID_208516543" 
	TEXT="文件移动和删除">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_485341663" 
	TEXT="mv = add + rm 。改名操作的自动判别">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1535472563" 
	TEXT="git rm">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_373068541" 
	TEXT="关于 Stage 的故事">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1984210510" 
	TEXT="Stage: Git 的与众不同">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_190543215" 
	TEXT="Git 的第一个与众不同">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1043421356" 
	TEXT="修改一个文件"/>
<node COLOR="#111111" FOLDED="true" ID="ID_98925318" 
	TEXT="git status">
<node COLOR="#111111" ID="ID_1070512561" 
	TEXT="$ git status&#xa;# On branch master&#xa;# Changes to be committed:&#xa;#   (use &quot;git reset HEAD &lt;file&gt;...&quot; to unstage)&#xa;#&#xa;#       modified:   file1&#xa;#       modified:   file2&#xa;#       modified:   file3&#xa;#&#xa;# Changed but not updated:&#xa;#   (use &quot;git add &lt;file&gt;...&quot; to update what will be committed)&#xa;#&#xa;#        modified:   file4&#xa;#">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" ID="ID_1102475020" 
	TEXT="git diff"/>
<node COLOR="#111111" ID="ID_1683404370" 
	TEXT="git commit"/>
<node COLOR="#111111" ID="ID_719016930" 
	TEXT="没有提交成功？"/>
<node COLOR="#111111" ID="ID_604137617" 
	TEXT="git add . =&gt; git status"/>
<node COLOR="#111111" ID="ID_250948108" 
	TEXT="git diff 没有结果！"/>
<node COLOR="#111111" ID="ID_1634311448" 
	TEXT="git commit 提交成功"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1954661768" 
	TEXT="再来一次">
<node COLOR="#111111" ID="ID_1282784375" 
	TEXT="文件修改"/>
<node COLOR="#111111" ID="ID_1157150146" 
	TEXT="git diff"/>
<node COLOR="#111111" ID="ID_1276822757" 
	TEXT="git add ."/>
<node COLOR="#111111" ID="ID_1149413662" 
	TEXT="git diff 没有结果"/>
<node COLOR="#111111" ID="ID_261937897" 
	TEXT="再次修改，又有结果了"/>
<node COLOR="#111111" ID="ID_229199062" 
	TEXT="git commit 提交是哪一个版本呢？"/>
<node COLOR="#111111" ID="ID_423488036" 
	TEXT="提交之后再看 git diff ？"/>
</node>
</node>
<node COLOR="#111111" ID="ID_1051105030" 
	TEXT="图片说明 stage:&#xa;http://progit.org/figures/ch2/18333fig0201-tn.png">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_840974546" 
	TEXT="概念 ： stage">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="idea"/>
<node COLOR="#111111" ID="ID_402420242" 
	TEXT="stage 是介于 workcopy 和 版本库 rev 的一种中间状态。通过索引文件 .git/index 可以找到 stage">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_381630532" 
	TEXT="stage 可以看作是版本库中的 transaction 文件">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1171359271" 
	TEXT="将 Current working directory 记为 (1)&#xa;将 Index file 记为 (2)&#xa;将 Git repository 记为 (3)&#xa;&#xa;他们之间的提交层次关系是 (1) -&gt; (2) -&gt; (3)&#xa;git add完成的是(1) -&gt; (2)&#xa;git commit完成的是(2) -&gt; (3)&#xa;git commit -a两者的直接结合&#xa;&#xa;从时间上看，可以认为(1)是最新的代码，(2)比较旧，(3)更旧&#xa;按时间排序就是 (1) &lt;- (2) &lt;- (3)&#xa;&#xa;git diff得到的是从(2)到(1)的变化&#xa;git diff –cached得到的是从(3)到(2)的变化&#xa;git diff HEAD得到的是从(3)到(1)的变化&#xa;&#xa;摘录自： http://roclinux.cn/?p=385"/>
</node>
<node COLOR="#111111" ID="ID_825030317" 
	TEXT="git commit 操作，仅针对于 stage 中的文件，将其转化为版本库的 rev，而不管工作区中文件">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1131079079" 
	TEXT="git add 命令，可以将工作区改动文件（修改/删除等）以及工作区新文件添加到 stage">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1940464136" 
	TEXT="git diff 命令，缺省拿工作拷贝的文件和 stage 中的文件比较，如果已经加入stage，文件没有变化">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1354898047" 
	TEXT="如果文件已经添加到 stage，然后文件继续更改，则运行 git status ，该文件会出现两次。git commit 只会提交 stage 中版本，不会对后继修改提交。如果需要将后继修改也提交，再次执行 git add。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1575676964" 
	TEXT="从 stage 中撤出文件： git reset -- filenanme，或者 git reset HEAD -- filename&#xa;从 stage 中撤出文件，采用本地当前文件。如果本地文件和当前库中版本有差异，该命令输出警告。（目的是提醒用户可以通过进一步操作做本地恢复，或者继续提交）">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_921806727" 
	TEXT="git add： 最古怪的 git 命令（做登记）">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1453606480" 
	TEXT="古怪，是因为 git add 命令不但可以对未版本控制文件添加，而且对修改/删除文件都可以操作，即做“登记”">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_521959180" 
	TEXT="$ git add file1 （添加文件进入 stage）">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_313070430" 
	TEXT="添加文件，即使尚未提交，git 也要将文件复制到库的 cache 中。"/>
<node COLOR="#111111" ID="ID_804767410" 
	TEXT="cache 即所谓  stage"/>
<node COLOR="#111111" ID="ID_1838581736" 
	TEXT=".git 版本库内的变化： .git/index 文件增加相应记录， .git/objects/ 目录包括要增加的文件"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_106023203" 
	TEXT="stage 中的文件可以和本地修改比较">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_614825163" 
	TEXT="stage 的版本在库中以 cache 形式保存，虽然尚未提交。"/>
<node COLOR="#111111" ID="ID_1629038091" 
	TEXT="如果本地又有修改，可以用 git diff 命令比较"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1492730907" 
	TEXT="要添加的文件，如果再修改，执行提交，提交的是哪个版本？">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_434781581" 
	TEXT="提交的是 git cache 的版本，即 stage 版本"/>
</node>
<node COLOR="#111111" ID="ID_48248594" 
	TEXT="如果想让添加又修改的文件一次性提交，对该文件执行命令 git add。即重新将文件加入 stage">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_993287139" 
	TEXT="一次添加操作可能在 .git 库中遗留多个 object，即有多余的 object 没有在索引中引用">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1956927621" 
	TEXT="$ git add -i  # 进入交互模式进行添加">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_671515005" 
	TEXT="stage 和 commit">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" FOLDED="true" ID="ID_638875324" 
	TEXT="git commit 不指定文件，则只提交在 stage 中的文件">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_546273959" 
	TEXT="即 git add 的文件被加入 stage。"/>
<node COLOR="#111111" ID="ID_886318301" 
	TEXT="git commit 对 stage 中文件进行提交"/>
</node>
<node COLOR="#111111" ID="ID_803156245" 
	TEXT="对于修改的文件，执行 git add 增加进入 stage （候选提交文件）,再输入命令 git commit，完成修改文件的提交">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1365799077" 
	TEXT="本地删除的文件，执行 git rm filename，将删除动作记入 stage。再输入命令 git commit，则完成提交">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_967972896" 
	TEXT="git commit 文件名称，则提交文件，无须先执行 git add">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_485238243" 
	TEXT="git commit -a ： 对所有修改文件以及 stage 内容进行提交。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_414666265" 
	TEXT="git 提交后，.git 库的变化">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_343392673" 
	TEXT=".git/COMMIT_EDITMSG 保留最近一次的提交说明，可以用于在后续提交时参考"/>
<node COLOR="#111111" ID="ID_224515068" 
	TEXT=".git/index 索引文件改变"/>
<node COLOR="#111111" FOLDED="true" ID="ID_116132992" 
	TEXT=".git/refs/heads/master 文件记录了 HEAD 版本的 id 号">
<node COLOR="#111111" ID="ID_921014973" 
	TEXT="如：9e9507eb90db675fe82192ace46138881b331d68"/>
</node>
<node COLOR="#111111" ID="ID_1971297601" 
	TEXT=".git/logs/HEAD 文件：记录所有 HEAD 历史"/>
<node COLOR="#111111" ID="ID_1906529081" 
	TEXT=".git/logs/refs/heads/master 文件：记录所有 HEAD 历史"/>
<node COLOR="#111111" FOLDED="true" ID="ID_154818933" 
	TEXT=".git/objects/两位字符的目录/38位字符的文件名">
<node COLOR="#111111" ID="ID_1869080881" 
	TEXT="即通过 SHA1SUM 作为文件名来保存对象"/>
</node>
</node>
<node COLOR="#111111" ID="ID_1164070366" 
	TEXT="总结： git commit 这样设计的好处是，避免无关文件被提交。提交应该用 git add 命令在提交前，计划好要提交的文件列表（changeset）。">
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="idea"/>
</node>
<node COLOR="#111111" ID="ID_510626354" 
	TEXT="提交后悔？ 用命令： $ git commit --amend">
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="idea"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1529490072" 
	TEXT="提交前的一些操作 （reset, checkout）">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1575517712" 
	TEXT="文件的本地修改取消（未用 git add 添加到 stage）： git checkout filename">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1183892315" 
	TEXT="本地删除文件的恢复（未用 git add 添加到 stage）： git checkout filename">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_651338057" 
	TEXT="本地即上次提交到 stage 中后的修改或者删除等变更全部取消： git checkout . ">
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="forward"/>
<node COLOR="#111111" ID="ID_262170749" 
	TEXT="说明： checkout 后面跟一个点，即覆盖当前分支下，继上次 stage 后所有变更的内容。有点危险啊"/>
<node COLOR="#111111" ID="ID_1583305689" 
	TEXT="何谓 stage 后：  修改文件/删除文件等操作后，用 git add 命令将变更的文件添加到 stage。则执行 git checkout . 不会破坏已经在 stage 中的文件了。">
<icon BUILTIN="idea"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1425606071" 
	TEXT="思考： git checkout &lt;branch_name&gt; 如果 branch_name 和 filename 同名该如何？">
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="help"/>
<node COLOR="#111111" ID="ID_642541143" 
	TEXT="如果遇到文件名和分支名同名，则使用分支名">
<icon BUILTIN="yes"/>
</node>
<node COLOR="#111111" ID="ID_900705167" 
	TEXT="如果 checkout 的参数就是当前分支名，仅仅会显示当前分支下文件的修改情况（那些文件被修改，删除）"/>
<node COLOR="#111111" ID="ID_1955154967" 
	TEXT="如果 checkout 的参数是另外的分支，会切换到另外的分支。如果当前有文件被修改，会拒绝切换，报错：&#xa;  error: Entry &apos;&lt;CURRENT_BRANCH_NAME&gt;&apos; would be overwritten by merge. Cannot merge.&#xa;"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1321032263" 
	TEXT="已经提交到 stage 中的文件，要将其从 stage 中取消： git reset HEAD filename">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_951224380" 
	TEXT="添加的文件将成为 Untracked files"/>
<node COLOR="#111111" ID="ID_1007872425" 
	TEXT="修改的文件成为修改过但未列入提交列表中（不再 stage 中）"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_921911312" 
	TEXT="修改文件已经加入 stage，将其从 stage 中取消的两步操作">
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="forward"/>
<node COLOR="#111111" ID="ID_1714375162" 
	TEXT="从 stage 中撤出文件： git reset HEAD filenanme&#xa;  命令输出：文件包含本地修改（含义是可以通过进一步操作做本地恢复，或者继续提交）">
<arrowlink DESTINATION="ID_1321032263" ENDARROW="Default" ENDINCLINATION="411;0;" ID="Arrow_ID_702316956" STARTARROW="None" STARTINCLINATION="411;0;"/>
<icon BUILTIN="full-1"/>
</node>
<node COLOR="#111111" ID="ID_445461686" 
	TEXT="恢复文件修改： git checkout filename">
<arrowlink DESTINATION="ID_1575517712" ENDARROW="Default" ENDINCLINATION="248;0;" ID="Arrow_ID_281092955" STARTARROW="None" STARTINCLINATION="248;0;"/>
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="full-2"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_900380665" 
	TEXT="删除文件动作加入 stage。要取消对文件的删除，两步操作：reset 和 checkout">
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="forward"/>
<node COLOR="#111111" ID="ID_827525105" 
	TEXT="从 stage 中撤销动作： git reset HEAD filenanme&#xa;  命令输出：文件包含本地修改（含义是可以通过进一步操作做本地恢复，或者继续提交删除操作）">
<icon BUILTIN="full-1"/>
</node>
<node COLOR="#111111" ID="ID_1809983399" 
	TEXT="恢复本地被删除的文件： git checkout filename">
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="full-2"/>
</node>
</node>
<node COLOR="#111111" ID="ID_1083543798" 
	TEXT="修改文件或者新文件，加入提交列表： git add">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_796157516" 
	TEXT="本地删除文件，加入提交列表： git rm">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_397549446" 
	TEXT="git diff 操作 (缺省和 stag 比)">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" FOLDED="true" ID="ID_162103863" 
	TEXT="$ git diff  （本地和 stage 版本做比较)">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" FOLDED="true" ID="ID_134336896" 
	TEXT="git diff （不加参数）： 是和下次要提交数据的比较">
<node COLOR="#111111" ID="ID_1105345111" 
	TEXT="相当于 git diff --cached"/>
</node>
<node COLOR="#111111" ID="ID_89918704" 
	TEXT="如果修改了文件，执行 git diff 可以看到差异"/>
<node COLOR="#111111" ID="ID_1079387608" 
	TEXT="如果对修改文件执行 git add，即将修改的文件加入提交列表，则再执行 git diff 无结果。因为 差异已经列入 stage， git diff 是和 stage 对比。">
<icon BUILTIN="messagebox_warning"/>
</node>
<node COLOR="#111111" ID="ID_1903394236" 
	TEXT="如果执行了 git add， git diff （无参数），也看不到差异，因为也是和 stage 做对比。"/>
<node COLOR="#111111" ID="ID_1673831293" 
	TEXT="如果执行 git add 加入了 stage 后，又对文件进行了修改，则 git diff 可以查看区别。"/>
<node COLOR="#111111" ID="ID_1301248700" 
	TEXT="参见 git add">
<arrowlink DESTINATION="ID_106023203" ENDARROW="Default" ENDINCLINATION="200;0;" ID="Arrow_ID_695624221" STARTARROW="None" STARTINCLINATION="165;6;"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1784009420" 
	TEXT="$ git diff --cached （查看 stage 版本的差异。拿 stage 和 HEAD 版本做比较）">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1590779873" 
	TEXT="--cached 代表 stage 中版本。即查看 stage 版本的差异（和 HEAD 版本，不是本地工作区版本）"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1783520204" 
	TEXT="$ git diff &lt;commit-ish&gt; （本地和 &lt;commit-ish&gt; 版本做比较）">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1417251206" 
	TEXT="如： git diff HEAD"/>
</node>
<node COLOR="#111111" ID="ID_1041674501" 
	TEXT="$ git diff --cached &lt;commit-ish&gt; （拿 stage 和 &lt;commit-ish&gt; 版本做比较）">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1881181636" 
	TEXT="$ git diff &lt;commit&gt;..&lt;commit&gt; ： 比较两个 commit （第二个版本对第一个版本以来的改动）">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_673753697" 
	TEXT="$ git diff &lt;commit&gt;...&lt;commit&gt; ： 显示第一个版本以来双方的改动">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1470277981" 
	TEXT="相当于： git diff $(git-merge-base A B) B"/>
<node COLOR="#111111" ID="ID_1268799387" 
	TEXT="参见"/>
</node>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_959144194" 
	TEXT="stage 使用小巧门">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1584715185" 
	TEXT="git add -u: 将所有修改文件加入 stage">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_858315007" 
	TEXT="git add -A">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
<node COLOR="#00b439" ID="ID_1740233891" 
	TEXT="文件反删除">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_271761078" 
	TEXT="查看状态">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1186507177" 
	TEXT="git status 帮助你操作 stage">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1974305203" 
	TEXT="git status 的输出及精简输出">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1936865227" 
	TEXT="文件忽略">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_740129745" 
	TEXT="两种文件忽略方式">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_235129425" 
	TEXT="文件忽略 .gitignore">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1354178741" 
	TEXT="本地忽略，修改 .git/info/exclude">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_548392411" 
	TEXT="被所有人共享的忽略： .gitignore 文件">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_725076369" 
	TEXT=".gitignore 可以位于任何目录中，作用范围整个目录及子目录">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_822192638" 
	TEXT="说明">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_886336086" 
	TEXT="* Blank lines or lines starting with # are ignored."/>
<node COLOR="#111111" ID="ID_865432939" 
	TEXT="* Standard glob patterns work."/>
<node COLOR="#111111" ID="ID_568738096" 
	TEXT="* You can end patterns with a forward slash (/) to specify a directory."/>
<node COLOR="#111111" ID="ID_553726268" 
	TEXT="* You can negate a pattern by starting it with an exclamation point (!)."/>
</node>
<node COLOR="#111111" ID="ID_405547622" 
	TEXT="# a comment - this is ignored&#xa;*.a       # no .a files&#xa;!lib.a    # but do track lib.a, even though you&apos;re ignoring .a files above&#xa;/TODO     # only ignore the root TODO file, not subdir/TODO&#xa;build/    # ignore all files in the build/ directory&#xa;doc/*.txt # ignore doc/notes.txt, but not doc/server/arch.txt">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1691925220" 
	TEXT="到底哪些文件需要忽略？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1082968153" 
	TEXT="Git 版本库创建的模板？定制模板就可以实现 info/exclude 文件的自动定义">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" ID="ID_1852828083" 
	TEXT="查看差异">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1775567645" 
	TEXT="查看历史">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1289410189" 
	TEXT="历史和历史版本操作">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_360135280" 
	TEXT="查看提交线索？">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1246163096" 
	TEXT="git log --graph"/>
<node COLOR="#111111" ID="ID_1392367672" 
	TEXT="gitk"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_991764538" 
	TEXT="查看提交统计信息？">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1728572554" 
	TEXT="git log --stat"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_608982222" 
	TEXT="查看提交的变更集">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1056817906" 
	TEXT="git log -p"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_721067319" 
	TEXT="关于版本号">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1908240575" 
	TEXT="40 位的 SHA1SUM，但是可以用前7位的缩写">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_395790774" 
	TEXT="关于版本范围的说明：">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1266652522" 
	TEXT="$ git log v2.5..        # commits since (not reachable from) v2.5&#xa;$ git log test..master  # commits reachable from master but not test&#xa;$ git log master..test  # ...reachable from test but not master&#xa;$ git log master...test # ...reachable from either test or master,&#xa;                        #    but not both&#xa;$ git log --since=&quot;2 weeks ago&quot; # commits from the last 2 weeks">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_6361013" 
	TEXT="git show： 查看提交的 patch 和说明">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1221945355" 
	TEXT="不带参数执行 git show，相当于 hg tip -p">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_388941267" 
	TEXT="查看历史版本某一文件： $ git show v2.5:fs/locks.c">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1737901372" 
	TEXT="$ git show HEAD^  # to see the parent of HEAD&#xa;$ git show HEAD^^ # to see the grandparent of HEAD&#xa;$ git show HEAD^1 # show the first parent of HEAD (same as HEAD^)&#xa;$ git show HEAD^2 # show the second parent of HEAD&#xa;$ git show HEAD~4 # to see the great-great grandparent of HEAD">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1269679766" 
	TEXT="如何检出历史版本？">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1307575202" 
	TEXT="git checkout &lt;commit&gt; - FILE"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1286509021" 
	TEXT="显示某个文件的历史版本？">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1562583079" 
	TEXT="查看历史版本某一文件： $ git show &lt;commit-id&gt;:path/to/file">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_570563852" 
	TEXT="撤销操作">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1275319654" 
	TEXT="用 git checkout 取消本地文件修改，相当于 svn revert">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="idea"/>
<node COLOR="#111111" ID="ID_1169991971" 
	TEXT="git checkout -- filename ： 回退本地修改">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_3868544" 
	TEXT="git checkout 和 hg revert 的概念相同">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_634582136" 
	TEXT="例如本地误删了文件，运行 git checkout 目录/文件名 就可以回复文件">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_331099602" 
	TEXT="修改的文件，运行 git checkout 会被原始文件覆盖！！">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1906651008" 
	TEXT="但是注意区分： git revert 和 hg revert 概念不同">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_263324807" 
	TEXT="git revert &lt;COMMIT-ISH&gt; 是 cherry-pick 合并操作，即将某个 commit 反向提交。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1092307074" 
	TEXT="hg revert 是取消本地修改，相当于用库中文件覆盖本地文件">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" ID="ID_1360337445" 
	TEXT="checkout 命令，在文件丢失或者要还原会用到。分支创建和检出是后话"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1510390008" 
	TEXT="如何不变更历史的撤销某个提交">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_78948129" 
	TEXT="git revert &lt;commit&gt;"/>
</node>
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
<node COLOR="#990000" FOLDED="true" ID="ID_893753929" 
	TEXT="git reset 多说几句">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1406689311" 
	TEXT="所谓重置(reset)，就是切换当前分支的最新节点。根据是否清空 index（stage）和工作区内容，分为下面三种类型。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_903649289" 
	TEXT="参数一： --mixed 是默认参数。重置 HEAD 和 INDEX。即当前分支最新节点切换到 某个节点处，并用改节的内容覆盖 index。可以用于从 stage（即 index） 中撤销文件。&#xa;（安全：既不改变 index/stage 文件，又不改变本地工作区文件）">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_512826760" 
	TEXT="参数二： --soft 参数。仅仅重置 HEAD。而 index 即 stage 不变。可用于撤销之前的提交，而对应的改动并不取消，仍保存在 stage 中。 &#xa;（安全：不改变本地工作区文件）">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1289130702" 
	TEXT="参数三： --hard 参数。重置 HEAD, index and working tree。 即 HEAD 会切换到指定版本，index 和工作区也会和指定版本一致。（当然，工作区新的未入库文件保留）&#xa;（危险操作：本地工作区也被重置）">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1256997393" 
	TEXT="1. 从 stage 中撤出文件： git reset HEAD -- filename。 &#xa;    相当于 git reset --mixed HEAD -- filename">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_682445051" 
	TEXT="如果 git reset &lt;commit-ish&gt; 的 &lt;commit-ish&gt; 为历史 commit 且最新的 commit 没有 tag 对应，可能造成因为找不到最新的 commit-ish 导致丢失 &lt;commit-ish&gt; 之后的提交？！">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_890532234" 
	TEXT="Tip ： 如果不小心因执行 git reset &lt;old-commit-ish&gt;，可以通过 .git/logs/HEAD 文件找到丢失的 &lt;commit-ish&gt;">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1604059460" 
	TEXT="可以通过  .git/logs/HEAD 查看日志，找到切换分支的新分支点前的 commit id。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1739339320" 
	TEXT="再执行 git reset  &lt;40-DIGIT-COMMIT-ID&gt;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_111701884" 
	TEXT="2. 远程 PUSH 后，用 git reset HEAD，切换到最新的 HEAD 版本">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1545262381" 
	TEXT="远程 push 到本地，用 reset 更新，因为现在的 HEAD 处于旧版本">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1678666166" 
	TEXT="执行 git status 发现本地版本不是 HEAD 版本">
<node COLOR="#111111" ID="ID_88055624" 
	TEXT=" git status&#xa;# On branch master&#xa;# Changes to be committed:&#xa;#   (use &quot;git reset HEAD &lt;file&gt;...&quot; to unstage)&#xa;#&#xa;#       modified:   .gitignore&#xa;#       deleted:    demo/conf/trac.ini&#xa;#       deleted:    demo/db/trac.db&#xa;#       deleted:    demo/log/trac.log&#xa;#       copied:     demo/README -&gt; freemind/README&#xa;#       copied:     demo/VERSION -&gt; freemind/VERSION&#xa;#       new file:   freemind/conf/trac.ini&#xa;#       copied:     demo/conf/trac.ini.sample -&gt; freemind/conf/trac.ini.sample&#xa;#       new file:   freemind/db/trac.db&#xa;#       new file:   freemind/log/trac.log&#xa;#       copied:     demo/templates/site.html -&gt; freemind/templates/site.html&#xa;#       modified:   infrastructure/conf/trac.ini&#xa;#       modified:   infrastructure/db/trac.db&#xa;#       deleted:    infrastructure/log/trac.log&#xa;#       modified:   ossxp/db/trac.db&#xa;#       renamed:    demo/README -&gt; pysvnmanager/README&#xa;#       renamed:    demo/VERSION -&gt; pysvnmanager/VERSION&#xa;#       new file:   pysvnmanager/conf/trac.ini&#xa;#       renamed:    demo/conf/trac.ini.sample -&gt; pysvnmanager/conf/trac.ini.sample&#xa;#       new file:   pysvnmanager/db/trac.db&#xa;#       new file:   pysvnmanager/log/trac.log&#xa;#       renamed:    demo/templates/site.html -&gt; pysvnmanager/templates/site.html&#xa;#       modified:   subversion/db/trac.db&#xa;#       modified:   trac/db/trac.db&#xa;#       modified:   trac/log/trac.log&#xa;#&#xa;"/>
</node>
<node COLOR="#111111" ID="ID_77053629" 
	TEXT="运行 git reset HEAD ，迁移到 HEAD 版本"/>
<node COLOR="#111111" ID="ID_1089500250" 
	TEXT="运行 git checkout .  以便检出/回退最新版本"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_204354559" 
	TEXT="3. 提交有误，收回以便重新提交">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1137902355" 
	TEXT="$ git commit ...&#xa;&#xa;# 收回 前一次提交&#xa;$ git reset --soft HEAD^&#xa;$ edit                     &#xa;$ git commit -a -c ORIG_HEAD  # -c 含义是从 ORIG_HEAD 获取提交说明&#xa;"/>
<node COLOR="#111111" ID="ID_1820970943" 
	TEXT="不过，使用命令 &quot;git commit --amend&quot; 最为简单。">
<icon BUILTIN="idea"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1530384981" 
	TEXT="4. 收回前几次提交">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1439168298" 
	TEXT="$ git commit ...&#xa;&#xa;# 收回 前三次提交&#xa;$ git reset --soft HEAD~3&#xa;$ edit                     &#xa;$ git commit -a&#xa;"/>
</node>
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
<node COLOR="#00b439" FOLDED="true" ID="ID_617927665" 
	TEXT="Multiple stage: stash">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1304116001" 
	TEXT="不要撤销，暂存状态">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_578368319" 
	TEXT="我们知道 stage 的内容已经加入到 Git 对象库里了，但是由于没有提交，因此暂存区是不稳定的可以随时用 git reset 命令撤销。">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1940338708" 
	TEXT="提交的整理：变基">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1329578132" 
	TEXT="实现历史提交的整理">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1677205659" 
	TEXT="Git rebase">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1751138846" 
	TEXT="checkout -b 立即创建分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1964124212" 
	TEXT="$ git checkout -b mywork origin&#xa;$ vi file.txt&#xa;$ git commit&#xa;$ vi otherfile.txt&#xa;$ git commit&#xa;...">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_813843658" 
	TEXT="新分支和原分支的关系图">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_317611602" 
	TEXT=" o--o--o &lt;-- origin&#xa;        \&#xa;         o--o--o &lt;-- mywork">
<font NAME="Monospaced" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1186319571" 
	TEXT="上游新版本合并到 origin">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1259480926" 
	TEXT=" o--o--O--o--o--o &lt;-- origin&#xa;        \&#xa;         a--b--c &lt;-- mywork">
<font NAME="Monospaced" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1554841311" 
	TEXT="如果直接 pull，不能保存 mywork 分支的更改历史">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1798216167" 
	TEXT=" o--o--O--o--o--o &lt;-- origin&#xa;        \        \&#xa;         a--b--c--m &lt;-- mywork">
<font NAME="Monospaced" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1879310698" 
	TEXT="rebase 命令，则可以实现保存分支的提交历史">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1984300932" 
	TEXT=" o--o--O--o--o--o &lt;-- origin&#xa;                 \&#xa;                  a&apos;--b&apos;--c&apos; &lt;-- mywork">
<font NAME="Monospaced" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_75452676" 
	TEXT="rebase 操作示例">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1964245507" 
	TEXT="$ git checkout mywork&#xa;$ git rebase origin">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1822377021" 
	TEXT="遇到冲突？">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1346680846" 
	TEXT="解决冲突"/>
<node COLOR="#111111" ID="ID_1189964672" 
	TEXT="并用 git add 将更新加到 index(cache)">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1613905945" 
	TEXT="执行  git rebase --continue， 而非 commit"/>
<node COLOR="#111111" ID="ID_575085095" 
	TEXT="任何时候都可以执行 $ git rebase --abort，退回到 rebase 操作之前">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1500257679" 
	TEXT="用 rebase 修改以前的提交说明">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="idea"/>
<node COLOR="#111111" ID="ID_413415452" 
	TEXT="修改最新版本的提交说明，用命令： $ git commit --amend">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_998950318" 
	TEXT="如果要修改的 comment 是当前分支 mywork 的倒数第5个把版本，执行下面的命令">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_732955735" 
	TEXT="$ git show mywork~5&#xa;$ git tag bad mywork~5&#xa;&#xa;$ git checkout bad&#xa;$ # make changes here and update the index&#xa;$ git commit --amend&#xa;$ # HEAD 指的是刚刚修改完 commit log 的提交&#xa;$ git rebase --onto HEAD bad mywork&#xa;&#xa;$ git tag -d bad">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_833010138" 
	TEXT="也可以用下面更为简洁的命令">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_263493368" 
	TEXT="$ git rebase -i mywork~5&#xa;Stopped at 7482e0d... updated the gemspec to hopefully work better&#xa;You can amend the commit now, with&#xa;&#xa;       git commit --amend&#xa;&#xa;Once you’re satisfied with your changes, run&#xa;&#xa;       git rebase --continue&#xa;&#xa;$ git commit --amend&#xa;$ git rebase --continue"/>
</node>
</node>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1780915744" 
	TEXT="灵活的让人可怕，不要将鸡蛋放在一个篮子里（git push）">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1081340660" 
	TEXT="本地克隆">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_450920240" 
	TEXT="clone --mirror"/>
<node COLOR="#111111" ID="ID_1454885577" 
	TEXT="git push"/>
</node>
<node COLOR="#990000" ID="ID_532743507" 
	TEXT="本地 init 一个空库，然后 push">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_517515732" 
	TEXT="远程版本库(1)">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_934923174" 
	TEXT="ssh 命令创建"/>
<node COLOR="#111111" ID="ID_547439418" 
	TEXT="git push 采用 ssh 协议"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1661833629" 
	TEXT="远程版本库(2)">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1893797772" 
	TEXT="安装了 gitolite 服务器"/>
<node COLOR="#111111" ID="ID_978875185" 
	TEXT="ssh 访问，看到授权列表"/>
<node COLOR="#111111" ID="ID_1992529555" 
	TEXT="git push 直接建立版本库"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1084314909" 
	TEXT="远程版本库(3)">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_963412725" 
	TEXT="Github 上创建版本库"/>
<node COLOR="#111111" ID="ID_162949319" 
	TEXT="git push"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_326035925" 
	TEXT="多台机器数据的同步（git pull）">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1887461557" 
	TEXT="git pull">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" ID="ID_1387396129" 
	TEXT="U盘的 Push">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1232726862" 
	TEXT="总结：">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_786390773" 
	TEXT="已经具备基本的 git 操作能力">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_397493570" 
	TEXT="学习命令总结">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_254977034" 
	TEXT="git init">
<node COLOR="#111111" ID="ID_225700766" 
	TEXT="--bare"/>
<node COLOR="#111111" ID="ID_359688133" 
	TEXT="后面直接跟目录"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1467192950" 
	TEXT="git commit">
<node COLOR="#111111" FOLDED="true" ID="ID_1356030161" 
	TEXT="commit 的 --allow-empty 参数">
<node COLOR="#111111" ID="ID_1672362163" 
	TEXT="是否必须添加数据，才能创建一个版本库？"/>
<node COLOR="#111111" ID="ID_15958456" 
	TEXT="不必，使用 git commit --allow-empty 即可"/>
</node>
<node COLOR="#111111" ID="ID_1217006871" 
	TEXT="commit 的 -s 参数"/>
<node COLOR="#111111" ID="ID_1535801411" 
	TEXT="commit 的 -a 参数"/>
<node COLOR="#111111" ID="ID_1389691457" 
	TEXT="--amend"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_615493497" 
	TEXT="git add">
<node COLOR="#111111" ID="ID_1077788346" 
	TEXT="-u"/>
<node COLOR="#111111" ID="ID_1375693109" 
	TEXT="-A"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1982781693" 
	TEXT="git clone">
<node COLOR="#111111" ID="ID_1416620309" 
	TEXT="--mirror"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1371367219" 
	TEXT="示例：$ git clone git://git.kernel.org/pub/scm/git/git.git">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1862124939" 
	TEXT="$ git clone git://git.kernel.org/pub/scm/git/git.git&#xa;Initialized empty Git repository in /data/_repos/GitHome/git/.git/&#xa;remote: Counting objects: 89127, done.&#xa;remote: Compressing objects: 100% (22856/22856), done.&#xa;remote: Total 89127 (delta 65153), reused 88493 (delta 64713)&#xa;Receiving objects: 100% (89127/89127), 18.27 MiB | 366 KiB/s, done.&#xa;Resolving deltas: 100% (65153/65153), done.&#xa;"/>
</node>
<node COLOR="#111111" ID="ID_112019295" 
	TEXT="ssh 协议： git clone user@server:repo.git"/>
<node COLOR="#111111" ID="ID_1172126749" 
	TEXT="http 协议: git clone http://server/git/repo.git"/>
<node COLOR="#111111" ID="ID_105771985" 
	TEXT="本地克隆："/>
</node>
<node COLOR="#111111" ID="ID_1243886138" 
	TEXT="git blame"/>
<node COLOR="#111111" ID="ID_1558124340" 
	TEXT="git pull"/>
<node COLOR="#111111" ID="ID_1912377513" 
	TEXT="git push"/>
<node COLOR="#111111" ID="ID_391397658" 
	TEXT="git reset"/>
<node COLOR="#111111" ID="ID_1095212077" 
	TEXT="git revert"/>
<node COLOR="#111111" ID="ID_634084612" 
	TEXT="git rebase"/>
<node COLOR="#111111" ID="ID_1107534014" 
	TEXT="git config"/>
<node COLOR="#111111" ID="ID_727217935" 
	TEXT="git log"/>
<node COLOR="#111111" ID="ID_1421330643" 
	TEXT="git diff"/>
<node COLOR="#111111" ID="ID_1173282285" 
	TEXT="git status"/>
<node COLOR="#111111" ID="ID_70293844" 
	TEXT="git checkout"/>
</node>
<node COLOR="#990000" ID="ID_1342700695" 
	TEXT="同步过程中会遇到冲突的问题">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_1192962447" POSITION="right" 
	TEXT="Git 基础（冲突解决）">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" ID="ID_1158946938" 
	TEXT="用 push 和 pull 可以模拟集中式版本控制系统的工作流程">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_646053453" 
	TEXT="引发冲突的条件：不是基于服务器最新提交进行更改。">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_289026884" 
	TEXT="冲突解决的几种可能">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1119183962" 
	TEXT="未引发冲突">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_631261458" 
	TEXT="冲突的自动解决（成功）">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1298374889" 
	TEXT="冲突的自动解决（逻辑冲突）">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1890445539" 
	TEXT="真正的冲突（手动解决）">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_462055545" 
	TEXT="因为文件重命名引发的冲突。到底改名不改名？（SVN 中叫做树冲突）">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" ID="ID_1552803355" 
	TEXT="冲突解决的方法">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1281299742" 
	TEXT="其它可引发冲突的命令">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_667248525" 
	TEXT="rebase">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1877967511" 
	TEXT="pull">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1226880636" 
	TEXT="merge">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1068443755" 
	TEXT="总结：">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_556618630" 
	TEXT="可以通过 u 盘或者网络对自己在多台机器的操作进行同步，并能够在同步的时候，进行冲突的解决。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_647665757" 
	TEXT="命令总结">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1388474577" 
	TEXT="git pull"/>
<node COLOR="#111111" ID="ID_1955965565" 
	TEXT="git push"/>
<node COLOR="#111111" ID="ID_600732035" 
	TEXT="git fetch"/>
<node COLOR="#111111" ID="ID_1448237318" 
	TEXT="git merge"/>
<node COLOR="#111111" ID="ID_1981932107" 
	TEXT="git mergetool"/>
</node>
<node COLOR="#990000" ID="ID_718955226" 
	TEXT="而且refs 中只有一个 master 感到非常困惑，为什么叫做 master，还能不能有其它">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_135506718" POSITION="right" 
	TEXT="Git 进阶（里程碑/分支）">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" FOLDED="true" ID="ID_747613262" 
	TEXT="和 Subversion 相似之处，Commit 不可变，指定了唯一标识。">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_159479043" 
	TEXT="缺点难记，最好有标识对应，就是 tag">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1411786851" 
	TEXT="还有 commit 可能由于 reset 而丢失">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_622673054" 
	TEXT="tag 详解">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_964368660" 
	TEXT="简单的 tag">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_947982010" 
	TEXT="注释/签名的 tag">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1608622172" 
	TEXT="git describe 命令">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1541336346" 
	TEXT="git name-rev">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_810203260" 
	TEXT="切换到里程碑，HEAD 处于 detached HEAD 状态，为何故？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_356033177" 
	TEXT="Git 里程碑">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1950537415" 
	TEXT="Git 的 commit-id">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1447221485" 
	TEXT="COMMIT-ISH 即提交ID，是由 40 个十六进制数字组成，可以由开头的任意长度的数字串指代，只要不冲突。">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_442805379" 
	TEXT="建立/删除和查看 tag">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1528429187" 
	TEXT="运行 git tag tag_name 即可创建轻量级里程碑">
<node COLOR="#111111" ID="ID_434774012" 
	TEXT="git tag v2.5 1b2e1d63ff ： 创建轻量级里程碑">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_253481402" 
	TEXT="轻量级里程碑，用 git-show 只能看到tag应用到的 commit 本身">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1649246214" 
	TEXT="$ git tag v1.4-lw&#xa;$ git tag&#xa;v0.1&#xa;v1.3&#xa;v1.4&#xa;v1.4-lw&#xa;v1.5"/>
<node COLOR="#111111" ID="ID_1650891693" 
	TEXT="$ git show v1.4-lw&#xa;commit 15027957951b64cf874c3557a0f3547bd83b3ff6&#xa;Merge: 4a447f7... a6b4c97...&#xa;Author: Scott Chacon &lt;schacon@gee-mail.com&gt;&#xa;Date:   Sun Feb 8 19:02:46 2009 -0800&#xa;&#xa;    Merge branch &apos;experiment&apos;"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_544725214" 
	TEXT="带注解的里程碑">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="idea"/>
<node COLOR="#111111" ID="ID_9424802" 
	TEXT="带有注解的里程碑是使用 -a 或者 -s 方式创建，并且用 -m 参数添加说明">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_178956216" 
	TEXT="用 -a 参数创建带有注解的里程碑">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1982377819" 
	TEXT="$ git tag -a v1.4 -m &apos;my version 1.4&apos;&#xa;$ git tag&#xa;v0.1&#xa;v1.3&#xa;v1.4"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1134478249" 
	TEXT="-s 参数用 gpg 签名里程碑。用 -v 参数可以校验之">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1875442721" 
	TEXT="$ git tag -s v1.5 -m &apos;my signed 1.5 tag&apos;&#xa;You need a passphrase to unlock the secret key for&#xa;user: &quot;Scott Chacon &lt;schacon@gee-mail.com&gt;&quot;&#xa;1024-bit DSA key, ID F721C45A, created 2009-02-09"/>
<node COLOR="#111111" ID="ID_1332191361" 
	TEXT="$ git tag -v v1.4.2.1&#xa;object 883653babd8ee7ea23e6a5c392bb739348b1eb61&#xa;type commit&#xa;tag v1.4.2.1&#xa;tagger Junio C Hamano &lt;junkio@cox.net&gt; 1158138501 -0700&#xa;&#xa;GIT 1.4.2.1&#xa;&#xa;Minor fixes since 1.4.2, including git-mv and git-http with alternates.&#xa;gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A&#xa;gpg: Good signature from &quot;Junio C Hamano &lt;junkio@cox.net&gt;&quot;&#xa;gpg:                 aka &quot;[jpeg image of size 1513]&quot;&#xa;Primary key fingerprint: 3565 2A26 2040 E066 C9A7  4A7D C0C6 D9A4 F311 9B9A"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_643957992" 
	TEXT="用 git show 命令，查看里程碑的注解">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1246653964" 
	TEXT="$ git show v1.4&#xa;tag v1.4&#xa;Tagger: Scott Chacon &lt;schacon@gee-mail.com&gt;&#xa;Date:   Mon Feb 9 14:45:11 2009 -0800&#xa;&#xa;my version 1.4&#xa;commit 15027957951b64cf874c3557a0f3547bd83b3ff6&#xa;Merge: 4a447f7... a6b4c97...&#xa;Author: Scott Chacon &lt;schacon@gee-mail.com&gt;&#xa;Date:   Sun Feb 8 19:02:46 2009 -0800&#xa;&#xa;    Merge branch &apos;experiment&apos;"/>
</node>
</node>
<node COLOR="#111111" ID="ID_1456091512" 
	TEXT="删除 tag： git tag -d tagname"/>
<node COLOR="#111111" ID="ID_1769178636" 
	TEXT="git tag ： 查看里程碑列表">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1006292485" 
	TEXT="查看 tag 对应的 commit id">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_552581117" 
	TEXT="查看某个 commit id 是否有对应的 tag 或者分支？ (name-rev)">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1411702649" 
	TEXT="git name-rev 用于查看某个 commit 是否有对应 tag。&#xa;&#xa;$ git name-rev 41008ee&#xa;41008ee tags/v1.0~1&#xa;">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_484431346" 
	TEXT="能否在 Tag 上提交？">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1592731522" 
	TEXT="SVN 是可以在 tag 上提交的，但是 git 很好的处理这个问题"/>
<node COLOR="#111111" ID="ID_1112648429" 
	TEXT="git co tagname， 实际上 HEAD 内容会变成 40位 commitid，而非 symbol ref name"/>
<node COLOR="#111111" ID="ID_1290204665" 
	TEXT="提交不会被保留"/>
<node COLOR="#111111" ID="ID_1739869171" 
	TEXT="要想提交被保留，执行 git co -b branch_name"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1971546762" 
	TEXT="Tag 的实质">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_568608532" 
	TEXT="里程碑和分支实际上都是 commitid 的对应物"/>
<node COLOR="#111111" ID="ID_1943737533" 
	TEXT="分支：实际是一个分支名，指向该分支的顶节点。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_914294268" 
	TEXT="* The branch &quot;test&quot; is short for &quot;refs/heads/test&quot;.">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1157001888" 
	TEXT="* The tag &quot;v2.6.18&quot; is short for &quot;refs/tags/v2.6.18&quot;.">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1491413743" 
	TEXT="* &quot;origin/master&quot; is short for &quot;refs/remotes/origin/master&quot;.">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1459232538" 
	TEXT="共享里程碑">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="idea"/>
<node COLOR="#111111" ID="ID_1491796945" 
	TEXT="缺省 git push 命令不上传 tag 名称到服务器。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_739219089" 
	TEXT="您必须显示的上传 tag 名">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1709782807" 
	TEXT="git push origin &lt;tagname&gt;">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_523576403" 
	TEXT="$ git push origin v1.5&#xa;Counting objects: 50, done.&#xa;Compressing objects: 100% (38/38), done.&#xa;Writing objects: 100% (44/44), 4.56 KiB, done.&#xa;Total 44 (delta 18), reused 8 (delta 1)&#xa;To git@github.com:schacon/simplegit.git&#xa;* [new tag]         v1.5 -&gt; v1.5"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_927753999" 
	TEXT="或者使用 git push --tags">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_146935287" 
	TEXT="If you have a lot of tags that you want to push up at once, you can also use the --tags option to the git push command. This will transfer all of your tags to the remote server that are not already there.">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_902930995" 
	TEXT="$ git push origin --tags&#xa;Counting objects: 50, done.&#xa;Compressing objects: 100% (38/38), done.&#xa;Writing objects: 100% (44/44), 4.56 KiB, done.&#xa;Total 44 (delta 18), reused 8 (delta 1)&#xa;To git@github.com:schacon/simplegit.git&#xa; * [new tag]         v0.1 -&gt; v0.1&#xa; * [new tag]         v1.2 -&gt; v1.2&#xa; * [new tag]         v1.4 -&gt; v1.4&#xa; * [new tag]         v1.4-lw -&gt; v1.4-lw&#xa; * [new tag]         v1.5 -&gt; v1.5"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_204980636" 
	TEXT="里程碑的误用">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1511354576" 
	TEXT="不要修改里程碑"/>
<node COLOR="#111111" ID="ID_613309185" 
	TEXT="修改的里程碑，运行 git push, git pull 不会自动同步"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_500719407" 
	TEXT="分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1346624824" 
	TEXT="版本库创建时的 master 分支">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_227226980" 
	TEXT="直接在 .git/refs/heads 下拷贝">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_341479438" 
	TEXT="使用 git  branch 命令创建">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_669600485" 
	TEXT="使用 git checkout 命令创建">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_795682101" 
	TEXT="分支的作用">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_231331067" 
	TEXT="release 分支">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1208444838" 
	TEXT="功能分支">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1701672550" 
	TEXT="只读分支">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1008288155" 
	TEXT="分支的奥秘">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<icon BUILTIN="idea"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1618650480" 
	TEXT=".git/refs/heads/ 下是分支名称">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1297388320" 
	TEXT="$ ls .git/refs/heads/&#xa;master  new&#xa;"/>
</node>
<node COLOR="#990000" ID="ID_686167280" 
	TEXT="例如 .git/refs/heads/master 中记录的是 master 分支对应的 40 位 commit id">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_346325" 
	TEXT=".git/refs/tags/ 下是里程碑名称。如果目录为空，可能已经打包整理到文件 .git/packed-refs 文件中了。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_133390599" 
	TEXT=".git/packed-refs 是 git 版本库经过 gc 整理后的分支和commit 对应索引文件（纯文本文件）">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1050308485" 
	TEXT=".git/HEAD 文件内容指向具体的分支。例如 ref: refs/heads/newbranch">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1488868592" 
	TEXT="$ cat .git/HEAD&#xa;ref: refs/heads/new&#xa;"/>
</node>
<node COLOR="#990000" ID="ID_1250067505" 
	TEXT=".git/logs/refs/heads/ 下以分支名称命名的文件，包含对应分支的 commit 历史">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_96167658" 
	TEXT="一般我们使用简写的名称，实际的对应关系如下。&#xa;    * The branch &quot;test&quot; is short for &quot;refs/heads/test&quot;.&#xa;    * The tag &quot;v2.6.18&quot; is short for &quot;refs/tags/v2.6.18&quot;.&#xa;    * &quot;origin/master&quot; is short for &quot;refs/remotes/origin/master&quot;. &#xa;&#xa;如果存在同名的里程碑和分支，就需要用长的名称（全名）了。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="idea"/>
</node>
</node>
<node COLOR="#00b439" ID="ID_1638439749" 
	TEXT="引用的奥秘">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1746903634" 
	TEXT="不同路径下的引用">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_623285892" 
	TEXT="refs/heads">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1301309041" 
	TEXT="refs/tags">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_828457952" 
	TEXT="refs/remotes/">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1083169713" 
	TEXT="refs/top-bases/">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1110131535" 
	TEXT="refs/changes/">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_757285595" 
	TEXT="refs/for/">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" ID="ID_1832578454" 
	TEXT="只有 refs/heads/ 下引用可以检出并直接操作？其它都是 detached HEAD？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1053799415" 
	TEXT="HEAD 和分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1853158730" 
	TEXT="HEAD 即顶节点，是当前开发分支的最顶端节点">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1120344198" 
	TEXT="一般 HEAD 指向 master 分支">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_247582814" 
	TEXT="$ cat .git/HEAD&#xa;ref: refs/heads/master&#xa;"/>
<node COLOR="#111111" ID="ID_1548822312" 
	TEXT="$ cat .git/HEAD&#xa;ref: refs/heads/feature&#xa;"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1360048480" 
	TEXT="checkout master 和具体 commit-id 的区别">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_949867618" 
	TEXT="master 可以跟踪最新提交"/>
<node COLOR="#111111" ID="ID_1133004358" 
	TEXT="而 commit-id 则无反应"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1142406819" 
	TEXT="克隆远程版本库的操作">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_953801272" 
	TEXT="远程版本库是否有 HEAD，及影响？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_148671887" 
	TEXT="本地 master 如何创建？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_751970680" 
	TEXT="fetch / pull 命令的区分">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1744088608" 
	TEXT="push 命令？">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_942411666" 
	TEXT="本地分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_808002371" 
	TEXT="master 就是分支">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_915189552" 
	TEXT="git co master"/>
<node COLOR="#111111" ID="ID_1766366410" 
	TEXT="cat .git/HEAD"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1411472705" 
	TEXT="git checkout &lt;tag_name&gt;: 检出旧版本/切换分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_183695024" 
	TEXT="不带参数执行 git checkout：检查当前文件状态和 stage 中的差异">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_858558358" 
	TEXT="git checkout -- filename 或者 git checkout filename：&#xa;从 stage 中取出文件 filename，如果本地有修改则被覆盖">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_838452361" 
	TEXT="git checkout . ： 从 stage 中取出当前目录下所有文件。本地文件被覆盖。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1455820907" 
	TEXT="git checkout &lt;tag_name&gt; ： 取出旧版本">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1473909945" 
	TEXT="git checkout &lt;branch_name&gt;： 工作在分支 branch_name 上">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_889609250" 
	TEXT="git checkout -b &lt;new_branch&gt; [branch_name] ： 继续某分支或当前分支，创建新的分支">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_142134936" 
	TEXT="如何区分参数是 tag/branch 还是 filename/dirname？ 在文件名/目录名的前面加上两个减号： git checkout [options] [&lt;branch&gt;] -- &lt;file&gt;...">
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="help"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_356300620" 
	TEXT="切换分支： git checkout &lt;branch_name&gt;">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_798748093" 
	TEXT="$ git branch&#xa;* master&#xa;  new&#xa;$ git checkout new&#xa;Switched to branch &apos;new&apos;&#xa;$ git branch&#xa;  master&#xa;* new">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_945738539" 
	TEXT="查看分支： git branch">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_160958947" 
	TEXT="$ git branch&#xa;* master">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_855093224" 
	TEXT="创建新分支 ： git branch &lt;branch_name&gt; [base_tag]">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_422338654" 
	TEXT="最当前版本创建">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_225688362" 
	TEXT="$ git branch new&#xa;$ git branch&#xa;* master&#xa;  new&#xa;$ git checkout new&#xa;Switched to branch &apos;new&apos;&#xa;$ git branch&#xa;  master&#xa;* new">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_962990354" 
	TEXT="基于旧版本/里程碑创建分支">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1273081362" 
	TEXT="$ git branch new v1.6.3&#xa;$ git branch&#xa;* master&#xa;  new&#xa;$ git checkout new&#xa;Switched to branch &apos;new&apos;&#xa;$ git branch&#xa;  master&#xa;* new">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_308624239" 
	TEXT="gitk 可以看到 branch 建立在 tag v1.6.3 上"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_340611059" 
	TEXT="创建并切换到新分支： git checkout -b &lt;new_branch&gt; [base_tag]">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1926222995" 
	TEXT="$ git checkout -b new&#xa;Switched to a new branch &apos;new&apos;&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_490875564" 
	TEXT="删除分支： git branch -d &lt;branch_name&gt; （限制条件： 该分支已经合并到当前分支）">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_723094752" 
	TEXT="$ git branch -d new&#xa;error: Cannot delete the branch &apos;new&apos; which you are currently on.&#xa;$ git checkout master&#xa;Switched to branch &apos;master&apos;&#xa;$ git branch -d new&#xa;Deleted branch new (was f01f109).&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1056472844" 
	TEXT="无条件删除分支： git branch -D &lt;branch_name&gt; ">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="yes"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_75201423" 
	TEXT="重新确定分支点： git reset --hard tagname">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_6243239" 
	TEXT="和 git checkout &lt;branch_name&gt; 的区别在哪里？">
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="help"/>
</node>
<node COLOR="#111111" ID="ID_77988161" 
	TEXT="注意：该命令非常危险，如果原分支点没有其它标记，找回原分支点很麻烦">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1036807919" 
	TEXT="可以通过  .git/logs/HEAD 查看日志，找到切换分支的新分支点前的 commit id。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_984347032" 
	TEXT="再执行 git reset --hard &lt;40-DIGIT-COMMIT-ID&gt;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_873938692" 
	TEXT="gitk 可以显示分支图">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="idea"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1402402678" 
	TEXT="合并分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1734632324" 
	TEXT="git merge &lt;branch_name&gt;"/>
<node COLOR="#111111" ID="ID_580430573" 
	TEXT="merge 操作，在合并分支以及 pull 的时候会发生">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_4917764" 
	TEXT="git pull 相当于 git fetch 和 git merge 操作"/>
<node COLOR="#111111" ID="ID_1650808696" 
	TEXT="cherry-pick">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_59919153" 
	TEXT="Git rebase">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1421674809" 
	TEXT="checkout -b 立即创建分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_568763057" 
	TEXT="$ git checkout -b mywork origin&#xa;$ vi file.txt&#xa;$ git commit&#xa;$ vi otherfile.txt&#xa;$ git commit&#xa;...">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1792836032" 
	TEXT="新分支和原分支的关系图">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1049874766" 
	TEXT=" o--o--o &lt;-- origin&#xa;        \&#xa;         o--o--o &lt;-- mywork">
<font NAME="Monospaced" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_607960789" 
	TEXT="上游新版本合并到 origin">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1513097688" 
	TEXT=" o--o--O--o--o--o &lt;-- origin&#xa;        \&#xa;         a--b--c &lt;-- mywork">
<font NAME="Monospaced" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_798113952" 
	TEXT="如果直接 pull，不能保存 mywork 分支的更改历史">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1998511345" 
	TEXT=" o--o--O--o--o--o &lt;-- origin&#xa;        \        \&#xa;         a--b--c--m &lt;-- mywork">
<font NAME="Monospaced" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_394712205" 
	TEXT="rebase 命令，则可以实现保存分支的提交历史">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1942398612" 
	TEXT=" o--o--O--o--o--o &lt;-- origin&#xa;                 \&#xa;                  a&apos;--b&apos;--c&apos; &lt;-- mywork">
<font NAME="Monospaced" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1125035204" 
	TEXT="rebase 操作示例">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_103632276" 
	TEXT="$ git checkout mywork&#xa;$ git rebase origin">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_392485053" 
	TEXT="遇到冲突？">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1907177270" 
	TEXT="解决冲突"/>
<node COLOR="#111111" ID="ID_1556659120" 
	TEXT="并用 git add 将更新加到 index(cache)">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1864011894" 
	TEXT="执行  git rebase --continue， 而非 commit"/>
<node COLOR="#111111" ID="ID_1095159015" 
	TEXT="任何时候都可以执行 $ git rebase --abort，退回到 rebase 操作之前">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_750827169" 
	TEXT="用 rebase 修改以前的提交说明">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="idea"/>
<node COLOR="#111111" ID="ID_54849690" 
	TEXT="修改最新版本的提交说明，用命令： $ git commit --amend">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_955446883" 
	TEXT="如果要修改的 comment 是当前分支 mywork 的倒数第5个把版本，执行下面的命令">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1323972562" 
	TEXT="$ git show mywork~5&#xa;$ git tag bad mywork~5&#xa;&#xa;$ git checkout bad&#xa;$ # make changes here and update the index&#xa;$ git commit --amend&#xa;$ # HEAD 指的是刚刚修改完 commit log 的提交&#xa;$ git rebase --onto HEAD bad mywork&#xa;&#xa;$ git tag -d bad">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_35536157" 
	TEXT="也可以用下面更为简洁的命令">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_603210112" 
	TEXT="$ git rebase -i mywork~5&#xa;Stopped at 7482e0d... updated the gemspec to hopefully work better&#xa;You can amend the commit now, with&#xa;&#xa;       git commit --amend&#xa;&#xa;Once you’re satisfied with your changes, run&#xa;&#xa;       git rebase --continue&#xa;&#xa;$ git commit --amend&#xa;$ git rebase --continue"/>
</node>
</node>
</node>
</node>
</node>
<node COLOR="#00b439" ID="ID_1758115602" 
	TEXT="Tag 和分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_1672445363" 
	TEXT="引用">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_197912906" 
	TEXT="remote">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_1635733651" 
	TEXT="远程 remote">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_869964709" 
	TEXT="分支合并">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_387283656" 
	TEXT="合并工具： kdiff3">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1031182526" 
	TEXT="访问 Git 对象的语法">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1914007866" 
	TEXT="40 hash">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_331628691" 
	TEXT="short hash">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1565629099" 
	TEXT="git describe 的类似输出">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_554258130" 
	TEXT="a closest tag, optionally followed by a dash and a number of commits, followed by a dash, a g, and an abbreviated object name."/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1066702103" 
	TEXT="tag 或者 branch 名称">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1305791724" 
	TEXT="            1. if $GIT_DIR/&lt;name&gt; exists, that is what you mean (this is usually useful only for HEAD, FETCH_HEAD, ORIG_HEAD and MERGE_HEAD);&#xa;&#xa;            2. otherwise, refs/&lt;name&gt; if exists;&#xa;&#xa;            3. otherwise, refs/tags/&lt;name&gt; if exists;&#xa;&#xa;            4. otherwise, refs/heads/&lt;name&gt; if exists;&#xa;&#xa;            5. otherwise, refs/remotes/&lt;name&gt; if exists;&#xa;&#xa;            6. otherwise, refs/remotes/&lt;name&gt;/HEAD if exists.&#xa;&#xa;               HEAD names the commit your changes in the working tree is based on. FETCH_HEAD records the branch you fetched from a remote repository&#xa;               with your last git fetch invocation. ORIG_HEAD is created by commands that moves your HEAD in a drastic way, to record the position of&#xa;               the HEAD before their operation, so that you can change the tip of the branch back to the state before you ran them easily. MERGE_HEAD&#xa;               records the commit(s) you are merging into your branch when you run git merge.&#xa;&#xa;               Note that any of the refs/* cases above may come either from the $GIT_DIR/refs directory or from the $GIT_DIR/packed-refs file.&#xa;&#xa;"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1481747587" 
	TEXT="date spec ： tag@{date}">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1929386422" 
	TEXT="@符号前面必须是一个 ref 引用名称。如果省略代表当前分支"/>
<node COLOR="#111111" ID="ID_1222712317" 
	TEXT="花括号内如果有空格，需要用引号括起来"/>
<node COLOR="#111111" ID="ID_1926362123" 
	TEXT="master@{yesterday}&#xa;"/>
<node COLOR="#111111" ID="ID_490673257" 
	TEXT="master@{&quot;1 month ago&quot;} "/>
<node COLOR="#111111" ID="ID_403138643" 
	TEXT="其它，如： {yesterday}, {1 month 2 weeks 3 days 1 hour 1 second            ago} or {1979-02-26 18:30:00}"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_671940362" 
	TEXT="ordinal spec ： master@{5} ">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_255719041" 
	TEXT="@ 符号前必须是一个 ref引用，而不能是一个 HASH-ID"/>
<node COLOR="#111111" ID="ID_767856448" 
	TEXT="{-n} 是 ref 之后的第n个提交"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_515202194" 
	TEXT="carrot parent ： master^2 ">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_233696486" 
	TEXT="^ 符号前面可以是引用或者 HASH-ID"/>
<node COLOR="#111111" ID="ID_356651474" 
	TEXT="master^ 相当于 master^1 即该提交的第一个 parent"/>
<node COLOR="#111111" ID="ID_1303302343" 
	TEXT="master^2 相当于该提交的第二个 parent"/>
<node COLOR="#111111" ID="ID_1634381833" 
	TEXT="^0 相当于提交本身。如果应用于一个 tag 对象，相当于tag对象指向的提交"/>
<node COLOR="#111111" ID="ID_1425345856" 
	TEXT="~5 相当于 ^^^^^"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_850052162" 
	TEXT="^{}">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_157893596" 
	TEXT="例如 v0.99.8^{}"/>
<node COLOR="#111111" ID="ID_678865064" 
	TEXT="对象可能是一个 tag，逐次解析直至一个非 tag 对象。"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1587542499" 
	TEXT="tilde spec ： e65s46~5 ">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_885943293" 
	TEXT="符号前可以是 ref 引用，也可以是 HASH-id"/>
</node>
<node COLOR="#990000" ID="ID_168649522" 
	TEXT="tree pointer ： e65s46^{tree} ">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_411153150" 
	TEXT=":/log_pattern ： 通过提交日志定位。冒号后面是斜线和日志">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1589996118" 
	TEXT="$ git rev-parse :/^git | xargs -i{} git cat-file -p {}"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_431349119" 
	TEXT="master:path/to/file ">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1591745017" 
	TEXT="blob spec 。文件"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_155413323" 
	TEXT=":0:README">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1143289749" 
	TEXT="访问 stage 中的文件。如果 stage 0, 可以省略0和一个冒号，如 :Readme"/>
<node COLOR="#111111" ID="ID_801271217" 
	TEXT="在合并的时候，stage 1 代表公共的祖先。stage 2 代表目标分支版本（当前分支版本），stage3 代表要合并的版本。"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_527892004" 
	TEXT="访问 Git 版本范围的语法">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_945774347" 
	TEXT="^r1 r2">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_37934130" 
	TEXT="^r1 r2 means commits reachable from r2 but exclude the ones        reachable from r1.">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1445746737" 
	TEXT="r1..r2">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_315803677" 
	TEXT="When you have two commits r1 and r2 (named according to the syntax        explained in SPECIFYING REVISIONS above), you can ask for commits that are reachable from r2 excluding those that are reachable from r1 by ^r1 r2        and it can be written as r1..r2.">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1268416785" 
	TEXT="r1...r2">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1794923099" 
	TEXT=" r1 r2 --not $(git merge-base --all r1 r2)"/>
<node COLOR="#111111" ID="ID_1637322380" 
	TEXT="A similar notation r1...r2 is called symmetric difference of r1 and r2 and is defined as r1 r2 --not $(git merge-base --all r1 r2). It is the set        of commits that are reachable from either one of r1 or r2 but not from both. "/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_603175635" 
	TEXT="r1^@">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_974512945" 
	TEXT="The r1^@ notation means all parents of r1."/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_828485619" 
	TEXT="r1^!">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_372153712" 
	TEXT="r1^!&#xa;       includes commit r1 but excludes all of its parents."/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_843005755" 
	TEXT="示例">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1320024771" 
	TEXT="&#xa;           G   H   I   J&#xa;            \ /     \ /&#xa;             D   E   F&#xa;              \  |  / \&#xa;               \ | /   |&#xa;                \|/    |&#xa;                 B     C&#xa;                  \   /&#xa;                   \ /&#xa;                    A&#xa;">
<font NAME="Courier New" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_913224514" 
	TEXT="           A =      = A^0&#xa;           B = A^   = A^1     = A~1&#xa;           C = A^2  = A^2&#xa;           D = A^^  = A^1^1   = A~2&#xa;           E = B^2  = A^^2&#xa;           F = B^3  = A^^3&#xa;           G = A^^^ = A^1^1^1 = A~3&#xa;           H = D^2  = B^^2    = A^^^2  = A~2^2&#xa;           I = F^   = B^3^    = A^^3^&#xa;           J = F^2  = B^3^2   = A^^3^2&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1915878443" 
	TEXT="总结：">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_475026628" 
	TEXT="可以通过建立 tag 来标记里程碑，以及用分支进行特性开发。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_49318021" 
	TEXT="命令总结">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1047345905" 
	TEXT="git tag"/>
<node COLOR="#111111" ID="ID_792830821" 
	TEXT="git branch"/>
</node>
<node COLOR="#990000" ID="ID_1933926024" 
	TEXT="我们已经知道如何操作本地分支，对于远程版本库的分支如何操作以及和本地分支的关系如何？">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_148688254" POSITION="right" 
	TEXT="Git 进阶（远程分支）">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" FOLDED="true" ID="ID_433746938" 
	TEXT="直接操作远程版本库的分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_606995194" 
	TEXT="如何查看远程服务器的分支？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1986091941" 
	TEXT="如何删除远程服务器的分支？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_927844154" 
	TEXT="如何在远程服务器上创建分支？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1197025428" 
	TEXT="本地分支和远程分支的关系">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_15981385" 
	TEXT="本地分支用于临时性的提交和试验（experiment)，如果和上游某个分支同名，会有什么问题么？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1413435672" 
	TEXT="具体说1: 如果我执行了 git pull ，会把上游的同名分支拉过来么？这可能是我不需要的。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1845345488" 
	TEXT="具体说2：如果我不小心执行了 git push，会把我本地的测试提交推送上游么？">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" ID="ID_1207155389" 
	TEXT="push 的语法">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_988747655" 
	TEXT="任何版本库都有 master 分支以及本地分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1550421566" 
	TEXT="如果向其它版本库 PUSH 的时候，会将本地所有分支推送到版本库中么？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_101142689" 
	TEXT="混乱，因为本地分支由个人管理，名称五花八门">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_695348295" 
	TEXT="作为集中式服务器需要更好的统一的分支名称管理">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_799638677" 
	TEXT="因此缺省是不会进行 push 的。">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_650221643" 
	TEXT="总结：">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_154672801" 
	TEXT="知道了如何操作远程分支以及远程分支和本地分支的关系">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_974768808" 
	TEXT="命令总结">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_621238900" 
	TEXT="git remote"/>
<node COLOR="#111111" ID="ID_1102078323" 
	TEXT="git branch -r"/>
</node>
<node COLOR="#990000" ID="ID_1996763168" 
	TEXT="我们已经知道如何操作本地分支，对于远程版本库的分支如何操作以及和本地分支的关系如何？">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1424004637" 
	TEXT="远程分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_539245296" 
	TEXT="显示和查看远程分支： git branch -r">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1743903876" 
	TEXT="git 以 origin/master 名称在本地版本库保留了远程版本库的分支。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_829197712" 
	TEXT="未 packed 的库，在 .git/refs/remotes/origin 目录下的文件代表远程分支">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_702292586" 
	TEXT="packed 之后的库，在 .git/packed-refs 文件： &#xa; * 保存了 tags 和 commit id 对应关系。&#xa; * 还保存了 远程版本库分支名： refs/remotes/origin/*">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1096514672" 
	TEXT="远程分支不能直接 checkout！">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1582544476" 
	TEXT="远程分支不能直接检出/查看，需要通过创建本地分支方式检出">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1758050633" 
	TEXT="$ git checkout -b my-todo-copy origin/todo">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1840200523" 
	TEXT="或者使用 --track 参数，直接创建同名的本地分支，以便更好的和该远程分支同步"/>
<node COLOR="#111111" ID="ID_1587629032" 
	TEXT="建立远程分支的本地分支： git checkout -b branchname origin/branchname">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_890592170" 
	TEXT="建立远程分支的本地分支的另外一个等价方法：&#xa;$ git checkout --track origin/branchname">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="idea"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1167537737" 
	TEXT="理解 Git 远程分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_257612643" 
	TEXT="获取远程版本库的分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_357415041" 
	TEXT="缺省同步/克隆一个版本库，是将 .git/refs/heads/ 下的本地分支克隆到新的版本库的 .git/refs/remote/ 下面"/>
<node COLOR="#111111" ID="ID_972022301" 
	TEXT="如果要将一个源库的 remotes 分支也同步到镜像版本库，需要增加一个 fetch 设置。具体的应用范例，参见"/>
<node COLOR="#111111" ID="ID_1308206492" 
	TEXT="        mkdir project&#xa;        cd project&#xa;        git init&#xa;        git remote add origin server:/pub/project&#xa;        git config --add remote.origin.fetch &apos;+refs/remotes/*:refs/remotes/*&apos;&#xa;        git fetch&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1045868165" 
	TEXT="远程分支引发的冲突">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_781319123" 
	TEXT="别人先我提交"/>
<node COLOR="#111111" ID="ID_924044629" 
	TEXT="我收回先前提交"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_415476154" 
	TEXT="删除远程分支:  git push origin :&lt;remote-branch-name&gt;">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_50163334" 
	TEXT="相当于命令 git push [remotename] [localbranch]:[remotebranch]  的 [localbranch] 为空">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_235525133" 
	TEXT="git push origin :branch_name"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1973915817" 
	TEXT="分支操作的安全性设置">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1569772311" 
	TEXT="是否允许 reset，版本库的安全设置">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1985647956" 
	TEXT="receive.denyNonFastForwards 如果设置为 true，禁止 non-fast forword"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1807048641" 
	TEXT="是否允许删除分支？">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_329380009" 
	TEXT="receive.denyDeletes"/>
</node>
<node COLOR="#990000" ID="ID_607752764" 
	TEXT="receive.denyCurrentBranch 缺省是 refuse，导致不能向含工作目录的库 push">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1491314093" 
	TEXT="git remote">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1605394372" 
	TEXT="克隆即分支">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1428695704" 
	TEXT="一些 DCVS，如 Hg，压根就没有分支概念，有的只是不同的版本库克隆"/>
<node COLOR="#111111" ID="ID_301815757" 
	TEXT="Git 有分支也有克隆，可以吧克隆看成是另外的分支，反之亦然"/>
<node COLOR="#111111" ID="ID_434286054" 
	TEXT="克隆的操作"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1697598217" 
	TEXT="remote 和克隆">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_121878323" 
	TEXT="问题： 如何将修改 push 到不同的服务器？"/>
<node COLOR="#111111" ID="ID_1688292333" 
	TEXT="先来看看这个问题： git clone 和 git init 的配置文件的差别"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1613287570" 
	TEXT="什么是 remote？">
<node COLOR="#111111" ID="ID_1724614543" 
	TEXT="git remote -v"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1530022290" 
	TEXT="那么如何push 到不同服务器呢？">
<node COLOR="#111111" ID="ID_1834765921" 
	TEXT="git remote add ..."/>
<node COLOR="#111111" ID="ID_967717756" 
	TEXT="git push ... master"/>
</node>
</node>
<node COLOR="#990000" ID="ID_899954519" 
	TEXT="remote 的名字空间">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1817874429" 
	TEXT="git remote add ： 跟踪其他源（除了缺省克隆时指定的源外）">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_641029727" 
	TEXT="$ git remote add linux-nfs git://linux-nfs.org/pub/nfs-2.6.git&#xa;$ git fetch linux-nfs&#xa;* refs/remotes/linux-nfs/master: storing branch &apos;master&apos; ...&#xa;  commit: bf81b46">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_114975816" 
	TEXT="相当于对 .git/config 进行了修改">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_693274854" 
	TEXT="git remote add name url 设定另外的同步源，用于 pull 和 fetch。相当于在 .git/config 文件尾部增加一个 remote 小节">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1090689828" 
	TEXT="$ tail .git/config&#xa;&#xa;[remote &quot;linux-nfs&quot;]&#xa;        url = git://linux-nfs.org/pub/nfs-2.6.git&#xa;        fetch = +refs/heads/*:refs/remotes/linux-nfs/*&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1518562701" 
	TEXT="remote update">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" ID="ID_1540388880" 
	TEXT="多个远程版本库">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_241320967" POSITION="right" 
	TEXT="Git 其它内容">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" FOLDED="true" ID="ID_497159056" 
	TEXT="git ls-tree">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_158650374" 
	TEXT="git ls-tree -r 命令可以递归查看">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" ID="ID_1242975695" 
	TEXT="git grep">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1177062367" 
	TEXT="instaweb">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_386475477" 
	TEXT="&#xa;If you don’t want to fire up Tk, you can also browse your repository&#xa;quickly via the git instaweb command. This will basically fire up a&#xa;web server running the gitweb (http://git.or.cz/gitwiki/Gitweb) CGI script&#xa;using lighttpd, apache or webrick. It then tries to automatically fire up&#xa;your default web browser and points it at the new server.&#xa;$ git instaweb --httpd=webrick&#xa;[2008-04-08 20:32:29] INFO WEBrick 1.3.1&#xa;[2008-04-08 20:32:29] INFO ruby 1.8.4 (2005-12-24) [i686-&#xa;darwin8.8.2]&#xa;">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_328071214" 
	TEXT="git gc">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_182713492" 
	TEXT="多长时间整理一次?">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_358793755" 
	TEXT="是否需要设置 gc.auto?">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_660180163" 
	TEXT="$ git config --global gc.auto 1"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1731754977" 
	TEXT="git fsck 可以查看哪些 blob 没有被引用">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_640289668" 
	TEXT="$ git fsck&#xa;dangling tree 8276318347b8e971733ca5fab77c8f5018c75261&#xa;dangling blob 2302a5a4baec369fb631bb89cfe287cc002dc049&#xa;dangling blob cb54512d0a989dcfb2d78a7f3c8909f76ad2326a&#xa;dangling tree 8e1088e1cc1bc67e0ef01e018707dcb07a2a562b&#xa;dangling blob 5e069ed35afae29015b6622fe715c0aee10112ad&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_957665703" 
	TEXT="git prune 可以删除没有用的文件">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_316957658" 
	TEXT="$ git prune -n&#xa;2302a5a4baec369fb631bb89cfe287cc002dc049&#xa;5e069ed35afae29015b6622fe715c0aee10112ad&#xa;8276318347b8e971733ca5fab77c8f5018c75261&#xa;8e1088e1cc1bc67e0ef01e018707dcb07a2a562b&#xa;cb54512d0a989dcfb2d78a7f3c8909f76ad2326a&#xa;$ git prune&#xa;$ git fsck&#xa;$&#xa;blob&#xa;blob&#xa;tree&#xa;tree&#xa;blob&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
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
