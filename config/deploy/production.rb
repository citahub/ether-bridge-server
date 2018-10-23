set :domain, '47.96.73.126'
set :deploy_to, '/home/cita/ether-bridge-server'
set :branch, 'master'
set :user, 'cita'
set :sidekiq_pid, "#{fetch(:deploy_to)}/shared/tmp/pids/sidekiq.pid"
