module Solana
  module Signers
    # Main signer that combines both capabilities
    class KeypairSigner
      include MessagePartialSigner
      include TransactionPartialSigner

      attr_reader :keypair

      def initialize(keypair)
        @keypair = keypair
      end

      def sign_message(message)
        Keys::Signature.sign_bytes(keypair.private_key, message)
      end

      def sign_transaction(transaction)
        raise NotImplementedError, "Transaction signing not yet implemented"
      end
    end
  end
end