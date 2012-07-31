module Trinidad
  module Extensions
    class ValveWebAppExtension < WebAppExtension

      def configure(tomcat, context)
        @logger = context.logger
        
        if @options.has_key?(:valves) # 'old' syntax
          valves = (@options[:valves] ||= Array.new)
        else
          valves = @options
        end

        unless valves.empty?
          valves.each do |name, properties| # Hash or Array
            if properties.nil? && name.is_a?(Hash)
              properties, name = name, nil
            end
            properties = properties ? properties.dup : {}
            class_name = properties.delete(:className) || name

            unless class_name
              logger.warn "Valve defined without a 'className' attribute, " + 
                          "skipping valve definition: #{properties.inspect}"
              next
            end

            begin
              valve = get_valve(class_name.to_s)
            rescue NameError => e
              @logger.warn "Valve '#{class_name}' not found (#{e.message}), " + 
                           "ensure valve class is in your class-path"
              next
            end

            set_valve_properties(valve, properties)

            # Add the valve to the context using the suggested getPipeline()
            context.pipeline.add_valve(valve)
          end
        end
      end

      protected
      
      def get_valve(valve_name)
        class_name = valve_name.index('.') ? valve_name : camelize(valve_name)
        begin
          valve_class = Java::JavaClass.for_name(class_name)
        rescue NameError => e
          if class_name.index('.').nil?
            class_name = "org.apache.catalina.valves.#{class_name}"
            valve_class = Java::JavaClass.for_name(class_name)
          else
            raise e
          end
        end
        valve_class.constructor.new_instance.to_java
      end

      def set_valve_properties(valve_instance, properties)
        properties.each do |option, value|
          value = replace_properties(value) if value.is_a?(String)
          begin
            valve_instance.send("#{option}=", value)
          rescue TypeError => e
            @logger.warn "Incorrect type passed for property '#{option}' on valve " + 
                "'#{valve_instance.java_class}' (#{e.message}), skipping property"
          rescue NoMethodError => e
            @logger.warn "Not settable property '#{option}' found on valve " + 
                "'#{valve_instance.java_class}', skipping property"
          end
        end
      end

      private
      
      def camelize(string)
        string = string.sub(/^[a-z\d]*/) { $&.capitalize }
        string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
        string
      end
      
      java_import 'org.apache.tomcat.util.IntrospectionUtils'
      
      def replace_properties(text)
        IntrospectionUtils.replace_properties(text, java.lang.System.getProperties, nil)
      end
      
    end
  end
end
