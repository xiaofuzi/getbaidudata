class Yang
	@@num = 1
	def pop
		
		puts "yang"
		@@num +=1
		5.times do
			
			pop
		end
	end
end

my = Yang.new
my.pop