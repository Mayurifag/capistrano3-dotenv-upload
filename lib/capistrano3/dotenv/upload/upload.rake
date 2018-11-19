namespace :deploy do
  # TODO: append files to symlinked at stage?

  def env_file_is_okay?(file)
    # TODO: check env file content
    File.exist?(file)
  end

  def warning_env_file_not_found(file)
    info "The #{file} was not specified or not found."
  end

  def upload_env_file(file)
    to_path = "#{shared_path}/#{File.basename(file)}"
    info "deploying #{file} => #{to_path}"
    upload! file, to_path
  end

  desc "Upload .env files to remote server"
  task :dotenv_upload do
    # TODO: move to namespace load task defaults?
    # TODO: if both files are equal (have equal content) check
    env_file = fetch(:env_file, ".env")
    stage_env_file = fetch(:stage_env_file, ".env.#{fetch(:stage)}")

    on roles(:all) do
      [env_file, stage_env_file].each do |file|
        if env_file_is_okay?(file)
          upload_env_file(file)
        else
          warning_env_file_not_found(file)
        end
      end
    end
  end

  before 'deploy:symlink:shared', 'deploy:dotenv_upload'
end
