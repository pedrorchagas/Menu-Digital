class Food
    attr_reader :products, :name, :id

    def initialize(name, id)
        self.name = name

        @id = id
        @products = []
    end

    def name=(name)
      @name = name.downcase.gsub(" ", "_")
    end

    def getFactoredName
        return @name.capitalize.gsub("_", "")
    end

    def addItem(item)
        @products.push(item)
    end

end

class Item

  # Variáveis essenciais: NAME e VALUE
  attr_accessor :name, :value, :image_link, :description, :image, :id

  def initialize(name, value)
    @name = name
    @value = value
    @image = ""
    @description = ""
    @id = nil
  end

  def setID(id)
    @id = id
  end

  def setImage(imageLink)
    @image = imageLink
  end

  def setDescription(description)
    @description = description.to_s
  end
end