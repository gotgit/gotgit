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
<node COLOR="#00b439" ID="ID_190902118" 
	TEXT="Since Linus had (and still has) a passionate dislike of just about all&#xa;existing source code management systems, he decided to write his&#xa;own. Thus, in April of 2005, Git was born. A few months later, in July,&#xa;maintenance was turned over to Junio Hamano, who has maintained&#xa;the project ever since.&#xa;“I’m an egotistical bastard, and I name all my projects after myself.&#xa;First Linux, now git.” – Linus&#xa;">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_996144378" POSITION="right" 
	TEXT="Git 版本演进">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" FOLDED="true" ID="ID_1382353423" 
	TEXT="新内容">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1458306811" 
	TEXT="git 1.7.0 开始，支持稀疏检出（sparse checkout）">
<arrowlink DESTINATION="ID_1175431394" ENDARROW="Default" ENDINCLINATION="496;0;" ID="Arrow_ID_528443662" STARTARROW="None" STARTINCLINATION="496;0;"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_426664552" 
	TEXT="1.7.4开始，分支名称不能以减号（-）开始了。">
<arrowlink DESTINATION="ID_1353977648" ENDARROW="Default" ENDINCLINATION="567;0;" ID="Arrow_ID_1149913574" STARTARROW="None" STARTINCLINATION="567;0;"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1362930547" 
	TEXT="1.7.4 开始，系统范围的属性放在 /etc/gitattributes 下，可以用 core.attributesfile 来定制。">
<arrowlink DESTINATION="ID_1313454464" ENDARROW="Default" ENDINCLINATION="509;0;" ID="Arrow_ID_209018035" STARTARROW="None" STARTINCLINATION="509;0;"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_558897917" 
	TEXT="1.7.4开始，git read-tree  需要使用 --empty 清空 index。原来版本可以不加 --empty 未来将被取消。">
<arrowlink DESTINATION="ID_641667772" ENDARROW="Default" ENDINCLINATION="509;0;" ID="Arrow_ID_1247411754" STARTARROW="None" STARTINCLINATION="509;0;"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_549537488" 
	TEXT="1.7.4开始，可以扩展 git-shell">
<arrowlink DESTINATION="ID_1478661715" ENDARROW="Default" ENDINCLINATION="501;0;" ID="Arrow_ID_626498615" STARTARROW="None" STARTINCLINATION="501;0;"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1342349696" 
	TEXT="1.7.3 开始，git rebase 命令也支持 -X 参数。">
<arrowlink DESTINATION="ID_571745435" ENDARROW="Default" ENDINCLINATION="598;0;" ID="Arrow_ID_1769794447" STARTARROW="None" STARTINCLINATION="598;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_672690286" 
	TEXT="init 时的模板">
<arrowlink DESTINATION="ID_1873318436" ENDARROW="Default" ENDINCLINATION="385;0;" ID="Arrow_ID_1295226355" STARTARROW="None" STARTINCLINATION="385;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_932135575" 
	TEXT="git cherry-pick 和 git revert 支持版本范围">
<arrowlink DESTINATION="ID_802982994" ENDARROW="Default" ENDINCLINATION="307;0;" ID="Arrow_ID_810873421" STARTARROW="None" STARTINCLINATION="307;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1188644332" 
	TEXT="core.eol 和 text/eol 属性">
<arrowlink DESTINATION="ID_1826224759" ENDARROW="Default" ENDINCLINATION="423;0;" ID="Arrow_ID_83864035" STARTARROW="None" STARTINCLINATION="423;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1058200960" 
	TEXT="git status --ignored 可以显示忽略的文件">
<arrowlink DESTINATION="ID_1190862969" ENDARROW="Default" ENDINCLINATION="484;0;" ID="Arrow_ID_937212414" STARTARROW="None" STARTINCLINATION="484;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1207534196" 
	TEXT="git checkout --orphan">
<arrowlink DESTINATION="ID_378477505" ENDARROW="Default" ENDINCLINATION="622;0;" ID="Arrow_ID_634206484" STARTARROW="None" STARTINCLINATION="622;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1281981464" 
	TEXT="git status -s -b">
<arrowlink DESTINATION="ID_472554416" ENDARROW="Default" ENDINCLINATION="736;0;" ID="Arrow_ID_1628952368" STARTARROW="None" STARTINCLINATION="736;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_22869168" 
	TEXT="1.7.0 开始，git merge -Xsubtree=path/to/dir">
<arrowlink DESTINATION="ID_750449377" ENDARROW="Default" ENDINCLINATION="453;0;" ID="Arrow_ID_881115965" STARTARROW="None" STARTINCLINATION="453;0;"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_394112014" 
	TEXT="git branch origin --delete branch： 删除远程分支的新语法">
<arrowlink DESTINATION="ID_410954959" ENDARROW="Default" ENDINCLINATION="378;0;" ID="Arrow_ID_1625689504" STARTARROW="None" STARTINCLINATION="378;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1384571588" 
	TEXT="git rebase -i 支持 fixup 命令">
<arrowlink DESTINATION="ID_1885089706" ENDARROW="Default" ENDINCLINATION="436;0;" ID="Arrow_ID_858133395" STARTARROW="None" STARTINCLINATION="436;0;"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1845192798" 
	TEXT="git remote set-url">
<arrowlink DESTINATION="ID_1856626110" ENDARROW="Default" ENDINCLINATION="596;0;" ID="Arrow_ID_1339127841" STARTARROW="None" STARTINCLINATION="596;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_403948176" 
	TEXT="git status 在 1.7 版本支持 -s 参数">
<arrowlink DESTINATION="ID_1647068944" ENDARROW="Default" ENDINCLINATION="388;0;" ID="Arrow_ID_988979998" STARTARROW="None" STARTINCLINATION="388;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1861062746" 
	TEXT="git 1.6.6 起，提供智能HTTP支持">
<arrowlink DESTINATION="ID_376577638" ENDARROW="Default" ENDINCLINATION="241;0;" ID="Arrow_ID_401487274" STARTARROW="None" STARTINCLINATION="241;0;"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1000616699" 
	TEXT="git 1.6.6 起，当检出一个不存在分支，但是在 remotes 中存在，自动创建本地跟踪分支。">
<arrowlink DESTINATION="ID_1573102995" ENDARROW="Default" ENDINCLINATION="242;0;" ID="Arrow_ID_1420657099" STARTARROW="None" STARTINCLINATION="242;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_25188869" 
	TEXT="git 1.6.6 起，git commit -c/-C/--amend 参数，使用新的 committer ID，而不用原 log 中的。">
<arrowlink DESTINATION="ID_289042464" ENDARROW="Default" ENDINCLINATION="300;0;" ID="Arrow_ID_1069921645" STARTARROW="None" STARTINCLINATION="300;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1120410514" 
	TEXT="git 1.6.6 起，新的 git notes 命令，可以为提交附加注释">
<arrowlink DESTINATION="ID_357086736" ENDARROW="Default" ENDINCLINATION="585;0;" ID="Arrow_ID_166593595" STARTARROW="None" STARTINCLINATION="585;0;"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1176516418" 
	TEXT="git 1.6.6 起，git rebase -i 支持 reword 参数，修改历史提交的说明">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_599598790" 
	TEXT="git 1.6.6 起，git-svn 支持  svn 1.5的  mergetrack。">
<arrowlink DESTINATION="ID_562935013" ENDARROW="Default" ENDINCLINATION="397;0;" ID="Arrow_ID_1062677327" STARTARROW="None" STARTINCLINATION="397;0;"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_791961332" 
	TEXT="git 1.5.6，core.ignorecase 可以对大小写不敏感的文件系统提供支持">
<arrowlink DESTINATION="ID_1286567135" ENDARROW="Default" ENDINCLINATION="377;0;" ID="Arrow_ID_1839525646" STARTARROW="None" STARTINCLINATION="377;0;"/>
<arrowlink DESTINATION="ID_1286567135" ENDARROW="Default" ENDINCLINATION="377;0;" ID="Arrow_ID_646282505" STARTARROW="None" STARTINCLINATION="377;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1669471019" 
	TEXT="git 1.5.4, git ci --allow-empty">
<arrowlink DESTINATION="ID_1054041252" ENDARROW="Default" ENDINCLINATION="1281;0;" ID="Arrow_ID_1202135371" STARTARROW="None" STARTINCLINATION="1281;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1958435139" 
	TEXT="从 1.5.4 开始，不在使用  git-command，而是用  git command">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_819728988" 
	TEXT="git 1.5.0 开始出现的浅克隆">
<arrowlink DESTINATION="ID_269406994" ENDARROW="Default" ENDINCLINATION="733;0;" ID="Arrow_ID_320154676" STARTARROW="None" STARTINCLINATION="733;0;"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1002140911" 
	TEXT="1.7.4">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1353977648" 
	TEXT="1.7.4开始，分支名称不能以减号（-）开始了。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_514551657" 
	TEXT=" * The option parsers of various commands that create new branch (or    rename existing ones to a new name) were too loose and users were    allowed to call a branch with a name that begins with a dash by    creative abuse of their command line options, which only lead to    burn themselves.  The name of a branch cannot begin with a dash    now. "/>
</node>
<node COLOR="#990000" ID="ID_1313454464" 
	TEXT="1.7.4 开始，系统范围的属性放在 /etc/gitattributes 下，可以用 core.attributesfile 来定制。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_641667772" 
	TEXT="1.7.4开始，git read-tree  需要使用 --empty 清空 index。原来版本可以不加 --empty 未来将被取消。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1478661715" 
	TEXT="1.7.4开始，可以扩展 git-shell">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_361144147" 
	TEXT=" * you can extend &quot;git shell&quot;, which is often used on boxes that allow&#xa;   git-only login over ssh as login shell, with custom set of&#xa;   commands.&#xa;"/>
</node>
<node COLOR="#990000" ID="ID_1589699353" 
	TEXT="git log -G&lt;pattern&gt; ： 只显示匹配正则表达式的日志">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_148721287" 
	TEXT="git merge --log 增加选项（--log=47）可以显示超过20个条目">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_595517981" 
	TEXT=" * &quot;git merge --log&quot; used to limit the resulting merge log to 20&#xa;   entries; this is now customizable by giving e.g. &quot;--log=47&quot;.&#xa;"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_171792862" 
	TEXT="git diff 和 git grep 对 fortran 的支持">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1817659865" 
	TEXT=" * &quot;git diff&quot; and &quot;git grep&quot; learned how functions and subroutines&#xa;   in Fortran look like.&#xa;"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_26821308" 
	TEXT="1.7.3">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_326279428" 
	TEXT="git-gui 更新">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1168417067" 
	TEXT="    * git-gui, now at version 0.13.0, got various updates and a new&#xa;        maintainer, Pat Thoyts.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_527467018" 
	TEXT="1.7.3 开始，Git web 的配置直接生效。之前版本只在启动时生效。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1362700867" 
	TEXT="    * Gitweb allows its configuration to change per each request; it used to&#xa;        read the configuration once upon startup.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1679600004" 
	TEXT="1.7.3 开始，当 git 发现一个损坏的对象，报告包含它的文件。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1167826262" 
	TEXT="    * When git finds a corrupt object, it now reports the file that contains&#xa;        it.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_947196584" 
	TEXT="1.7.3 开始，git checkout 支持 -B 参数，相当于可以强制创建新分支。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_383096967" 
	TEXT="    * &quot;git checkout -B &lt;it&gt;&quot; is a shorter way to say &quot;git branch -f &lt;it&gt;&quot;&#xa;        followed by &quot;git checkout &lt;it&gt;&quot;.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1017955800" 
	TEXT="1.7.3 开始，git clean 命令支持 -e 参数，排除一些文件不必清理">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1267651196" 
	TEXT="    * &quot;git clean&quot; learned &quot;-e&quot; (&quot;--exclude&quot;) option.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1915520198" 
	TEXT="1.7.3 开始，当执行 git merge 可以对目录变成文件或相反，支持的更好。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1980042025" 
	TEXT="1.7.3 开始，git fetch $url 命令在不使用 refspec 时出错的问题已经解决。可能影响很长时间了。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="messagebox_warning"/>
</node>
<node COLOR="#990000" ID="ID_672909703" 
	TEXT="1.7.3 开始，解决了：当配置了 diff.noprefix ，git rebase 工作不好。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="messagebox_warning"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1534725170" 
	TEXT="1.7.3 开始，当执行  diff， status 命令时，可以通过 diff.ignoresubmodules 忽略子模组的改变">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1997284823" 
	TEXT="    * diff.ignoresubmodules configuration variable can be used to squelch the&#xa;        differences in submodules reported when running commands (e.g. &quot;diff&quot;,&#xa;        &quot;status&quot;, etc.) at the superproject level.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1656226009" 
	TEXT="1.7.3 开始，http.useragent 选项可以伪装为某种浏览器，以欺骗防火墙">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1819565233" 
	TEXT="    * http.useragent configuration can be used to lie who you are to your&#xa;        restrictive firewall.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_571745435" 
	TEXT="1.7.3 开始，git rebase --strategy 支持 -X 参数以传递所选 strategy 可用的附加参数">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_39282596" 
	TEXT="    * &quot;git rebase --strategy &lt;s&gt;&quot; learned &quot;-X&quot; option to pass extra options&#xa;        that are understood by the chosen merge strategy.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1089792426" 
	TEXT="1.7.3 开始，git rebase -i 支持 exec 选项，可以在两个步骤之间运行一个命令。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_151217568" 
	TEXT="    * &quot;git rebase -i&quot; learned &quot;exec&quot; that you can insert into the insn sheet&#xa;        to run a command between its steps.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1559961518" 
	TEXT="1.7.3 开始，git rebase 在变基时遇到很多二进制变更（不冲突）会更快。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1167378875" 
	TEXT="    * &quot;git rebase&quot; between branches that have many binary changes that do&#xa;        not conflict should be faster.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_795091466" 
	TEXT="1.7.3 开始，git rebase 读取 rebase.autosquash 设置，就像使用了 --autosquash 参数">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_57453508" 
	TEXT=" * &quot;git rebase -i&quot; peeks into rebase.autosquash configuration and acts as&#xa;   if you gave --autosquash from the command line.">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1143217323" 
	TEXT="1.7.3 开始，当 git checkout 和 git merge 因为本地存在修改而不工作时，以前只显示一个可能会丢失的文件，现在显示多个文件。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1715058906" 
	TEXT="    * When &quot;git checkout&quot; or &quot;git merge&quot; refuse to proceed in order to&#xa;        protect local modification to your working tree, they used to stop&#xa;        after showing just one path that might be lost.  They now show all,&#xa;        in a format that is easier to read.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1220606126" 
	TEXT="&quot;git -c foo=bar subcmd&quot; did not work well for subcmd that is not&#xa;   implemented as a built-in command.   ">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="messagebox_warning"/>
</node>
<node COLOR="#990000" ID="ID_752814557" 
	TEXT="    * Hunk headers produced for C# files by &quot;git diff&quot; and friends show more&#xa;        relevant context than before.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1489349200" 
	TEXT="1.7.2">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_802982994" 
	TEXT="1.7.2 开始，git cherry-pick 和 git revert 参数支持版本范围了！">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1200000649" 
	TEXT=" * &quot;git cherry-pick&quot; learned to pick a range of commits&#xa;   (e.g. &quot;cherry-pick A..B&quot; and &quot;cherry-pick --stdin&quot;), so did &quot;git&#xa;   revert&quot;; these do not support the nicer sequencing control &quot;rebase&#xa;   [-i]&quot; has, though.&#xa;"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_635893099" 
	TEXT="1.7.2 开始，git cherry-pick 和 git-revert 支持 --strategy 参数了">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1604019951" 
	TEXT=" * &quot;git cherry-pick&quot; and &quot;git revert&quot; learned --strategy option to specify&#xa;   the merge strategy to be used when performing three-way merges.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1826224759" 
	TEXT="1.7.2 开始，增加了 core.eol 配置和 text/eol 属性，设置文件的换行符">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1761534072" 
	TEXT=" * core.eol configuration and text/eol attributes are the new way to control&#xa;   the end of line conventions for files in the working tree.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_912417015" 
	TEXT="1.7.2 开始，配置 core.autocrlf 更加安全了。只对新文件，以及以LF-only格式的版本库文件起作用。&#xa;为了对版本库中使用了 CRLF 换行符的文件进行标准化，请使用新的 eol/text 属性。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1161450988" 
	TEXT=" * core.autocrlf has been made safer - it will now only handle line&#xa;   endings for new files and files that are LF-only in the&#xa;   repository. To normalize content that has been checked in with&#xa;   CRLF, use the new eol/text attributes."/>
</node>
<node COLOR="#990000" ID="ID_1190862969" 
	TEXT="1.7.2 开始， * &quot;git status [-s] --ignored&quot; can be used to list ignored paths. ">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_627208393" 
	TEXT="1.7.2 开始， * The whitespace rules used in &quot;git apply --whitespace&quot; and &quot;git diff&quot;&#xa;   gained a new member in the family (tab-in-indent) to help projects with&#xa;   policy to indent only with spaces.&#xa;">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_52986892" 
	TEXT="1.7.2 开始，:/&lt;string&gt; 现在支持正则表达式，而不再是从头匹配日志了。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_281404178" 
	TEXT=" * &apos;:/&lt;string&gt;&apos; notation to look for a commit now takes regular expression&#xa;   and it is not anchored at the beginning of the commit log message&#xa;   anymore (this is a backward incompatible change).">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_378477505" 
	TEXT="1.7.2 开始，支持 git checkout --orphan 参数创建一个空的分支。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1976543874" 
	TEXT=" * &quot;git checkout --orphan newbranch&quot; is similar to &quot;-b newbranch&quot; but&#xa;   prepares to create a root commit that is not connected to any existing&#xa;   commit.&#xa;"/>
