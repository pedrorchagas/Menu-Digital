require 'sinatra'
require_relative 'utils/database'
require_relative 'utils/objects'

set :bind, '0.0.0.0'
set :port, 4567

set :public_folder, 'public'

#createFood("pizzas10", 3)
#print("Comidas", listFoods())
#addProduct("pizzas10", Item.new("Ovo", 20.00))
#print(listProducts("pizzas10"))

getAll().each do | food |
    food.products.each do | product |
        puts product.name
    end
end

get "/" do
    @foods = getAll()

    @drinks = [Item.new("Coca 2lt", 2.00), Item.new("Coca 4lt", 8.00)]
    @toys = [Item.new("Pula pula", 20.20)]
    erb :index
end

get "/admin" do
    @foods = listFoods()
    erb :admin
end

post "/admin/createfood" do
    name = params["name"]
    id = params["id"]

    createFood(Food.new(name, id))

    return 'Criado com sucesso!'
end

get "/admin/:food" do
    @food = getFood(params['food'])

    erb :foods
end

post "/admin/:food/createproduct" do
    food = getFood(params['food'])

    product_name = params['name']
    product_value = params['value']
    product_description = params['description']
    product = Item.new(product_name, product_value)
    product.setDescription(product_description)

    addProduct(food, product)
    return "Deu certo!!!"
end
