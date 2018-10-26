# frozen_string_literal: true

require "daemons"
require_relative "../config/environment"

options = {
  log_output: false,
  log_dir: Rails.root.join("log"),
  monitor: true,
  dir: Rails.root.join("tmp", "pids").to_s
}

# ETH To EBC
Daemons.run_proc("#{Rails.env}_eth_to_ebc_listen_transactions", options) do
  Rails.logger = Logger.new(Rails.root.join("log", "#{Rails.env}_eth_to_ebc.log"))
  loop do
    EthereumNetwork.new.listen_transactions
    sleep(10)
  end
end

Daemons.run_proc("#{Rails.env}_eth_to_ebc_process_transfers", options) do
  Rails.logger = Logger.new(Rails.root.join("log", "#{Rails.env}_eth_to_ebc.log"))
  loop do
    EthereumNetwork.new.process_transfers
    sleep(10)
  end
end

Daemons.run_proc("#{Rails.env}_eth_to_ebc_process_update_tx", options) do
  Rails.logger = Logger.new(Rails.root.join("log", "#{Rails.env}_eth_to_ebc.log"))
  loop do
    EthereumNetwork.new.process_update_tx
    sleep(10)
  end
end

# EBC To ETH
Daemons.run_proc("#{Rails.env}_ebc_to_eth_listen_event_logs", options) do
  Rails.logger = Logger.new(Rails.root.join("log", "#{Rails.env}_ebc_to_eth.log"))
  loop do
    AppChainNetwork.new.listen_event_logs
    sleep(10)
  end
end

Daemons.run_proc("#{Rails.env}_ebc_to_eth_confirm_tx", options) do
  Rails.logger = Logger.new(Rails.root.join("log", "#{Rails.env}_ebc_to_eth.log"))
  loop do
    AppChainNetwork.new.confirm_tx
    sleep(10)
  end
end

Daemons.run_proc("#{Rails.env}_ebc_to_eth_process_transfers", options) do
  Rails.logger = Logger.new(Rails.root.join("log", "#{Rails.env}_ebc_to_eth.log"))
  loop do
    AppChainNetwork.new.process_transfers
  end
end

# Daemons.run_proc("#{Rails.env}_ebc_to_eth_process_update_tx", options) do
#   Rails.logger = Logger.new(Rails.root.join("log", "#{Rails.env}_ebc_to_eth.log"))
#   loop do
#     AppChainNetwork.new.process_update_tx
#     sleep(10)
#   end
# end
