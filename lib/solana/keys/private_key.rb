# lib/solana/keys/private_key.rb
require 'ed25519'
require 'securerandom'

module Solana
  module Keys
    class PrivateKey
      def initialize(uint8_keypair = nil)
        if uint8_keypair
          bytes = uint8_keypair.slice(0...32).pack('C*')
          @signing_key = Ed25519::SigningKey.new(bytes)
        else
          @signing_key = Ed25519::SigningKey.generate
        end
      end

      def self.generate
        new
      end

      def public_key
        PublicKey.new(@signing_key.verify_key.to_bytes)
      end

      def sign(message)
        Signature.new(@signing_key.sign(message))
      end

      def to_uint8
        to_bytes.unpack('C*')
      end

      def to_bytes
        @signing_key.to_bytes + @signing_key.verify_key.to_bytes
      end
    end
  end
end