</node>
<node COLOR="#990000" ID="ID_1632468552" 
	TEXT=" * &quot;git diff --word-diff=&lt;mode&gt;&quot; extends the existing &quot;--color-words&quot;&#xa;   option, making it more useful in color-challenged environments.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_472554416" 
	TEXT="1.7.2 开始， * &quot;git status -s -b&quot; shows the current branch in the output. ">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_688470198" 
	TEXT="1.7.2 开始， * &quot;git status&quot; learned &quot;--ignore-submodules&quot; option. ">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1679241762" 
	TEXT="1.7.2 开始， * &quot;git help -w&quot; learned &quot;chrome&quot; and &quot;chromium&quot; browsers. ">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_711992749" 
	TEXT=" * &quot;git notes prune&quot; learned &quot;-n&quot; (dry-run) and &quot;-v&quot; options, similar to&#xa;   what &quot;git prune&quot; has.&#xa;">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_328957149" 
	TEXT=" * &quot;git remote&quot; learned &quot;set-branches&quot; subcommand.&#xa;">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_527495663" 
	TEXT="解决了 file:// 协议中出现 % 的问题">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="messagebox_warning"/>
<node COLOR="#111111" ID="ID_1063583180" 
	TEXT=" * We didn&apos;t URL decode &quot;file:///path/to/repo&quot; correctly when path/to/repo&#xa;   had percent-encoded characters (638794c, 9d2e942, ce83eda, 3c73a1d)."/>
</node>
<node COLOR="#990000" ID="ID_1757862963" 
	TEXT=" * The regexp to detect function headers used by &quot;git diff&quot; for PHP has&#xa;   been enhanced for visibility modifiers (public, protected, etc.) to&#xa;   better support PHP5.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1876033116" 
	TEXT=" * &quot;diff.noprefix&quot; configuration variable can be used to implicitly&#xa;   ask for &quot;diff --no-prefix&quot; behaviour.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1850195503" 
	TEXT=" * &quot;git for-each-ref&quot; learned &quot;%(objectname:short)&quot; that gives the object&#xa;   name abbreviated.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_597764004" 
	TEXT=" * &quot;git format-patch&quot; learned --signature option and format.signature&#xa;   configuration variable to customize the e-mail signature used in the&#xa;   output.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1957809845" 
	TEXT=" * Various options to &quot;git grep&quot; (e.g. --count, --name-only) work better&#xa;   with binary files.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_912960538" 
	TEXT=" * &quot;git grep&quot; learned &quot;-Ovi&quot; to open the files with hits in your editor.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1986689095" 
	TEXT=" * &quot;git log --decorate&quot; shows commit decorations in various colours.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1544041030" 
	TEXT=" * &quot;git log --follow &lt;path&gt;&quot; follows across copies (it used to only follow&#xa;   renames).  This may make the processing more expensive.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1232038261" 
	TEXT=" * &quot;git log --pretty=format:&lt;template&gt;&quot; specifier learned &quot;% &lt;something&gt;&quot;&#xa;   magic that inserts a space only when %&lt;something&gt; expands to a&#xa;   non-empty string; this is similar to &quot;%+&lt;something&gt;&quot; magic, but is&#xa;   useful in a context to generate a single line output.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_197032726" 
	TEXT=" * &quot;git patch-id&quot; can be fed a mbox without getting confused by the&#xa;   signature line in the format-patch output.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_499106353" 
	TEXT=" * &quot;git rev-list A..B&quot; learned --ancestry-path option to further limit&#xa;   the result to the commits that are on the ancestry chain between A and&#xa;   B (i.e. commits that are not descendants of A are excluded).&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1260421500" 
	TEXT=" * &quot;git show -5&quot; is equivalent to &quot;git show --do-walk 5&quot;; this is similar&#xa;   to the update to make &quot;git show master..next&quot; walk the history,&#xa;   introduced in 1.6.4.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_823321367" 
	TEXT=" * Various &quot;gitweb&quot; enhancements and clean-ups, including syntax&#xa;   highlighting, &quot;plackup&quot; support for instaweb, .fcgi suffix to run&#xa;   it as FastCGI script, etc.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_426462981" 
	TEXT=" * The test harness has been updated to produce TAP-friendly output.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1181885261" 
	TEXT=" * Many documentation improvement patches are also included.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_383370029" 
	TEXT=" * &quot;git cvsserver&quot; can be told to use pserver; its password file can be&#xa;   stored outside the repository.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1001228511" 
	TEXT=" * &quot;git blame&quot; applies the textconv filter to the contents it works&#xa;   on, when available.&#xa;&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_537358478" 
	TEXT="DISCOVERY_ACROSS_FILESYSTEM 环境变量告诉 Git 在向上查询 .git 目录的时候不要在文件系统边界停止，一直搜索到/。">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_589428921" 
	TEXT=" * When working from a subdirectory, by default, git does not look for its&#xa;   metadirectory &quot;.git&quot; across filesystems, primarily to help people who&#xa;   have invocations of git in their custom PS1 prompts, as being outside&#xa;   of a git repository would look for &quot;.git&quot; all the way up to the root&#xa;   directory, and NFS mounts are often slow.  DISCOVERY_ACROSS_FILESYSTEM&#xa;   environment variable can be used to tell git not to stop at a&#xa;   filesystem boundary.&#xa;&#xa;"/>
</node>
<node COLOR="#990000" ID="ID_1358770686" 
	TEXT=" * &quot;git&quot; wrapper learned &quot;-c name=value&quot; option to override configuration    variable from the command line. ">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_573848694" 
	TEXT="1.7.1">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1873318436" 
	TEXT="1.7.1 开始，git init 可以检查 init.templatedir 配置的模板目录">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_953360056" 
	TEXT=" * &quot;git init&quot; can be told to look at init.templatedir configuration&#xa;   variable (obviously that has to come from either /etc/gitconfig or&#xa;   $HOME/.gitconfig).&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1610082031" 
	TEXT="TEMPLATE DIRECTORY&#xa;       The template directory contains files and directories that will be copied to the $GIT_DIR after it is created.&#xa;&#xa;       The template directory used will (in order):&#xa;&#xa;       ·   The argument given with the --template option.&#xa;&#xa;       ·   The contents of the $GIT_TEMPLATE_DIR environment variable.&#xa;&#xa;       ·   The init.templatedir configuration variable.&#xa;&#xa;       ·   The default template directory: /usr/share/git-core/templates.&#xa;&#xa;       The default template directory includes some directory structure, some suggested &quot;exclude patterns&quot;, and copies of sample &quot;hook&quot; files. The&#xa;       suggested patterns and hook files are all modifiable and extensible.&#xa;&#xa;"/>
</node>
<node COLOR="#990000" ID="ID_624451505" 
	TEXT="1.7.1 开始， * &quot;git notes&quot; command has been rewritten in C and learned many commands&#xa;   and features to help you carry notes forward across rebases and amends.&#xa;">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1446785559" 
	TEXT="1.7.1 开始， * &quot;git reset&quot; learned &quot;--keep&quot; option that lets you discard commits&#xa;   near the tip while preserving your local changes in a way similar&#xa;   to how &quot;git checkout branch&quot; does.">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_776560351" 
	TEXT=" * &quot;git request-pull&quot; identifies the commit the request is relative to in&#xa;   a more readable way.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1330094415" 
	TEXT="一些命令如 git svn, http 界面等交互式询问口令，可以通过 GIT_ASKPASS 设置外部程序读取口令">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1478313828" 
	TEXT=" * Some commands (e.g. svn and http interfaces) that interactively ask&#xa;   for a password can be told to use an external program given via&#xa;   GIT_ASKPASS.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_41776530" 
	TEXT="冲突的标识更易让 diff3 等识别">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_931924444" 
	TEXT=" * Conflict markers that lead the common ancestor in diff3-style output&#xa;   now have a label, which hopefully would help third-party tools that&#xa;   expect one.&#xa;"/>
</node>
<node COLOR="#990000" ID="ID_1471313774" 
	TEXT=" * &quot;git am&quot; learned &quot;--keep-cr&quot; option to handle inputs that are&#xa;   a mixture of changes to files with and without CRLF line endings.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1360681956" 
	TEXT=" * &quot;git cvsimport&quot; learned -R option to leave revision mapping between&#xa;   CVS revisions and resulting git commits.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_636336495" 
	TEXT=" * &quot;git diff --submodule&quot; notices and describes dirty submodules.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_188558849" 
	TEXT=" * &quot;git for-each-ref&quot; learned %(symref), %(symref:short) and %(flag)&#xa;   tokens.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_672671253" 
	TEXT=" * &quot;git hash-object --stdin-paths&quot; can take &quot;--no-filters&quot; option now.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1436326505" 
	TEXT=" * &quot;git grep&quot; learned &quot;--no-index&quot; option, to search inside contents that&#xa;   are not managed by git.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1277976163" 
	TEXT=" * &quot;git grep&quot; learned --color=auto/always/never.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1953379108" 
	TEXT=" * &quot;git grep&quot; learned to paint filename and line-number in colors.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_534895962" 
	TEXT=" * &quot;git log -p --first-parent -m&quot; shows one-parent diff for merge&#xa;   commits, instead of showing combined diff.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1972688678" 
	TEXT=" * &quot;git merge-file&quot; learned to use custom conflict marker size and also&#xa;   to use the &quot;union merge&quot; behaviour.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_476752935" 
	TEXT=" * &quot;git status&quot; notices and describes dirty submodules.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1926944721" 
	TEXT=" * &quot;git svn&quot; should work better when interacting with repositories&#xa;   with CRLF line endings.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1223400416" 
	TEXT=" * &quot;git imap-send&quot; learned to support CRAM-MD5 authentication.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1718360383" 
	TEXT=" * &quot;gitweb&quot; installation procedure can use &quot;minified&quot; js/css files&#xa;   better.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_379311746" 
	TEXT=" * Various documentation updates.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1070179243" 
	TEXT="1.7.0">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1775879331" 
	TEXT="1.7.0 开始，当向远程带工作区版本库的当前分支 push 时，禁止！（1.6.2以后就已经开始警告了）">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_861857010" 
	TEXT=" * &quot;git push&quot; into a branch that is currently checked out (i.e. pointed at by&#xa;   HEAD in a repository that is not bare) is refused by default.&#xa;&#xa;   Similarly, &quot;git push $there :$killed&quot; to delete the branch $killed&#xa;   in a remote repository $there, when $killed branch is the current&#xa;   branch pointed at by its HEAD, will be refused by default.&#xa;&#xa;   Setting the configuration variables receive.denyCurrentBranch and&#xa;   receive.denyDeleteCurrent to &apos;ignore&apos; in the receiving repository&#xa;   can be used to override these safety features.&#xa;"/>
</node>
<node COLOR="#990000" ID="ID_739710898" 
	TEXT="1.7.0 开始，git-svn 支持 Subversion 的 merge tracks。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1175431394" 
	TEXT="1.7.0 开始，稀疏检出支持只检出部分工作区文件">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1004796795" 
	TEXT=" * &quot;sparse checkout&quot; feature allows only part of the work tree to be  checked out. ">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1170051309" 
	TEXT="设置 core.sparseCheckout 为 on"/>
<node COLOR="#111111" ID="ID_1408659630" 
	TEXT="Sparse checkout&#xa;&#xa;&quot;Sparse checkout&quot; allows to sparsely populate working directory. It uses skip-worktree bit (see git-update-index(1)) to tell Git whether a file on working directory is worth looking at.&#xa;&#xa;&quot;git read-tree&quot; and other merge-based commands (&quot;git merge&quot;, &quot;git checkout&quot;…) can help maintaining skip-worktree bitmap and working directory update. $GIT_DIR/info/sparse-checkout is used to define the skip-worktree reference bitmap. When &quot;git read-tree&quot; needs to update working directory, it will reset skip-worktree bit in index based on this file, which uses the same syntax as .gitignore files. If an entry matches a pattern in this file, skip-worktree will be set on that entry. Otherwise, skip-worktree will be unset.&#xa;&#xa;Then it compares the new skip-worktree value with the previous one. If skip-worktree turns from unset to set, it will add the corresponding file back. If it turns from set to unset, that file will be removed.&#xa;&#xa;While $GIT_DIR/info/sparse-checkout is usually used to specify what files are in. You can also specify what files are _not_ in, using negate patterns. For example, to remove file &quot;unwanted&quot;:&#xa;&#xa;*&#xa;!unwanted&#xa;&#xa;Another tricky thing is fully repopulating working directory when you no longer want sparse checkout. You cannot just disable &quot;sparse checkout&quot; because skip-worktree are still in the index and you working directory is still sparsely populated. You should re-populate working directory with the $GIT_DIR/info/sparse-checkout file content as follows:&#xa;&#xa;*&#xa;&#xa;Then you can disable sparse checkout. Sparse checkout support in &quot;git read-tree&quot; and similar commands is disabled by default. You need to turn core.sparseCheckout on in order to have sparse checkout support.&#xa;"/>
<node COLOR="#111111" ID="ID_511482883" 
	TEXT="$ git clone ~/git/git&#xa;$ cd git&#xa;$ ls|wc -l&#xa;361&#xa;$ git config core.sparsecheckout true&#xa;$ echo ppc/ &gt; .git/info/sparse-checkout&#xa;$ echo perl/ &gt;&gt; .git/info/sparse-checkout&#xa;$ git read-tree -m -u HEAD&#xa;$ ls&#xa;perl/  ppc/&#xa;"/>
<node COLOR="#111111" ID="ID_921099678" 
	TEXT="Checkout sub directories in git (sparse checkouts)&#xa;&#xa;SVN externals is a really nice feature I used a lot. Switching to git I was really missing it. Of course there is git-submodule but it’s not the same. Now, with version 1.7 git supports so called sparse checkouts which allow you to only include specific sub directories of a repository in your project. You still need to clone the whole repository, but afterwards you can tell git to only show the specified sub directories.&#xa;&#xa;Here is how it works:&#xa;&#xa;   1. clone the other repository (in my case, for a Rails app, I did it in vendor/plugins/)&#xa;&#xa;      git clone &lt;repository_url&gt; &lt;directory&gt;&#xa;&#xa;   2. cd to &lt;directory&gt;&#xa;&#xa;      cd &lt;directory&gt;&#xa;&#xa;   3. enable sparsecheckout&#xa;&#xa;      git config core.sparsecheckout true&#xa;&#xa;   4. add directories you want to have in your checkout to .git/info/sparse-checkout, e.g.&#xa;&#xa;      echo app/models/ &gt; .git/info/sparse-checkout&#xa;      echo lib/ &gt;&gt; .git/info/sparse-checkout&#xa;&#xa;   5. run read-tree&#xa;&#xa;      git read-tree -m -u HEAD&#xa;&#xa;ls now shows&#xa;&#xa;app lib&#xa;&#xa;Forgot a directory you wanted to include? Just repeat step 4 and 5."/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_515274876" 
	TEXT="1.7.0 开始，git fetch 增加了 --all 参数，获取所有跟踪上游。（1.6.6 即支持）">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1731241106" 
	TEXT=" * &quot;git fetch --all&quot; can now be used in place of &quot;git remote update&quot;.">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_750449377" 
	TEXT="1.7.0 开始， git merge 可以传递参数">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_718813018" 
	TEXT=" * &quot;git merge&quot; learned to pass options specific to strategy-backends.  E.g.&#xa;&#xa;    - &quot;git merge -Xsubtree=path/to/directory&quot; can be used to tell the subtree&#xa;      strategy how much to shift the trees explicitly.&#xa;                                                                                                                                                            &#xa;    - &quot;git merge -Xtheirs&quot; can be used to auto-merge as much as possible,&#xa;      while discarding your own changes and taking merged version in&#xa;      conflicted regions.&#xa;"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_410954959" 
	TEXT="1.7.0 开始，删除分支可以使用新语法">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1405789984" 
	TEXT=" * &quot;git push&quot; learned &quot;git push origin --delete branch&quot;, a syntactic sugar&#xa;   for &quot;git push origin :branch&quot;.&#xa;"/>
</node>
<node COLOR="#990000" ID="ID_1647068944" 
	TEXT="1.7.0 开始，git status 在 1.7 版本支持 -s 参数">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_649723620" 
	TEXT="1.7.0 开始，git push --upstream">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1616575731" 
	TEXT=" * &quot;git push&quot; learned &quot;git push --set-upstream origin forker:forkee&quot; that&#xa;   lets you configure your &quot;forker&quot; branch to later pull from &quot;forkee&quot;&#xa;   branch at &quot;origin&quot;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1885089706" 
	TEXT="1.7.0 开始，git rebase -i 支持 fixup 命令">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1048397282" 
	TEXT=" * &quot;git rebase -i&quot; learned new action &quot;fixup&quot; that squashes the change&#xa;   but does not affect existing log message.&#xa;"/>
<node COLOR="#111111" ID="ID_526881727" 
	TEXT=" * &quot;git rebase -i&quot; also learned --autosquash option that is useful&#xa;   together with the new &quot;fixup&quot; action.&#xa;"/>
