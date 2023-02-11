def eighties_b_movies
  # List all the movies from 1980-1989 with scores falling between 3 and 5
  # (inclusive). Show the id, title, year, and score.
  Movie
    .select("id, title, yr, score")
    .where("yr BETWEEN 1980 AND 1989 AND score BETWEEN 3 AND 5")
end

def bad_years
  # List the years in which no movie with a rating above 8 was released.
  Movie
    # .select(:yr)
    .where("yr NOT IN (:good_years)", good_years: Movie.select(:yr)
    .group(:yr)
    .where("score > 8")).distinct.pluck(:yr)
end

def cast_list(title)
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord). Show the actor id and name.
  Actor
    .select("actors.id, actors.name")
    .joins(:movies).where("movies.title = (?)", title)
    .order("castings.ord")
end

def vanity_projects
  # List the title of all movies in which the director also appeared as the
  # starring actor. Show the movie id, title, and director's name.

  # Note: Directors appear in the 'actors' table.
  Movie
    .joins("JOIN castings AS c ON c.movie_id = movies.id AND c.actor_id = movies.director_id")
    .joins("JOIN actors ON actors.id = movies.director_id")
    .where("c.ord = 1")
    .select("movies.id, movies.title, actors.name")
end

def most_supportive
  # Find the two actors with the largest number of non-starring roles.
  # Show each actor's id, name, and number of supporting roles.
  Casting
    .joins(:actor)
    .select("actors.id, actors.name, COUNT(actors.id) AS roles")
    .where("ord != 1")
    .group("actors.id")
    .order("roles DESC")
    .limit(2)
end