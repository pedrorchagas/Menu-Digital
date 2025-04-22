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

def createFood(name, id)
  name.gsub!(" ", "_")
  $database.execute("INSERT INTO foods (name, id_store) VALUES (?, ?)", [name, id])
  $database.execute <<-SQL
    CREATE TABLE products_#{name} (
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


def addProduct(foodName, product)
  foodName.gsub!(" ", "_")
  $database.execute("INSERT INTO products_#{foodName} (name, value, image, description) VALUES (?, ?, ?, ?)", [product.name, product.value, product.image, product.description])
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