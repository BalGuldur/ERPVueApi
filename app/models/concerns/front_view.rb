# rubocop:disable Style/AsciiComments
# Концерн для добавления стандартного front_view в модели
concern :FrontView do # rubocop:disable Metrics/BlockLength
  # Методы экземпляра класса

  # Стандартный Front_view
  def front_view(collection: false)
    @result = { id => json_front }
    return @result if collection # Если генерим для коллекции возвращаем только объект
    @result = { model_name_camelize => @result }
    return @result if reflect_names_collect.empty? # Если генерим для одиночного вида и нет reflections
    reflect_names_collect.each { |ref_name| @result.merge! send(ref_name).front_view(with_child: false) }
    @result
  end

  # объявления приватных методов класса
  included do
    # private_class_method :reflections_has_many, :model_name_camelize
  end

  # методы класса
  module ClassMethods
    # методы класса
    # Стандартный Front_View класса
    def front_view(with_child: true)
      f_v = {}
      includes(reflect_names_collect).find_each { |item| f_v.merge!(item.front_view(collection: true)) }
      f_v = { model_name_camelize => f_v }
      if with_child
        add_items f_v
      end
      f_v
    end

    def add_items(f_v)
      ref_names_has_many_class.each do |ref_name|
        @add_items = ref_name.safe_constantize
                         .includes(model_name.singular)
                         .where(model_name.collection => { id: [ids] })
        f_v.merge!(@add_items.front_view(with_child: false))
      end
      ref_names_has_many_and_belong_class.each do |ref_name|
        @add_items = ref_name.safe_constantize
                         .includes(model_name.collection)
                         .where(model_name.collection => { id: [ids] })
        f_v.merge!(@add_items.front_view(with_child: false))
      end
    end

    # приватные методы класса
    def reflections_has_many
      reflect_on_all_associations(:has_many).select { |ref| !ref.through_reflection? }
    end

    def reflections_has_many_and_belongs
      reflect_on_all_associations(:has_and_belongs_to_many).select { |ref| !ref.through_reflection? }
    end

    def reflect_names_collect
      res = reflections_has_many.map { |ref| ref.klass.model_name.collection }
      res + reflections_has_many_and_belongs.map { |ref| ref.klass.model_name.collection }
    end

    def model_name_camelize
      model_name.name.pluralize.camelize(:lower)
    end

    def ref_names_has_many_class
      reflections_has_many.map { |ref| ref.klass.model_name.name }
    end

    def ref_names_has_many_and_belong_class
      reflections_has_many_and_belongs.map { |ref| ref.klass.model_name.name }
    end
  end

  # Приватные методы инстанса
  private

  def json_front
    return as_json if reflect_names_ids.empty?
    # @reflect_names = reflections_has_many.map { |reflection| reflection.klass.model_name.singular + '_ids' }
    as_json(methods: reflect_names_ids)
  end

  def model_name_camelize
    model_name.name.pluralize.camelize(:lower)
  end

  def reflections_has_many
    self.class.reflect_on_all_associations(:has_many)
        .select { |ref| !ref.through_reflection? }
  end

  def reflections_has_many_and_belongs
    self.class.reflect_on_all_associations(:has_and_belongs_to_many)
        .select { |ref| !ref.through_reflection? }
  end

  def reflect_names_collect
    res = reflections_has_many.map { |ref| ref.klass.model_name.collection }
    res + reflections_has_many_and_belongs.map { |ref| ref.klass.model_name.collection }
  end

  def reflect_names_ids
    res = reflections_has_many.map { |ref| ref.klass.model_name.singular + '_ids' }
    res + reflections_has_many_and_belongs.map { |ref| ref.klass.model_name.singular + '_ids' }
  end
end