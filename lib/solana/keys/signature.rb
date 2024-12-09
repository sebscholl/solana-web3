module Solana
  module Keys
    class Signature
      SIGNATURE_LENGTH = 64
      SIGNATURE_BASE58_MIN_LENGTH = 64
      SIGNATURE_BASE58_MAX_LENGTH = 88

      class SignatureError < StandardError; end

      def initialize(bytes)
        raise ArgumentError, "Signature must be #{SIGNATURE_LENGTH} bytes" unless bytes.length == SIGNATURE_LENGTH
        @bytes = bytes
      end

      def verify(message, public_key)
        public_key.verify(self, message)
      end

      def to_bytes
        @bytes
      end

      def self.sign_bytes(key, data)
        data_bytes = data.is_a?(String) ? data.bytes : data
        
        key.sign(data_bytes.pack('C*'))
      end

      def self.assert_is_signature(putative_signature)
        # Fast path: check string length
        if !(SIGNATURE_BASE58_MIN_LENGTH..SIGNATURE_BASE58_MAX_LENGTH).cover?(putative_signature.length)
          raise SignatureError, "Signature string length out of range: #{putative_signature.length}"
        end

        # Slow path: attempt to decode base58
        begin
          bytes = Base58.decode(putative_signature).to_s(16).scan(/../).map(&:hex).pack('C*')
          if bytes.length != SIGNATURE_LENGTH
            raise SignatureError, "Invalid signature byte length: #{bytes.length}"
          end
        rescue StandardError
          raise SignatureError, "Invalid signature encoding"
        end

        true
      end
    end
  end
end