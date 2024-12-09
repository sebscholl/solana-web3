# spec/solana/keys/keypair_spec.rb
require 'spec_helper'

RSpec.describe Solana::Keys::Keypair do
  describe '.generate' do
    it 'creates a new keypair with random keys' do
      keypair = described_class.generate
      expect(keypair.public_key).not_to be_nil
      expect(keypair.private_key).not_to be_nil
    end

    it 'generates unique keypairs' do
      keypair1 = described_class.generate
      keypair2 = described_class.generate
      
      expect(keypair1.public_key).not_to eq(keypair2.public_key)
      expect(keypair1.private_key).not_to eq(keypair2.private_key)
    end
  end

  describe '#initialize' do
    context 'with an existing private key' do
      let(:private_key) { Solana::Keys::PrivateKey.generate }
      
      it 'creates a keypair with the given private key' do
        keypair = described_class.new(private_key.to_uint8)

        expect(keypair.private_key.to_bytes).to eq(private_key.to_bytes)
        expect(keypair.public_key.to_bytes).to eq(private_key.public_key.to_bytes)
      end
    end

    context 'without a private key' do
      it 'generates a new random keypair' do
        keypair = described_class.new
        expect(keypair.public_key).not_to be_nil
        expect(keypair.private_key).not_to be_nil
      end
    end
  end

  describe '#sign' do
    let(:keypair) { described_class.generate }
    let(:message) { "Hello, Solana!" }

    it 'signs a message using the private key' do
      signature = keypair.sign(message)
      expect(signature).to be_a(Solana::Keys::Signature)
    end

    it 'produces verifiable signatures' do
      signature = keypair.sign(message)
      expect(signature.verify(message, keypair.public_key)).to be true
    end
  end

  describe '.load_from_file' do
    let(:keypair) { described_class.generate }
    let(:temp_path) { 'tmp_keypair.json' }
  
    after do
      File.delete(temp_path) if File.exist?(temp_path)
    end
  
    it 'loads a keypair from a JSON file' do
      keypair.save_to_file(temp_path)
      loaded_keypair = described_class.load_from_file(temp_path)
      
      expect(loaded_keypair.public_key.to_bytes).to eq(keypair.public_key.to_bytes)
      expect(loaded_keypair.private_key.to_bytes).to eq(keypair.private_key.to_bytes)
    end
  end
  
  describe '#save_to_file' do
    let(:keypair) { described_class.generate }
    let(:temp_path) { 'tmp_keypair.json' }
  
    after do
      File.delete(temp_path) if File.exist?(temp_path)
    end
  
    it 'saves the keypair to a JSON file' do
      keypair.save_to_file(temp_path)
      expect(File.exist?(temp_path)).to be true
      
      json_data = JSON.parse(File.read(temp_path))
      expect(json_data.length).to eq(64)  # 32 bytes private + 32 bytes public
      expect(json_data).to all(be_a(Integer))
      expect(json_data).to all(be >= 0)
      expect(json_data).to all(be <= 255)
    end
  end
end