# Trinidad Valve Extension

This is an extension to allow Tomcat valves to be configured and attached to web
applications running under [Trinidad](). 
Any valve accessible within the application class-path can be used. 
Built-in Tomcat valves are available without extra dependencies. 

A list of available built-in valves can be found at: http://tomcat.apache.org/tomcat-7.0-doc/config/valve.html

## Installation

    jruby -S gem install trinidad_valve_extension

## Configuration

This extension will configure valves from a list of hashes that contain the 
properties that configure each valve. The **'className'** key is used to define 
what valve class is being configured, just as when configuring tomcat using the 
traditional *context.xml* file. 
Substitutions are done with system properties for values referenced within ${}.

To enable the extension, add a *'valve'* element under the *'extensions'* key 
(as usual) and define at least one valve. An example of an AccessLogValve:

```
---
  extensions:
    valve:
      valves:
        - className: "org.apache.catalina.valves.AccessLogValve"
          directory:      "log"
          prefix:         "access_log"
          fileDateFormat: ".yyyy-MM-dd"
          suffix:         ".log"
          pattern:        "%h %l %u %t \"%r\" %s %b %T %S"
```

# Copyright

Copyright (c) 2011 Michael Leinartas. See LICENSE for details.
