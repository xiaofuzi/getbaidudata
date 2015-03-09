class Yang
	@@x=[]
	@@n = 0
	def initialize
		@m = []
	end
	def add()
		#puts @@x.length
		@@n += 1
		@m<< @@n
		puts "#{@m}"
		@m		
	end
	def output
		puts @@n
	end
	def changedata
		puts @@x.length
		@@x.each do |f|

			puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
			add()
		end
	end
end

yang = Yang.new
loop do
	if yang.add().size < 10
		puts yang.add().size
		yang.add()
	else
		break
	end
end
#yang.add()
#yang.output
#yang.changedata



class Customer
   @@no_of_customers=0
   
    def total_no_of_customers()
       @@no_of_customers += 1
       puts "Total number of customers: #@@no_of_customers"
    end
end

# 创建对象
cust1=Customer.new #("1", "John", "Wisdom Apartments, Ludhiya")
cust2=Customer.new #("2", "Poul", "New Empire road, Khandala")

# 调用方法
cust1.total_no_of_customers()
cust2.total_no_of_customers()