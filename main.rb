require 'sinatra'

set :bind, '0.0.0.0'
set :port, 4567

set :public_folder, 'public'

get "/" do
    @foods = [{name: "Pizzas", id: 02, flavor: [{name: "Peperoni", value: 12.5, ingredients: "pão seco, carne de coelho, espetinho de asadapomspd aosdpm pao omspoagnopa somaposda ", image: "/images/pizza-pepperoni.jpeg"}, {name: "Portuguesa", value: 12.5, ingredients: "asdasads asd asd asd asdasd asdasdw asdw"}, {name: "Bacon", value: 12.5}]}, {name: "Pizzas", id: 02, flavor: [{name: "Peperoni", value: 12.5, ingredients: "pão seco, carne de coelho, espetinho de asadapomspd aosdpm pao omspoagnopa somaposda ", image: "/images/pizza-pepperoni.jpeg"}, {name: "Portuguesa", value: 12.5, ingredients: "asdasads asd asd asd asdasd asdasdw asdw"}, {name: "Bacon", value: 12.5}]}]
    @drinks = [{name: "Coca-Cola 2Lt", value: 12.00}, {name: "Sprite 2Lt", value: 12.00}, {name: "Sprite 2Lt", value: 12.00}, {name: "Sprite 2Lt", value: 12.00}, {name: "Sprite 2Lt", value: 12.00}, {name: "Sprite 2Lt", value: 12.00}, {name: "Sprite 2Lt", value: 12.00}, {name: "Sprite 2Lt", value: 12.00}, {name: "Sprite 2Lt", value: 12.00}, {name: "Sprite 2Lt", value: 12.00}, {name: "Sprite 2Lt", value: 12.00}, {name: "Sprite 2Lt", value: 12.00}, {name: "Sprite 2Lt", value: 12.00}]
    @toys = [{name: "Pula-Pula", value: 2.00}, {name: "Castelo inflado", value: 2.00}, {name: "Brinquedoteca", value: 2.00}]
    erb :index
end

