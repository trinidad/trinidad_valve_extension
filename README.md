# Trinidad Valve Extension

This is an extension to allow Tomcat valves to be configured and attached to web
applications running under [Trinidad](https://github.com/trinidad/trinidad/).
Built-in Tomcat valves or any valve implementation accessible within the 
application's class-path can be used.

A list of built-in valves can be found at: http://tomcat.apache.org/tomcat-7.0-doc/config/valve.html

## Installation

    jruby -S gem install trinidad_valve_extension

## Configuration

This extension will configure valves from a list of hashes that contain the 
properties that configure each valve. The **'className'** key might be used to 
define what valve class is being configured, just as when configuring tomcat 
using the traditional *context.xml* file. 
Tomcat valves (from the org.apache.catalina.valves package) might be specified
simply as class name keys followed by a configuration for it's properties.
Substitutions for values referenced within **${}** will be performed with Java's
system properties.

To enable the extension, specify at least one valve configuration with *valves* 
under the *extensions* key e.g. :

```
---
  # ...
  extensions:
    valves:
      AccessLogValve: # class-name under org.apache.catalina.valves
        directory: log
      crawler_session_manager_valve: # underscored class-name
        # leave defaults
      remote_address_filter: # not a class-name since className specified
        className: org.apache.catalina.valves.RemoteAddrValve
        allow: "127\.0\.0\.1"
```

Alternatively, you can still use the traditional (old) syntax using the *valve* 
extension element with *valves* specified as an array e.g. :

```
---
  extensions:
    valve:
      valves:
        - className: org.apache.catalina.valves.AccessLogValve
          pattern:        "%h %l %u %t \"%r\" %s %b %T %S"
          directory:      "log"
          prefix:         "access_log"
          suffix:         ".log"
          fileDateFormat: ".yyyy-MM-dd"
        - className: org.apache.catalina.valves.CrawlerSessionManagerValve
          sessionInactiveInterval: 42
```

# Copyright

Copyright (c) 2011 Michael Leinartas. See LICENSE for details.
