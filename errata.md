---
layout: master
title: 勘误表
stylesheets: [ "/html/inc/errata.css" ]
javascripts: [ "/javascripts/jquery.js", "html/inc/click_more.js" ]
---
test
您发现了新的错误？可以通过下面方式贡献：

1. 记录您发现的问题。

   访问 [缺陷追踪系统（Github）](https://github.com/gotgit/gotgit/issues/new) 报告问题。

2. 修改本Git版本库中的勘误表。

    * 在 GitHub 上从本版本库 <https://github.com/gotgit/gotgit/> 派生后，直接修改勘误表文件 ``errata.md`` 。
    * 您的修改可以通过 Github 的 Pull Request 工具通知我。
    * 还可以直接通过 [新浪微博](http://weibo.com/gotgit/) @群英汇蒋鑫。

## 第一版• 第三印

### 勘误

页码    | 位置                     | 错误描述            | 原文                         | 修正为                       | 缺陷追踪
-------:| ------------------------ | ------------------- | ---------------------------- | ---------------------------- | --------
     30 | 倒数第5行                | 命令没有加粗        | $ . \`brew --prefix\`/etc/bash\_completion | $ **. \`brew --prefix\`/etc/bash\_completion** |
    415 | 脚注(1)第一行尾          | 漏印、丢字          | 而且是Gitolite的主要安装方式， | 且曾是Gitolite的主要安装方式， |
    429 | 第21行                   | 代码块应向右缩进    | dev1$ **git push ...**       | -                            |
    429 | 第22行                   | 文字前后重复，删除“拥有”两字 | 例如用户dev1拥有对其自建的版本库... | 例如用户dev1对其自建的版本库... |

### 说明

为避免对排版的破坏，下列更新已经用脚注的方式标注在书的相关章节中。具体细节还要参照如下博客中的内容。

1. [Gitolite服务架设](http://www.worldhello.net/2011/11/30/02-gitolite-install.html) ，书P415脚注(1)。
2. [Gitolite版本库镜像](http://www.worldhello.net/2011/11/30/03-gitolite-mirror.html) ，书P436脚注(1)。
3. [Gitolite通配符版本库自定义授权](http://www.worldhello.net/2011/11/30/04-gitolite-getperms-setperms.html) ，书P429第30.4.3小节已更新。
4. [Gitolite管理员定义命令](http://www.worldhello.net/2011/11/30/05-gitolite-adc.html) 。

## 第一版• 第二印

### 勘误

<a class="click-more"></a>

页码    | 位置                     | 错误描述            | 原文                         | 修正为                       | 缺陷追踪
-------:| ------------------------ | ------------------- | ---------------------------- | ---------------------------- | --------
文前IX页| 第8行                    | 官方网站URL变更     | http://www.ossxp.com/doc/gotgit/ | http://www.worldhello.net/gotgit/ |
     30 | 第18,19行共两处          | 反引号错印为单引号  | 'brew --prefix'              | \`brew --prefix\`            | [#146][bug2-146]
     30 | 倒数第5行                | 命令提示符和点号之间有空格 | $**. \`brew --prefix\`/etc/bash\_completion** | $ **. \`brew --prefix\`/etc/bash\_completion** | [#152][bug2-152]
    146 | 倒数第3行                | 命令 ``$ git rev-list --oneline F^! D`` 的结果中应该有Commit G  | - | - | [GitHub#11][bug-11]
    229 | 第18,23,28行             | 用户输入字母未加粗  | Use (m)odified or (d)eleted file, or (a)bort? 用户输入 | Use (m)odified or (d)eleted file, or (a)bort? **用户输入** | [#155][bug2-155]

### 更新

<a class="click-more"></a>

* “第30章 Gitolite 服务架设”部分内容已经过时，为避免对排版的破坏，以脚注形式补充在书的相关章节中。具体细节还要参照如下博客中的内容。

  1. [Gitolite服务架设](http://www.worldhello.net/2011/11/30/02-gitolite-install.html)
  2. [Gitolite版本库镜像](http://www.worldhello.net/2011/11/30/03-gitolite-mirror.html)
  3. [Gitolite通配符版本库自定义授权](http://www.worldhello.net/2011/11/30/04-gitolite-getperms-setperms.html)
  4. [Gitolite管理员定义命令](http://www.worldhello.net/2011/11/30/05-gitolite-adc.html)

## 第一版• 第一印

### 勘误

<a class="click-more"></a>

页码    | 位置                      | 错误描述            | 原文                         | 修正为                       | 缺陷追踪
-------:| ------------------------- | ------------------- | ---------------------------- | ---------------------------- | --------
     30 | 倒数第5,7,11,12行等6处    | 反引号错印为单引号  | 'brew --prefix'              | \`brew --prefix\`            | [#146][bug2-146]
     30 | 倒数第5行                 | 反引号错印、未加粗、缺少命令提示符  | 'brew --prefix'/etc/bash\_completion | $ **. \`brew --prefix\`/etc/bash\_completion** | [#152][bug2-152]
     66 | 倒数第11行                | “作者”误为“提交者”  | Author（提交者）             |  Author（作者）              | [GitHub#2][bug-2]
    144 | 第1行                     | 行首多了一个反引号  | \`$ **git rev-parse  A^{tree}  A:**  | $ **git rev-parse  A^{tree}  A:**              | [#153][bug2-153]
    218 | 第8行                     | Git后多了个字母's'  | Gits标识出合并冲突，         | Git标识出合并冲突，                      | [#159][bug2-159]
    265 | 最后1行                   | 单词 'world' 少了字母 's' | 用户在使用1.0版的hello-word | 用户在使用1.0版的hello-world  | [GitHub#5][bug-5]
    369 | 第21行                    | 丢了一个项目的“目”字 | 但 `-i` 参数仅当对一个项执行时才有效。 | 但 `-i` 参数仅当对一个项目执行时才有效。     | [GitHub#3][bug-3]
    516 | 倒数第15行                | 反引号错印为双引号  | **oldtag="cat"**             | **oldtag=\`cat\`**           | [#151][bug2-151]

### 更新

<a class="click-more"></a>

页码    | 位置                     | 原内容                       | 更新内容
-------:| ------------------------ | ---------------------------- | ----------------------------
    489 | 倒数第4行之前            | -                            | GitHub的流行一方面是因其简便的Git版本库创建和托管流程，另一方面还在于其提供了实用的协同工具（如在线Fork + Pull Request），极大地方便了团队协同和项目管理。GitHub的丰富功能足可以单独再写一本书，帮我来完善它吧。网址： http://gotgit.github.com/gotgithub/ 。
307,311,312 | 多处替换             | 金字塔（式协同模型）         | 社交网络（式协同模型）
    311 | 倒数第4行                | 金字塔模型的含义是，         | 社交网络的含义是针对版本库的修改在信任的个体（程序员）间传递。金字塔的含义是，
    463 | 第17行 | 虽然演示用的是本地地址（localhost），但是操作远程服务器也是可以的，只要拥有管理员权限。 | 命令中的user是Gerrit上注册的第一个账号ID，host是刚刚架设的Gerrit服务器地址（域名或IP）。
    463 | 第19行 | $ **``ssh  -p  29418  localhost  gerrit  gsql``** | $ **``ssh  -p  29418  user@host  gerrit  gsql``**
    467 | 第3行  | 在 Gerrit 个人配置界面中设置了公钥之后，就可以连接 Gerrit 的 SSH 服务器执行命令，示例使用的是本机localhost，其实也可以使用远程IP地址。只是对于远程主机需要确认端口不要被防火墙拦截，Gerrit的SSH服务器使用特殊的端口，默认是29418。 | 在Gerrit个人配置界面中设置了公钥之后，就可以连接Gerrit的SSH服务器（默认端口29418）执行命令。以下示例中Gerrit服务器地址为host，用户ID是在Gerrit中创建的管理员ID（如gerrit）。如果SSH命令的登录ID和系统登录ID相同，用户ID还可省略。
467-473 | 多处将 ``localhost`` 替换为 ``gerrit@host`` | $ ssh -p 29418 localhost gerrit ls-projects | $ ssh -p 29418 gerrit@host gerrit ls-projects
477,478,483,486 | 多处将 ``localhost`` 替换为 ``jiangxin@host`` | ssh://localhost:29418/hello.git | ssh://jiangxin@host:29418/hello.git


  [bug-2]: http://github.com/gotgit/gotgit/issues/2
  [bug-3]: http://github.com/gotgit/gotgit/issues/3
  [bug-5]: http://github.com/gotgit/gotgit/issues/5
  [bug-11]: http://github.com/gotgit/gotgit/issues/11
  [bug2-146]: http://redmine.ossxp.com/redmine/issues/146
  [bug2-151]: http://redmine.ossxp.com/redmine/issues/151
  [bug2-152]: http://redmine.ossxp.com/redmine/issues/152
  [bug2-153]: http://redmine.ossxp.com/redmine/issues/153
  [bug2-155]: http://redmine.ossxp.com/redmine/issues/155
  [bug2-159]: http://redmine.ossxp.com/redmine/issues/159
