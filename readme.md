#使用指导
## 首先在mysql中建立一个包含两张表的数据库

* 表一（关键词表）
id, relationword, link

* 表二（标题和域名表）
keyword_id, title, domain


* 创建语句
1.create database yilong_db character set gbk
2.create table baidukeywords(
	id int unsigned not null auto_increment primary key,
	relationword char(24) not null,
	link text not null
)

　create table title_domains(
	keyword_id int unsigned not null auto_increment primary key,
	title text not null,
	domian text not null)
3.insert into baidukeywords values(NULL, "science杂志","/s?wd=science杂志&amp;rsp=0&amp;f=1&amp;oq=science&amp;ie=utf-8&amp;usm=2&amp;rsv_idx=1&amp;rsv_pq=8eeb11ea00018f6d&amp;rsv_t=6ce1kgB8VSjlUXBlseZ5o5d9e1VwsVjp8ZXqxSIWOHng8HWkMJAkSN%2BrWis&amp;rsv_ers=xn1&amp;rs_src=0&amp;rsv_pq=8eeb11ea00018f6d&amp;rsv_t=6ce1kgB8VSjlUXBlseZ5o5d9e1VwsVjp8ZXqxSIWOHng8HWkMJAkSN%2BrWis");

##待完成
１．网址链接相同部分删除效果差
２．多线程执行
 
 ##如何运行，在当前目录下运行以下命令
ruby get_baidu.rb