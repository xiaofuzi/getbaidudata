require 'socket'
require 'nokogiri'
require 'mysql2'

   class Getbaidu
   	@@host = 'www.baidu.com'
   	@@port = 80
   	@@path = ["/s?wd=science%E6%9D%82%E5%BF%97&amp;rsp=0&amp;f=1&amp;oq=science&amp;ie=utf-8&amp;usm=2&amp;rsv_idx=1&amp;rsv_pq=8eeb11ea00018f6d&amp;rsv_t=6ce1kgB8VSjlUXBlseZ5o5d9e1VwsVjp8ZXqxSIWOHng8HWkMJAkSN%2BrWis&amp;rsv_ers=xn1&amp;rs_src=0&amp;rsv_pq=8eeb11ea00018f6d&amp;rsv_t=6ce1kgB8VSjlUXBlseZ5o5d9e1VwsVjp8ZXqxSIWOHng8HWkMJAkSN%2BrWis" ]
   	@@relation_word = [ "science" ]
   	@@get_times = 0

   	#测试
   	@@debug_num = 0
   	def getRelationData(path)
   		
   		tmp_href_data = [ ]
   		tmp_content_data = [ ]

   		if(@@get_times > 2)
   				puts "数据量过大，超过预估值。"
     		 		return false
		end
   		request = "GET #{path} HTTP/1.0\r\n\r\n"
		socket = TCPSocket.open(@@host, @@port)  
		socket.print(request)               
		response = socket.read        
		headers,body = response.split("\r\n\r\n", 2)
		socket.close

		puts @@relation_word.length
		@@debug_num +=1
   		puts "get number"+"#{@@debug_num }"

		html_doc = Nokogiri::HTML(body)
  
  		html_doc.xpath("//th//a/@href").each do |link|
     		 	tmp_href_data << link
   		end 
   		html_doc.xpath("//th//a").each do |link|
     		 	
     		 	tmp_content_data << link.content
   		end 
   		@@get_times += 1
   		puts tmp_content_data
   		#去掉相同的关键字
   		tmp_href_data = tmp_href_data -  (@@path & tmp_href_data)
   		tmp_content_data = tmp_content_data - (@@relation_word & tmp_content_data)
   		puts 52
   		puts tmp_content_data
   		tmp_href_data.each do |f|
   			getRelationData(f)
   		end
   		@@path << tmp_href_data
   		@@relation_word << tmp_content_data 
   		puts @@relation_word
   				                        
   	end 
   	def puts_data
   		puts @@relation_word
   	end

   	def insert_data
   		
   		client = Mysql2::Client.new(:host => "localhost", :username => "root",:password=> "xiaofu",:database=> "dragon_db")
   		for i in 0...@@relation_word.length
   			client.query("insert into baidukeywords values(NULL, '#{@@relation_word[i]}','#{@@path[i]}')")
   		end
   	end
   end


  $path = "/s?wd=science%E6%9D%82%E5%BF%97&amp;rsp=0&amp;f=1&amp;oq=science&amp;ie=utf-8&amp;usm=2&amp;rsv_idx=1&amp;rsv_pq=8eeb11ea00018f6d&amp;rsv_t=6ce1kgB8VSjlUXBlseZ5o5d9e1VwsVjp8ZXqxSIWOHng8HWkMJAkSN%2BrWis&amp;rsv_ers=xn1&amp;rs_src=0&amp;rsv_pq=8eeb11ea00018f6d&amp;rsv_t=6ce1kgB8VSjlUXBlseZ5o5d9e1VwsVjp8ZXqxSIWOHng8HWkMJAkSN%2BrWis"
  science_data =  Getbaidu.new
  science_data.getRelationData($path)
  #science_data.insert_data

  #client = Mysql2::Client.new(:host => "localhost", :username => "root",:password=> "xiaofu",:database=> "dragon_db")
  
 #new_science_data = client.query("insert into baidukeywords values(NULL, 'science12233','/s?w2BrWis')")
 #results = client.query("SELECT * FROM baidukeywords ")
 #results.each do |row|
 #	puts row["relationword"]
 #end