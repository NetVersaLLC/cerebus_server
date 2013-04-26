#!/usr/bin/env ruby

require 'openssl'

module Cerebus
  VERSION = "0.0.3"

  def Cerebus.make_key
    OpenSSL::Random.random_bytes(56)
  end
  def Cerebus.decrypt_blowfish(data, key)
    cipher     = OpenSSL::Cipher::Cipher.new('bf-cbc').decrypt
    cipher.key = Digest::MD5.digest key.to_s
    cipher.update(data) << cipher.final
  end
  def Cerebus.decrypt_rsa(data, key_filename, passphrase)
    opri       = OpenSSL::PKey::RSA.new( File.read(key_filename), passphrase )
    opri.private_decrypt data
  end
  def Cerebus.encrypt_blowfish(data, key)
    cipher     = OpenSSL::Cipher::Cipher.new('bf-cbc').encrypt
    cipher.key = Digest::MD5.digest key
    cipher.update(data) << cipher.final
  end
  def Cerebus.encrypt_rsa(data, key_filename)
    opri       = OpenSSL::PKey::RSA.new File.read key_filename
    opri.public_encrypt data
  end
  def Cerebus.encrypt(data, key_filename)
    key            = Cerebus.make_key
    encrypted_key  = Cerebus.encrypt_rsa(key, key_filename).unpack("H*")[0]
    encrypted_data = Cerebus.encrypt_blowfish(data, key).unpack("H*")[0]
    (encrypted_key.to_s + encrypted_data.to_s)
  end
  def Cerebus.decrypt(incoming, key_filename, passphrase)
    data           = StringIO.new(incoming)
    encrypted_key  = [data.read(512)].pack("H*")
    encrypted_data = [data.read].pack("H*")
    decrypted_key  = Cerebus.decrypt_rsa(encrypted_key, key_filename, passphrase)
    decrypted_data = Cerebus.decrypt_blowfish(encrypted_data, decrypted_key)
  end
end
