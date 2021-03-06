require "guard/espect/inspectors/simple_inspector.rb"
require "guard/espect/inspectors/keeping_inspector.rb"
require "guard/espect/inspectors/focused_inspector.rb"

module Guard
  class Espect < Plugin
    module Inspectors
      class Factory
        class << self
          def create(options = {})
            case options[:failed_mode]
            when :focus  then FocusedInspector.new(options)
            when :keep   then KeepingInspector.new(options)
            else; SimpleInspector.new(options)
            end
          end

          private :new
        end
      end
    end
  end
end
