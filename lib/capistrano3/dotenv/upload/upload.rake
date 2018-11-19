namespace :deploy do
  def env_file_is_okay?(file)
    # TODO: check env file content
    File.exist?(file)
  end

  def warning_env_file_not_found(file)
    info "The #{file} was not specified or not found."
  end

  def upload_env_file(file)
    on roles(:all) do
      to_path = "#{shared_path}/#{file}"
      info "deploying #{file} => #{to_path}"
      upload! file, to_path
    end
  end

  desc "Upload .env files to remote server"
  task :dotenv_upload do
    # TODO: move to namespace load task defaults?
    env_file = fetch(:env_file, ".env")
    stage_env_file = fetch(:stage_env_file, ".env.#{fetch(:stage)}")

    # TODO: if both files are equal

    [env_file, stage_env_file].each do |file|
      # TODO: append to symlinked?
      if env_file_is_okay?(file)
    	  upload_env_file(file)
      else
        warning_env_file_not_found(file)
      end
    end
  end

  before 'deploy:symlink:shared', 'deploy:dotenv_upload'
end
