# spec/solana/keys/signature_spec.rb
require 'spec_helper'

RSpec.describe Solana::Keys::Signature do
  describe '#initialize' do
    context 'with valid bytes' do
      let(:bytes) { Array.new(64) { rand(0..255) }.pack('C*') }
      
      it 'creates a signature from bytes' do
        signature = described_class.new(bytes)
        expect(signature.to_bytes).to eq(bytes)
      end
    end

    context 'with invalid length' do
      let(:bytes) { Array.new(63) { rand(0..255) }.pack('C*') }
      
      it 'raises an error' do
        expect { described_class.new(bytes) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#verify' do
    let(:keypair) { Solana::Keys::Keypair.generate }
    let(:message) { "Hello, Solana!" }
    let(:signature) { keypair.sign(message) }

    it 'verifies against the original message and public key' do
      expect(signature.verify(message, keypair.public_key)).to be true
    end

    it 'fails verification with wrong message' do
      expect(signature.verify("Wrong message", keypair.public_key)).to be false
    end
  end

  describe '#to_bytes' do
    let(:bytes) { Array.new(64) { rand(0..255) }.pack('C*') }
    let(:signature) { described_class.new(bytes) }
    
    it 'returns the original bytes' do
      expect(signature.to_bytes).to eq(bytes)
    end

    it 'returns 64 bytes' do
      expect(signature.to_bytes.length).to eq(64)
    end
  end

  describe '.sign_bytes' do
    let(:keypair) { Solana::Keys::Keypair.generate }
    let(:message) { "Hello Solana" }
    let(:message_bytes) { [1, 2, 3, 4, 5] }
   
    it 'signs a string message' do
      signature_bytes = described_class.sign_bytes(keypair.private_key, message).to_bytes

      expect(signature_bytes.length).to eq(64) # Ed25519 signatures are 64 bytes
      
      # Verify signature is valid
      signature = described_class.new(signature_bytes)
      expect(keypair.verify(signature, message)).to be true
    end
   
    it 'signs byte arrays' do
      signature_bytes = described_class.sign_bytes(keypair.private_key, message_bytes).to_bytes
      expect(signature_bytes.length).to eq(64)
      
      # Verify signature is valid
      signature = described_class.new(signature_bytes)
      expect(keypair.verify(signature, message_bytes.pack('C*'))).to be true
    end
  end

  describe '.assert_is_signature' do
    let(:valid_signature) do
      # Generate a valid signature for testing
      keypair = Solana::Keys::Keypair.generate
      signature = keypair.sign("test message")
      Base58.encode(signature.to_bytes.unpack('H*')[0].to_i(16), :bitcoin)
    end

    context 'with valid signature' do
      it 'returns true for valid signature strings' do
        expect(described_class.assert_is_signature(valid_signature)).to be true
      end
    end

    context 'with invalid signature length' do
      it 'raises error for short strings' do
        expect {
          described_class.assert_is_signature('a' * 63)
        }.to raise_error(Solana::Keys::Signature::SignatureError, /length out of range/)
      end

      it 'raises error for long strings' do
        expect {
          described_class.assert_is_signature('a' * 89)
        }.to raise_error(Solana::Keys::Signature::SignatureError, /length out of range/)
      end
    end

    context 'with invalid base58 encoding' do
      it 'raises error for invalid characters' do
        invalid_sig = valid_signature.gsub(/^./, '!')  # Replace first char with invalid one
        expect {
          described_class.assert_is_signature(invalid_sig)
        }.to raise_error(Solana::Keys::Signature::SignatureError, /Invalid signature encoding/)
      end
    end

    context 'with wrong decoded length' do
      it 'raises error for signatures that decode to wrong length' do
        # Create a base58 string that's valid length (86 chars) but decodes to 63 bytes
        too_short = Base58.encode(("1" * 126).to_i(16), :bitcoin)
        expect {
          described_class.assert_is_signature(too_short)
        }.to raise_error(Solana::Keys::Signature::SignatureError)
      end
    end
  end
end