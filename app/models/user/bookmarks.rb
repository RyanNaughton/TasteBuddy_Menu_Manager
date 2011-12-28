require_dependency File.expand_path('../../user', __FILE__)

module User::Bookmarks
  def add_bookmark(obj)
    model_class = obj.class.name.underscore.pluralize
    if self.bookmarks[model_class].blank?
      self.bookmarks[model_class] = [obj.id]; true
    elsif self.bookmarks[model_class].include? obj.id
      nil
    else
      self.bookmarks[model_class] += [obj.id]; true
    end
  end

  def remove_bookmark(obj)
    model_class = obj.class.name.underscore.pluralize
    return nil if ! bookmarks[model_class]
    self.bookmarks[model_class] -= [obj.id]
  end

  def bookmarks_data
    Hash[
      bookmarks.map do |type, values|
        klass = type.classify.constantize
        [type, klass.find(values).map {|obj| obj.application_hash(self) }]
      end
    ]
  end
end
