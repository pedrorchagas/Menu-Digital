require 'redis'
require 'securerandom'
require 'dotenv'

Dotenv.load

#docker pull redis/redis-stack-server:latest
#docker run -d --name redis-stack-server -p 6379:6379 redis/redis-stack-server:latest
# docker start redis-stack-server <- para iniciar o redis caso ele não tenha iniciado
production = ENV['PRODUCTION'].to_s.downcase == 'true'
if production
  $redis = Redis.new(host: "localhost", port: 6379)
else
  $redis = Redis.new(host: "redis", port: 6379)
end


def create_session(ip)
  uuid = SecureRandom.uuid
  $redis.set(uuid.to_s, ip.to_s)
  return uuid
end

def validate_session(uuid, ip)
  unless uuid.nil?
    stored_ip = $redis.get(uuid)
    puts "CLASS: #{stored_ip.class}"
    unless stored_ip.nil?
      if stored_ip == ip
        # logado
        return true
      else
        # não logado ou expirado
        return false
      end
    else
      # UUID não encontrado
      return false
    end
  else
    return false
  end
end

def clean_redis
  $redis.flushall
end