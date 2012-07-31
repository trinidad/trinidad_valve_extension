require 'trinidad_valve_extension'

# alternative extension name so we can configure as:
# ---
#   trap: false
#   extensions:
#     valves:
#       AccessLogValve:
#         directory: logs
#         suffix: .log
#       crawler_session_manager_valve:
#         sessionInactiveInterval: 42
#
module Trinidad
  module Extensions
    ValvesWebAppExtension = ValveWebAppExtension
  end
end