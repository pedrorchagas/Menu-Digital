require 'sinatra'
require_relative 'utils/database'
require_relative 'utils/objects'

set :bind, '0.0.0.0'
set :port, 4567

set :public_folder, 'public'

createFood("pizzas10", 3)
print("Comidas", listFoods())
addProduct("pizzas10", Item.new("Ovo", 20.00))
print(listProducts("pizzas10"))


get "/" do
    @foods = []

    pizza = Food.new("Pizzas", 02)
    pizza.addItem(Item.new("Pepperoni", 20.00))

    bacon = Item.new("Bacon", 25.00)
    bacon.setImage("https://static.itdg.com.br/images/640-440/47d6583c93d77edac5244cab67ba660b/253447-378226756-original.jpg")
    bacon.setDescription("adsdasdasda asdasd asd  asd asdasda sda d")
    pizza.addItem(bacon)
    @foods.push(pizza)

    @drinks = [Item.new("Coca 2lt", 2.00), Item.new("Coca 4lt", 8.00)]
    @toys = [Item.new("Pula pula", 20.20)]
    erb :index
end

