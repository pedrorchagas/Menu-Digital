require 'dotenv'
require 'mysql2'
require_relative '../objects'

Dotenv.load

#docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=senha123 -e MYSQL_DATABASE=meubanco -e MYSQL_USER=usuario -e MYSQL_PASSWORD=senhausuario -e MYSQL_ROOT_PASSWORD=senha123 -p 3306:3306 mysql:latest

# Conexão com o banco MySQL
$database = Mysql2::Client.new(
  host: ENV['DATABASE_HOST'],
  username: ENV['DATABASE_USERNAME'],
  password: ENV['DATABASE_PASSWORD'],
  database: ENV['DATABASE_DB'],
  port: 3306,
  symbolize_keys: true
)

# Criação das tabelas principais
$database.query <<-SQL
  CREATE TABLE IF NOT EXISTS foods (
    Unique_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    id_store VARCHAR(255) NOT NULL,
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
SQL

$database.query <<-SQL
  CREATE TABLE IF NOT EXISTS drinks (
    Unique_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    value DOUBLE NOT NULL,
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
SQL

$database.query <<-SQL
  CREATE TABLE IF NOT EXISTS toys (
    Unique_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    value DOUBLE NOT NULL,
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
SQL

def createFood(food)
  $database.query("INSERT INTO foods (name, id_store) VALUES ('#{food.name}', '#{food.id}')")
  safe_table = food.name.gsub(" ", "_")

  $database.query <<-SQL
    CREATE TABLE products_#{safe_table} (
      Unique_id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(255) NOT NULL UNIQUE,
      value DOUBLE NOT NULL,
      image TEXT,
      description TEXT,
      created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  SQL
end

def deleteFood(food_name)
  safe_table = food_name.gsub(" ", "_")
  $database.query("DROP TABLE products_#{safe_table}")
  $database.query("DELETE FROM foods WHERE name = '#{food_name}'")
end

def listFoods()
  foods = []
  results = $database.query("SELECT * FROM foods")
  results.each do |food|
    foods << Food.new(food[:name], food[:id_store])
  end
  foods
end

def getFood(foodName)
  result = $database.query("SELECT * FROM foods WHERE name = '#{foodName}'").first
  food = Food.new(result[:name], result[:id_store])
  safe_table = food.name.gsub(" ", "_")

  $database.query("SELECT * FROM products_#{safe_table}").each do |row|
    product = Item.new(row[:name], row[:value])
    product.setImage(row[:image])
    product.setDescription(row[:description])
    product.setID(row[:Unique_id])
    food.addItem(product)
  end

  food
end

def addProduct(food, product)
  safe_table = food.name.gsub(" ", "_")
  $database.query("INSERT INTO products_#{safe_table} (name, value, image, description) VALUES ('#{product.name}', #{product.value}, '#{product.image}', '#{product.description}')")
end

def listProducts(foodName)
  safe_table = foodName.gsub(" ", "_")
  products = []
  $database.query("SELECT * FROM products_#{safe_table}").each do |row|
    product = Item.new(row[:name], row[:value])
    product.setImage(row[:image])
    product.setDescription(row[:description])
    products << product
  end
  products
end

def removeProduct(food_name, product_id)
  safe_table = food_name.gsub(" ", "_")
  $database.query("DELETE FROM products_#{safe_table} WHERE Unique_id = #{product_id}")
end

def getAll()
  foods = []
  $database.query("SELECT * FROM foods").each do |food_row|
    food = Food.new(food_row[:name], food_row[:id_store])
    safe_table = food.name.gsub(" ", "_")

    $database.query("SELECT * FROM products_#{safe_table}").each do |row|
      product = Item.new(row[:name], row[:value])
      product.setImage(row[:image])
      product.setDescription(row[:description])
      food.addItem(product)
    end
    foods << food
  end
  foods
end

def getProduct(food_name, product_id)
  safe_table = food_name.gsub(" ", "_")
  row = $database.query("SELECT * FROM products_#{safe_table} WHERE Unique_id = #{product_id}").first
  product = Item.new(row[:name], row[:value])
  product.setImage(row[:image])
  product.setDescription(row[:description])
  product.setID(row[:Unique_id])
  product
end

def editProduct(food_name, product)
  safe_table = food_name.gsub(" ", "_")
  $database.query("UPDATE products_#{safe_table} SET name='#{product.name}', value=#{product.value}, description='#{product.description}', image='#{product.image}' WHERE Unique_id=#{product.id}")
end

def getDrinks()
  drinks = []
  $database.query("SELECT * FROM drinks").each do |row|
    item = Item.new(row[:name], row[:value])
    item.setID(row[:Unique_id])
    drinks << item
  end
  drinks
end

def addDrink(name, value)
  $database.query("INSERT INTO drinks (name, value) VALUES ('#{name}', #{value})")
end

def removeDrink(id)
  $database.query("DELETE FROM drinks WHERE Unique_id = #{id}")
end

def getToys()
  toys = []
  $database.query("SELECT * FROM toys").each do |row|
    item = Item.new(row[:name], row[:value])
    item.setID(row[:Unique_id])
    toys << item
  end
  toys
end

def addToy(name, value)
  $database.query("INSERT INTO toys (name, value) VALUES ('#{name}', #{value})")
end

def removeToy(id)
  $database.query("DELETE FROM toys WHERE Unique_id = #{id}")
end
