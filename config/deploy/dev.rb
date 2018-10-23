set :domain, '47.97.171.140'
set :deploy_to, '/home/deploy/ether-bridge-server'
set :branch, 'develop'
set :user, 'root'
set :rvm_use_path, '/usr/share/rvm/scripts/rvm'
set :sidekiq_pid, "#{fetch(:deploy_to)}/shared/tmp/pids/sidekiq.pid"
