class MatchGroup < ApplicationRecord
    has_many :summoner_match_groups
    has_many :summoners, :through => :summoner_match_groups

    before_create :set_uuid

    def set_uuid
        self.uuid = SecureRandom.uuid unless self.uuid.present?
    end
end
