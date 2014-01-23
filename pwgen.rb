require "openssl"
require "securerandom"
require 'optparse'
require 'io/console'

options = {}

optparse = OptionParser.new do|opts|

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end


  options[:bits_entropy] = 64
  opts.on( '-b', '--bits NUM', "Number of bits entropy (default: 64, >32 is ok, >64 is good)" ) do |u|
    options[:bits_entropy] = u.to_i
    if u.to_i < 32
      puts "Don't do that - its unsecure, but ok whatever you want"
    end
    if u.to_i <= 16
      puts "Sorry thats just stupid"
      exit
    end
  end

  options[:static] = false
  opts.on( '-s', '--static USE', "Generate password deterministically from master password for the given usecase" ) do |u|
    options[:static] = true
    options[:salt] = u
  end

  opts.on( '-f', '--file FILE', "Generate password deterministically from filecontet (better to read aloud then hexdigests)" ) do |u|
    options[:static] = true
    options[:salt] = OpenSSL::Digest::SHA256.hexdigest(File.read(u))
    options[:bits_entropy] = 256
    options[:password] = "NoNeedForAPasswordForFiles"
  end

  options[:wordlist] = "wordlist.txt"
  opts.on( '-w', '--wordlist FILE', "Wordlist used for generation (default: wordlist.txt)" ) do |f|
    options[:wordlist] = f
  end

  options[:display] = false
  opts.on( '-d', '--display', "Displays the password instead of puting it into xclip" ) do
    options[:display] = true
  end

  options[:clipboard] = "xclip -i"
  opts.on( '-c', '--clipboard', "The program to print the password to (default: 'xclip -i')" ) do |c|
    options[:clipboard] = c
  end
end

optparse.parse!

#read wordlist into array of words
words = File.read(options[:wordlist]).lines.to_a

#get master password blindly if needed
if options[:static] && !options[:password]
  puts "Please enter your master password:"
  options[:password] = STDIN.noecho(&:gets).strip
  puts "Thank you, I will no generate a password for the usecase #{options[:salt].inspect}"
end

iterations = 100000 # we want many iterations as to prevent bruteforce attempts
#add some more bits, since we will only use words where the number of bits remaining to choose is bigger then log2(size(wordlist)
bits_entropy = options[:bits_entropy] + words.length.to_s(2).length
#generate the hexstring of a 64 byte random value (either deterministically or from secure_random)
if options[:static]
  seed = OpenSSL::PKCS5.pbkdf2_hmac_sha1(options[:password], options[:salt], iterations, 64).bytes.map{|x| x.to_s(16).rjust(2,"0")}.join
else 
  seed = SecureRandom.hex(64)
end

# use the first few bits of this random string
pass = seed.to_i(16).to_s(2)[0..bits_entropy].to_i(2)
final_pw = ""

#choose random words until we consumed enough randomness
while pass>words.length
  wordindex = pass % words.length
  pass = pass / words.length
  final_pw += words[wordindex].strip.downcase.capitalize
end

#append a single random digit so websides shut the fuck up
final_pw+=(seed.to_i(16)%10).to_s

#finaly display the password / copy it to clipboard
if options[:display]
  puts final_pw
else
  IO.popen(options[:clipboard],"w"){|p| p.print final_pw}
end
