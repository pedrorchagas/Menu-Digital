require 'sinatra'
require 'securerandom'
require 'redis'
require_relative 'utils/database'
require_relative 'utils/objects'

set :bind, '192.168.18.15'
set :port, 4567

set :public_folder, 'public'

#docker pull redis/redis-stack-server:latest
#docker run -d --name redis-stack-server -p 6379:6379 redis/redis-stack-server:latest
# docker start redis-stack-server <- para iniciar o redis caso ele não tenha iniciado
$redis = Redis.new(host: "localhost", port: 6379)

getAll().each do | food |
    food.products.each do | product |
        puts "name: ", product.name
        puts "description: ", product.description
        puts "image: ", product.image.empty?
        puts "_____________________________________________"
    end
end

get "/" do
    @foods = getAll()
    @drinks = getDrinks
    @toys = getToys
    erb :index
end


get "/login/" do
    puts request
    erb :login
end

post "/login/" do
    user = params['user']
    password = params['password']

    if user == "ADM" and password == "1234"
        uuid = SecureRandom.uuid
        response.set_cookie("session", value: uuid, expires: Time.now + 3600 )
        redirect '/admin'
    else
        "ERRADDOOOOOO"
    end
end

get "/admin" do
    puts uuid
    redirect '/admin/'
end

get "/admin/" do
    @foods = listFoods()
    @drinks = getDrinks
    @toys = getToys
    erb :admin
end

post "/admin/createfood" do
    name = params["name"]
    id = params["id"]

    createFood(Food.new(name, id))

    redirect '/admin/'
end

get "/admin/:food" do
    @food = getFood(params['food'])

    erb :foods
end

post "/admin/:food/delete" do
    deleteFood(params['food'])
    redirect '/admin/'
end

post "/admin/:food/createproduct" do
    food = getFood(params['food'])

    product_name = params['name']
    product_value = params['value']
    product_description = params['description']
    product_image = params['image']
    product = Item.new(product_name, product_value)
    product.setDescription(product_description)
    product.setImage(product_image)

    addProduct(food, product)
    redirect "/admin/#{params['food']}"
end

post "/admin/food/:food/:id/delete" do
    removeProduct(params['food'], params['id'])
    redirect "/admin/#{params['food']}"
end

get "/admin/food/:food/:id/edit" do
    @product = getProduct(params['food'], params['id'])
    erb :edit_food
end

post "/admin/food/:food/:id/edit" do
    product = getProduct(params['food'], params['id'])
    puts " ID: #{product.id}"
    product.name = params['name']
    product.value = params['value'] 
    product.description = params['description']
    product.image = params['image']

    editProduct(params['food'], product)
    redirect "/admin/#{params['food']}"

end

post "/admin/drink/create" do
    name = params['name']
    value = params['value']
    addDrink(name, value)
    redirect '/admin/'
end

post "/admin/drink/:id/delete" do
    id = params['id']
    removeDrink(id)
    redirect '/admin/'
end

post "/admin/toy/create" do
    name = params['name']
    value = params['value']
    addToy(name, value)
    redirect '/admin/'
end

post "/admin/toy/:id/delete" do
    id = params['id']
    removeToy(id)
    redirect '/admin/'
end

$redis.flushall