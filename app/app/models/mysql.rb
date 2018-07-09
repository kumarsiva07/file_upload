
require 'mysql2'

module Mysql
  class Base

    def initialize(h)
      h.each {|k,v| public_send("#{k}=",v)}
    end


    def query(sql)
      Record.do_sql do |conn|
        conn.query(sql)
      end
    end

    def self.query(sql)
    Record.do_sql do |conn|
      conn.query(sql)
    end
  end

    def execute(sql)
      Record.do_sql do |conn|
        begin
          conn.query('begin')
          conn.query(sql)
          conn.last_id
        ensure
          conn.query('commit')
        end
      end
    end

  end

  class Record

    attr_accessor :connection_pool

    def initialize
      @connection_pool = []
      DatabaseConfig['pool'].times {
        client = Mysql2::Client.new(:host => DatabaseConfig['host'] || 'localhost', :username => DatabaseConfig['username'], :password => DatabaseConfig['password'], :database => DatabaseConfig['database'])
        @connection_pool.push(client)
      }
      ActiveRecord::Base.establish_connection
    end

    @@instance = Record.new

    def self.do_sql()
      # synchronize do
      begin
        conn = @@instance.connection_pool.pop
        yield(conn)
      ensure
        @@instance.connection_pool.push(conn)
      end
      # end
    end

    private_class_method :new
  end
end

