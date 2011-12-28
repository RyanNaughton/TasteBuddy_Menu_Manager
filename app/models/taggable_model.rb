module TaggableModel
  def add_tag(user, tag)
    user_id = user.id # BSON

    if ! tag_exists?(tag)
      errors.add(:tags, "#{tag} is not a permitted value")
    elsif self.tags[tag].blank?
      self.tags[tag] = [user_id]
      true
    else
      self.tags[tag].include?(user_id) or self.tags[tag] += [user_id]
      true
    end
  end

  def remove_tag(user, tag)
    return true if self.tags[tag].nil?

    self.tags[tag] -= [user.id]
    if self.tags[tag].empty?
      hash = self.tags.dup
      hash.delete(tag)
      self.tags = hash
    end
    true
  end

  def tags_with_count
    Hash[
      tags.map {|tag_name, user_ids| [tag_name, user_ids.size] }
    ]
  end

  def user_tags(user)
    return nil if user.nil? or ! user.persisted?
    tags
      .select {|k,v| v.include?(user.id) }
      .keys
  end

  private

  def tag_exists?(tag)
    Tag.where(name: tag).present?
  end
end
