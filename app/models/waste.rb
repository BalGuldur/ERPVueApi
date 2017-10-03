class Waste < ApplicationRecord
  include FrontViewSecond
  has_many :waste_items, dependent: :destroy
  has_many :store_items, through: :waste_items

  # Определение связей для генерации front veiw
  # { model: '', type: 'many/one', rev_type: 'many/one', index_inc: true/false }
  def self.refs
    [
        { model: 'waste_items', type: 'many', rev_type: 'one', index_inc: true },
        { model: 'store_items', type: 'many', rev_type: 'one', index_inc: false }
    ]
  end

  # Стандартный вывод для front_view
  # def self.front_view
  #   f_v = {}
  #   if reflections_has_many.empty?
  #     find_each do |item|
  #       f_v.merge!(item.front_view(collection: true))
  #     end
  #     f_v = { model_name.name.pluralize.camelize(:lower) => f_v }
  #   else
  #     # @items =
  #     @reflect_names = reflections_has_many.map { |ref| ref.klass.model_name.collection }
  #     @items = includes(@reflect_names)
  #     @items.find_each do |item|
  #       f_v.merge!(item.front_view(collection: true))
  #     end
  #     f_v = { model_name.name.pluralize.camelize(:lower) => f_v }
  #     @reflect_names = reflections_has_many.map { |ref| ref.klass.model_name.name }
  #     @reflect_names.each do |ref_name|
  #       @add_items = ref_name.safe_constantize.includes(:waste).where(wastes: { id: [ids] })
  #       f_v.merge!(@add_items.front_view)
  #     end
  #   end
  #   f_v
  #   # f_v = {}
  #   # @waste_items = WasteItem.includes(:waste).where(wastes: { id: [ids] })
  #   # includes(:waste_items).find_each do |waste|
  #   #   f_v.merge!(waste.front_view(collection: true))
  #   # end
  #   # { wastes: f_v }.merge!(@waste_items.front_view)
  # end

  # def front_view(collection: false)
  #   @result = { id => json_front }
  #   return @result if collection
  #   @result = { wastes: @result }
  #   return @result if reflections_has_many.empty?
  #   @reflect_names = reflections_has_many.map { |reflection| reflection.klass.model_name.collection }
  #   @reflect_names.each { |ref_name| @result.merge! send(ref_name).front_view }
  #   @result
  # end

  # def json_front
  #   return as_json if reflections_has_many.empty?
  #   @reflect_names = reflections_has_many.map { |reflection| reflection.klass.model_name.singular + '_ids' }
  #   as_json(methods: @reflect_names)
  # end

  # def self.reflections_has_many
  #   self.reflect_on_all_associations(:has_many).select { |ref| !ref.through_reflection? }
  # end
  #
  # def reflections_has_many
  #   self.class.reflect_on_all_associations(:has_many).select { |ref| !ref.through_reflection? }
  # end

  # def self.front_view_with_name_key
  #   f_v = {}
  #   all.includes(:waste_items).find_each do |waste|
  #     f_v.merge!(waste.front_view_with_key)
  #   end
  #   {wastes: f_v}
  # end
  #
  # def self.front_view
  #   f_v = {}
  #   all.each do |waste|
  #     f_v.merge!(waste.front_view_with_key)
  #   end
  #   f_v
  # end
  #
  # def front_view_with_name_key
  #   {waste: front_view_with_key}
  # end
  #
  # def front_view_with_key
  #   {id => front_view}
  # end
  #
  # def front_view_with_name
  #   {waste: front_view}
  # end
  #
  # def front_view
  #   as_json(methods: [:waste_item_ids])
  # end

  def waste_store
    # puts "store item ids #{self.store_item_ids}"
    waste_items.each do |waste_item|
      @store_item = waste_item.store_item
      @store_item.remains = @store_item.remains - waste_item.qty
      @store_item.save
    end
  end

  def revert
    revert_store
    if destroy
      self
    else
      waste_store
      false
    end
  end

  def revert_store
    waste_items.each do |waste_item|
      @store_item = waste_item.store_item
      @store_item.remains = @store_item.remains + waste_item.qty
      @store_item.save
    end
  end

  private

  def test2
    puts 'teste'
  end
end
