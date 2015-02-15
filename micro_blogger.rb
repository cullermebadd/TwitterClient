require 'jumpstart_auth'

class MicroBlogger
	attr_reader :client
	
	def initialize
		#puts "Initialize MicroBlogger"
		@client = JumpstartAuth.twitter
		@followers = @client.followers.collect {|follower| @client.user(follower).screen_name.downcase}
		puts @followers
	end
	
	def tweet(message)
	  
	  if message.length <= 140
	     @client.update(message)
	  else
	    puts "Message is longer than 140"  
	  end
	end
	
	def dm(target, message)
	  puts "trying to send #{target} the message: #{message}"
	  message = "d @#{target} #{message}"
	  puts message
	  tweet(message)
	end
	
	def spam_followers(message)
	  @followers.each { |follower|
	    dm(follower, message)
	  }
	end
	
	def isFollower(target)
	  ret = false
	  @followers.include?(target) ? ret = true : ret = false
	  return ret
	end
	
	def last_tweet()
	  friends = @client.friends
	  
	  friends.each { |friend|
	    puts friend.screen_name
	    
	    status = friend.status.text
	    puts "#{friend.screen_name}: #{status}"
	  }
	end
	
	def run
	  puts "welcome to the jsl twitter client"
	  
	  command = ""
	    
	  while command != "q"
	    printf "enter command: "
	    input = gets.chomp
	    parts = input.split
	    command = parts[0]
	    
	    case command
	    when "t" then
	      tweet(parts[1..-1].join(" "))
	    when "dm"
	      target = parts[1]
	      if isFollower(target)
	       dm(target, parts[2..-1].join(" "))
	      else
	        puts("Target is not a follower")  
	      end
	    when "spam"
	      spam_followers(parts[1..-1].join(" "))
	    when "elt"
	      last_tweet()
	    else
	      puts "Don't know that command"
	    end
	  end
	end
end

blogger = MicroBlogger.new
blogger.run
