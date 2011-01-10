module Mongify
  #
  # Actually runs the translation from sql to no sql
  #
  class Translation
    module Printer
      def print
        ''.tap do |output|
          @tables.each do |t|
            output << %Q[table "#{t.name}" do\n]
              t.columns.each do |c|
                output << "\t#{c.to_print}\n"
              end
            output << "end\n\n"
          end
        end
      end
    end
  end
end