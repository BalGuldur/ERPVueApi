# rubocop:disable Style/AsciiComments
# Концерн для добавления стандартного front_view в модели
concern :FrontViewSecond do # rubocop:disable Metrics/BlockLength
  # def model_name_camelize
  #   model_name.name.pluralize.camelize(:lower)
  # end
  #
  # def names_ids
  #   refs.map do |ref|
  #     if ref[:type] == 'many'
  #       ref[:model].singularize + '_ids'
  #     elsif ref[:type] == 'one'
  #       ref[:model] + '_ids'
  #     end
  #   end
  # end

  def front_view(*options)
  # def front_view(options = {})
  #   puts options.as_json
    return json_front if options.include? :without_id
    return { id => json_front } if options.include? :without_model_name
    return { self.class.model_name_camelize => { id => json_front } } if options.include? :without_child
    @result = { self.class.model_name_camelize => { id => json_front } }
    self.class.names_inc.each do |ref_name|
      child_model_name = send(ref_name).model_name_camelize
      if @result.include? child_model_name
        @result[child_model_name].merge! send(ref_name).front_view(:without_child)[child_model_name]
      else
        @result.merge! send(ref_name).front_view(:without_child)
      end
    end
    @result
  end

  def json_front
    return as_json if self.class.names_ids.empty?
    as_json(methods: self.class.names_ids)
  end

  # методы класса
  module ClassMethods
    def model_name_camelize
      model_name.name.pluralize.camelize(:lower)
    end

    def names_ids # имена для добавления ids в каждую json_front запись
      refs.map do |ref|
        if ref[:type] == 'many'
          ref[:model].singularize + '_ids'
        elsif ref[:type] == 'one'
          ref[:model] + '_id'
        end
      end
    end

    def names_inc # имена для include и добавления дочерних объектов в collection и instance front_view
      # selectRefs = refs.select { |ref| ref[:index_inc] == true }
      refs.map { |ref| ref[:model] }
    end

    def ref_names # имена для построения дочерних веток объектов в collection
      refs.map { |ref| ref[:model].camelize.singularize }
    end

    def rev_inc_name ref
      if ref[:rev_type] == 'many'
        model_name.collection
      elsif ref[:rev_type] == 'one'
        model_name.singular
      end
    end

    def rev_where_name ref
      if ref[:rev_type] == 'many'
        model_name.collection
      elsif ref[:rev_type] == 'one'
        model_name.collection
      end
    end

    def refs_for_add_items
      refs.select { |ref| ref[:index_inc] == true }
    end

    def add_items f_v
      refs_for_add_items.each do |ref|
        objectName = ref[:model].camelize.singularize
        @add_items = objectName.safe_constantize
                         .includes(rev_inc_name ref)
                         .where(rev_where_name(ref) => { id: [ids] })
        f_v.merge!(@add_items.front_view(:without_child))
      end
      f_v
    end

    def front_view(*options)
      f_v = {}
      includes(names_inc).find_each do |item|
        f_v.merge!(item.front_view(:without_model_name))
      end
      f_v = { model_name_camelize => f_v }
      return f_v if options.include? :without_child
      add_items f_v
      f_v
    end
  end
end