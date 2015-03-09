#database config

###表一（关键词表）
id, relationword, link

###表二（标题和域名表）
keyword_id, title, domain


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


       #一个关键词抓取十个title,domian
              #for i in 0...@path_title.size do
              #      client.query("insert into title_domains values(#{i+10000}, '#{@path_title[i]}','#{@path_domain[i]}')")
              #end
#获得标题和域名的ＣＳＳ路径
              #title:h3.t a  domain:div.f13 span.g
              html_doc.css("div h3.t a").each do |f|
                @path_title << f.children.text
              end

              html_doc.css("div.f13 span.g").each do |f|
                @path_domain << f.children.text
              end

              puts @path_title



              #获取关键词的搜索结果的前十条的标题和域名
　#标题与域名抓取并存储

 def get_title_domian
      client = Mysql2::Client.new(:host => "localhost", :username => "root",:password=> "xiaofu",:database=> "dragon_db")
      
      results = client.query("SELECT * FROM baidukeywords ")
      results.each do |f|
              request = "GET #{f["link"]} HTTP/1.0\r\n\r\n"
              socket = TCPSocket.open(@host, @port)  
              socket.print(request)               
              response = socket.read        
              headers,body = response.split("\r\n\r\n", 2)
              socket.close
                   
              html_doc = Nokogiri::HTML(body)
              
              #获得标题和域名的ＣＳＳ路径
              #title:h3.t a  domain:div.f13 span.g
              html_doc.css("div h3.t a").each do |f|
                @path_title << f.children.text
              end

              html_doc.css("div.f13 span.g").each do |f|
                @path_domain << f.children.text
              end
       end
    end