require File.join(File.dirname(File.expand_path(__FILE__)), 'base_config')

module Mongify
  module Database
    #
    # Sql connection configuration
    #
    class SqlConfig < Mongify::Database::BaseConfig

      REQUIRED_FIELDS = %w{host adapter database}

      def setup_connection_adapter
        @connection_adapter ||= ActiveRecord::Base.establish_connection(self.to_hash) unless sqlite_adapter?
      end

      def valid?
        return false unless @adapter
        case @adapter
        when 'sqlite'
          return true if @database
        else
          return super
        end
        false
      end

      def get_tables
        return nil unless has_connection?
        ActiveRecord::Base.connection.tables
      end

      def columns_for(table_name)
        ActiveRecord::Base.connection.columns(table_name)
      end

      def has_connection?
        begin
          setup_connection_adapter
          ActiveRecord::Base.connection.send(:connect) if ActiveRecord::Base.connection.respond_to?(:connect)
        rescue ActiveRecord::ConnectionNotEstablished => e
          puts "Error: #{e}"
          return false
        end
        true
      end

      #######
      private
      #######
      def sqlite_adapter?
        @adapter && @adapter.downcase == 'sqlite'
      end
    end
  end
end