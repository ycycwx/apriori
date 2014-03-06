#!/usr/bin/ruby

# Open file, output apriori & flatten apriori
def openFile(inputPath)
	apriori = []
	File.open(inputPath, "r") do |file|
		while line = file.gets
			result = line.chomp.split(",")
			result.collect! { |item|
				item.strip
			}
			# p result
			apriori.push(result)
		end
	end
	stat = apriori.flatten.uniq!
	# puts("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
	# p stat
	# puts("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
	return apriori, stat
end

# Get percent of each stat
def statApriori(apriori, stat)
	dict = {}
	stat.each { |item|
		cnt = 0
		item = [item] if item.size == 1
		apriori.each { |apri|
			cnt += 1 if apri.length == (apri | item).length
		}
		item = item[0] if item.size == 1
		dict[item] = cnt / apriori.length.to_f
	}
	return dict
end

# Drop key if value <= rate
def dropBranch(dict, rate)
	dict.select { |key, value|
		value > rate
	}
end

# Gain combination with key in dict
def comb(item, n)
	item = item.keys if item.class == Hash
	item = item.flatten.uniq
	item.combination(n).to_a
end

# Main phase
def apriori(inputPath, rate)
	cnt = 2
	apriori, stat = openFile(inputPath)
	# p apriori
	# p stat
	result_key = []
	result_value = []
	while TRUE
		# puts(cnt - 1)
		dict = statApriori(apriori, stat)
		# p dict
		# p dict if dict.size != 0
		if dict.size == dropBranch(dict, rate).size or dropBranch(dict, rate).size == 0
			break
		end
		dict = dropBranch(dict, rate)
		result_key += dict.keys if dict.size != 0
		result_value += dict.values if dict.size != 0
		stat = comb(dict, cnt)
		cnt += 1
	end

	(0...result_value.size).each do |i|
		puts("#{result_key[i]} => #{result_value[i]}") if result_key[i].size != 1
	end
end

if __FILE__ == $0
	inputPath = 'apriori.bak'
	rate = 0.25
	apriori(inputPath, rate)
	# p apriori
	# pen
	# p stat
end