</node>
<node COLOR="#990000" ID="ID_1856626110" 
	TEXT="1.7.0 开始， * &quot;git remote&quot; learned set-url subcommand that updates (surprise!) url&#xa;   for an existing remote nickname.&#xa;">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_859224047" 
	TEXT="HTTP 认证可以使用除 basic 认证外的 digest 认证">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1671704539" 
	TEXT=" * A new syntax &quot;&lt;branch&gt;@{upstream}&quot; can be used on the command line to&#xa;   substitute the name of the &quot;upstream&quot; of the branch.  Missing branch&#xa;   defaults to the current branch, so &quot;git fetch &amp;&amp; git merge @{upstream}&quot;&#xa;   will be equivalent to &quot;git pull&quot;.&#xa;">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1236579405" 
	TEXT=" * &quot;git checkout A...B&quot; is a way to detach HEAD at the merge base between&#xa;   A and B.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1002208138" 
	TEXT="其它">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1742665431" 
	TEXT=" * Various commands given by the end user (e.g. diff.type.textconv,&#xa;   and GIT_EDITOR) can be specified with command line arguments.  E.g. it&#xa;   is now possible to say &quot;[diff &quot;utf8doc&quot;] textconv = nkf -w&quot;.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1914856080" 
	TEXT=" * &quot;git send-email&quot; does not make deep threads by default when sending a&#xa;   patch series with more than two messages.  All messages will be sent&#xa;   as a reply to the first message, i.e. cover letter.&#xa;&#xa;   It has been possible already to configure send-email to send &quot;shallow thread&quot;&#xa;   by setting sendemail.chainreplyto configuration variable to false.  The&#xa;   only thing this release does is to change the default when you haven&apos;t&#xa;   configured that variable.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1071476024" 
	TEXT=" * More performance improvement patches for msysgit port.">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1168678555" 
	TEXT=" * &quot;git diff&quot; traditionally treated various &quot;ignore whitespace&quot; options&#xa;   only as a way to filter the patch output.  &quot;git diff --exit-code -b&quot;&#xa;   exited with non-zero status even if all changes were about changing the&#xa;   amount of whitespace and nothing else;  and &quot;git diff -b&quot; showed the&#xa;   &quot;diff --git&quot; header line for such a change without patch text.&#xa;&#xa;   In this release, the &quot;ignore whitespaces&quot; options affect the semantics&#xa;   of the diff operation.  A change that does not affect anything but&#xa;   whitespaces is reported with zero exit status when run with&#xa;   --exit-code, and there is no &quot;diff --git&quot; header for such a change.">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_843923492" 
	TEXT=" * External diff and textconv helpers are now executed using the shell.&#xa;   This makes them consistent with other programs executed by git, and&#xa;   allows you to pass command-line parameters to the helpers. Any helper&#xa;   paths containing spaces or other metacharacters now need to be&#xa;   shell-quoted.  The affected helpers are GIT_EXTERNAL_DIFF in the&#xa;   environment, and diff.*.command and diff.*.textconv in the config&#xa;   file.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_385608324" 
	TEXT=" * The --max-pack-size argument to &apos;git repack&apos;, &apos;git pack-objects&apos;, and&#xa;   &apos;git fast-import&apos; was assuming the provided size to be expressed in MiB,&#xa;   unlike the corresponding config variable and other similar options accepting&#xa;   a size value.  It is now expecting a size expressed in bytes, with a possible&#xa;   unit suffix of &apos;k&apos;, &apos;m&apos;, or &apos;g&apos;.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1800206833" 
	TEXT="1.7.0 和之前版本的兼容性问题">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1005622121" 
	TEXT="当向远程带工作区版本库的当前分支 push 时，警告。实际在 1.6.2 就引入了。">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1159865590" 
	TEXT=" * &quot;git push&quot; into a branch that is currently checked out (i.e. pointed at by&#xa;   HEAD in a repository that is not bare) is refused by default.&#xa;&#xa;   Similarly, &quot;git push $there :$killed&quot; to delete the branch $killed&#xa;   in a remote repository $there, when $killed branch is the current&#xa;   branch pointed at by its HEAD, will be refused by default.&#xa;&#xa;   Setting the configuration variables receive.denyCurrentBranch and&#xa;   receive.denyDeleteCurrent to &apos;ignore&apos; in the receiving repository&#xa;   can be used to override these safety features.&#xa;"/>
<node COLOR="#111111" ID="ID_1673420217" 
	TEXT=" * &quot;git push&quot; into a branch that is currently checked out (i.e. pointed by&#xa;   HEAD in a repository that is not bare) will be refused by default.&#xa;&#xa;   Similarly, &quot;git push $there :$killed&quot; to delete the branch $killed&#xa;   in a remote repository $there, when $killed branch is the current&#xa;   branch pointed at by its HEAD, will be refused by default.&#xa;&#xa;   Setting the configuration variables receive.denyCurrentBranch and&#xa;   receive.denyDeleteCurrent to &apos;ignore&apos; in the receiving repository&#xa;   can be used to override these safety features.  Versions of git&#xa;   since 1.6.2 have issued a loud warning when you tried to do these&#xa;   operations without setting the configuration, so repositories of&#xa;   people who still need to be able to perform such a push should&#xa;   already have been future proofed.&#xa;&#xa;   Please refer to:&#xa;&#xa;   http://git.or.cz/gitwiki/GitFaq#non-bare&#xa;   http://thread.gmane.org/gmane.comp.version-control.git/107758/focus=108007&#xa;&#xa;   for more details on the reason why this change is needed and the&#xa;   transition process that already took place so far.&#xa;"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1253461329" 
	TEXT="1.6.6">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1971651865" 
	TEXT="1.6.6 开始，git fsck 缺省使用 --full 参数，如果希望使用原来快速模式 ，可以用 --no-full 参数（在1.5.4之后就支持者 --no-full 参数了）。">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_941336105" 
	TEXT=" * &quot;git fsck&quot; by default checks the packfiles (i.e. &quot;--full&quot; is the&#xa;   default); you can turn it off with &quot;git fsck --no-full&quot;.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_376577638" 
	TEXT="1.6.6 开始，git fetch 支持智能  HTTP">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1573102995" 
	TEXT="1.6.6 开始，当检出一个不存在分支，但是在 remotes 中存在，自动创建本地跟踪分支。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_289042464" 
	TEXT="1.6.6 开始，git commit -c/-C/--amend 参数，使用新的 committer ID，而不用原 log 中的。">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1105463259" 
	TEXT=" * &quot;git commit -c/-C/--amend&quot; can be told with a new &quot;--reset-author&quot; option&#xa;   to ignore authorship information in the commit it is taking the message&#xa;   from.&#xa;"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1176376225" 
	TEXT="1.6.6 开始，git fetch 增加了 --all 参数，获取所有跟踪上游。（1.6.6 即支持）">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_400788295" 
	TEXT=" * &quot;git fetch --all&quot; can now be used in place of &quot;git remote update&quot;.">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1055299445" 
	TEXT=" * &quot;git fetch&quot; learned --all and --multiple options, to run fetch from&#xa;   many repositories, and --prune option to remove remote tracking&#xa;   branches that went stale.  These make &quot;git remote update&quot; and &quot;git&#xa;   remote prune&quot; less necessary (there is no plan to remove &quot;remote&#xa;   update&quot; nor &quot;remote prune&quot;, though).&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_764335338" 
	TEXT="1.6.6 开始， * &quot;git instaweb&quot; knows how to talk with mod_cgid to apache2. ">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_699936559" 
	TEXT="1.6.6 开始，git rebase -i 支持 reword 参数，修改历史提交的说明">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_733761588" 
	TEXT=" * &quot;git rebase -i&quot; learned &quot;reword&quot; that acts like &quot;edit&quot; but immediately&#xa;   starts an editor to tweak the log message without returning control to&#xa;   the shell, which is done by &quot;edit&quot; to give an opportunity to tweak the&#xa;   contents.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_562935013" 
	TEXT="1.6.6 开始， * &quot;git svn&quot; learned to read SVN 1.5+ and SVK merge tickets. ">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1217223988" 
	TEXT=" * &quot;git svn&quot; learned to recreate empty directories tracked only by SVN.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1447725313" 
	TEXT=" * &quot;git describe&quot; can be told to add &quot;-dirty&quot; suffix with &quot;--dirty&quot; option. ">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_477480258" 
	TEXT=" * &quot;git grep&quot; can use -F (fixed strings) and -i (ignore case) together.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_325088979" 
	TEXT=" * import-tars contributed fast-import frontend learned more types of&#xa;   compressed tarballs.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_115705365" 
	TEXT=" * &quot;git log --decorate&quot; shows the location of HEAD as well.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1446678635" 
	TEXT=" * &quot;git log&quot; and &quot;git rev-list&quot; learned to take revs and pathspecs from&#xa;   the standard input with the new &quot;--stdin&quot; option.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_609091979" 
	TEXT=" * &quot;--pretty=format&quot; option to &quot;log&quot; family of commands learned:&#xa;&#xa;   . to wrap text with the &quot;%w()&quot; specifier.&#xa;   . to show reflog information with &quot;%g[sdD]&quot; specifier.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_357086736" 
	TEXT="新的 git notes 命令，可以为提交附加注释">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1732949801" 
	TEXT=" * &quot;git notes&quot; command to annotate existing commits.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_898585434" 
	TEXT=" * &quot;git merge&quot; (and &quot;git pull&quot;) learned --ff-only option to make it fail&#xa;   if the merge does not result in a fast-forward.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1684951903" 
	TEXT=" * &quot;git mergetool&quot; learned to use p4merge.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_802260172" 
	TEXT=" * &quot;git send-email&quot; can be told with &quot;--envelope-sender=auto&quot; to use the&#xa;   same address as &quot;From:&quot; address as the envelope sender address.">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1816183958" 
	TEXT=" * &quot;git send-email&quot; will issue a warning when it defaults to the&#xa;   --chain-reply-to behaviour without being told by the user and&#xa;   instructs to prepare for the change of the default in 1.7.0 release.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_966213929" 
	TEXT=" * In &quot;git submodule add &lt;repository&gt; &lt;path&gt;&quot;, &lt;path&gt; is now optional and&#xa;   inferred from &lt;repository&gt; the same way &quot;git clone &lt;repository&gt;&quot; does.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1779387905" 
	TEXT=" * &quot;gitweb&quot; can optionally render its &quot;blame&quot; output incrementally (this&#xa;   requires JavaScript on the client side).&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_30771611" 
	TEXT=" * Author names shown in gitweb output are links to search commits by the&#xa;   author.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1719050810" 
	TEXT="1.6.5">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_614711157" 
	TEXT="1.6.5 开始，git clone 不在复制 refs 下除了 heads, tags 外的引用">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_790125804" 
	TEXT=" * &quot;git clone&quot; does not grab objects that it does not need (i.e.&#xa;   referenced only from refs outside refs/heads and refs/tags&#xa;   hierarchy) anymore.&#xa;"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_915333998" 
	TEXT="1.6.5 开始，gc 和 .git 下文件的 mtime 相关？">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_698460521" 
	TEXT=" * &quot;git clone&quot; run locally hardlinks or copies the files in .git/ to&#xa;   newly created repository.  It used to give new mtime to copied files,&#xa;   but this delayed garbage collection to trigger unnecessarily in the&#xa;   cloned repository.  We now preserve mtime for these files to avoid&#xa;   this issue.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1089962016" 
	TEXT="1.6.5 开始，git replace 命令和 refs/replace/">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_57588445" 
	TEXT=" * refs/replace/ hierarchy is designed to be usable as a replacement&#xa;   of the &quot;grafts&quot; mechanism, with the added advantage that it can be&#xa;   transferred across repositories.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_773427270" 
	TEXT="1.6.5 开始，git clone --recursive 参数，直接初始化 子模组。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_297426783" 
	TEXT="1.6.5 开始，支持 git init this 。直接创建子目录，并克隆">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_68365358" 
	TEXT=" * &quot;git instaweb&quot; optionally can use mongoose as the web server.">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1903717576" 
	TEXT="1.6.4">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_154750986" 
	TEXT="* Git-over-ssh transport on Windows supports PuTTY plink and TortoisePlink.">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_113258859" 
	TEXT="增加 remote.$name.pushurl">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1947274560" 
	TEXT=" * &quot;git push $name&quot; honors remote.$name.pushurl if present before&#xa;   using remote.$name.url.  In other words, the URL used for fetching&#xa;   and pushing can be different.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1052460274" 
	TEXT="git am 支持 StGIT">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1574260622" 
	TEXT=" * &quot;git am&quot; accepts StGIT series file as its input. ">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_253983951" 
	TEXT=" * &quot;git add --edit&quot; lets users edit the whole patch text to fine-tune what&#xa;   is added to the index.&#xa;">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_250002113" 
	TEXT="1.6.3">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1219038649" 
	TEXT="git 配置中的布尔值是 yes/no ，还可以是 on/off">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1461051787" 
	TEXT="* Boolean configuration variable yes/no can be written as on/off.">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_223733961" 
	TEXT="* &quot;--oneline&quot; is a synonym for &quot;--pretty=oneline --abbrev-commit&quot;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1650751061" 
	TEXT="* @{-1} is a new way to refer to the last branch you were on introduced in&#xa;  1.6.2, but the initial implementation did not teach this to a few&#xa;  commands.  Now the syntax works with &quot;branch -m @{-1} newname&quot;.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_284916482" 
	TEXT="git branch -v -v">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_792050738" 
	TEXT="* &quot;git-branch -v -v&quot; is a new way to get list of names for branches and the&#xa;  &quot;upstream&quot; branch for them.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1181351741" 
	TEXT="git config -e 可以打开配置文件直接编辑">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_925317149" 
	TEXT="* git-config learned -e option to open an editor to edit the config file   directly.">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1345899858" 
	TEXT="* You can give --date=&lt;format&gt; option to git-blame. ">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_585472460" 
	TEXT="* git-imap-send learned to work around Thunderbird&apos;s inability to easily   disable format=flowed with a new configuration, imap.preformattedHTML.  ">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_178661559" 
	TEXT="1.6.2">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1854665092" 
	TEXT="@{-1} 上一次工作的分支">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1622452000" 
	TEXT="* @{-1} is a way to refer to the last branch you were on.  This is   accepted not only where an object name is expected, but anywhere   a branch name is expected and acts as if you typed the branch name.   E.g. &quot;git branch --track mybranch @{-1}&quot;, &quot;git merge @{-1}&quot;, and   &quot;git rev-parse --symbolic-full-name @{-1}&quot; would work as expected.  "/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1147901916" 
	TEXT="git checkout - ： 检出上次工作分支">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_964650680" 
	TEXT="* &quot;git checkout -&quot; is a shorthand for &quot;git checkout @{-1}&quot;. ">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_798318685" 
	TEXT="1.6.1">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_447530033" 
	TEXT="* &quot;git svn&quot; can rebuild an out-of-date rev_map file.">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_540080135" 
	TEXT="* &quot;git svn branch&quot; can create new branches on the other end. ">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1171341079" 
	TEXT="* &quot;git describe --tags&quot; favours closer lightweight tags than farther   annotated tags now. ">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1006937695" 
	TEXT="1.6.0">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_34978065" 
	TEXT="从 1.5.4 开始，不在使用  git-command，而是用  git command">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_417952020" 
	TEXT="An ancient merge strategy &quot;stupid&quot; has been removed.">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1800640013" 
	TEXT="git-clone --mirror 以裸版本库方式克隆，非常方便">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_473956048" 
	TEXT="&quot;git-clone --mirror&quot; is a handy way to set up a bare mirror repository."/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_528335561" 
	TEXT="stash 过期">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_903249304" 
	TEXT="* By default, stash entries never expire.  Set reflogexpire in [gc   &quot;refs/stash&quot;] to a reasonable value to get traditional auto-expiration   behaviour back"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1261388683" 
	TEXT="git add -i 支持 edit">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_547163094" 
	TEXT="* &quot;git-add -i&quot; has a new action &apos;e/dit&apos; to allow you edit the patch hunk&#xa;  manually.&#xa;"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1178646984" 
	TEXT="1.5.6（基础版本）">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<icon BUILTIN="gohome"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1286567135" 
	TEXT="core.ignorecase 可以对大小写不敏感的文件系统提供支持">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_595025543" 
	TEXT="* core.ignorecase configuration variable can be used to work better on   filesystems that are not case sensitive. ">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1441775252" 
	TEXT="* &quot;git init&quot; now autodetects the case sensitivity of the filesystem and&#xa;  sets core.ignorecase accordingly.&#xa;"/>
