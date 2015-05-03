require 'capistrano/scm'
require 'capistrano/git'
class Capistrano::Git < Capistrano::SCM
  module SubmoduleStrategy
    include DefaultStrategy

    def release
      context.execute :rm, '-rf', release_path
      git :clone, '--branch', fetch(:branch),
        '--recursive',
        '--no-hardlinks',
        repo_path, release_path
    end
  end
end