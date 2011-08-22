module Trinidad
  module Extensions
    module Valve
      VERSION = '0.4'
    end

    class ValveWebAppExtension < WebAppExtension
      def configure(tomcat, app_context)
        @logger = app_context.logger

        @options[:valves] ||= Array.new

        if not @options[:valves].empty?
          @options[:valves].each do |valve_properties|
            valve_properties = valve_properties.clone
            class_name = valve_properties.delete 'className'

            if not class_name
              @logger.warn("Tomcat valve defined without a 'className' attribute.  Skipping valve definition: '#{valve_properties.inspect}'")
              next
            end

            begin
              valve = get_valve(class_name)
            rescue NameError => e
              @logger.warn("Tomcat valve '#{class_name}' not found.  Ensure valve exists in your classpath")
              next
            end

            set_valve_properties(valve, valve_properties)

            # Add the valve to the context using the suggested getPipeline()
            app_context.pipeline.add_valve(valve)
          end
        end
      end

      def get_valve(valve_name)
        valve_class = Java::JavaClass.for_name valve_name
        valve_instance = valve_class.constructor.new_instance.to_java
      end

      def set_valve_properties(valve_instance, properties)
        properties.each do |option,value|
          begin
            if value.kind_of? String
              value = replace_properties(value)
            end
          valve_instance.send("#{option}=", value)

          rescue TypeError => e
            @logger.warn("Incorrect type passed for property '#{option}' on valve '#{valve_instance.java_class}'. Skipping property")
          rescue NoMethodError => e
            @logger.warn("No settable property '#{option}' found on valve '#{valve_instance.java_class}'")
          end
        end
      end

      def replace_properties(text)
        java_import 'org.apache.tomcat.util.IntrospectionUtils'
        IntrospectionUtils.replace_properties(text, java.lang.System.getProperties(), nil)
      end
    end
  end
end
