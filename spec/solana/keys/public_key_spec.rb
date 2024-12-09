# spec/solana/keys/public_key_spec.rb
require 'spec_helper'

RSpec.describe Solana::Keys::PublicKey do
  let(:bytes) { Array.new(32) { rand(0..255) }.pack('C*') }

  describe '#initialize' do
    context 'with valid bytes' do
      it 'creates a public key from bytes' do
        public_key = described_class.new(bytes)
        expect(public_key.to_bytes).to eq(bytes)
      end
    end
  end

  describe '#verify' do
    let(:private_key) { Solana::Keys::PrivateKey.generate }
    let(:public_key) { private_key.public_key }
    let(:message) { "Hello, Solana!" }
    let(:signature) { private_key.sign(message) }

    it 'verifies valid signatures' do
      expect(public_key.verify(signature, message)).to be true
    end

    it 'rejects invalid signatures' do
      bad_message = "Bad message"
      expect(public_key.verify(signature, bad_message)).to be false
    end
  end

  describe '#to_bytes' do
    let(:public_key) { described_class.new(bytes) }
    
    it 'returns the original bytes' do
      expect(public_key.to_bytes).to eq(bytes)
    end

    it 'returns 32 bytes' do
      expect(public_key.to_bytes.length).to eq(32)
    end
  end

  describe '#to_base58' do
    it 'returns a base58 encoded string' do
      public_key = described_class.new(bytes)
      expect(public_key.to_base58).to be_a(String)
      expect(public_key.to_base58).not_to include('0') # Base58 excludes 0
      expect(public_key.to_base58).not_to include('O') # Base58 excludes O
      expect(public_key.to_base58).not_to include('I') # Base58 excludes I
      expect(public_key.to_base58).not_to include('l') # Base58 excludes l
    end

    it 'is the same as #address' do
      public_key = described_class.new(bytes)
      expect(public_key.to_base58).to eq(public_key.address)
    end
  end
end