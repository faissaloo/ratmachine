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

      post_to_delete = Post.first("ORDER BY updated_at ASC")
    end

    post = Post.create(message: message, parent: parent_id)
    post_id = post.id

    parent = Nil
    #Update all parents
    last_reply = post
    until parent_id.nil?
      parent = Post.find(parent_id)
      unless parent.nil?
        #This is a little broken because of our little addition here
        # might need to rework this logic for crystal
        parent.update(last_reply: last_reply.id)
        #parent.touch #Maybe we don't need this
        last_reply = parent
        parent_id = last_reply.parent
      end
    end

    unless post_to_delete.nil?
      posts_to_orphan = Post.all("SET parent = NULL WHERE parent EQUALS #{post_to_delete.id}")
      post_to_delete.destroy
    end
    post_id
  end

  def self.get_replies(parent : Post | Nil = nil)
    if parent.nil?
      Post.all("WHERE parent IS NULL ORDER BY updated_at DESC")
    else
      Post.all("WHERE parent = #{parent.id} ORDER BY updated_at DESC")
    end
  end
end
