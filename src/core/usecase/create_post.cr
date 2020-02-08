module Usecase
  class CreatePost(POST_GATEWAY)
    def call(message : String, parent : Int32?, ip_address : String | Nil)
      begin
        if parent.nil?
          post_id = POST_GATEWAY.reply(message: message, ip_address: ip_address)
        else
          post_id = POST_GATEWAY.reply(message: message, parent_id: parent, ip_address: ip_address)
        end
        { post_id: post_id, status: nil }
      rescue Granite::Querying::NotFound
        { post_id: nil, status: "The post you're trying to reply to does not exist" }
      end
    end
  end
end
