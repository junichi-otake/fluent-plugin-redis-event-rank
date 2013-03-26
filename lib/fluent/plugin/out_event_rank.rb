class Fluent::EventRankOutput < Fluent::BufferedOutput
  Fluent::Plugin.register_output('event_rank', self)

  config_param :host, :string
  config_param :port, :integer, :default => 30110
  config_param :event_id, :string
  config_param :rank_key, :string
  
  def initialize
    super
    require 'redis'
  end
  
  def configure(conf)
    super

    if @event_id.nil?
      raise Fluent::ConfigError, "event_id not found"
    end
    if @rank_key.nil?
      raise Fluent::ConfigError, "event_id not found"
    end
  end
  
  def start
    super
    @redis = Redis.new(:host => @host, :port => @port, :thread_safe => true)
  end
  
  def shutdown
    super
    @redis.quit
  end
  
  def format(tag, time, record)
    [record, record.to_msgpack].to_msgpack
  end
  
  def write(chunk)
    @redis.pipelined {
      chunk.msgpack_each { |record, data|
        @redis.set @event_id + ":" + record["id"], data
        @redis.zadd @event_id + ":" + @rank_key, record[@rank_key], record["id"]
      }
    }
  end
end
