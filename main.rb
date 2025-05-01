require 'sinatra'
require_relative 'utils/objects'
require_relative 'utils/sessions'

database = "sqlite"
if database == 'sqlite'
    # sqlite
    require_relative 'utils/database/sqlite3'
 
elsif database == 'postgre' 
    
    # postgreSQL
    require_relative 'utils/database/postgre'

else 
    require_relative 'utils/database/mysql'
end


set :bind, '0.0.0.0'
set :port, 4567
set :public_folder, 'public'
set :protection, except: :http_origin


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
    erb :login
end

post "/login/" do
    user = params['user']
    password = params['password']

    if user == "ADM" and password == "1234"
        
        response.set_cookie("session", value: create_session(request.ip), expires: Time.now + 3600, path: "/" )
        redirect '/admin'
    else
        "ERRADDOOOOOO"
    end
end

get "/admin" do
    # validador da sessão
    uuid = request.cookies["session"]
    ip = request.ip
    unless validate_session(uuid, ip)
      redirect '/login/'
    end
    
    redirect "/admin/"
end

get "/admin/" do
    # validador da sessão
    uuid = request.cookies["session"]
    ip = request.ip
    unless validate_session(uuid, ip)
      redirect '/login/'
    end

    @foods = listFoods()
    @drinks = getDrinks
    @toys = getToys
    erb :admin
end

post "/admin/createfood" do
    # validador da sessão
    uuid = request.cookies["session"]
    ip = request.ip
    unless validate_session(uuid, ip)
      redirect '/login/'
    end

    name = params["name"]
    id = params["id"]

    createFood(Food.new(name, id))

    redirect '/admin/'
end

get "/admin/:food" do
    # validador da sessão
    uuid = request.cookies["session"]
    ip = request.ip
    unless validate_session(uuid, ip)
        redirect '/login/'
    end
    @food = getFood(params['food'])

    erb :foods
end

post "/admin/:food/delete" do
    # validador da sessão
    uuid = request.cookies["session"]
    ip = request.ip
    unless validate_session(uuid, ip)
        redirect '/login/'
    end
    deleteFood(params['food'])
    redirect '/admin/'
end

post "/admin/:food/createproduct" do
    # validador da sessão
    uuid = request.cookies["session"]
    ip = request.ip
    unless validate_session(uuid, ip)
        redirect '/login/'
    end
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
    # validador da sessão
    uuid = request.cookies["session"]
    ip = request.ip
    unless validate_session(uuid, ip)
        redirect '/login/'
    end
    removeProduct(params['food'], params['id'])
    redirect "/admin/#{params['food']}"
end

get "/admin/food/:food/:id/edit" do
    # validador da sessão
    uuid = request.cookies["session"]
    ip = request.ip
    unless validate_session(uuid, ip)
        redirect '/login/'
    end
    @product = getProduct(params['food'], params['id'])
    erb :edit_food
end

post "/admin/food/:food/:id/edit" do
    # validador da sessão
    uuid = request.cookies["session"]
    ip = request.ip
    unless validate_session(uuid, ip)
        redirect '/login/'
    end
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
    uuid = request.cookies["session"]
    ip = request.ip
    unless validate_session(uuid, ip)
        redirect '/login/'
    end
    name = params['name']
    value = params['value']
    addDrink(name, value)
    redirect '/admin/'
end

post "/admin/drink/:id/delete" do
    uuid = request.cookies["session"]
    ip = request.ip
    unless validate_session(uuid, ip)
        redirect '/login/'
    end

    id = params['id']
    removeDrink(id)
    redirect '/admin/'
end

post "/admin/toy/create" do
    uuid = request.cookies["session"]
    ip = request.ip
    unless validate_session(uuid, ip)
        redirect '/login/'
    end
    
    name = params['name']
    value = params['value']
    addToy(name, value)
    redirect '/admin/'
end

post "/admin/toy/:id/delete" do
    uuid = request.cookies["session"]
    ip = request.ip
    unless validate_session(uuid, ip)
        redirect '/login/'
    end
    
    id = params['id']
    removeToy(id)
    redirect '/admin/'
end

# Fazer a limpeza do banco de dados redis
clean_redis