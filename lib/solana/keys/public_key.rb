# lib/solana/keys/public_key.rb
require 'base58'
require 'ed25519'

module Solana
  module Keys
    class PublicKey
      def initialize(bytes)
        @verify_key = Ed25519::VerifyKey.new(bytes)
      end

      def verify(signature, message)
        @verify_key.verify(signature.to_bytes, message)
      rescue Ed25519::VerifyError
        false
      end

      def address
        to_base58
      end

      def to_base58
        Base58.encode(to_bytes.unpack('H*')[0].to_i(16), :bitcoin)
      end

      def to_bytes
        @verify_key.to_bytes
      end
    end
  end
end