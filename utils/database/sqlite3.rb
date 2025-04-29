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

$database.execute <<-SQL
  CREATE TABLE IF NOT EXISTS drinks (
    Unique_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    value REAL NOT NULL,
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
SQL

$database.execute <<-SQL
  CREATE TABLE IF NOT EXISTS toys (
    Unique_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    value REAL NOT NULL,
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

def deleteFood(food_name)
  $database.execute("DROP TABLE products_#{food_name}")
  $database.execute("DELETE FROM foods WHERE name = ?", [food_name])
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
    product.setID(productSQL[0])

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

def removeProduct(food, product_id)
  $database.execute("DELETE FROM products_#{food} WHERE unique_id = ?", [product_id])
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

def getProduct(food_name, product_id) 
  data = $database.execute("SELECT * FROM products_#{food_name} WHERE unique_id = ? ", [product_id])
  product = Item.new(data[0][1], data[0][2])
  product.setImage(data[0][3])
  product.setDescription(data[0][4])
  product.setID(product_id)

  return product
end

def editProduct(food_name, product)
  puts product.name, product.value, product.description, product.image, product.id
  $database.execute("UPDATE products_#{food_name} SET name = ?, value = ?, description = ?, image = ? WHERE unique_id = ?", [product.name, product.value, product.description, product.image, product.id])
end

def getDrinks()
  drinks = []

  $database.execute("SELECT * FROM drinks").each do | drink |
    item = Item.new(drink[1], drink[2])
    item.setID(drink[0])

    drinks.push(item)
  end
  return drinks
end

def addDrink(name, value)
  $database.execute("INSERT INTO drinks (name, value) VALUES (?, ?)", [name, value])
end

def removeDrink(id)
  $database.execute("DELETE FROM drinks WHERE unique_id = ?", [id])
end

def getToys()
  toys = []

  $database.execute("SELECT * FROM toys").each do | toy |
    item = Item.new(toy[1], toy[2])
    item.setID(toy[0])

    toys.push(item)
  end
  return toys
end

def addToy(name, value)
  $database.execute("INSERT INTO toys (name, value) VALUES (?, ?)", [name, value])
end

def removeToy(id)
  $database.execute("DELETE FROM toys WHERE unique_id = ?", [id])
end