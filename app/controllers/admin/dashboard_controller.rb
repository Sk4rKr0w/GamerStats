module Admin
  class DashboardController < ApplicationController
    before_action :require_admin

    def index
      @user_count = User.count
      @online_users = calculate_online_users
      @application_status = check_application_status
      @user_registration_times = User.pluck(:created_at)
      @last_sign_in_times = User.pluck(:last_sign_in_at)
      @user_emails = User.pluck(:email)
    end

    def shutdown
      pid_file = Rails.root.join('tmp', 'pids', 'server.pid')
      if File.exist?(pid_file)
        begin
          pid = File.read(pid_file).to_i
          Rails.logger.info "Trying to kill process with PID: #{pid}"
          puts "Trying to kill process with PID: #{pid}"
          if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
            system("taskkill /PID #{pid} /F")
          else
            system("kill -9 #{pid}")
          end
          flash[:notice] = "Application is shutting down."
        rescue => e
          Rails.logger.error "Failed to shutdown application: #{e.message}"
          flash[:alert] = "Failed to shutdown application: #{e.message}"
        end
      else
        Rails.logger.error "PID file not found at #{pid_file}"
        flash[:alert] = "PID file not found. The application might not be running."
      end
      redirect_to admin_dashboard_path
    end

    private

    def calculate_online_users
      online_users = User.where("last_sign_in_at > ?", 15.minutes.ago)
      online_users.count
    end

    def check_application_status
      if Service.status_ok?
        "Operational"
      else
        "Down"
      end
    end


    class Service
      def self.status_ok?
        # Logica per determinare lo stato dell'applicazione.
        # Potrebbe includere controlli per il database, l'API, ecc.
        database_status_ok?
      end
    
      def self.database_status_ok?
        # Logica per controllare se il database è operativo.
        ActiveRecord::Base.connection.active?
      end
    end
  end
end