</node>
<node COLOR="#990000" ID="ID_413026257" 
	TEXT="* &quot;git init --bare&quot; is a synonym for &quot;git --bare init&quot; now.">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_721605042" 
	TEXT="* &quot;git cherry-pick&quot; and &quot;git revert&quot; can add a sign-off">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1570694201" 
	TEXT="* &quot;git branch&quot; (and &quot;git checkout -b&quot;) can be told to set up&#xa;  branch.&lt;name&gt;.rebase automatically, so that later you can say &quot;git pull&quot;&#xa;  and magically cause &quot;git pull --rebase&quot; to happen.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1315433003" 
	TEXT="* &quot;git clone&quot; was rewritten in C.  This will hopefully help cloning a   repository with insane number of refs. ">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="button_ok"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_431032935" 
	TEXT="1.5.5">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_942196338" 
	TEXT=" * &quot;git gc&quot; now automatically prunes unreachable objects that are two&#xa;   weeks old or older.&#xa;">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1155030838" 
	TEXT=" * &quot;git branch&quot; (and &quot;git checkout -b&quot;) to branch from a local branch can&#xa;   optionally set &quot;branch.&lt;name&gt;.merge&quot; to mark the new branch to build on&#xa;   the other local branch, when &quot;branch.autosetupmerge&quot; is set to&#xa;   &quot;always&quot;, or when passing the command line option &quot;--track&quot; (this option&#xa;   was ignored when branching from local branches).  By default, this does&#xa;   not happen when branching from a local branch.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_970676210" 
	TEXT=" * &quot;git checkout&quot; to switch to a branch that has &quot;branch.&lt;name&gt;.merge&quot; set&#xa;   (i.e. marked to build on another branch) reports how much the branch&#xa;   and the other branch diverged.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1488328671" 
	TEXT=" * &quot;git commit&quot; learned a new hook &quot;prepare-commit-msg&quot; that can&#xa;   inspect what is going to be committed and prepare the commit&#xa;   log message template to be edited.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_569277201" 
	TEXT=" * A pattern &quot;foo/&quot; in .gitignore file now matches a directory&#xa;   &quot;foo&quot;.  Pattern &quot;foo&quot; also matches as before.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_956118664" 
	TEXT=" * You can be warned when core.autocrlf conversion is applied in&#xa;   such a way that results in an irreversible conversion.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_889814542" 
	TEXT=" * &quot;git help &lt;alias&gt;&quot; now reports &quot;&apos;git &lt;alias&gt;&apos; is alias to &lt;what&gt;&quot;,&#xa;   instead of saying &quot;No manual entry for git-&lt;alias&gt;&quot;.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_288387704" 
	TEXT=" * &quot;git stash&quot; learned &quot;pop&quot; command, that applies the latest stash and&#xa;   removes it from the stash, and &quot;drop&quot; command to discard the named&#xa;   stash entry.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1210722729" 
	TEXT=" * &quot;git checkout&quot; is rewritten in C.&#xa;&#xa; * &quot;git remote&quot; is rewritten in C.&#xa;">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="button_ok"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1121010630" 
	TEXT="1.5.4">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_710440610" 
	TEXT="不再提供 git-command 命令，而是用 git command 取而代之">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_662415801" 
	TEXT=" * From v1.6.0, git will by default install dashed form of commands&#xa;   (e.g. &quot;git-commit&quot;) outside of users&apos; normal $PATH, and will install&#xa;   only selected commands (&quot;git&quot; itself, and &quot;gitk&quot;) in $PATH.  This&#xa;   implies:&#xa;&#xa;   - Using dashed forms of git commands (e.g. &quot;git-commit&quot;) from the&#xa;     command line has been informally deprecated since early 2006, but&#xa;     now it officially is, and will be removed in the future.  Use&#xa;     dash-less forms (e.g. &quot;git commit&quot;) instead.&#xa;&#xa;   - Using dashed forms from your scripts, without first prepending the&#xa;     return value from &quot;git --exec-path&quot; to the scripts&apos; PATH, has been&#xa;     informally deprecated since early 2006, but now it officially is.&#xa;&#xa;   - Use of dashed forms with &quot;PATH=$(git --exec-path):$PATH; export&#xa;     PATH&quot; early in your script is not deprecated with this change.&#xa;&#xa;   Users are strongly encouraged to adjust their habits and scripts now&#xa;   to prepare for this change.&#xa;"/>
</node>
<node COLOR="#990000" ID="ID_270281812" 
	TEXT=" * The post-receive hook was introduced in March 2007 to supersede&#xa;   the post-update hook, primarily to overcome the command line length&#xa;   limitation of the latter.  Use of post-update hook will be deprecated&#xa;   in future versions of git, starting from v1.6.0.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_346053373" 
	TEXT=" * Value &quot;true&quot; for color.diff and color.status configuration used to&#xa;   mean &quot;always&quot; (even when the output is not going to a terminal).&#xa;   This has been corrected to mean the same thing as &quot;auto&quot;.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1054041252" 
	TEXT=" * &quot;git commit --allow-empty&quot; allows you to create a single-parent    commit that records the same tree as its parent, overriding the usual    safety valve.">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1773416176" 
	TEXT=" * &quot;git commit --amend&quot; can amend a merge that does not change the tree&#xa;   from its first parent.&#xa;">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1172672754" 
	TEXT=" * &quot;git commit&quot; has been rewritten in C. ">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="help"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_660389910" 
	TEXT="1.5.3">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1257652" 
	TEXT="新命令： &quot;git stash&quot; allows you to quickly save away your work in&#xa;    progress and replay it later on an updated state.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1313647537" 
	TEXT="新命令： &quot;git rebase&quot; learned an &quot;interactive&quot; mode that let you&#xa;    pick and reorder which commits to rebuild.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_847700637" 
	TEXT="  - $GIT_WORK_TREE environment variable can be used together with     $GIT_DIR to work in a subdirectory of a working tree that is     not located at &quot;$GIT_DIR/..&quot;. ">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1789880206" 
	TEXT="  - &quot;git log&quot; learned a new option &quot;--follow&quot;, to follow&#xa;    renaming history of a single file.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1113985459" 
	TEXT="1.5.2">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_714769439" 
	TEXT="新命令  - &quot;subtree&quot; merge strategy allows another project to be merged in as     your subdirectory. ">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1408747441" 
	TEXT="  - &quot;git add -u&quot; is a quick way to do the first stage of &quot;git     commit -a&quot; (i.e. update the index to match the working     tree); it obviously does not make a commit. ">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_337068020" 
	TEXT="* The packfile format now optionally supports 64-bit index.&#xa;&#xa;  This release supports the &quot;version 2&quot; format of the .idx&#xa;  file.  This is automatically enabled when a huge packfile&#xa;  needs more than 32-bit to express offsets of objects in the&#xa;  pack.">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1982665055" 
	TEXT="* Plumbing level gitattributes support.&#xa;&#xa;  The gitattributes mechanism allows you to add &apos;attributes&apos; to&#xa;  paths in your project, and affect the way certain git&#xa;  operations work.  Currently you can influence if a path is&#xa;  considered a binary or text (the former would be treated by&#xa;  &apos;git diff&apos; not to produce textual output; the latter can go&#xa;  through the line endings conversion process in repositories&#xa;  with core.autocrlf set), expand and unexpand &apos;$Id$&apos; keyword&#xa;  with blob object name, specify a custom 3-way merge driver,&#xa;  and specify a custom diff driver.  You can also apply&#xa;  arbitrary filter to contents on check-in/check-out codepath&#xa;  but this feature is an extremely sharp-edged razor and needs&#xa;  to be handled with caution (do not use it unless you&#xa;  understand the earlier mailing list discussion on keyword&#xa;  expansion).  These conversions apply when checking files in&#xa;  or out, and exporting via git-archive.">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1409043535" 
	TEXT="* Plumbing level superproject support.&#xa;&#xa;  You can include a subdirectory that has an independent git&#xa;  repository in your index and tree objects of your project&#xa;  (&quot;superproject&quot;).  This plumbing (i.e. &quot;core&quot;) level&#xa;  superproject support explicitly excludes recursive behaviour.&#xa;&#xa;  The &quot;subproject&quot; entries in the index and trees of a superproject&#xa;  are incompatible with older versions of git.  Experimenting with&#xa;  the plumbing level support is encouraged, but be warned that&#xa;  unless everybody in your project updates to this release or&#xa;  later, using this feature would make your project&#xa;  inaccessible by people with older versions of git.">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1596680974" 
	TEXT="1.5.1">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_231444885" 
	TEXT="git diff --no-index pathA pathB">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" ID="ID_1040385957" 
	TEXT="  - A new configuration &quot;core.symlinks&quot; can be used to disable     symlinks on filesystems that do not support them; they are     checked out as regular files instead. ">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1472978148" 
	TEXT="git name-rev 可以通过 --refs=&lt;pattern&gt; 显示符合表达式的tag">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1082992486" 
	TEXT="&#xa;  - &quot;git name-rev&quot; learned --refs=&lt;pattern&gt;, to limit the tags&#xa;    used for naming the given revisions only to the ones&#xa;    matching the given pattern.&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1414888467" 
	TEXT="git mergetool 工具可以帮助使用图形化工具完成冲突解决。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<icon BUILTIN="info"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1110271514" 
	TEXT="引入了 &apos;:/message text&apos; 定位语法">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1644159716" 
	TEXT="  - You can name a commit object with its first line of the&#xa;    message.  The syntax to use is &apos;:/message text&apos;.  E.g.&#xa;&#xa;    $ git show &quot;:/object name: introduce &apos;:/&lt;oneline prefix&gt;&apos; notation&quot;&#xa;&#xa;    means the same thing as:&#xa;&#xa;    $ git show 28a4d940443806412effa246ecc7768a21553ec7&#xa;"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_818525294" 
	TEXT="选项 core.autocrlf">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_270622424" 
	TEXT="  - core.autocrlf configuration, when set to &apos;true&apos;, makes git&#xa;    to convert CRLF at the end of lines in text files to LF when&#xa;    reading from the filesystem, and convert in reverse when&#xa;    writing to the filesystem.  The variable can be set to&#xa;    &apos;input&apos;, in which case the conversion happens only while&#xa;    reading from the filesystem but files are written out with&#xa;    LF at the end of lines.  Currently, which paths to consider&#xa;    &apos;text&apos; (i.e. be subjected to the autocrlf mechanism) is&#xa;    decided purely based on the contents, but the plan is to&#xa;    allow users to explicitly override this heuristic based on&#xa;    paths.&#xa;"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_296633439" 
	TEXT="1.5.0">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1855351852" 
	TEXT="对 Index 的改进">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_549048241" 
	TEXT="* Index manipulation&#xa;&#xa; - git-add is to add contents to the index (aka &quot;staging area&quot;&#xa;   for the next commit), whether the file the contents happen to&#xa;   be is an existing one or a newly created one.&#xa;&#xa; - git-add without any argument does not add everything&#xa;   anymore.  Use &apos;git-add .&apos; instead.  Also you can add&#xa;   otherwise ignored files with an -f option.&#xa;&#xa; - git-add tries to be more friendly to users by offering an&#xa;   interactive mode (&quot;git-add -i&quot;).&#xa;&#xa; - git-commit &lt;path&gt; used to refuse to commit if &lt;path&gt; was&#xa;   different between HEAD and the index (i.e. update-index was&#xa;   used on it earlier).  This check was removed.&#xa;&#xa; - git-rm is much saner and safer.  It is used to remove paths&#xa;   from both the index file and the working tree, and makes sure&#xa;   you are not losing any local modification before doing so.&#xa;&#xa; - git-reset &lt;tree&gt; &lt;paths&gt;... can be used to revert index&#xa;   entries for selected paths.&#xa;&#xa; - git-update-index is much less visible.  Many suggestions to&#xa;   use the command in git output and documentation have now been&#xa;   replaced by simpler commands such as &quot;git add&quot; or &quot;git rm&quot;.&#xa;"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1694751947" 
	TEXT="版本库布局的改进。如远程版本库的分支放在 refs/remotes 下而不是混在当前空间下。">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_578754894" 
	TEXT="* Repository layout and objects transfer&#xa;&#xa; - The data for origin repository is stored in the configuration&#xa;   file $GIT_DIR/config, not in $GIT_DIR/remotes/, for newly&#xa;   created clones.  The latter is still supported and there is&#xa;   no need to convert your existing repository if you are&#xa;   already comfortable with your workflow with the layout.&#xa;&#xa; - git-clone always uses what is known as &quot;separate remote&quot;&#xa;   layout for a newly created repository with a working tree.&#xa;&#xa;   A repository with the separate remote layout starts with only&#xa;   one default branch, &apos;master&apos;, to be used for your own&#xa;   development.  Unlike the traditional layout that copied all&#xa;   the upstream branches into your branch namespace (while&#xa;   renaming their &apos;master&apos; to your &apos;origin&apos;), the new layout&#xa;   puts upstream branches into local &quot;remote-tracking branches&quot;&#xa;   with their own namespace. These can be referenced with names&#xa;   such as &quot;origin/$upstream_branch_name&quot; and are stored in&#xa;   .git/refs/remotes rather than .git/refs/heads where normal&#xa;   branches are stored.&#xa;&#xa;   This layout keeps your own branch namespace less cluttered,&#xa;   avoids name collision with your upstream, makes it possible&#xa;   to automatically track new branches created at the remote&#xa;   after you clone from it, and makes it easier to interact with&#xa;   more than one remote repository (you can use &quot;git remote&quot; to&#xa;   add other repositories to track).  There might be some&#xa;   surprises:&#xa;"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_269406994" 
	TEXT="浅克隆。即只克隆最新的几次提交。主要用途是研究最近提交的代码，以及通过邮件发送补丁。">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1128564114" 
	TEXT="* Shallow clones&#xa;&#xa; - There is a partial support for &apos;shallow&apos; repositories that&#xa;   keeps only recent history.  A &apos;shallow clone&apos; is created by&#xa;   specifying how deep that truncated history should be&#xa;   (e.g. &quot;git clone --depth 5 git://some.where/repo.git&quot;).&#xa;&#xa;   Currently a shallow repository has number of limitations:&#xa;&#xa;   - Cloning and fetching _from_ a shallow clone are not&#xa;     supported (nor tested -- so they might work by accident but&#xa;     they are not expected to).&#xa;&#xa;   - Pushing from nor into a shallow clone are not expected to&#xa;     work.&#xa;&#xa;   - Merging inside a shallow repository would work as long as a&#xa;     merge base is found in the recent history, but otherwise it&#xa;     will be like merging unrelated histories and may result in&#xa;     huge conflicts.&#xa;&#xa;   but this would be more than adequate for people who want to&#xa;   look at near the tip of a big project with a deep history and&#xa;   send patches in e-mail format.                                                                                                                           "/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1665798290" 
	TEXT="版本库日志字符集">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1074870150" 
	TEXT="* I18n&#xa;&#xa; - We have always encouraged the commit message to be encoded in&#xa;   UTF-8, but the users are allowed to use legacy encoding as&#xa;   appropriate for their projects.  This will continue to be the&#xa;   case.  However, a non UTF-8 commit encoding _must_ be&#xa;   explicitly set with i18n.commitencoding in the repository&#xa;   where a commit is made; otherwise git-commit-tree will&#xa;   complain if the log message does not look like a valid UTF-8&#xa;   string.&#xa;&#xa; - The value of i18n.commitencoding in the originating&#xa;   repository is recorded in the commit object on the &quot;encoding&quot;&#xa;   header, if it is not UTF-8.  git-log and friends notice this,&#xa;   and reencodes the message to the log output encoding when&#xa;   displaying, if they are different.  The log output encoding&#xa;   is determined by &quot;git log --encoding=&lt;encoding&gt;&quot;,&#xa;   i18n.logoutputencoding configuration, or i18n.commitencoding&#xa;   configuration, in the decreasing order of preference, and&#xa;   defaults to UTF-8.&#xa;&#xa; - Tools for e-mailed patch application now default to -u&#xa;   behavior; i.e. it always re-codes from the e-mailed encoding&#xa;   to the encoding specified with i18n.commitencoding.  This&#xa;   unfortunately forces projects that have happily been using a&#xa;   legacy encoding without setting i18n.commitencoding to set&#xa;   the configuration, but taken with other improvement, please&#xa;   excuse us for this very minor one-time inconvenience.&#xa;"/>
</node>
<node COLOR="#990000" ID="ID_929514760" 
	TEXT="从 1.4.2 起，loose object 的信息头格式改变，以便更易打包和访问">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_257705503" 
	TEXT="从 1.4.3 起，packfile 的存储更有效率">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1084112474" 
	TEXT="从 1.4.4 开始，git pack-refs 在打包时对 refs 引用进行打包，以便访问更有效率">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_920542571" 
	TEXT="gitweb 从 1.4.0 开始成为 git 的一部分">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1259521511" 
	TEXT="reflog 是 git 1.4.0 的发明">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1818169356" 
	TEXT=" - reflog is an v1.4.0 invention.  This allows you to name a&#xa;   revision that a branch used to be at (e.g. &quot;git diff&#xa;   master@{yesterday} master&quot; allows you to see changes since&#xa;   yesterday&apos;s tip of the branch).&#xa;"/>
</node>
</node>
<node COLOR="#00b439" ID="ID_279184571" 
	TEXT="1.4.4">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_705771263" POSITION="right" 
	TEXT="Git 安装">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" FOLDED="true" ID="ID_1943723592" 
	TEXT="git 说明">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_163866761" 
	TEXT="////////////////////////////////////////////////////////////////&#xa;&#xa;  GIT - the stupid content tracker&#xa;&#xa;////////////////////////////////////////////////////////////////&#xa;&#xa;&quot;git&quot; can mean anything, depending on your mood.&#xa;&#xa; - random three-letter combination that is pronounceable, and not&#xa;   actually used by any common UNIX command.  The fact that it is a&#xa;   mispronunciation of &quot;get&quot; may or may not be relevant.&#xa; - stupid. contemptible and despicable. simple. Take your pick from the&#xa;   dictionary of slang.&#xa; - &quot;global information tracker&quot;: you&apos;re in a good mood, and it actually&#xa;   works for you. Angels sing, and a light suddenly fills the room.&#xa; - &quot;goddamn idiotic truckload of sh*t&quot;: when it breaks&#xa;&#xa;Git is a fast, scalable, distributed revision control system with an&#xa;unusually rich command set that provides both high-level operations&#xa;and full access to internals.&#xa;&#xa;Git is an Open Source project covered by the GNU General Public License.&#xa;It was originally written by Linus Torvalds with help of a group of&#xa;hackers around the net. It is currently maintained by Junio C Hamano.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_869235119" 
	TEXT="Git 文档">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1299420099" 
	TEXT="Documentation/RelNotes">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1194600228" 
	TEXT="Documentation/technical">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1220118444" 
	TEXT="Documentation/howto">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_307259825" 
	TEXT="Documentation/*.txt ： 命令帮助">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_580181661" 
	TEXT="Linux 下的安装">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1213896275" 
	TEXT="  $ make configure ;# as yourself&#xa;  $ ./configure --prefix=/usr ;# as yourself&#xa;  $ make all doc ;# as yourself&#xa;  # make install install-doc install-html;# as root&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_600654023" 
	TEXT="$ wget http://kernel.org/pub/software/scm/git/git-&#xa;1.5.4.4.tar.bz2&#xa;$ tar jxpvf git-1.5.4.4.tar.bz2&#xa;$ cd git-1.5.4.4&#xa;$ make prefix=/usr all doc info&#xa;$ sudo make prefix=/usr install install-doc install-info&#xa;">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_420945151" 
	TEXT="git 还是 git-core">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_450704299" 
	TEXT="原因是很早就有一款软件占用了 git 这一名称： gnuit">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1866983047" 
	TEXT="gnuit">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_603527454" 
	TEXT=" GNU Interactive Tools, a file browser/viewer and process viewer/killer&#xa; gnuit (GNU Interactive Tools) is a set of interactive text-mode tools,&#xa; closely integrated with the shell.  It contains an extensible file&#xa; system browser (similar to Norton Commander and XTree), an ASCII/hex&#xa; file viewer, a process viewer/killer and some other related utilities&#xa; and shell scripts.  It can be used to increase the speed and&#xa; efficiency of most of the daily tasks such as copying and moving&#xa; files and directories, invoking editors, compressing and&#xa; uncompressing files, creating and expanding archives, compiling&#xa; programs, sending mail, etc.  It looks nice, has colors (if the&#xa; standard ANSI color sequences are supported) and is user-friendly.&#xa; .&#xa; One of the main advantages of gnuit is its flexibility.  It is not&#xa; limited to a given set of commands.  The configuration file can be&#xa; easily enhanced, allowing the user to add new commands or file&#xa; operations, depending on its needs or preferences.&#xa;Homepage: http://www.gnu.org/software/gnuit/&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_296073571" 
	TEXT="Debian 老版本的 git 包实为 gnuit 包">
