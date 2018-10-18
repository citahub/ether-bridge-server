# frozen_string_literal: true

namespace :bg do
  desc "start bg processes"
  task start: :environment do
    puts `ruby #{Rails.root.join("lib", "bg_task_control.rb")} start`
  end

  task status: :environment do
    puts `ruby #{Rails.root.join("lib", "bg_task_control.rb")} status`
  end

  task stop: :environment do
    puts `ruby #{Rails.root.join("lib", "bg_task_control.rb")} stop`
  end

  task restart: :environment do
    puts `ruby #{Rails.root.join("lib", "bg_task_control.rb")} restart`
  end
end
