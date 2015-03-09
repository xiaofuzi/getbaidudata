require 'socket'
require 'nokogiri'
require 'mysql2'

   class Getbaidu
       def initialize(host, port, path, search_word)
            @host = host
            @port = port
            @path = [path]
            @search_word = search_word
            @path_content = []
            @path_title = []
            @path_domain = []
       end

   def get_path_length
            @path.size
       end

    def get_relation_data
              tmp_href_data = []
              tmp_content_data = []
               
               puts "当前已抓取到#{@path.size}个相关关键词"    
              @path.each do |f|
                    puts "当前正在抓取#{tmp_content_data.size}个相关词条数目"
                    request = "GET #{f} HTTP/1.0\r\n\r\n"
          socket = TCPSocket.open(@host, @port)  
          socket.print(request)               
          response = socket.read        
          headers,body = response.split("\r\n\r\n", 2)
          socket.close
                   
          html_doc = Nokogiri::HTML(body)
  
            html_doc.xpath("//th//a/@href").each do |link|
                     tmp_href_data << link
             end 
            html_doc.xpath("//th//a").each do |link|
                 tmp_content_data << link.content
             end 
      end
      #去掉相同的关键字
      tmp_href_data = tmp_href_data -  (@path & tmp_href_data)
      tmp_content_data = tmp_content_data - (@path_content & tmp_content_data)          
      
              @path  += tmp_href_data
      @path_content += tmp_content_data 
    end
   
     #将数据保存到数据库中
    def set_data_todb
      #相关词存储
      client = Mysql2::Client.new(:host => "localhost", :username => "root",:password=> "xiaofu",:database=> "dragon_db")
      for i in 0...@path.size do
        client.query("insert into baidukeywords values(#{i+10000}, '#{@path_content[i]}','#{@path[i]}')")
      end
    end
　  def output
           puts "#{@path_content}"
       end
end


$host = 'www.baidu.com'
$port = 80
$path = "/s?wd=science%E6%9D%82%E5%BF%97&amp;rsp=0&amp;f=1&amp;oq=science&amp;ie=utf-8&amp;usm=2&amp;rsv_idx=1&amp;rsv_pq=8eeb11ea00018f6d&amp;rsv_t=6ce1kgB8VSjlUXBlseZ5o5d9e1VwsVjp8ZXqxSIWOHng8HWkMJAkSN%2BrWis&amp;rsv_ers=xn1&amp;rs_src=0&amp;rsv_pq=8eeb11ea00018f6d&amp;rsv_t=6ce1kgB8VSjlUXBlseZ5o5d9e1VwsVjp8ZXqxSIWOHng8HWkMJAkSN%2BrWis" 
$search_word = [ "science" ]

  science_data =  Getbaidu.new($host, $port, $path, $search_word)
  loop do 
    n_path = science_data.get_path_length
    #最后所得关键字词数可能会大于下面判断语句的数
       if   n_path < 50
            #puts n_path
            science_data.get_relation_data
      else
            break
      end
  end
  science_data.output
  science_data.set_data_todb

  #science_data.getRelationData
  #science_data.puts_data
  #science_data.get_all_data

  #client = Mysql2::Client.new(:host => "localhost", :username => "root",:password=> "xiaofu",:database=> "dragon_db")
  
 #new_science_data = client.query("insert into baidukeywords values(NULL, 'science12233','/s?w2BrWis')")
 #results = client.query("SELECT * FROM baidukeywords ")
 #results.each do |row|
 #	puts row["relationword"]
 #end