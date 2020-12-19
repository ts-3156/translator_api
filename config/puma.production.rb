environment 'production'

dir = Dir.pwd

threads 2, 2
# daemonize true
pidfile "#{dir}/tmp/pids/puma.pid"
state_path "#{dir}/tmp/pids/puma.state"
bind 'unix:///var/translator/tmp/puma.sock'
stdout_redirect "#{dir}/log/puma.log", "#{dir}/log/puma.log", true
