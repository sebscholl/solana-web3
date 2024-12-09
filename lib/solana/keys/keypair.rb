require 'json'

module Solana
  module Keys
    class Keypair
      attr_reader :public_key, :private_key
      
      def initialize(uint8_keypair = nil)
        @private_key = PrivateKey.new(uint8_keypair)
        @public_key = @private_key.public_key
      end

      def self.generate
        new
      end

      def sign(message)
        @private_key.sign(message)
      end

      def verify(signature, message)
        @public_key.verify(signature, message)
      end
      
      def save_to_file(path)
        File.write(path, @private_key.to_uint8)
      end

      def self.load_from_file(path)
        new JSON.load_file(path).map(&:to_i)
      end
    end
  end
end