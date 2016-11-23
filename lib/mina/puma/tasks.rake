require 'mina/bundler'
require 'mina/rails'

namespace :puma do
  set :web_server, :puma

  set :puma_role,      -> { user }
  set :puma_env,       -> { fetch(:rails_env, 'production') }
  set :puma_config,    -> { "#{fetch(:shared_path)}/config/puma.rb" }
  set :puma_socket,    -> { "#{fetch(:shared_path)}/tmp/sockets/puma.sock" }
  set :puma_state,     -> { "#{fetch(:shared_path)}/tmp/sockets/puma.state" }
  set :puma_pid,       -> { "#{fetch(:shared_path)}/tmp/pids/puma.pid" }
  set :puma_cmd,       -> { "#{fetch(:bundle_prefix)} puma" }
  set :pumactl_cmd,    -> { "#{fetch(:bundle_prefix)} pumactl" }
  set :pumactl_socket, -> { "#{fetch(:shared_path)}/tmp/sockets/pumactl.sock" }

  desc 'Start puma'
  task :start => :environment do
    puma_port_option = "-p #{fetch(:puma_port)}" if set?(:puma_port)

    comment "Starting Puma..."
    command %[
      if [ -e '#{fetch(:pumactl_socket)}' ]; then
        echo 'Puma is already running!';
      else
        if [ -e '#{fetch(:puma_config)}' ]; then
          cd #{fetch(:current_path)} && #{fetch(:puma_cmd)} -q -d -e #{fetch(:puma_env)} -C #{fetch(:puma_config)}
        else
          cd #{fetch(:current_path)} && #{fetch(:puma_cmd)} -q -d -e #{fetch(:puma_env)} -b 'unix://#{fetch(:puma_socket)}' #{puma_port_option} -S #{fetch(:puma_state)} --pidfile #{fetch(:puma_pid)} --control 'unix://#{fetch(:pumactl_socket)}'
        fi
      fi
    ]
  end

  desc 'Stop puma'
  task stop: :environment do
    comment "Stopping Puma..."
    pumactl_command 'stop'
    command %[rm -f '#{fetch(:pumactl_socket)}']
  end

  desc 'Restart puma'
  task restart: :environment do
    comment "Restart Puma...."
    pumactl_command 'restart'
  end

  desc 'Restart puma (phased restart)'
  task phased_restart: :environment do
    comment "Restart Puma -- phased..."
    pumactl_command 'phased-restart'
  end

  desc 'Restart puma (hard restart)'
  task hard_restart: :environment do
    comment "Restart Puma -- hard..."
    invoke 'puma:stop'
    invoke 'puma:start'
  end
  
  desc 'Get status of puma'
  task status: :environment do
    comment "Puma status..."
    pumactl_command 'status'
  end

  def pumactl_command(command)
    cmd =  %{
      if [ -e '#{fetch(:pumactl_socket)}' ]; then
        if [ -e '#{fetch(:puma_config)}' ]; then
          cd #{fetch(:current_path)} && #{fetch(:pumactl_cmd)} -F #{fetch(:puma_config)} #{command}
        else
          cd #{fetch(:current_path)} && #{fetch(:pumactl_cmd)} -S #{fetch(:puma_state)} -C 'unix://#{fetch(:pumactl_socket)}' --pidfile #{fetch(:puma_pid)} #{command}
        fi
      else
        echo 'Puma is not running!';
      fi
    }
    if set?(:puma_debug)
      comment "Running command:\n#{cmd}"
    end
    command cmd
  end
end
