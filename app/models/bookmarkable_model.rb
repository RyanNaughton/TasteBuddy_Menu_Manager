module BookmarkableModel
  def add_bookmark(user)
    bookmarks.include?(user.id) or self.bookmarks += [user.id]
  end

  def remove_bookmark(user)
    bookmarks.delete user.id
  end
end
