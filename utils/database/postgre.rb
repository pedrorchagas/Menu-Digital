require 'pg'
require_relative 'objects'

$database = PG.connect(
  dbname: 'meu_banco',
  user: 'pedro',
  password: 'minha_senha_segura',
  host: 'localhost',
  port: 5432
)

$database.exec <<-SQL
  CREATE TABLE IF NOT EXISTS foods (
    Unique_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    id_store TEXT NOT NULL,
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
SQL

$database.exec <<-SQL
  CREATE TABLE IF NOT EXISTS drinks (
    Unique_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    value REAL NOT NULL,
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
SQL

$database.exec <<-SQL
  CREATE TABLE IF NOT EXISTS toys (
    Unique_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    value REAL NOT NULL,
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
SQL

res = $database.exec("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")

res.each do |row|
  puts row['table_name']
end

def createFood(food)
    $database.exec_params(
        "INSERT INTO foods (name, id_store) VALUES ($1, $2)",
        [food.name, food.id]
    )

    $database.exec <<-SQL
      CREATE TABLE products_#{food.name} (
        Unique_id SERIAL PRIMARY KEY,
        name TEXT NOT NULL UNIQUE,
        value REAL NOT NULL,
        image TEXT,
        description TEXT,
        created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    SQL
end

def deleteFood(food_name)
    $database.exec("DROP TABLE products_#{food_name}")
    $database.exec_params("DELETE FROM foods WHERE name = $1", [food_name])
end

def listFoods()
    foods = []
  
    $database.exec("SELECT * FROM foods").each do | food |
        
        foods.push(Food.new(food[1], food[2]))
    end
    return foods
end

def getFood(foodName)
    food = $database.exec("SELECT * FROM foods WHERE name = '#{foodName}'")
    food = Food.new(food[0][1], food[0][2])
    
    $database.exec("SELECT * FROM products_#{food.name.gsub(" ", "_")}").each do | productSQL |
      product = Item.new(productSQL[1], productSQL[2])
      product.setImage(productSQL[3])
      product.setDescription(productSQL[4])
      product.setID(productSQL[0])
  
      food.addItem(product)
    end
  
    return food
end

def addProduct(food, product)
    $database.exec_params("INSERT INTO products_#{food.name.gsub(" ", "_")} (name, value, image, description) VALUES ($1, $2, $3, $4)", [product.name, product.value, product.image, product.description])
end

def listProducts(foodName)
    foodName.gsub!(" ", "_")
    products = []
    $database.exec("SELECT * FROM products_#{foodName}").each do | productSQL |
      product = Item.new(productSQL[1], productSQL[2])
      product.setImage(productSQL[3])
      product.setDescription(productSQL[4])
  
      products.push(product)
    end
    return products
end

def removeProduct(food, product_id)
    $database.exec_params("DELETE FROM products_#{food} WHERE unique_id = $1", [product_id])
end

def getAll()
    foods = []
    $database.exec("SELECT * FROM foods").each do | food |
        puts "food: #{food[1]}"
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
    data = $database.exec_params("SELECT * FROM products_#{food_name} WHERE unique_id = $1 ", [product_id])
    product = Item.new(data[0][1], data[0][2])
    product.setImage(data[0][3])
    product.setDescription(data[0][4])
    product.setID(product_id)
  
    return product
end

def editProduct(food_name, product)
    $database.exec_params("UPDATE products_#{food_name} SET name = $1, value = $2, description = $2, image = $3 WHERE unique_id = $4", [product.name, product.value, product.description, product.image, product.id])
end

def getDrinks()
    drinks = []
  
    $database.exec("SELECT * FROM drinks").each do | drink |
      item = Item.new(drink[1], drink[2])
      item.setID(drink[0])
  
      drinks.push(item)
    end
    return drinks
end

def addDrink(name, value)
    $database.exec_params("INSERT INTO drinks (name, value) VALUES ($1, $2)", [name, value])
end

def removeDrink(id)
    $database.exec_params("DELETE FROM drinks WHERE unique_id = $1", [id])
end

def getToys()
    toys = []
  
    $database.exec("SELECT * FROM toys").each do | toy |
      item = Item.new(toy[1], toy[2])
      item.setID(toy[0])
  
      toys.push(item)
    end
    return toys
end

def addToy(name, value)
    $database.exec_params("INSERT INTO toys (name, value) VALUES ($1, $2)", [name, value])
end

def removeToy(id)
    $database.exec_params("DELETE FROM toys WHERE unique_id = $1", [id])
end


