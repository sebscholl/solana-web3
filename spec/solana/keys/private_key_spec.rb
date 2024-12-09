# spec/solana/keys/private_key_spec.rb
require 'spec_helper'

RSpec.describe Solana::Keys::PrivateKey do
  describe '.generate' do
    it 'creates a new random private key' do
      private_key = described_class.generate
      expect(private_key.to_bytes.length).to eq(64) # Ed25519 private key is 64 bytes
    end

    it 'generates unique keys' do
      key1 = described_class.generate
      key2 = described_class.generate
      expect(key1.to_bytes).not_to eq(key2.to_bytes)
    end
  end

  describe '#initialize' do
    context 'with no arguments' do
      it 'generates a new random key' do
        private_key = described_class.new
        expect(private_key.to_bytes).not_to be_nil
      end
    end

    context 'with Uint8Array keypair' do
      let(:keypair_bytes) { Array.new(64) { rand(0..255) } }
      
      it 'creates a private key from the first 32 bytes' do
        private_key = described_class.new(keypair_bytes)
        expect(private_key.to_bytes[0...32]).to eq(keypair_bytes[0...32].pack('C*'))
      end
    end
  end

  describe '#public_key' do
    let(:private_key) { described_class.generate }
    
    it 'returns the corresponding public key' do
      expect(private_key.public_key).to be_a(Solana::Keys::PublicKey)
    end

    it 'returns consistent public keys' do
      public_key1 = private_key.public_key
      public_key2 = private_key.public_key

      expect(public_key1.to_bytes).to eq(public_key2.to_bytes)
    end
  end

  describe '#sign' do
    let(:private_key) { described_class.generate }
    let(:message) { "Hello, Solana!" }

    it 'signs a message' do
      signature = private_key.sign(message)
      expect(signature).to be_a(Solana::Keys::Signature)
    end

    it 'produces signatures that can be verified' do
      signature = private_key.sign(message)
      expect(private_key.public_key.verify(signature, message)).to be true
    end
  end

  describe '#to_bytes' do
    let(:private_key) { described_class.generate }
    
    it 'returns 64 bytes' do
      expect(private_key.to_bytes.length).to eq(64)
    end
  end
end