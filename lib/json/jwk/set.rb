module JSON
  class JWK
    class Set < Array
      class KidNotFound < JWT::Exception; end

      def initialize(*jwks)
        jwks = if jwks.first.is_a?(Hash) && (keys = jwks.first.with_indifferent_access[:keys])
          keys
        else
          jwks
        end
        jwks = Array(jwks).flatten.collect do |jwk|
          JWK.new jwk
        end
        replace jwks
      end

      def content_type
        'application/jwk-set+json'
      end

      def [](kid)
        puts "[](kid = #{kid})"
        if kid
          found_key = detect do |jwk|
            jwk[:kid] && jwk[:kid] == kid
          end
          raise JWK::Set::KidNotFound unless found_key
          return found_key
        elsif length == 1
          puts "length == 1 >> #{first}"
          return first
        else # no kid && length > 1
          puts "no kid && length !"
          raise JWK::Set::KidNotFound
        end
      end

      def as_json(options = {})
        # NOTE: Array.new wrapper is requied to avoid CircularReferenceError
        {keys: Array.new(self)}
      end
    end
  end
end