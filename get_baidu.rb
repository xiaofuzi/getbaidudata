require 'socket'
require 'nokogiri'
require 'mysql2'

   class Getbaidu
       def initialize(host, port, path, search_word)
            @host = host
            @port = port
            @path = [path]
            @search_word = search_word
            @path_content = [@search_word]
            @path_title = []
            @path_domain = []
            @table_keywords = 0
            @table_titles =0
            @threads = []
       end

       def get_path_length
            @path.size
       end

    def get_relation_data
               puts "当前已抓取到#{@path.size}个相关关键词链接"
               puts "当前已抓取到的关键词#{@path_content.size}"    
              @path.each do |f|
                    tmp_href_data = []
                    tmp_content_data = []

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
                                  tmp_content_data<< link.content
                            end 

                       #去掉相同的关键字
                       #tmp_href_data = tmp_href_data -  (@path & tmp_href_data)
                       #tmp_content_data = tmp_content_data - (@path_content & tmp_content_data)          
                       
                       
                       @path  += tmp_href_data
                       @path_content += tmp_content_data 
                       if @path.size > 50
                        puts "当前所抓取的总数目为#{@path.size}"
                        return true
                      end
            end
    end
   
     #将数据保存到数据库中
    def set_data_todb
      #相关词存储
      client = Mysql2::Client.new(:host => "localhost", :username => "root",:password=> "xiaofu",:database=> "dragon_db")
      @table_keywords = @path.size
      for i in 0...@path.size do
        client.query("insert into baidukeywords values(#{i+10000}, '#{@path_content[i]}','#{@path[i]}')")
      end
    end

    #get and set the title domian
    def attr_title_domian
      client = Mysql2::Client.new(:host => "localhost", :username => "root",:password=> "xiaofu",:database=> "dragon_db")
      tmp_title = []
      tmp_domain = []
      results = client.query("SELECT * FROM baidukeywords ")
      results.each do |f|
              puts ".............................................................................................................."
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
                tmp_title << f.children.text
              end
              puts "#{tmp_title}"
              html_doc.css("div.f13 span.g").each do |f|
                tmp_domain << f.children.text
              end
       end
       @path_title += tmp_title.join(",")
       @path_domain  += tmp_domain.join(",")
       
       @table_titles = @path_title.size
       for i in 0...@path_title.size do
        client.query("insert into title_domains values(#{i+10000}, '#{@path_title[i]}','#{@path_domain[i]}')")
      end
    end

    def is_getting_right
      if @table_keywords == @table_titles
        return true
      else
        return false
      end
    end

    def reset_table
      #再次存入数据库前请重置数据库，否则会有ＩＤ冲突
      client = Mysql2::Client.new(:host => "localhost", :username => "root",:password=> "xiaofu",:database=> "dragon_db")
      client.query("delete from baidukeywords")
      client.query("delete from title_domains")
    end
      
      def output
           puts "#{@path_content}"
       end
       def get_content
        @path_content
      end
end


$host = 'www.baidu.com'
$port = 80
$path = "/s?wd=science%E6%9D%82%E5%BF%97&amp;rsp=0&amp;f=1&amp;oq=science&amp;ie=utf-8&amp;usm=2&amp;rsv_idx=1&amp;rsv_pq=8eeb11ea00018f6d&amp;rsv_t=6ce1kgB8VSjlUXBlseZ5o5d9e1VwsVjp8ZXqxSIWOHng8HWkMJAkSN%2BrWis&amp;rsv_ers=xn1&amp;rs_src=0&amp;rsv_pq=8eeb11ea00018f6d&amp;rsv_t=6ce1kgB8VSjlUXBlseZ5o5d9e1VwsVjp8ZXqxSIWOHng8HWkMJAkSN%2BrWis" 
$search_word =  "science" 

  science_data =  Getbaidu.new($host, $port, $path, $search_word)
  science_data.reset_table
  loop do 
    n_path = science_data.get_path_length
    
    #最后所得关键字词数可能会大于下面判断语句的数
       if   n_path < 50
            science_data.get_relation_data
      else
            break
      end
  end

  science_data.set_data_todb
  science_data.attr_title_domian
  science_data.output