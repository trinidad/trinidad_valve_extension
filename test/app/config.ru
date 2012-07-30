 use Rack::CommonLogger
 run Proc.new { [200, {'Content-Type' => 'text/plain'}, 'OK'] }