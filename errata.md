---
layout: master
title: 勘误表
---

## 参与勘误

您发现了新的错误么？贡献出来吧，这厢有礼了。Orz

1. 记录您发现的问题。

   访问 [缺陷追踪系统（Github）](https://github.com/gotgit/gotgit/issues/new) 报告问题。

2. 修改本Git版本库中的勘误表。

    * 在 GitHub 上从本版本库 <https://github.com/gotgit/gotgit/> 派生后，直接修改勘误表。
    * 将您的修改通过 Github 的 Pull Request 工具通知我。
    * 您还可以直接通过 [新浪微博](http://weibo.com/gotgit/) @群英汇蒋鑫。

## 勘误表

说明：为突出字体加粗，用棕色字体显示加粗字体。

| 页码   | 位置                      | 原文/错误描述                | 修正为                       | 缺陷追踪                                             |
| ------:| ------------------------- | ---------------------------- | ---------------------------- | ---------------------------------------------------- |
|     30 | 倒数第5,7,11,12行等6处    | 'brew --prefix'              | \`brew --prefix\`            | [#146](http://redmine.ossxp.com/redmine/issues/146)  |
|     30 | 倒数第5行                 | 'brew --prefix'/etc/bash\_completion | $ **. \`brew --prefix\`/etc/bash\_completion** | [#152](http://redmine.ossxp.com/redmine/issues/152)  |
|     66 | 倒数第11行                | Author（提交者）             |  Author（作者）              | [GitHub#2](http://github.com/gotgit/gotgit/issues/2)    |
|    144 | 第1行                     | \`$ **git rev-parse  A^{tree}  A:**  | $ **git rev-parse  A^{tree}  A:**              | [#153](http://redmine.ossxp.com/redmine/issues/153)  |
|    146 |                           | ``$ git rev-list --oneline F^! D`` 的结果中应该有Commit G | | [GitHub#11](http://github.com/gotgit/gotgit/issues/11)    |
|    218 | 第8行                     | 况下，Gits标识出合并冲突，           | 况下，Git标识出合并冲突，                      | [#159](http://redmine.ossxp.com/redmine/issues/159)  |
|    265 | 最后1行                   | 用户在使用1.0版的hello-word          | 用户在使用1.0版的hello-world                   | [GitHub#5](http://github.com/gotgit/gotgit/issues/5)    |
|    369 | 第21行                    | 但 `-i` 参数仅当对一个项执行时才有效。 | 但 `-i` 参数仅当对一个项目执行时才有效。     | [GitHub#3](http://github.com/gotgit/gotgit/issues/3)    |
|    516 | 倒数第15行                | **oldtag="cat"**             | **oldtag=\`cat\`**           | [#151](http://redmine.ossxp.com/redmine/issues/151)  |

