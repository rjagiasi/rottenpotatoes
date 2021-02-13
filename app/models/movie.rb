class Movie < ActiveRecord::Base
    def self.all_ratings
        return ['G','PG','PG-13','R']
    end
    
    def self.with_ratings(ratings)
        if ratings.nil?
            Movie.all
        else
            Movie.where(rating:ratings)
        end
    end
end
