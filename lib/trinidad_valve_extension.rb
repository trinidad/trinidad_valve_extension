module Trinidad
  module Extensions
    module Valve
      VERSION = '0.1'
    end

    class ValveWebAppExtension < WebAppExtension
      def configure(tomcat, app_context)
        logger = app_context.getLogger()

        @options[:valves] ||= Array.new

        if not @options[:valves].empty?
          @options[:valves].each do |valve_properties|
            valve_properties = valve_properties.clone
            class_name = valve_properties.delete 'className'

            if not class_name
              logger.warn("Tomcat valve defined without a 'className' attribute.  Skipping valve definition: '#{valve_properties.inspect}'")
              next
            end

            begin
              valve = get_valve(class_name)
            rescue NameError => e
              logger.warn("Tomcat valve '#{class_name}' not found.  Ensure valve exists in your classpath")
              next
            end

            set_valve_properties(valve, valve_properties)

            # Add the valve to the context using the suggested getPipeline()
            app_context.getPipeline().addValve(valve)
          end
        end
      end

      def get_valve(valve_name)
        valve_class = Java::JavaClass.for_name "org.apache.catalina.valves.AccessLogValve"
        valve_instance = valve_class.constructor.new_instance.to_java
      end

      def set_valve_properties(valve_instance, properties)
        properties.each do |option,value|
          valve_instance.send("#{option}=", value)
        end
      end
    end
  end
end
