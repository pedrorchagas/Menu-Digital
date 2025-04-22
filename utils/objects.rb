class Food
  attr_reader :products, :name, :id
  
  def initialize(name, id)
      @name = name
      @id = id
      @products = []
  end

  def addItem(item)
      @products.push(item)
  end

end

class Item

  # Variáveis essenciais: NAME e VALUE
  attr_reader :name, :value, :image_link, :description, :image

  def initialize(name, value)
      @name = name.to_s
      @value = value
      @image = ""
      @description = ""
  end

  def setImage(imageLink)
      @image = imageLink
  end

  def setDescription(description)
      @description = description.to_s
  end
end