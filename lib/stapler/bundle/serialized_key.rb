#--
# Copyright (c) Michael Rykov
#++

module Stapler
  class Bundle
    class SerializedKey; end
    @@asset_id = Time.now.to_i.to_s

    class << SerializedKey
      def to_key(paths)
        key = Utils.url_encode(paths.map { |a| Utils.groom_path(a) })
        File.join(key, signature(key), @@asset_id)
      end

      def to_paths(bundle)
        key, signature = bundle.split(/[\.\/]/, 3)
        url_decode_with_signature(key, signature)
      rescue Utils::BadString
        nil
      end

    private
      # Security signature for URLs #
      def signature(key)
        Digest::SHA1.hexdigest("#{key}#{Config.secret}")[0...8]
      end

      def url_decode_with_signature(key, key_signature)
        if signature(key.to_s) == key_signature.to_s
          Utils.url_decode(key)
        else
          raise BadString, "Invalid signature"
        end
      end
    end
  end
end
