require File.expand_path('test_helper', File.dirname(__FILE__))
require 'yaml'

module Trinidad
  module Extensions
    class ValveWebAppExtensionTest < Test::Unit::TestCase

      APP_DIR = File.expand_path('app', File.dirname(__FILE__))
      
      test "configures specified valves" do
        options = YAML.load( File.read(File.join(APP_DIR, 'trinidad.yml')) )
        Trinidad.configure!(options)
        web_app = create_web_app; context = create_web_app_context(web_app)
        
        Trinidad::Extensions.configure_webapp_extensions(web_app.extensions, tomcat, context)
        
        assert_not_nil context.pipeline
        assert_not_nil context.pipeline.valves
        valves = context.pipeline.valves.to_a
        
        assert_equal 3, valves.size, valves.map { |v| v.toString }.inspect
        assert_instance_of org.apache.catalina.valves.AccessLogValve, valves[0], valves[0].class.name
        assert_equal '.xxx', valves[0].getSuffix
        assert_equal 'xxx_access', valves[0].getPrefix
        assert_equal 'log', valves[0].getDirectory
        assert_instance_of org.apache.catalina.valves.CrawlerSessionManagerValve, valves[1], valves[1].class.name
        assert_equal 42, valves[1].getSessionInactiveInterval
      end
      
      test "configures alternatively with className resolved from keys" do
        options = YAML.load( File.read(File.join(APP_DIR, 'trinidad-alt.yml')) )
        Trinidad.configure!(options)
        web_app = create_web_app; context = create_web_app_context(web_app)
        
        Trinidad::Extensions.configure_webapp_extensions(web_app.extensions, tomcat, context)
        
        assert_not_nil context.pipeline
        assert_not_nil context.pipeline.valves
        valves = context.pipeline.valves.to_a
        
        assert_equal 4, valves.size, valves.map { |v| v.toString }.inspect
        assert_instance_of org.apache.catalina.valves.AccessLogValve, valves[0], valves[0].class.name
        assert_equal '.log', valves[0].getSuffix
        assert_equal 'logs', valves[0].getDirectory
        assert_instance_of org.apache.catalina.valves.CrawlerSessionManagerValve, valves[1], valves[1].class.name
        assert_instance_of org.apache.catalina.valves.RemoteAddrValve, valves[2], valves[2].class.name
        assert_equal "127\\.0\\.0\\.1", valves[2].getAllow
      end
      
      private

      def tomcat
        @tomcat ||= org.apache.catalina.startup.Tomcat.new
      end
      
      def create_web_app(config = {})
        Trinidad::WebApp.create({ 
            :context_path => '/',  :web_app_dir => APP_DIR 
          }.merge(config)
        )
      end

      def create_web_app_context(context_dir = APP_DIR, web_app_or_context_path = '/')
        context_path, lifecycle = web_app_or_context_path, nil
        if web_app_or_context_path.is_a?(Trinidad::WebApp)
          context_path = web_app_or_context_path.context_path
          lifecycle = web_app_or_context_path.define_lifecycle
        end
        context = tomcat.addWebapp(context_path, context_dir.to_s)
        context_config = org.apache.catalina.startup.ContextConfig.new
        context.addLifecycleListener context_config
        context.addLifecycleListener lifecycle if lifecycle
        context
      end
      
    end
  end
end