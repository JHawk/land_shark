namespace :development do
  namespace :db do
    desc 'rebuild dev db'

    task :boom =>
      [
        :'db:drop',
        :'db:create',
        :'db:migrate',
        :'db:seed'
      ]
    end
end

