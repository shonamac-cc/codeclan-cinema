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

  def update()
    sql = " UPDATE screenings SET (film_id, screening_time, capacity) = ($1, $2, $3) WHERE id = $4"
    values = [@film_id, @screening_time, @capacity, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM screenings where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql)
    result = screenings.map{ |screening| Screening.new( screening )}
    return result
  end

  def self.delete_all
    sql = "DELETE FROM screenings"
    values = []
    SqlRunner.run(sql)
  end

end
