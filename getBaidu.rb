require 'socket'
require 'nokogiri'
require 'mysql2'

   class Getbaidu
   	@@host = 'www.baidu.com'
   	@@port = 80
   	@@path = ["/s?wd=science%E6%9D%82%E5%BF%97&amp;rsp=0&amp;f=1&amp;oq=science&amp;ie=utf-8&amp;usm=2&amp;rsv_idx=1&amp;rsv_pq=8eeb11ea00018f6d&amp;rsv_t=6ce1kgB8VSjlUXBlseZ5o5d9e1VwsVjp8ZXqxSIWOHng8HWkMJAkSN%2BrWis&amp;rsv_ers=xn1&amp;rs_src=0&amp;rsv_pq=8eeb11ea00018f6d&amp;rsv_t=6ce1kgB8VSjlUXBlseZ5o5d9e1VwsVjp8ZXqxSIWOHng8HWkMJAkSN%2BrWis" ]
   	@@relation_word = [ "science" ]
   	@@tmp_href_data = [ ]
   	@@tmp_content_data = [ ]

   	def getRelationData(path)
   		if(@@path.length > 10)
     		 		return true
			end
   		request = "GET #{path} HTTP/1.0\r\n\r\n"
 
		socket = TCPSocket.open(@@host, @@port)  
		socket.print(request)               
		response = socket.read              
		headers,body = response.split("\r\n\r\n", 2)

		html_doc = Nokogiri::HTML(body)
  
  		html_doc.xpath("//th//a/@href").each do |link|
     		 	
     		 	#@@path << link
     		 	@@tmp_href_data << link
   		end 
   		html_doc.xpath("//th//a").each do |link|
     		 	
     		 	#@@relation_word << link.content
     		 	@@tmp_content_data << link.content
   		end 
   		@@tmp_href_data.each do |f|
   			getRelationData(f)
   		end
   		@@path = @@path | @@tmp_href_data
   		@@relation_word = @@relation_word | @@tmp_content_data

   		@@tmp_href_data = [ ]
   		@@tmp_content_data = [ ]                           
   	end 
   	def puts_data
   		puts @@relation_word
   	end
   end
  # client = Mysql2::Client.new(:host => "localhost", :username => "root",:password=> "xiaofu")
  $path = "/s?wd=science%E6%9D%82%E5%BF%97&amp;rsp=0&amp;f=1&amp;oq=science&amp;ie=utf-8&amp;usm=2&amp;rsv_idx=1&amp;rsv_pq=8eeb11ea00018f6d&amp;rsv_t=6ce1kgB8VSjlUXBlseZ5o5d9e1VwsVjp8ZXqxSIWOHng8HWkMJAkSN%2BrWis&amp;rsv_ers=xn1&amp;rs_src=0&amp;rsv_pq=8eeb11ea00018f6d&amp;rsv_t=6ce1kgB8VSjlUXBlseZ5o5d9e1VwsVjp8ZXqxSIWOHng8HWkMJAkSN%2BrWis"
  science_data =  Getbaidu.new
  science_data.getRelationData($path)
  science_data.puts_data
