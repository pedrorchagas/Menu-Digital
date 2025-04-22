require 'sqlite3'
require_relative 'objects'


$database = SQLite3::Database.new "database.db"
$database.execute <<-SQL
  CREATE TABLE IF NOT EXISTS foods (
    Unique_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    id_store TEXT NOT NULL,
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
SQL

def createFood(food)
  $database.execute("INSERT INTO foods (name, id_store) VALUES (?, ?)", [food.name, food.id])
  $database.execute <<-SQL
    CREATE TABLE products_#{food.name} (
      Unique_id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE,
      value REAL NOT NULL,
      image TEXT,
      description TEXT,
      created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  SQL

end

def listFoods()
  foods = []

  $database.execute("SELECT * FROM foods").each do | food |
    foods.push(Food.new(food[1], food[2]))
  end
  return foods
end
  
def getFood(foodName)
  food = $database.execute("SELECT * FROM foods WHERE name = '#{foodName}'")
  puts "1º  #{food}"
  food = Food.new(food[0][1], food[0][2])
  
  puts "1º  #{food.name}"
  #puts food.name.gsub(" ", "_")
  $database.execute("SELECT * FROM products_#{food.name.gsub(" ", "_")}").each do | productSQL |
    product = Item.new(productSQL[1], productSQL[2])
    product.setImage(productSQL[3])
    product.setDescription(productSQL[4])

    food.addItem(product)
  end

  return food
end

def addProduct(food, product)
  $database.execute("INSERT INTO products_#{food.name.gsub(" ", "_")} (name, value, image, description) VALUES (?, ?, ?, ?)", [product.name, product.value, product.image, product.description])
end

def listProducts(foodName)
  foodName.gsub!(" ", "_")
  products = []
  $database.execute("SELECT * FROM products_#{foodName}").each do | productSQL |
    product = Item.new(productSQL[1], productSQL[2])
    product.setImage(productSQL[3])
    product.setDescription(productSQL[4])

    products.push(product)
  end
  return products
end

def getAll()
  foods = []

  $database.execute("SELECT * FROM foods").each do | food |
    food = Food.new(food[1], food[2])

    $database.execute("SELECT * FROM products_#{food.name.gsub(" ", "_")}").each do | productSQL |
      product = Item.new(productSQL[1], productSQL[2])
      product.setImage(productSQL[3])
      product.setDescription(productSQL[4])

      food.addItem(product)
    end
    foods.push(food)
  end
  return foods
end