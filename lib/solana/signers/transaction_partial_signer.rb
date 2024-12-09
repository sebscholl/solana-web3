module Solana
  module Signers
    module TransactionPartialSigner
      def sign_transaction(transaction)
        raise NotImplementedError, "#{self.class} must implement #sign_transaction"
      end
    end
  end
end