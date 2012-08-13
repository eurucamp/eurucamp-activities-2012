Mongoid.logger.level = Logger::DEBUG
Moped.logger.level = Logger::DEBUG

# Mongoid.load!("./config/mongoid.yml")
Participation.create_indexes
User.create_indexes