<node COLOR="#111111" ID="ID_1371883243" 
	TEXT="git:&#xa;  已安装：  1:1.7.2.3-2&#xa;  候选软件包：1:1.7.2.3-2&#xa;  版本列表：&#xa; *** 1:1.7.2.3-2 0&#xa;        990 http://mirrors.bj.ossxp.com/debian/ testing/main amd64 Packages&#xa;         80 http://mirrors.bj.ossxp.com/debian/ sid/main amd64 Packages&#xa;        100 /var/lib/dpkg/status&#xa;     4.9.4-1 0&#xa;         70 http://mirrors.bj.ossxp.com/debian/ stable/main amd64 Packages&#xa;"/>
<node COLOR="#111111" FOLDED="true" ID="ID_886958634" 
	TEXT="dpkg -s">
<node COLOR="#111111" ID="ID_800498408" 
	TEXT="Package: git&#xa;Priority: optional&#xa;Section: utils&#xa;Installed-Size: 60&#xa;Maintainer: Ian Beckwith &lt;ianb@erislabs.net&gt;&#xa;Architecture: all&#xa;Source: gnuit&#xa;Version: 4.9.4-1&#xa;Depends: gnuit&#xa;Filename: pool/main/g/gnuit/git_4.9.4-1_all.deb&#xa;Size: 12138&#xa;MD5sum: 9f4ed528dc0b09b3567bd78a460aca6e&#xa;SHA1: 764c981be227bbac7339d9f78f7ffe6827ddd83c&#xa;SHA256: a5302c20887c6e2cc5f4af6d610ec7d74b4cf63288f0efa39f8e249da32f4635&#xa;Description: transitional dummy package which can be safely removed&#xa; This is a transitional dummy package to pull in the renamed&#xa; gnuit package. It can be safely removed.&#xa;"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_309921020" 
	TEXT="Debian 最早 Git  只好叫做 git-core">
<node COLOR="#111111" ID="ID_815385924" 
	TEXT="git-core:&#xa;  已安装：  1:1.7.2.3-2&#xa;  候选软件包：1:1.7.2.3-2&#xa;  版本列表：&#xa; *** 1:1.7.2.3-2 0&#xa;        990 http://mirrors.bj.ossxp.com/debian/ testing/main amd64 Packages&#xa;         80 http://mirrors.bj.ossxp.com/debian/ sid/main amd64 Packages&#xa;        100 /var/lib/dpkg/status&#xa;     1:1.5.6.5-3+lenny3.2 0&#xa;         70 http://mirrors.bj.ossxp.com/debian-security/ stable/updates/main amd64 Packages&#xa;     1:1.5.6.5-3+lenny3.1 0&#xa;         70 http://mirrors.bj.ossxp.com/debian/ stable/main amd64 Packages&#xa;"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1960475671" 
	TEXT="dpkg -s">
<node COLOR="#111111" ID="ID_382899462" 
	TEXT="Package: git-core&#xa;Priority: optional&#xa;Section: devel&#xa;Installed-Size: 6944&#xa;Maintainer: Gerrit Pape &lt;pape@smarden.org&gt;&#xa;Architecture: amd64&#xa;Version: 1:1.5.6.5-3+lenny3.1&#xa;Replaces: cogito (&lt;&lt; 0.16rc2-0), git-completion&#xa;Provides: git-completion&#xa;Depends: libc6 (&gt;= 2.7-1), libcurl3-gnutls (&gt;= 7.16.2-1), libexpat1 (&gt;= 1.95.8), zlib1g (&gt;= 1:1.2.0), perl-modules, liberror-perl, libdigest-sha1-perl&#xa;Recommends: patch, less, rsync, ssh-client&#xa;Suggests: git-doc, git-arch, git-cvs, git-svn, git-email, git-daemon-run, git-gui, gitk, gitweb&#xa;Conflicts: git (&lt;&lt; 4.3.20-11), git-completion, qgit (&lt;&lt; 1.5.5)&#xa;Filename: pool/main/g/git-core/git-core_1.5.6.5-3+lenny3.1_amd64.deb&#xa;Size: 3419794&#xa;MD5sum: 6ce2265e04a19bf21988494d4357adeb&#xa;SHA1: e7e30c35d4eed8b9ce1615ce05a302d62047f0a8&#xa;SHA256: c426cd77bbc9d4fa09d8b872b9b9c382a62d667ef43a1b2ab072f7c98ed5b2e7&#xa;Description: fast, scalable, distributed revision control system&#xa; Git is popular version control system designed to handle very large&#xa; projects with speed and efficiency; it is used mainly for various open&#xa; source projects, most notably the Linux kernel.&#xa; .&#xa; Git falls in the category of distributed source code management tools.&#xa; Every Git working directory is a full-fledged repository with full&#xa; revision tracking capabilities, not dependent on network access or a&#xa; central server.&#xa; .&#xa; This package provides the git main components with minimal dependencies.&#xa; Additional functionality, e.g. a graphical user interface and revision&#xa; tree visualizer, tools for interoperating with other VCS&apos;s, or a web&#xa; interface, is provided as separate git* packages.&#xa;Tag: devel::rcs, implemented-in::{c,perl,shell}, interface::commandline, network::client, role::program, works-with::file, works-with::software:source&#xa;&#xa;"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1536033833" 
	TEXT="Debian 最新的 git 包提供 Git 软件">
<node COLOR="#111111" ID="ID_112080065" 
	TEXT="git:&#xa;  已安装：  1:1.7.2.3-2&#xa;  候选软件包：1:1.7.2.3-2&#xa;  版本列表：&#xa; *** 1:1.7.2.3-2 0&#xa;        990 http://mirrors.bj.ossxp.com/debian/ testing/main amd64 Packages&#xa;         80 http://mirrors.bj.ossxp.com/debian/ sid/main amd64 Packages&#xa;        100 /var/lib/dpkg/status&#xa;     4.9.4-1 0&#xa;         70 http://mirrors.bj.ossxp.com/debian/ stable/main amd64 Packages&#xa;"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1910686336" 
	TEXT="dpkg -s">
<node COLOR="#111111" ID="ID_867847012" 
	TEXT="Package: git&#xa;Priority: optional&#xa;Section: vcs&#xa;Installed-Size: 10548&#xa;Maintainer: Gerrit Pape &lt;pape@smarden.org&gt;&#xa;Architecture: amd64&#xa;Version: 1:1.7.2.3-2&#xa;Replaces: cogito (&lt;&lt; 0.16rc2-0), git-core (&lt;= 1:1.7.0.4-1)&#xa;Provides: git-completion, git-core&#xa;Depends: libc6 (&gt;= 2.3.4), libcurl3-gnutls (&gt;= 7.16.2-1), libexpat1 (&gt;= 1.95.8), zlib1g (&gt;= 1:1.2.0), perl-modules, liberror-perl&#xa;Recommends: patch, less, rsync, ssh-client&#xa;Suggests: git-doc, git-arch, git-cvs, git-svn, git-email, git-daemon-run, git-gui, gitk, gitweb&#xa;Conflicts: git-core (&lt;= 1:1.7.0.4-1)&#xa;Breaks: cogito (&lt;= 0.18.2+), git-buildpackage (&lt;&lt; 0.4.38), gitosis (&lt;&lt; 0.2+20090917-7), gitpkg (&lt;&lt; 0.15), guilt (&lt;&lt; 0.33), qgit (&lt;&lt; 1.5.5), stgit (&lt;&lt; 0.15), stgit-contrib (&lt;&lt; 0.15)&#xa;Filename: pool/main/g/git/git_1.7.2.3-2_amd64.deb&#xa;Size: 5270132&#xa;MD5sum: 6c6d1847c91001ac1ed0c97c6a9992bc&#xa;SHA1: 66b4d0594031daf617b7c277b6ac3ccfd41bf5eb&#xa;SHA256: 8f4e8dc6464c38436b59fe6e0b9f1fbb70ed6e74692bf832d169c445e0730664&#xa;Description: fast, scalable, distributed revision control system&#xa; Git is popular version control system designed to handle very large&#xa; projects with speed and efficiency; it is used for many high profile&#xa; open source projects, most notably the Linux kernel.&#xa; .&#xa; Git falls in the category of distributed source code management tools.&#xa; Every Git working directory is a full-fledged repository with full&#xa; revision tracking capabilities, not dependent on network access or a&#xa; central server.&#xa; .&#xa; This package provides the git main components with minimal dependencies.&#xa; Additional functionality, e.g. a graphical user interface and revision&#xa; tree visualizer, tools for interoperating with other VCS&apos;s, or a web&#xa; interface, is provided as separate git* packages.&#xa;Homepage: http://git-scm.com/&#xa;Tag: implemented-in::c, interface::text-mode, role::dummy, role::program, scope::utility, suite::gnu, uitoolkit::ncurses, use::browsing, works-with::file, works-with::software:running&#xa;"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1460656238" 
	TEXT="Debian 最新的 git-core 包依赖新版本的 git 包">
<node COLOR="#111111" ID="ID_538712220" 
	TEXT="git-core:&#xa;  已安装：  1:1.7.2.3-2&#xa;  候选软件包：1:1.7.2.3-2&#xa;  版本列表：&#xa; *** 1:1.7.2.3-2 0&#xa;        990 http://mirrors.bj.ossxp.com/debian/ testing/main amd64 Packages&#xa;         80 http://mirrors.bj.ossxp.com/debian/ sid/main amd64 Packages&#xa;        100 /var/lib/dpkg/status&#xa;     1:1.5.6.5-3+lenny3.2 0&#xa;         70 http://mirrors.bj.ossxp.com/debian-security/ stable/updates/main amd64 Packages&#xa;     1:1.5.6.5-3+lenny3.1 0&#xa;         70 http://mirrors.bj.ossxp.com/debian/ stable/main amd64 Packages&#xa;"/>
<node COLOR="#111111" FOLDED="true" ID="ID_560481168" 
	TEXT="dpkg -s">
<node COLOR="#111111" ID="ID_1783571111" 
	TEXT="Package: git-core&#xa;Priority: optional&#xa;Section: vcs&#xa;Installed-Size: 28&#xa;Maintainer: Gerrit Pape &lt;pape@smarden.org&gt;&#xa;Architecture: all&#xa;Source: git&#xa;Version: 1:1.7.2.3-2&#xa;Depends: git (&gt;&gt; 1:1.7.0.2)&#xa;Filename: pool/main/g/git/git-core_1.7.2.3-2_all.deb&#xa;Size: 1326&#xa;MD5sum: 899bd23a36fe74b05d4c7b7b2e0be5d8&#xa;SHA1: c90e70895731c4d8bfb4b284f14628f8fbbbee1a&#xa;SHA256: 8be7a21bd50de7dd719a5b22268d1930a730eff4650a67e7b731ac6d9c5743c0&#xa;Description: fast, scalable, distributed revision control system (obsolete)&#xa; Git is popular version control system designed to handle very large&#xa; projects with speed and efficiency; it is used for many high profile&#xa; open source projects, most notably the Linux kernel.&#xa; .&#xa; Git falls in the category of distributed source code management tools.&#xa; Every Git working directory is a full-fledged repository with full&#xa; revision tracking capabilities, not dependent on network access or a&#xa; central server.&#xa; .&#xa; This is a transitional dummy package.  The &apos;git-core&apos; package has been&#xa; renamed to &apos;git&apos;, which has been installed automatically.  This&#xa; git-core package is now obsolete, and can safely be removed from the&#xa; system.&#xa;Homepage: http://git-scm.com/&#xa;Tag: devel::rcs, implemented-in::{c,perl,shell}, interface::commandline, network::client, network::server, protocol::http, protocol::ssh, role::program, scope::application, works-with::{file,software:source,vcs}&#xa;"/>
</node>
</node>
</node>
<node COLOR="#990000" ID="ID_1534081128" 
	TEXT="$ apt-get git-core&#xa;$ yum install git-core ">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1839388168" 
	TEXT="Mac 下安装">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1828158588" 
	TEXT="最简单的方式是下载一个图形化的 Git 安装软件">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_828548872" LINK="http://code.google.com/p/git-osx-installer" 
	TEXT="code.google.com &gt; P &gt; Git-osx-installer">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1305051246" 
	TEXT="使用 MacPorts 安装">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_627469172" LINK="http://www.macports.org" 
	TEXT="MacPorts (http://www.macports.org)."/>
<node COLOR="#111111" ID="ID_1588658270" 
	TEXT="$ sudo port install git-core +svn +doc +bash_completion +gitweb"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1786486760" 
	TEXT="Mac Ports">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1220925992" 
	TEXT="$ sudo port install git-core"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1238691862" 
	TEXT="Mac 10.4 – Tiger&#xa;There are some requirements you’ll have to install before you can&#xa;compile Git. Expat can be installed roughly like this:&#xa;curl -O http://surfnet.dl.sourceforge.net/sourceforge/expat/&#xa;expat-2.0.1.tar.gz&#xa;tar zxvf expat-2.0.1.tar.gz&#xa;cd expat-2.0.1&#xa;./configure --prefix=/usr/local&#xa;make&#xa;make check&#xa;sudo make install&#xa;cd ..&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_222454979" 
	TEXT="Mac 10.5">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_199506283" 
	TEXT="Mac 10.5 – Leopard&#xa;The easiest way to install is most likely the “Git OSX Installer”:http://&#xa;code.google.com/p/git-osx-installer/, which you can get from Google&#xa;Code, and has just recently been linked to as the official Mac ver-&#xa;sion on the Git homepage. Just download and run the DMG from the&#xa;website.&#xa;If you want to compile from source, all the requirements are installed&#xa;with the developer CD. You can just download the Git source and&#xa;compile pretty easily if the developer tools are installed.&#xa;Finally, MacPorts is also an easy option if you have that installed.&#xa;For an in-depth tutorial on installations under Leopard, see this&#xa;article (http://blog.kineticweb.com/articles/2007/10/30/compiling-git-for-mac-os-x-&#xa;leopard-10-5)&#xa;"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_938474165" 
	TEXT="Windows">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_435486463" 
	TEXT="msysGit">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1353517893" LINK="http://code.google.com/p/msysgit" 
	TEXT="code.google.com &gt; P &gt; Msysgit"/>
</node>
<node COLOR="#990000" ID="ID_1330993112" 
	TEXT="cygwin">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_860297350" 
	TEXT="Git 帮助">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1392933056" 
	TEXT="浏览器查看帮助">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_444766905" 
	TEXT="git help git -w"/>
<node COLOR="#111111" ID="ID_1715836094" 
	TEXT="git help checkout -w"/>
</node>
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
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_1873664526" POSITION="right" 
	TEXT="Git 基础篇： 循序渐进">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" ID="ID_937140096" 
	TEXT="本章概述，介绍最基本的命令：xxx，以及。。。奥秘">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_704007085" 
	TEXT="Step 1: 创建版本库及第一次提交">
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
<node COLOR="#111111" ID="ID_23993051" 
	TEXT="git config: who are you">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1892831577" 
	TEXT="git init: 创建版本库: 一条命令即可： git init">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1410409626" 
	TEXT="创建文件">
<node COLOR="#111111" FOLDED="true" ID="ID_816687715" 
	TEXT="welcome.txt">
<node COLOR="#111111" ID="ID_555364967" 
	TEXT="Hello."/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_10862766" 
	TEXT="git add:">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1852654265" 
	TEXT="新建文件需要通过运行 git add，准备添加入版本库"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_119273997" 
	TEXT="git ci:">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_245611066" 
	TEXT="如果没有设置 user.name 和 user.email 发出警告"/>
<node COLOR="#111111" ID="ID_317914717" 
	TEXT="完成提交操作，数据最终入库"/>
</node>
<node COLOR="#111111" ID="ID_662216801" 
	TEXT="运行 git log 可以看到提交历史"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_157775000" 
	TEXT="思考">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1792321693" 
	TEXT="Git 探秘1：工作区布局: what is .git">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_985533107" 
	TEXT="版本库和工作区在一起">
<font NAME="Serif" SIZE="12"/>
</node>
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
<node COLOR="#111111" FOLDED="true" ID="ID_1778125311" 
	TEXT="Git 探秘2: 是谁在提交？ ">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1070271305" 
	TEXT="CVS/Subversion 在提交时需要认证，那么很自然，认证帐号就是提交者。而 Git 不是这样。"/>
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
<node COLOR="#111111" FOLDED="true" ID="ID_1644431487" 
	TEXT="Git 探秘3: 命令别名. can I use ci?">
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" FOLDED="true" ID="ID_1457813025" 
	TEXT="Git 探秘4: git config 命令揭密">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_807991474" 
	TEXT="为什么前面出现 --global, --system ？">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_944003558" 
	TEXT="git config 缺省操作的三个 INI 文件。系统，用户级，版本库级">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_916840872" 
	TEXT="git config -e 可以直接打开配置文件进行编辑"/>
