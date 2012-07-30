module Trinidad
  module Extensions
    class ValveWebAppExtension < WebAppExtension
      
      def configure(tomcat, context)
        logger = context.logger

        valves = ( @options[:valves] ||= Array.new )

        unless valves.empty?
          valves.each do |valve_properties|
            valve_properties = valve_properties.dup
            class_name = valve_properties.delete :className

            unless class_name
              logger.warn "Tomcat valve defined without a 'className' attribute, " + 
                          "skipping valve definition: #{valve_properties.inspect}"
              next
            end

            begin
              valve = get_valve(class_name)
            rescue NameError
              logger.warn "Tomcat valve '#{class_name}' not found, " + 
                          "ensure valve class is in your class-path"
              next
            end

            set_valve_properties(valve, valve_properties)

            # Add the valve to the context using the suggested getPipeline()
            context.pipeline.add_valve(valve)
          end
        end
      end

      protected
      
      def get_valve(valve_name)
        valve_class = Java::JavaClass.for_name valve_name
        valve_class.constructor.new_instance.to_java
      end

      def set_valve_properties(valve_instance, properties)
        properties.each do |option, value|
          valve_instance.send("#{option}=", replace_properties(value))
        end
      end

      private
      
      java_import 'org.apache.tomcat.util.IntrospectionUtils'
      
      def replace_properties(text)
        return text unless text.is_a?(String) # do not suble numbers etc.
        IntrospectionUtils.replace_properties(text, java.lang.System.getProperties, nil)
      end
      
    end
  end
end
