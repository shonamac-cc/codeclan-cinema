require_relative('../db/sql_runner')

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  def save()
    sql = " INSERT INTO customers (
    name,
    funds
    )
    VALUES ($1, $2)
    RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values)[0]
    @id = customer['id'].to_i
  end

  def update()
    sql = " UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    result = customers.map{ |customer| Customer.new( customer )}
    return result
  end

  def self.delete_all
    sql = "DELETE FROM customers"
    values = []
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.* FROM films
    INNER JOIN tickets ON films.id = tickets.film_id
    WHERE customer_id = $1"
    values = [@id]
    film_data = SqlRunner.run(sql, values)
    films = film_data.map{ |film_data| Customer.new(film_data)}
    return films
  end

  def film_count()
    sql = "SELECT films.* FROM films
    INNER JOIN tickets ON films.id = tickets.film_id
    WHERE customer_id = $1"
    values = [@id]
    film_data = SqlRunner.run(sql, values)
    films = film_data.map{ |film_data| Customer.new(film_data)}
    return films.count
  end

end
