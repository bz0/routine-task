module Session
    def self.create
      if ENV.key?('API_TOKEN')
        return ENV['API_TOKEN']
      end
    end

    def self.get(token)
      unless ENV.key?('API_TOKEN')
        return 
      end

      if token == ENV['API_TOKEN']
        return {token:ENV['API_TOKEN']}
      end
    end
end