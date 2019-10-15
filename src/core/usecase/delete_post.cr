module Usecase
  class DeletePost(POST_GATEWAY)
    def call(post_id : Int32?)
      post = POST_GATEWAY.find(post_id)
      if post.nil?
        return { status: "No such post" }
      else
        post.delete()
        return { status: "Post deleted" }
      end
    end
  end
end
