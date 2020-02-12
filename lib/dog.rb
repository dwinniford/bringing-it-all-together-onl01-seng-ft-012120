class Dog 
  attr_accessor :id, :name, :breed 
  
  def initialize (id: nil, name:, breed:)
    @id = id 
    @name = name 
    @breed = breed 
  end 
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed INTEGER
      );
    SQL
    DB[:conn].execute(sql)
  end 
  
  def self.drop_table
    DB[:conn].execute("DROP TABLE dogs")
  end 
  
  def self.new_from_db(row)
    self.new(id: row[0], name: row[1], breed: row[2])
  end 
  
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE name = ?
    SQL
    row = DB[:conn].execute(sql, name)[0]
    self.new_from_db(row)
  end 
  
  def save 
    if self.id 
      self.update
    else 
      sql = <<-SQL
        INSERT INTO dogs 
        (name, breed)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self 
    end 
  end 
  
  def update 
    sql = <<-SQL
      UPDATE dogs 
      SET name = ?, breed = ?
      WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end 
    
  def self.create(name:, breed:)
    d = self.new(name:, breed:)
    d.save
  end 
    
  
  
  
end 