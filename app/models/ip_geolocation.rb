class IpGeolocation < ApplicationRecord
  validates :ip_address, presence: {
      message: "must be present!" 
    }, uniqueness: {
      case_sensitive: false,
      message: "is already present in the database"
    }
end
