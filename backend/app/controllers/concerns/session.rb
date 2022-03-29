module Session
    TOKEN = "a946509e05d5a39bb957a9a5b824b15aeda3d2d46ca475288ab63d3eea3265a6940561962c0a2e91a5e2eb5e57a58df32a5d33157ce567327a874751640eee19"
    def self.create
      return TOKEN
    end

    def self.get(token)
      if token === TOKEN
        return {token:TOKEN}
      end
    end
end