<node COLOR="#111111" ID="ID_845868289" 
	TEXT="Git config: 通过环境变量设定，修改任意 INI 文件。参考 git-svn ">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1334375027" 
	TEXT="Step 2: 修改文件 hello.txt，为什么提交不了？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1708429688" 
	TEXT="操作">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1003282484" 
	TEXT="修改文件">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1116960661" 
	TEXT="welcome.txt&#xa; hello.&#xa;+Nice to meet you."/>
</node>
<node COLOR="#111111" ID="ID_330856083" 
	TEXT="比较差异 git diff">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_785163115" 
	TEXT="提交不了？">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_773398172" 
	TEXT="log 还是只有一条？">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_720055561" 
	TEXT="git status 显示文件状态？">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1499591302" 
	TEXT="git add">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_386290260" 
	TEXT="git diff 无差异">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_735839345" 
	TEXT="git status 内容">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1839912350" 
	TEXT="再修改 welcome.txt">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1675972299" 
	TEXT="welcome.txt&#xa; hello.&#xa; Nice to meet you.&#xa;+Welcome to git world."/>
</node>
<node COLOR="#111111" ID="ID_460226484" 
	TEXT="git diff?">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_860733879" 
	TEXT="git status?">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_580340490" 
	TEXT="提交的是哪一个版本？">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_182909438" 
	TEXT="Log？">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1315816478" 
	TEXT="比较两个版本？">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1544263614" 
	TEXT="根据 git status 的提交，我们执行 git add , git commit">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_456073905" 
	TEXT="文件提交了。 git status -s -b , git log">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_612611347" 
	TEXT="总结： git add , git commit">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1335016709" 
	TEXT="思考: stage">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_373068541" 
	TEXT="关于 Stage 的故事">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1984210510" 
	TEXT="Stage: Git 的与众不同">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
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
<arrowlink DESTINATION="ID_1321032263" ENDARROW="Default" ENDINCLINATION="411;0;" ID="Arrow_ID_1651360928" STARTARROW="None" STARTINCLINATION="411;0;"/>
<icon BUILTIN="full-1"/>
</node>
<node COLOR="#111111" ID="ID_445461686" 
	TEXT="恢复文件修改： git checkout filename">
<arrowlink DESTINATION="ID_1575517712" ENDARROW="Default" ENDINCLINATION="248;0;" ID="Arrow_ID_1682050286" STARTARROW="None" STARTINCLINATION="248;0;"/>
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
<arrowlink DESTINATION="ID_106023203" ENDARROW="Default" ENDINCLINATION="200;0;" ID="Arrow_ID_638802253" STARTARROW="None" STARTINCLINATION="165;6;"/>
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
<node COLOR="#111111" FOLDED="true" ID="ID_959144194" 
	TEXT="stage 使用小巧门： change list">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#990000" ID="ID_807221835" 
	TEXT="操作： git stash 保存进度，经过后两章的知识准备后，再来清理工作区和暂存区。">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1069382257" 
	TEXT="Step 3: HEAD、master、提交和引用">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_858619768" 
	TEXT="提及 HEAD 和 master 分支，可以看到么？">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1377303061" 
	TEXT="git branch"/>
<node COLOR="#111111" ID="ID_484430083" 
	TEXT="git status"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1465029468" 
	TEXT="HEAD, master 可以交叉引用">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1021402064" 
	TEXT="git log --pretty=oneline"/>
<node COLOR="#111111" ID="ID_1705317115" 
	TEXT="git log --pretty=oneline HEAD"/>
<node COLOR="#111111" ID="ID_470824104" 
	TEXT="git log --pretty=oneline master"/>
<node COLOR="#111111" ID="ID_1930862875" 
	TEXT="git log --pretty=oneline ref/heads/master"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1264489955" 
	TEXT="HEAD 和 master 到底是什么呢？">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_132280906" 
	TEXT="find .git -name HEAD -o -name master">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1429444637" 
	TEXT="$ find .git -name HEAD -o -name master  -type f&#xa;.git/HEAD&#xa;.git/logs/HEAD&#xa;.git/logs/refs/heads/master&#xa;.git/refs/heads/master&#xa;"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1605817423" 
	TEXT="COMMIT 是多么的古怪？全局 ID 和全球 ID？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1106444909" 
	TEXT="对于顺序的 ID，很容易确定提交顺序，但是 SHA1 ID 呢？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_937928208" 
	TEXT="看看 master 中记录了什么？是一个提交列表么？ NO！">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1776586154" 
	TEXT="其内容是固定的么？">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_135426452" 
	TEXT="git commit"/>
<node COLOR="#111111" ID="ID_878948567" 
	TEXT="看到 refs/heads/master 内容改变"/>
<node COLOR="#111111" ID="ID_87770180" 
	TEXT="我们能够在 .git/objects 下找到它"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_403999594" 
	TEXT="那么我们就研究这个 ID">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1328723577" 
	TEXT="在对象库中寻找"/>
<node COLOR="#111111" ID="ID_1885290546" 
	TEXT="研究它的工具叫做 cat-file"/>
<node COLOR="#111111" ID="ID_1548593441" 
	TEXT="cat-file -t"/>
<node COLOR="#111111" ID="ID_964882040" 
	TEXT="cat-file -p"/>
<node COLOR="#111111" ID="ID_202205205" 
	TEXT="log -1 --pretty=raw COMMITID"/>
</node>
<node COLOR="#990000" ID="ID_272461282" 
	TEXT="Tree 也是 SHA1, 也在 objects 中。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1382024946" 
	TEXT="Tree 包含文件，文件内容也是 blob">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1855128475" 
	TEXT="rev-list 命令又确实可以列出提交顺序列表。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1710132349" 
	TEXT="用 git log --graph 可以看到图！">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1808167996" 
	TEXT="DAG">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1748473082" 
	TEXT="画一个更细致的 版本库结构图">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_292847528" 
	TEXT="Step 4: 分支是一个游标，reset 重置游标。">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_899251053" 
	TEXT="用图片展示 reset 命令">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1080317102" 
	TEXT="master 指向谁？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1974623513" 
	TEXT="reset 会怎样？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1227062383" 
	TEXT="如何找回？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_781709742" 
	TEXT="reflog？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_295962692" 
	TEXT="reset HEAD 是什么含义？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_31944918" 
	TEXT="reset 之后 commit 是什么概念？ 什么叫做 detached HEAD">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_801394658" 
	TEXT="Step 5: checkout 命令">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1842203629" 
	TEXT="svn 的 checkout, update, ...">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1182515328" 
	TEXT="checkout 改变 HEAD">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_87851831" 
	TEXT="Step 6: 暂存区和工作区恢复">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1267714615" 
	TEXT="stash list, pop">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_730582168" 
	TEXT="status">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1446619074" 
	TEXT="reset HEAD">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1287031700" 
	TEXT="checkout  用户清空改变">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1072649532" 
	TEXT="stash 探索">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_805509452" 
	TEXT="stash 的 reflog">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_469074680" 
	TEXT="暂存区/工作区的清理">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1702470554" 
	TEXT="如何将文件撤出 stage">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_350532826" 
	TEXT="git rm --cached">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1143620351" 
	TEXT="git reset HEAD">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" ID="ID_915848120" 
	TEXT="工作区用 checkout 清理">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1912771033" 
	TEXT="Step 7: 两个相同的大文件，以及版本库的整理">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_376643602" 
	TEXT="Git 库一定会比工作区大么？">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_641031184" 
	TEXT="这个章节的题目可能有问题。你可能会说前几次提交由于版本库的文件压缩存储肯定要小，但长久来看是要大。">
<font NAME="Serif" SIZE="12"/>
</node>
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
<node COLOR="#990000" ID="ID_994560929" 
	TEXT="文件删除再添加，版本库如何变化呢？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_181884990" 
	TEXT="这是为什么呢？">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1185169170" 
	TEXT="Git 是对内容进行跟踪，而非文件"/>
<node COLOR="#111111" ID="ID_773514279" 
	TEXT="不同文件只要内容相同，Git 库中的存储就是一个样"/>
</node>
<node COLOR="#990000" ID="ID_676573676" 
	TEXT="如何彻底清除版本库/版本库瘦身？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1148228648" 
	TEXT="版本库管理">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_328071214" 
	TEXT="git gc">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_182713492" 
	TEXT="多长时间整理一次?">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_358793755" 
	TEXT="是否需要设置 gc.auto?">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_660180163" 
	TEXT="$ git config --global gc.auto 1"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1731754977" 
	TEXT="git fsck 可以查看哪些 blob 没有被引用">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_640289668" 
	TEXT="$ git fsck&#xa;dangling tree 8276318347b8e971733ca5fab77c8f5018c75261&#xa;dangling blob 2302a5a4baec369fb631bb89cfe287cc002dc049&#xa;dangling blob cb54512d0a989dcfb2d78a7f3c8909f76ad2326a&#xa;dangling tree 8e1088e1cc1bc67e0ef01e018707dcb07a2a562b&#xa;dangling blob 5e069ed35afae29015b6622fe715c0aee10112ad&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_957665703" 
	TEXT="git prune 可以删除没有用的文件">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_316957658" 
	TEXT="$ git prune -n&#xa;2302a5a4baec369fb631bb89cfe287cc002dc049&#xa;5e069ed35afae29015b6622fe715c0aee10112ad&#xa;8276318347b8e971733ca5fab77c8f5018c75261&#xa;8e1088e1cc1bc67e0ef01e018707dcb07a2a562b&#xa;cb54512d0a989dcfb2d78a7f3c8909f76ad2326a&#xa;$ git prune&#xa;$ git fsck&#xa;$&#xa;blob&#xa;blob&#xa;tree&#xa;tree&#xa;blob&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1784330953" 
	TEXT="Step 8: 工作区的更多操作：修改/添加/删除/文件忽略">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1312613104" 
	TEXT="git diff 命令：是拿工作区和版本库文件做比较么？没有那么简单">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1231421942" 
	TEXT="新增文件，git add">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1002489103" 
	TEXT="文件本地删除。git rm">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1476806068" 
	TEXT="有修改，也有新增和本地删除。如果执行 git add . 会把所有文件都包含，如何加以区分式的添加？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_711234979" 
	TEXT="git add -u">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_58451841" 
	TEXT="git add -A">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_12694153" 
	TEXT="git status 命令：查看当前工作区文件状态。">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_441059113" 
	TEXT="文件修改"/>
<node COLOR="#111111" ID="ID_1448840040" 
	TEXT="文件本地删除"/>
<node COLOR="#111111" ID="ID_1248544624" 
	TEXT="新增文件"/>
<node COLOR="#111111" ID="ID_518774876" 
	TEXT="stauts 命令的输出太罗嗦？ git status -s"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_271761078" 
	TEXT="查看状态">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1186507177" 
	TEXT="git status 帮助你操作 stage">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1974305203" 
	TEXT="git status 的输出及精简输出">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_485341663" 
	TEXT="mv = add + rm 。改名操作的自动判别">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1936865227" 
	TEXT="Step 5: 文件忽略排除影响">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_980721363" 
	TEXT="git add -A">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1318926783" 
	TEXT="git clean -fd">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_836265266" 
	TEXT="显示忽略的文件">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1339970863" 
	TEXT="git status --ignore">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1865813549" 
	TEXT="git ls-files">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" ID="ID_200660530" 
	TEXT="git clean -fdx 也删除忽略的文件">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1513579147" 
	TEXT="git clean 命令，小心误删文件">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_740129745" 
	TEXT="两种文件忽略方式">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_235129425" 
	TEXT="文件忽略 .gitignore">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" ID="ID_1691925220" 
	TEXT="到底哪些文件需要忽略？">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1082968153" 
	TEXT="Git 版本库创建的模板？定制模板就可以实现 info/exclude 文件的自动定义">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_428815862" 
	TEXT="git status --ignore 查看忽略文件">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1615828487" 
	TEXT="not-tip: git commit -a">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1965877702" 
	TEXT="tip: git add -u, git add -A">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_840803921" 
	TEXT="Step 9: 历史穿梭">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1859556690" 
	TEXT="查看提交日志">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_645845907" 
	TEXT="提交编号 40 位 HASH">
<font NAME="Serif" SIZE="12"/>
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
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1174815863" 
	TEXT="全局 ID 和全球 ID">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_137212180" 
	TEXT="SVN 是全局 ID，Hg 的递增版本库号，也是全局版本号（版本库范围内）"/>
<node COLOR="#111111" ID="ID_342617326" 
	TEXT="全球版本库号，源自 SHA1 算法"/>
<node COLOR="#111111" ID="ID_116337544" 
	TEXT="SHA1 哈希算法介绍以及冲突的可能性概率计算。"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_360135280" 
	TEXT="查看提交线索？">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1043558081" 
	TEXT="执行 git log --graph 可以看到图形化的提交说明">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1392367672" 
	TEXT="gitk/gitg/qgit"/>
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
<node COLOR="#111111" FOLDED="true" ID="ID_405856168" 
	TEXT="这个图有个术语叫做 DAG，有向非环图。和 Subversion 的单向直线图不同。">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1562209254" 
	TEXT="画一下 Subversion 的单向图"/>
<node COLOR="#111111" ID="ID_459395000" 
	TEXT="画一下 Git 的DAG"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_262865429" 
	TEXT="现在的log 中显示的 DAG 太简单了，如何出现分叉？">
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" ID="ID_477153885" 
	TEXT="git  log --stat 可以看到更改信息">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_987877181" 
	TEXT="git log --pretty=oneline 可以看到精简提交日志">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_256019094" 
	TEXT="git log --pretty=fuller 可以看到真相">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_735485792" 
	TEXT="git log --pretty=oneline">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_411539511" 
	TEXT="git log -1">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_103596009" 
	TEXT="1.7.4开始，git log -G&lt;pattern&gt; ： 只显示匹配正则表达式的日志">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_6361013" 
	TEXT="git show： 查看提交的 patch 和说明">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
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
<node COLOR="#990000" FOLDED="true" ID="ID_1269679766" 
	TEXT="如何检出历史版本？">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_403222815" 
	TEXT="git checkout 检出历史版本">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1307575202" 
	TEXT="git checkout &lt;commit&gt; - FILE"/>
<node COLOR="#111111" ID="ID_1562583079" 
	TEXT="查看历史版本某一文件： $ git show &lt;commit-id&gt;:path/to/file">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1150322927" 
	TEXT="git rev-list">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_277601923" 
	TEXT="git show">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_545977190" 
	TEXT="git diff">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1031182526" 
	TEXT="访问 Git 对象的语法/版本表示法">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1914007866" 
	TEXT="40 hash">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_331628691" 
	TEXT="short hash">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1565629099" 
	TEXT="git describe 的类似输出">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_554258130" 
	TEXT="a closest tag, optionally followed by a dash and a number of commits, followed by a dash, a g, and an abbreviated object name."/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1066702103" 
	TEXT="tag 或者 branch 名称">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1305791724" 
	TEXT="            1. if $GIT_DIR/&lt;name&gt; exists, that is what you mean (this is usually useful only for HEAD, FETCH_HEAD, ORIG_HEAD and MERGE_HEAD);&#xa;&#xa;            2. otherwise, refs/&lt;name&gt; if exists;&#xa;&#xa;            3. otherwise, refs/tags/&lt;name&gt; if exists;&#xa;&#xa;            4. otherwise, refs/heads/&lt;name&gt; if exists;&#xa;&#xa;            5. otherwise, refs/remotes/&lt;name&gt; if exists;&#xa;&#xa;            6. otherwise, refs/remotes/&lt;name&gt;/HEAD if exists.&#xa;&#xa;               HEAD names the commit your changes in the working tree is based on. FETCH_HEAD records the branch you fetched from a remote repository&#xa;               with your last git fetch invocation. ORIG_HEAD is created by commands that moves your HEAD in a drastic way, to record the position of&#xa;               the HEAD before their operation, so that you can change the tip of the branch back to the state before you ran them easily. MERGE_HEAD&#xa;               records the commit(s) you are merging into your branch when you run git merge.&#xa;&#xa;               Note that any of the refs/* cases above may come either from the $GIT_DIR/refs directory or from the $GIT_DIR/packed-refs file.&#xa;&#xa;"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1481747587" 
	TEXT="date spec ： tag@{date}">
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" FOLDED="true" ID="ID_671940362" 
	TEXT="ordinal spec ： master@{5}  ： 实际上是对 reflog 的操作">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_255719041" 
	TEXT="@ 符号前必须是一个 ref引用，而不能是一个 HASH-ID"/>
<node COLOR="#111111" ID="ID_767856448" 
	TEXT="{-n} 是 ref 之后的第n个提交"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_515202194" 
	TEXT="carrot parent ： master^2 ">
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" FOLDED="true" ID="ID_850052162" 
	TEXT="^{}">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_157893596" 
	TEXT="例如 v0.99.8^{}"/>
<node COLOR="#111111" ID="ID_678865064" 
	TEXT="对象可能是一个 tag，逐次解析直至一个非 tag 对象。"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1587542499" 
	TEXT="tilde spec ： e65s46~5 ">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_885943293" 
	TEXT="符号前可以是 ref 引用，也可以是 HASH-id"/>
</node>
<node COLOR="#111111" ID="ID_168649522" 
	TEXT="tree pointer ： e65s46^{tree} ">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_411153150" 
	TEXT=":/log_pattern ： 通过提交日志定位。冒号后面是斜线和日志">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1589996118" 
	TEXT="$ git rev-parse :/^git | xargs -i{} git cat-file -p {}"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_431349119" 
	TEXT="master:path/to/file ">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1591745017" 
	TEXT="blob spec 。文件"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_155413323" 
	TEXT=":0:README">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1143289749" 
	TEXT="访问 stage 中的文件。如果 stage 0, 可以省略0和一个冒号，如 :Readme"/>
