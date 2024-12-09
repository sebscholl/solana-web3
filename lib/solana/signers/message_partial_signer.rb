module Solana
  module Signers
    # Base module for all signing capabilities
    module MessagePartialSigner
      def sign_message(message)
        raise NotImplementedError, "#{self.class} must implement #sign_message"
      end
    end
  end
end