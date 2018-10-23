set :domain, '47.99.40.201'
set :deploy_to, '/home/cita/ether-bridge-server'
set :branch, 'release'
set :user, 'cita'
set :sidekiq_pid, "#{fetch(:deploy_to)}/shared/tmp/pids/sidekiq.pid"