<node COLOR="#111111" ID="ID_801271217" 
	TEXT="在合并的时候，stage 1 代表公共的祖先。stage 2 代表目标分支版本（当前分支版本），stage3 代表要合并的版本。"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1451317442" 
	TEXT="@{-1} 上一次工作的分支">
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1884039479" 
	TEXT="* @{-1} is a way to refer to the last branch you were on.  This is   accepted not only where an object name is expected, but anywhere   a branch name is expected and acts as if you typed the branch name.   E.g. &quot;git branch --track mybranch @{-1}&quot;, &quot;git merge @{-1}&quot;, and   &quot;git rev-parse --symbolic-full-name @{-1}&quot; would work as expected.  "/>
<node COLOR="#111111" ID="ID_417589927" 
	TEXT="* @{-1} is a new way to refer to the last branch you were on introduced in   1.6.2, but the initial implementation did not teach this to a few   commands.  Now the syntax works with &quot;branch -m @{-1} newname&quot;. "/>
</node>
</node>
<node COLOR="#990000" ID="ID_1297983331" 
	TEXT="blame">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_938222670" 
	TEXT="cat-file -p">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1070000573" 
	TEXT="Step 10: 反删除和恢复">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_821734512" 
	TEXT="反删除？直接添加就是了。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1389963411" 
	TEXT="恢复历史提交？">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_940929520" 
	TEXT="直接 reverse"/>
<node COLOR="#111111" ID="ID_1455988397" 
	TEXT="如果再想还原回原来提交？ cherry-pick"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1579959370" 
	TEXT="Step 11: 改变历史">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_59318503" 
	TEXT="我们可以看到前面的反删除和恢复都是不改变历史的操作，但是要改变历史呢？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_740859438" 
	TEXT="最常遇到的问题是，刚刚的提交忘记一个文件，或者。。。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1670045255" 
	TEXT="git commit --amend, 改变最近的历史">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1472028670" 
	TEXT="忘记添加文件： git add . ; git ci --amend"/>
<node COLOR="#111111" ID="ID_774617574" 
	TEXT="忘记删除文件: git add -A; git ci --amend"/>
<node COLOR="#111111" ID="ID_1078181959" 
	TEXT="文件改动有问题：  modify; git add -u; git ci --amend"/>
<node COLOR="#111111" ID="ID_86984415" 
	TEXT="提交日志有问题： git ci --amend"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1940338708" 
	TEXT="Git 变基">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1329578132" 
	TEXT="实现历史提交的整理">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1677205659" 
	TEXT="Git rebase">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#990000" FOLDED="true" ID="ID_742058904" 
	TEXT="如何修改历史提交？">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1669550972" 
	TEXT="一个笨方法">
<node COLOR="#111111" ID="ID_714539649" 
	TEXT="checkout 历史版本"/>
<node COLOR="#111111" ID="ID_192846439" 
	TEXT="cherry-pick 错误提交"/>
<node COLOR="#111111" ID="ID_113764551" 
	TEXT="commit --amend"/>
<node COLOR="#111111" ID="ID_1143247945" 
	TEXT="git rebase 变基"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_432858843" 
	TEXT="好的办法">
<node COLOR="#111111" ID="ID_1436248394" 
	TEXT="git rebase -i 。。。"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_570563852" 
	TEXT="撤销操作（删除核弹起爆码）/和谐/墙">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1275319654" 
	TEXT="用 git checkout 取消本地文件修改，相当于 svn revert">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" FOLDED="true" ID="ID_1510390008" 
	TEXT="如何不变更历史的撤销某个提交">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_78948129" 
	TEXT="git revert &lt;commit&gt;"/>
</node>
<node COLOR="#111111" ID="ID_1296515440" 
	TEXT="如果 git add 和 git rm 操作尚未提交，如何撤销？">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_774476671" 
	TEXT="但是第一次建库，不是这么操作的，而要 git rm --cached ">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_339684205" 
	TEXT="撤销已经提交的操作。git reset ， --soft, --hard, ...">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_893753929" 
	TEXT="git reset 多说几句">
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" ID="ID_771150047" 
	TEXT="最新提交的撤销： git ci --amend">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1128240825" 
	TEXT="提交撤销的原理：分支游标">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1629350594" 
	TEXT="分支是 refs/heads 下的文件（引用）"/>
<node COLOR="#111111" ID="ID_1239615245" 
	TEXT="引用指向一个提交"/>
<node COLOR="#111111" ID="ID_879042389" 
	TEXT="分支的历史是和相关的。"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_354216441" 
	TEXT="找回重置的版本库 reflog">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1311492716" 
	TEXT="RefLog Shortnames&#xa;&#xa;One of the things Git does in the background while you’re working away is keep a reflog — a log of where your HEAD and branch references have been for the last few months.&#xa;&#xa;You can see your reflog by using git reflog:&#xa;&#xa;$ git reflog&#xa;734713b... HEAD@{0}: commit: fixed refs handling, added gc auto, updated&#xa;d921970... HEAD@{1}: merge phedders/rdocs: Merge made by recursive.&#xa;1c002dd... HEAD@{2}: commit: added some blame and merge stuff&#xa;1c36188... HEAD@{3}: rebase -i (squash): updating HEAD&#xa;95df984... HEAD@{4}: commit: # This is a combination of two commits.&#xa;1c36188... HEAD@{5}: rebase -i (squash): updating HEAD&#xa;7e05da5... HEAD@{6}: rebase -i (pick): updating HEAD&#xa;&#xa;Every time your branch tip is updated for any reason, Git stores that information for you in this temporary history. And you can specify older commits with this data, as well. If you want to see the fifth prior value of the HEAD of your repository, you can use the @{n} reference that you see in the reflog output:&#xa;&#xa;$ git show HEAD@{5}&#xa;&#xa;You can also use this syntax to see where a branch was some specific amount of time ago. For instance, to see where your master branch was yesterday, you can type&#xa;&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1780915744" 
	TEXT="Step 12: 不要将鸡蛋放在一个篮子里（git push）">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1937427093" 
	TEXT="本地克隆。每章一个克隆，有些太恐怖！">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_704217379" 
	TEXT="实际上只有一个克隆就可以了。">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1081340660" 
	TEXT="本地克隆">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_450920240" 
	TEXT="clone --mirror"/>
<node COLOR="#111111" ID="ID_1454885577" 
	TEXT="git push"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1567626628" 
	TEXT="直接向本地克隆为什么会失败？">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_557313563" 
	TEXT="裸版本库">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_532743507" 
	TEXT="本地 init 一个空库，然后 push">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_833622297" 
	TEXT="或者 git clone --mirror"/>
</node>
<node COLOR="#990000" ID="ID_1997618543" 
	TEXT="直接 push 太麻烦">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1547693638" 
	TEXT="注册远程版本库，push">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_326035925" 
	TEXT="多台机器数据的同步（git pull）">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1887461557" 
	TEXT="git pull">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1387396129" 
	TEXT="U盘的 Push">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1348857825" 
	TEXT="others">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
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
<node COLOR="#00b439" FOLDED="true" ID="ID_1549301818" 
	TEXT="DAG 畅想">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_767712039" 
	TEXT="可能构成环路，导致死循环么？ Git 根本不用在死循环判断上浪费一行代码">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_146324981" 
	TEXT="以一个树状的 DAG 说明，如何从一点递归到根。对于版本控制来说，见到历史。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_356306062" 
	TEXT="对于 Subversion 做到这样很难。因为其线性提交。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_296498879" 
	TEXT="可否包括多颗树？可以，不对版本库进行检查。">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1844858118" 
	TEXT="子树模型提供了一个不同版本库避免冲突的结合方案。">
<font NAME="Serif" SIZE="14"/>
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
<node COLOR="#0033ff" FOLDED="true" ID="ID_1683992194" POSITION="right" 
	TEXT="Git 进阶篇: 协作">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" FOLDED="true" ID="ID_473330881" 
	TEXT="Step 9: pull/push， 多人协作">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_1897687140" 
	TEXT="Git 支持的协议">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1093768980" 
	TEXT="ssh"/>
<node COLOR="#111111" ID="ID_380141024" 
	TEXT="http"/>
<node COLOR="#111111" ID="ID_1944877979" 
	TEXT="git"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_458559043" 
	TEXT="集中式服务器，push/pull">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1158946938" 
	TEXT="用 push 和 pull 可以模拟集中式版本控制系统的工作流程">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1268155066" 
	TEXT="Github 上 pull 我的版本库">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1838521611" 
	TEXT="设置 pushurl，推送到自己克隆的版本库">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1543952341" 
	TEXT="pull = fetch + merge">
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_95316404" 
	TEXT="从他人机器 pull">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1418738352" 
	TEXT="Step 10: format-patch/apply/am, 多人协作">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_249271017" 
	TEXT="commit -s">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1192962447" 
	TEXT="Step 11: Git 基础（冲突解决）">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_646053453" 
	TEXT="引发冲突的条件：不是基于服务器最新提交进行更改。">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_289026884" 
	TEXT="冲突解决的几种可能">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1119183962" 
	TEXT="未引发冲突">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_631261458" 
	TEXT="冲突的自动解决（成功）">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1298374889" 
	TEXT="冲突的自动解决（逻辑冲突）">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1890445539" 
	TEXT="真正的冲突（手动解决）">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_462055545" 
	TEXT="因为文件重命名引发的冲突。到底改名不改名？（SVN 中叫做树冲突）">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1552803355" 
	TEXT="冲突解决的方法">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1281299742" 
	TEXT="其它可引发冲突的命令">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_667248525" 
	TEXT="rebase">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1877967511" 
	TEXT="pull">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1226880636" 
	TEXT="merge">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1068443755" 
	TEXT="总结：">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_556618630" 
	TEXT="可以通过 u 盘或者网络对自己在多台机器的操作进行同步，并能够在同步的时候，进行冲突的解决。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_647665757" 
	TEXT="命令总结">
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" ID="ID_718955226" 
	TEXT="而且refs 中只有一个 master 感到非常困惑，为什么叫做 master，还能不能有其它">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_135506718" 
	TEXT="Step 12: 里程碑/分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_747613262" 
	TEXT="和 Subversion 相似之处，Commit 不可变，指定了唯一标识。">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_159479043" 
	TEXT="缺点难记，最好有标识对应，就是 tag">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1411786851" 
	TEXT="还有 commit 可能由于 reset 而丢失">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_622673054" 
	TEXT="tag 详解">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_964368660" 
	TEXT="简单的 tag">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_947982010" 
	TEXT="注释/签名的 tag">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1608622172" 
	TEXT="git describe 命令">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1541336346" 
	TEXT="git name-rev">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_810203260" 
	TEXT="切换到里程碑，HEAD 处于 detached HEAD 状态，为何故？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_356033177" 
	TEXT="Git 里程碑">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1950537415" 
	TEXT="Git 的 commit-id">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1447221485" 
	TEXT="COMMIT-ISH 即提交ID，是由 40 个十六进制数字组成，可以由开头的任意长度的数字串指代，只要不冲突。">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_442805379" 
	TEXT="建立/删除和查看 tag">
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" ID="ID_1006292485" 
	TEXT="查看 tag 对应的 commit id">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_552581117" 
	TEXT="查看某个 commit id 是否有对应的 tag 或者分支？ (name-rev)">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1411702649" 
	TEXT="git name-rev 用于查看某个 commit 是否有对应 tag。&#xa;&#xa;$ git name-rev 41008ee&#xa;41008ee tags/v1.0~1&#xa;">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_484431346" 
	TEXT="能否在 Tag 上提交？">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1592731522" 
	TEXT="SVN 是可以在 tag 上提交的，但是 git 很好的处理这个问题"/>
<node COLOR="#111111" ID="ID_1112648429" 
	TEXT="git co tagname， 实际上 HEAD 内容会变成 40位 commitid，而非 symbol ref name"/>
<node COLOR="#111111" ID="ID_1290204665" 
	TEXT="提交不会被保留"/>
<node COLOR="#111111" ID="ID_1739869171" 
	TEXT="要想提交被保留，执行 git co -b branch_name"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1971546762" 
	TEXT="Tag 的实质">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" FOLDED="true" ID="ID_1459232538" 
	TEXT="共享里程碑">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" FOLDED="true" ID="ID_204980636" 
	TEXT="里程碑的误用">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1511354576" 
	TEXT="不要修改里程碑"/>
<node COLOR="#111111" ID="ID_613309185" 
	TEXT="修改的里程碑，运行 git push, git pull 不会自动同步"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_500719407" 
	TEXT="分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1346624824" 
	TEXT="版本库创建时的 master 分支">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_227226980" 
	TEXT="直接在 .git/refs/heads 下拷贝">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_341479438" 
	TEXT="使用 git  branch 命令创建">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_669600485" 
	TEXT="使用 git checkout 命令创建">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_795682101" 
	TEXT="分支的作用">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_231331067" 
	TEXT="release 分支">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1208444838" 
	TEXT="功能分支">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1701672550" 
	TEXT="只读分支">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1008288155" 
	TEXT="分支的奥秘">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="idea"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1618650480" 
	TEXT=".git/refs/heads/ 下是分支名称">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1297388320" 
	TEXT="$ ls .git/refs/heads/&#xa;master  new&#xa;"/>
</node>
<node COLOR="#111111" ID="ID_686167280" 
	TEXT="例如 .git/refs/heads/master 中记录的是 master 分支对应的 40 位 commit id">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_346325" 
	TEXT=".git/refs/tags/ 下是里程碑名称。如果目录为空，可能已经打包整理到文件 .git/packed-refs 文件中了。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_133390599" 
	TEXT=".git/packed-refs 是 git 版本库经过 gc 整理后的分支和commit 对应索引文件（纯文本文件）">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1050308485" 
	TEXT=".git/HEAD 文件内容指向具体的分支。例如 ref: refs/heads/newbranch">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1488868592" 
	TEXT="$ cat .git/HEAD&#xa;ref: refs/heads/new&#xa;"/>
</node>
<node COLOR="#111111" ID="ID_1250067505" 
	TEXT=".git/logs/refs/heads/ 下以分支名称命名的文件，包含对应分支的 commit 历史">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_96167658" 
	TEXT="一般我们使用简写的名称，实际的对应关系如下。&#xa;    * The branch &quot;test&quot; is short for &quot;refs/heads/test&quot;.&#xa;    * The tag &quot;v2.6.18&quot; is short for &quot;refs/tags/v2.6.18&quot;.&#xa;    * &quot;origin/master&quot; is short for &quot;refs/remotes/origin/master&quot;. &#xa;&#xa;如果存在同名的里程碑和分支，就需要用长的名称（全名）了。">
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="idea"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1638439749" 
	TEXT="引用的奥秘">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1746903634" 
	TEXT="不同路径下的引用">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_623285892" 
	TEXT="refs/heads">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1301309041" 
	TEXT="refs/tags">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_828457952" 
	TEXT="refs/remotes/">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1083169713" 
	TEXT="refs/top-bases/">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1110131535" 
	TEXT="refs/changes/">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_757285595" 
	TEXT="refs/for/">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1832578454" 
	TEXT="只有 refs/heads/ 下引用可以检出并直接操作？其它都是 detached HEAD？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1053799415" 
	TEXT="HEAD 和分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1853158730" 
	TEXT="HEAD 即顶节点，是当前开发分支的最顶端节点">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1120344198" 
	TEXT="一般 HEAD 指向 master 分支">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_247582814" 
	TEXT="$ cat .git/HEAD&#xa;ref: refs/heads/master&#xa;"/>
<node COLOR="#111111" ID="ID_1548822312" 
	TEXT="$ cat .git/HEAD&#xa;ref: refs/heads/feature&#xa;"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1360048480" 
	TEXT="checkout master 和具体 commit-id 的区别">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_949867618" 
	TEXT="master 可以跟踪最新提交"/>
<node COLOR="#111111" ID="ID_1133004358" 
	TEXT="而 commit-id 则无反应"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1142406819" 
	TEXT="克隆远程版本库的操作">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_953801272" 
	TEXT="远程版本库是否有 HEAD，及影响？">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_148671887" 
	TEXT="本地 master 如何创建？">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_751970680" 
	TEXT="fetch / pull 命令的区分">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1744088608" 
	TEXT="push 命令？">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_942411666" 
	TEXT="本地分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_808002371" 
	TEXT="master 就是分支">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_915189552" 
	TEXT="git co master"/>
<node COLOR="#111111" ID="ID_1766366410" 
	TEXT="cat .git/HEAD"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1411472705" 
	TEXT="git checkout &lt;tag_name&gt;: 检出旧版本/切换分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" FOLDED="true" ID="ID_356300620" 
	TEXT="切换分支： git checkout &lt;branch_name&gt;">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_798748093" 
	TEXT="$ git branch&#xa;* master&#xa;  new&#xa;$ git checkout new&#xa;Switched to branch &apos;new&apos;&#xa;$ git branch&#xa;  master&#xa;* new">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_945738539" 
	TEXT="查看分支： git branch">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_160958947" 
	TEXT="$ git branch&#xa;* master">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_855093224" 
	TEXT="创建新分支 ： git branch &lt;branch_name&gt; [base_tag]">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" FOLDED="true" ID="ID_340611059" 
	TEXT="创建并切换到新分支： git checkout -b &lt;new_branch&gt; [base_tag]">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1926222995" 
	TEXT="$ git checkout -b new&#xa;Switched to a new branch &apos;new&apos;&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_490875564" 
	TEXT="删除分支： git branch -d &lt;branch_name&gt; （限制条件： 该分支已经合并到当前分支）">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_723094752" 
	TEXT="$ git branch -d new&#xa;error: Cannot delete the branch &apos;new&apos; which you are currently on.&#xa;$ git checkout master&#xa;Switched to branch &apos;master&apos;&#xa;$ git branch -d new&#xa;Deleted branch new (was f01f109).&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" ID="ID_1056472844" 
	TEXT="无条件删除分支： git branch -D &lt;branch_name&gt; ">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="yes"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_75201423" 
	TEXT="重新确定分支点： git reset --hard tagname">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" ID="ID_873938692" 
	TEXT="gitk 可以显示分支图">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="idea"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1402402678" 
	TEXT="合并分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#990000" ID="ID_1758115602" 
	TEXT="Tag 和分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1672445363" 
	TEXT="引用">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_197912906" 
	TEXT="remote">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_1635733651" 
	TEXT="远程 remote">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_869964709" 
	TEXT="分支合并">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_387283656" 
	TEXT="合并工具： kdiff3">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_527892004" 
	TEXT="访问 Git 版本范围的语法">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_945774347" 
	TEXT="^r1 r2">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_37934130" 
	TEXT="^r1 r2 means commits reachable from r2 but exclude the ones        reachable from r1.">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1445746737" 
	TEXT="r1..r2">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_315803677" 
	TEXT="When you have two commits r1 and r2 (named according to the syntax        explained in SPECIFYING REVISIONS above), you can ask for commits that are reachable from r2 excluding those that are reachable from r1 by ^r1 r2        and it can be written as r1..r2.">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1268416785" 
	TEXT="r1...r2">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1794923099" 
	TEXT=" r1 r2 --not $(git merge-base --all r1 r2)"/>
