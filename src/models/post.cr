require "../helpers/formatter_helper.cr"
class Post < Granite::Base
  adapter pg
  table_name posts

  # id : Int64 primary key is created for you
  field parent : Int32
  field message : String
  field last_reply : Int32
  timestamps

  def html
    FormatterHelper.format(self.message.as(String))
  end

  def self.reply(message, parent_id : Int32 | Nil = nil)
    post_to_delete : Post | Nil
    post_to_delete = nil

    if Post.count >= 254
      post_to_delete = Post.first("ORDER BY created_at ASC")
    end

    post = Post.create(message: message, parent: parent_id)
    post_id = post.id

    parent = nil
    last_reply = post_id
    until parent_id.nil?
      parent = Post.find!(parent_id)
      parent.update(last_reply: parent_id)
      last_reply = parent
      parent_id = last_reply.parent
    end

    post_to_delete.delete() unless post_to_delete.nil?
    post_id
  end

  def delete
    orphan_children()
    destroy()
  end

  def orphan_children()
    Post.all("WHERE parent = #{self.id}").each do |post|
      post.update(parent: nil)
    end
  end

  def self.get_replies(parent : Post | Nil = nil)
    if parent.nil?
      Post.all("WHERE parent IS NULL ORDER BY updated_at DESC")
    else
      Post.all("WHERE parent = #{parent.id} ORDER BY updated_at DESC")
    end
  end
end
