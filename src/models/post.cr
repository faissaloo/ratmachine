require "../helpers/formatter_helper.cr"
class Post < Granite::Base
  connection pg
  table posts

  column id : Int64, primary: true
  column parent : Int32?
  column message : String
  column ip_address : String?
  column last_reply : Int32?
  timestamps

  def html
    FormatterHelper.format(self.message.as(String))
  end

  def self.reply(message, ip_address : String | Nil, parent_id : Int32 | Nil = nil)
    post_to_delete : Post | Nil
    post_to_delete = nil

    if Post.count >= 254
      post_to_delete = Post.first("ORDER BY created_at ASC")
    end

    post = Post.create(message: message, parent: parent_id, ip_address: ip_address)
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

  def delete()
    orphan_children()
    destroy()
  end

  def orphan_children()
    Post.where(parent: id).each do |post|
      #https://github.com/faissaloo/ratmachine/issues/3
      post.parent = nil
      post.save
    end
  end

  def self.get_replies(parent : Post | Nil = nil)
    if parent.nil?
      Post.where(parent: nil).order(updated_at: :desc)
    else
      Post.where(parent: parent.id).order(updated_at: :desc)
    end
  end
end
