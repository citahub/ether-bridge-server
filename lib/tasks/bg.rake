# frozen_string_literal: true

namespace :bg do
  desc "start bg processes"
  task start: :environment do
    puts `ruby #{Rails.root.join("lib", "bg_task_control.rb")} start`
  end

  desc "bg processes status"
  task status: :environment do
    puts `ruby #{Rails.root.join("lib", "bg_task_control.rb")} status`
  end

  desc "stop bg processes"
  task stop: :environment do
    puts `ruby #{Rails.root.join("lib", "bg_task_control.rb")} stop`
  end

  desc "restart bg processes"
  task restart: :environment do
    puts `ruby #{Rails.root.join("lib", "bg_task_control.rb")} restart`
  end
end
