# animation-forum-system

#### 介绍
动漫论坛系统

#### 软件架构
 _springboot+react前后端分离_ 

 **数据库记得改成自己的账号密码** 
![输入图片说明](sql-design/MySQL_resource.png)

#### 数据库设计

 _数据库总体设计已完成_ 

数据库使用MySQL8.0

可导入的 MySQL 8.0 表结构和 mock 数据见 [comic_forum_dump.sql](comic_forum_dump.sql)。文件包含 7 张表，每张表的数据均少于 100 条；导入前请使用空的 `comic_forum` 数据库，脚本不会删除已有表。


几个表如下：
![输入图片说明](sql-design/%E6%89%80%E6%9C%89%E8%A1%A8.png.png)


 **user表的设计** 
![输入图片说明](sql-design/user.png.png)



 **board表的设计** 
![输入图片说明](sql-design/board.png)


 **classify表的设计** 
![输入图片说明](sql-design/classify.png)


 **forum表的设计** 
![输入图片说明](sql-design/forum.png)

 **comment表的设计** 
![输入图片说明](sql-design/comment2.png)

 **collects表和likes表的设计** 
![输入图片说明](likes.png)
![输入图片说明](collects.png)