# spec/solana/signers_spec.rb
require 'spec_helper'

RSpec.describe Solana::Signers::KeypairSigner do
  let(:keypair) { Solana::Keys::Keypair.generate }
  let(:signer) { described_class.new(keypair) }

  describe '#initialize' do
    it 'creates a signer with a keypair' do
      expect(signer.keypair).to eq(keypair)
    end
  end

  describe '#sign_message' do
    let(:message) { "Hello Solana" }
    let(:message_bytes) { [1, 2, 3, 4, 5] }
    
    it 'signs string messages' do
      signature = signer.sign_message(message)
      expect(signature).to be_a(Solana::Keys::Signature)
      expect(keypair.verify(signature, message)).to be true
    end
  
    it 'signs byte arrays' do
      signature = signer.sign_message(message_bytes)
      expect(signature).to be_a(Solana::Keys::Signature)
      expect(keypair.verify(signature, message_bytes.pack('C*'))).to be true
    end
  
    it 'produces unique signatures for different messages' do
      sig1 = signer.sign_message("Message 1")
      sig2 = signer.sign_message("Message 2")
      expect(sig1.to_bytes).not_to eq(sig2.to_bytes)
    end
  end

  describe '#sign_transaction' do
    it 'raises NotImplementedError' do
      expect { signer.sign_transaction("test") }.to raise_error(NotImplementedError)
    end
  end
end