<node COLOR="#111111" ID="ID_1637322380" 
	TEXT="A similar notation r1...r2 is called symmetric difference of r1 and r2 and is defined as r1 r2 --not $(git merge-base --all r1 r2). It is the set        of commits that are reachable from either one of r1 or r2 but not from both. "/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_603175635" 
	TEXT="r1^@">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_974512945" 
	TEXT="The r1^@ notation means all parents of r1."/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_828485619" 
	TEXT="r1^!">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_372153712" 
	TEXT="r1^!&#xa;       includes commit r1 but excludes all of its parents."/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_843005755" 
	TEXT="示例">
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#990000" FOLDED="true" ID="ID_897846578" 
	TEXT="分支管理 SOP">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_6816277" 
	TEXT="参考 Git 的管理： maintain-git.txt">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1945503704" 
	TEXT="The policy.&#xa;&#xa; - Feature releases are numbered as vX.Y.Z and are meant to&#xa;   contain bugfixes and enhancements in any area, including&#xa;   functionality, performance and usability, without regression.&#xa;&#xa; - Maintenance releases are numbered as vX.Y.Z.W and are meant&#xa;   to contain only bugfixes for the corresponding vX.Y.Z feature&#xa;   release and earlier maintenance releases vX.Y.Z.V (V &lt; W).&#xa;&#xa; - &apos;master&apos; branch is used to prepare for the next feature&#xa;   release. In other words, at some point, the tip of &apos;master&apos;&#xa;   branch is tagged with vX.Y.Z.&#xa;&#xa; - &apos;maint&apos; branch is used to prepare for the next maintenance&#xa;   release.  After the feature release vX.Y.Z is made, the tip&#xa;   of &apos;maint&apos; branch is set to that release, and bugfixes will&#xa;   accumulate on the branch, and at some point, the tip of the&#xa;   branch is tagged with vX.Y.Z.1, vX.Y.Z.2, and so on.&#xa;&#xa; - &apos;next&apos; branch is used to publish changes (both enhancements&#xa;   and fixes) that (1) have worthwhile goal, (2) are in a fairly&#xa;   good shape suitable for everyday use, (3) but have not yet&#xa;   demonstrated to be regression free.  New changes are tested&#xa;   in &apos;next&apos; before merged to &apos;master&apos;.&#xa;&#xa; - &apos;pu&apos; branch is used to publish other proposed changes that do&#xa;   not yet pass the criteria set for &apos;next&apos;.&#xa;&#xa; - The tips of &apos;master&apos;, &apos;maint&apos; and &apos;next&apos; branches will always&#xa;   fast-forward, to allow people to build their own&#xa;   customization on top of them.&#xa;&#xa; - Usually &apos;master&apos; contains all of &apos;maint&apos;, &apos;next&apos; contains all&#xa;   of &apos;master&apos; and &apos;pu&apos; contains all of &apos;next&apos;.&#xa;&#xa; - The tip of &apos;master&apos; is meant to be more stable than any&#xa;   tagged releases, and the users are encouraged to follow it.&#xa;&#xa; - The &apos;next&apos; branch is where new action takes place, and the&#xa;   users are encouraged to test it so that regressions and bugs&#xa;   are found before new topics are merged to &apos;master&apos;.&#xa;&#xa; - &apos;pu&apos; branch is used to publish other proposed changes that do&#xa;   not yet pass the criteria set for &apos;next&apos;.&#xa;&#xa; - The tips of &apos;master&apos;, &apos;maint&apos; and &apos;next&apos; branches will always&#xa;   fast-forward, to allow people to build their own&#xa;   customization on top of them.&#xa;&#xa; - Usually &apos;master&apos; contains all of &apos;maint&apos;, &apos;next&apos; contains all&#xa;   of &apos;master&apos; and &apos;pu&apos; contains all of &apos;next&apos;.&#xa;&#xa; - The tip of &apos;master&apos; is meant to be more stable than any&#xa;   tagged releases, and the users are encouraged to follow it.&#xa;&#xa; - The &apos;next&apos; branch is where new action takes place, and the&#xa;   users are encouraged to test it so that regressions and bugs&#xa;   are found before new topics are merged to &apos;master&apos;.&#xa;&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1915878443" 
	TEXT="总结：">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_475026628" 
	TEXT="可以通过建立 tag 来标记里程碑，以及用分支进行特性开发。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_49318021" 
	TEXT="命令总结">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1047345905" 
	TEXT="git tag"/>
<node COLOR="#111111" ID="ID_792830821" 
	TEXT="git branch"/>
</node>
<node COLOR="#111111" ID="ID_1933926024" 
	TEXT="我们已经知道如何操作本地分支，对于远程版本库的分支如何操作以及和本地分支的关系如何？">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1692345880" 
	TEXT="里程碑/分支名称的合法性问题">
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1282356050" 
	TEXT="1.7.4开始，分支名称不能以减号（-）开始了。">
<font NAME="Serif" SIZE="12"/>
<icon BUILTIN="info"/>
<node COLOR="#111111" ID="ID_1789485369" 
	TEXT=" * The option parsers of various commands that create new branch (or    rename existing ones to a new name) were too loose and users were    allowed to call a branch with a name that begins with a dash by    creative abuse of their command line options, which only lead to    burn themselves.  The name of a branch cannot begin with a dash    now. "/>
</node>
<node COLOR="#111111" ID="ID_1337413283" 
	TEXT="代码中看看哪些字符不允许？ "/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_148688254" 
	TEXT="Step 13: Git 进阶（远程分支）">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" FOLDED="true" ID="ID_433746938" 
	TEXT="直接操作远程版本库的分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_606995194" 
	TEXT="如何查看远程服务器的分支？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1986091941" 
	TEXT="如何删除远程服务器的分支？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_927844154" 
	TEXT="如何在远程服务器上创建分支？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1197025428" 
	TEXT="本地分支和远程分支的关系">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_15981385" 
	TEXT="本地分支用于临时性的提交和试验（experiment)，如果和上游某个分支同名，会有什么问题么？">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1413435672" 
	TEXT="具体说1: 如果我执行了 git pull ，会把上游的同名分支拉过来么？这可能是我不需要的。">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1845345488" 
	TEXT="具体说2：如果我不小心执行了 git push，会把我本地的测试提交推送上游么？">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1207155389" 
	TEXT="push 的语法">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" ID="ID_988747655" 
	TEXT="任何版本库都有 master 分支以及本地分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1550421566" 
	TEXT="如果向其它版本库 PUSH 的时候，会将本地所有分支推送到版本库中么？">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_101142689" 
	TEXT="混乱，因为本地分支由个人管理，名称五花八门">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_695348295" 
	TEXT="作为集中式服务器需要更好的统一的分支名称管理">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_799638677" 
	TEXT="因此缺省是不会进行 push 的。">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_650221643" 
	TEXT="总结：">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_154672801" 
	TEXT="知道了如何操作远程分支以及远程分支和本地分支的关系">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_974768808" 
	TEXT="命令总结">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_621238900" 
	TEXT="git remote"/>
<node COLOR="#111111" ID="ID_1102078323" 
	TEXT="git branch -r"/>
</node>
<node COLOR="#111111" ID="ID_1996763168" 
	TEXT="我们已经知道如何操作本地分支，对于远程版本库的分支如何操作以及和本地分支的关系如何？">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1532593470" 
	TEXT="git config 配置中的 .merge 和 .rebase">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_319938031" 
	TEXT="See `branch.&lt;name&gt;.rebase` in linkgit:git-config[1] if you want to make `git pull` always use `{litdd}rebase` instead of merging. ">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1424004637" 
	TEXT="远程分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_539245296" 
	TEXT="显示和查看远程分支： git branch -r">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" FOLDED="true" ID="ID_1096514672" 
	TEXT="远程分支不能直接 checkout！">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" FOLDED="true" ID="ID_1167537737" 
	TEXT="理解 Git 远程分支">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" FOLDED="true" ID="ID_1045868165" 
	TEXT="远程分支引发的冲突">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_781319123" 
	TEXT="别人先我提交"/>
<node COLOR="#111111" ID="ID_924044629" 
	TEXT="我收回先前提交"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_415476154" 
	TEXT="删除远程分支:  git push origin :&lt;remote-branch-name&gt;">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_50163334" 
	TEXT="相当于命令 git push [remotename] [localbranch]:[remotebranch]  的 [localbranch] 为空">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_235525133" 
	TEXT="git push origin :branch_name"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1973915817" 
	TEXT="分支操作的安全性设置">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1569772311" 
	TEXT="是否允许 reset，版本库的安全设置">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1985647956" 
	TEXT="receive.denyNonFastForwards 如果设置为 true，禁止 non-fast forword"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1807048641" 
	TEXT="是否允许删除分支？">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_329380009" 
	TEXT="receive.denyDeletes"/>
</node>
<node COLOR="#111111" ID="ID_607752764" 
	TEXT="receive.denyCurrentBranch 缺省是 refuse，导致不能向含工作目录的库 push">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1491314093" 
	TEXT="git remote">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" FOLDED="true" ID="ID_1605394372" 
	TEXT="克隆即分支">
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_1428695704" 
	TEXT="一些 DCVS，如 Hg，压根就没有分支概念，有的只是不同的版本库克隆"/>
<node COLOR="#111111" ID="ID_301815757" 
	TEXT="Git 有分支也有克隆，可以吧克隆看成是另外的分支，反之亦然"/>
<node COLOR="#111111" ID="ID_434286054" 
	TEXT="克隆的操作"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1697598217" 
	TEXT="remote 和克隆">
<font NAME="Serif" SIZE="12"/>
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
<node COLOR="#111111" ID="ID_899954519" 
	TEXT="remote 的名字空间">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_1817874429" 
	TEXT="git remote add ： 跟踪其他源（除了缺省克隆时指定的源外）">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_641029727" 
	TEXT="$ git remote add linux-nfs git://linux-nfs.org/pub/nfs-2.6.git&#xa;$ git fetch linux-nfs&#xa;* refs/remotes/linux-nfs/master: storing branch &apos;master&apos; ...&#xa;  commit: bf81b46">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" FOLDED="true" ID="ID_114975816" 
	TEXT="相当于对 .git/config 进行了修改">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="12"/>
<node COLOR="#111111" ID="ID_693274854" 
	TEXT="git remote add name url 设定另外的同步源，用于 pull 和 fetch。相当于在 .git/config 文件尾部增加一个 remote 小节">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_1090689828" 
	TEXT="$ tail .git/config&#xa;&#xa;[remote &quot;linux-nfs&quot;]&#xa;        url = git://linux-nfs.org/pub/nfs-2.6.git&#xa;        fetch = +refs/heads/*:refs/remotes/linux-nfs/*&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#111111" ID="ID_1518562701" 
	TEXT="remote update">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
<node COLOR="#990000" ID="ID_1540388880" 
	TEXT="多个远程版本库">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_241320967" POSITION="right" 
	TEXT="Git 技巧篇：">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" FOLDED="true" ID="ID_64232537" 
	TEXT="Git 定制">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_83627666" 
	TEXT="git config 各个选项">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1455669451" 
	TEXT="属性">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1834344876" 
	TEXT="1.7.4开始，系统范围的属性放在 /etc/gitattributes 下，可以用 core.attributesfile 来定制。">
<font NAME="Serif" SIZE="14"/>
<icon BUILTIN="info"/>
</node>
</node>
<node COLOR="#00b439" ID="ID_1778813255" 
	TEXT="钩子">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_426928459" 
	TEXT="模板">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_1366306704" 
	TEXT="git sparse checkout">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_868780133" 
	TEXT="git shallow clone">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" ID="ID_1408876651" 
	TEXT="git replace">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_640899539" 
	TEXT="git notes">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_861826055" 
	TEXT="可以为提交说明添加评注。">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1242975695" 
	TEXT="grep 和 git grep">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_582867299" 
	TEXT="Subversion 那种在每个目录下 .svn 目录保存文件原始备份的方式，会导致 grep 搜索，两份拷贝。">
<font NAME="Serif" SIZE="14"/>
</node>
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
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_1872967347" POSITION="left" 
	TEXT="Git 工具">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" FOLDED="true" ID="ID_995570865" 
	TEXT="gitk">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_333132495" 
	TEXT="fast, scalable, distributed revision control system (revision tree visualizer)&#xa; Git is popular version control system designed to handle very large&#xa; projects with speed and efficiency; it is used for many high profile&#xa; open source projects, most notably the Linux kernel.&#xa; .&#xa; Git falls in the category of distributed source code management tools.&#xa; Every Git working directory is a full-fledged repository with full&#xa; revision tracking capabilities, not dependent on network access or a&#xa; central server.&#xa; .&#xa; This package provides the gitk program, a tcl/tk revision tree visualizer.&#xa;Homepage: http://git-scm.com/&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1293015054" 
	TEXT="gitg">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1596076267" 
	TEXT="git repository viewer for gtk+/GNOME&#xa; gitg is a fast GTK2 git repository browser for the GNOME desktop.&#xa; It currently features:&#xa; .&#xa;  * Loading large repositories very fast&#xa;  * Show/browse repository history&#xa;  * Show highlighted revision diff&#xa;  * Browse file tree of a revision and export by drag and drop&#xa;  * Search in the revision history on subject, author or hash&#xa;  * Switch between history view of branches easily&#xa;  * Commit view providing per hunk stage/unstage and commit&#xa;Homepage: http://trac.novowork.com/gitg/&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
<node COLOR="#00b439" FOLDED="true" ID="ID_1801029123" 
	TEXT="qgit">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1186169511" 
	TEXT="Qt application for viewing GIT trees&#xa; With qgit you will be able to browse revision tree, view patch content&#xa; and changed files, graphically following different development branches.&#xa; Main features:&#xa;  - View revisions, diffs, files history, files annotation, archive tree.&#xa;  - Commit changes visually cherry picking modified files.&#xa;  - Apply or format patch series from selected commits, drag and&#xa;    drop commits between two instances of qgit.&#xa;  - qgit implements a GUI for the most common StGIT commands like push/pop&#xa;    and apply/format patches. You can also create new patches or refresh&#xa;    current top one using the same semantics of git commit, i.e.&#xa;    cherry picking single modified files.&#xa;">
<font NAME="Serif" SIZE="14"/>
</node>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_180033128" POSITION="left" 
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
<node COLOR="#00b439" FOLDED="true" ID="ID_179605721" 
	TEXT="Git 命令">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
<node COLOR="#990000" ID="ID_1469239031" 
	TEXT="cherry-pick 相当于？">
<edge STYLE="bezier" WIDTH="thin"/>
<arrowlink DESTINATION="ID_1058278190" ENDARROW="Default" ENDINCLINATION="83;0;" ID="Arrow_ID_1065913453" STARTARROW="None" STARTINCLINATION="83;0;"/>
<font NAME="Serif" SIZE="14"/>
</node>
<node COLOR="#990000" FOLDED="true" ID="ID_1058278190" 
	TEXT="format-patch, am">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="14"/>
<node COLOR="#111111" ID="ID_1808607422" 
	TEXT="gerrit-cherry-pick 代码">
<font NAME="Serif" SIZE="12"/>
</node>
<node COLOR="#111111" ID="ID_45902321" 
	TEXT="    read commit changeid &lt;&quot;$TODO&quot;&#xa;    git rev-parse HEAD^0 &gt;&quot;$STATE/head_before&quot;&#xa;    git format-patch \&#xa;        -k --stdout --full-index --ignore-if-in-upstream \&#xa;        $commit^..$commit |&#xa;    git am $git_am_opt --rebasing --resolvemsg=&quot;$RESOLVEMSG&quot; || exit&#xa;">
<font NAME="Serif" SIZE="12"/>
</node>
</node>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_1921897980" POSITION="left" 
	TEXT="Git 使用">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" ID="ID_930503296" 
	TEXT="gerrit/Document/user-signedoffby.html">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_408637332" POSITION="left" 
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
<node COLOR="#0033ff" FOLDED="true" ID="ID_1871970362" POSITION="left" 
	TEXT="Git 托管">
<edge STYLE="sharp_bezier" WIDTH="8"/>
<font NAME="Serif" SIZE="18"/>
<node COLOR="#00b439" ID="ID_883947475" 
	TEXT="repo.or.cz, Gitorious or GitHub">
<edge STYLE="bezier" WIDTH="thin"/>
<font NAME="Serif" SIZE="16"/>
</node>
</node>
<node COLOR="#0033ff" FOLDED="true" ID="ID_1450558845" POSITION="left" 
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
