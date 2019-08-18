require_relative('../db/sql_runner')

class Screening

  attr_reader :id
  attr_accessor :screening_time, :capacity, :film_id

  def initialize( options )
    @id = options['id'] if options['id']
    @screening_time = options['screening_time']
    @capacity = options['capacity'].to_i
    @film_id = options['film_id'].to_i
  end


  def save()
    sql = "INSERT INTO screenings (film_id, screening_time, capacity) VALUES ($1, $2, $3) RETURNING id"
    values = [@film_id, @screening_time, @capacity]
    ticket = SqlRunner.run(sql, values)[0]
    @id = ticket['id'].to_i
  end
end
