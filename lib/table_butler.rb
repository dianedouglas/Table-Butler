require 'pry'
require 'rubygems'
require 'active_support/core_ext/string/inflections'

class Table_Butler
#This will work as long as your class attribute name is equal to your DB column name
  def save
    table_name = self.class.to_s.downcase.pluralize
    values = ""
    columns = ""

    attributes = self.instance_variables
    attributes.each do |attribute|
      if attribute.id2name != '@id'
        values += "'" + self.instance_variable_get(attribute).to_s + "', "
        columns += attribute.id2name.slice(1, attribute.length-1) + ", "
      end
    end
    values = values.slice(0, values.length - 2)
    columns = columns.slice(0, columns.length - 2)

    results = DB.exec("INSERT INTO #{table_name} (#{columns}) VALUES (#{values}) RETURNING id;")

    @id = results.first["id"].to_i
  end

  def self.all
    table_name = self.to_s.downcase.pluralize
    class_instances = []
    results = DB.exec("SELECT * FROM #{table_name};")
    results.each do |result|
      class_instances << self.new(result)
    end
    class_instances
  end

  def ==(child)
    is_equal = true
    attributes = child.instance_variables
    attributes.each do |attribute|
      if self.instance_variable_get(attribute) != child.instance_variable_get(attribute)
        is_equal = false
      end
    end
    is_equal
  end

  def delete
    table_name = self.class.to_s.downcase.pluralize
    DB.exec("DELETE FROM #{table_name} WHERE id = #{self.id};")
  end
end
