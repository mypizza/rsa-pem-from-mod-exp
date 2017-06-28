require 'base64'

module RsaPemFromModExp
  class Pem
    class << self
      def from(mod, exp)
        encoded_pubkey = create_encoded_pubkey_from(mod, exp)
        der_b64 = hex_to_base64_digest encoded_pubkey

        pem_padding_for der_b64
      end

      private

      def create_encoded_pubkey_from(mod, exp)
        modulus = Base64.urlsafe_decode64(mod)
        exponent = Base64.urlsafe_decode64(exp)

        modulus_hex = prepad_signed(base64_to_hex_digest modulus)
        exponent_hex = prepad_signed(base64_to_hex_digest exponent)

        modlen = modulus_hex.length / 2
        explen = exponent_hex.length / 2

        encoded_modlen = encode_length_hex(modlen)
        encoded_explen = encode_length_hex(explen)

        full_hex_len = modlen + explen + encoded_modlen.length/2 + encoded_explen.length/2 + 2
        encoded_hex_len = encode_length_hex(full_hex_len)

        "30#{encoded_hex_len}02#{encoded_modlen}#{modulus_hex}02#{encoded_explen}#{exponent_hex}"
      end

      def pem_padding_for(der_b64)
        "-----BEGIN RSA PUBLIC KEY-----\n#{add_newlines der_b64}\n-----END RSA PUBLIC KEY-----"
      end

      def add_newlines(der_b64)
        der_b64.scan(/.{1,64}/).join("\n")
      end

      def prepad_signed(hex)
        msb = hex[0]
        if (msb < '0' || msb > '7')
          pad(hex, '00')
        else
         hex
        end
      end

      def encode_length_hex(der_len)
        # encode ASN.1 DER length field

        if short_form? der_len
          int_to_hex(der_len)
        else
          number_hex = int_to_hex(der_len)
          length_of_length_byte = 128 + number_hex.length/2

          "#{int_to_hex(length_of_length_byte)}#{number_hex}"
        end
      end

      def short_form?(asn1_der_length)
        asn1_der_length <= 127
      end

      def pad(hex, padding)
        "#{padding}#{hex}"
      end

      def int_to_hex(int)
        number_hex = int.to_s(16)
        number_hex.length.odd? ? pad(number_hex, '0') : number_hex
      end

      def hex_to_base64_digest(hex)
        # https://stackoverflow.com/questions/9986971/converting-a-hexadecimal-digest-to-base64-in-ruby
        [[hex].pack("H*")].pack("m0")
      end

      def base64_to_hex_digest(base64)
        # http://anthonylewis.com/2011/02/09/to-hex-and-back-with-ruby/
        base64.unpack('H*').first
      end
    end
  end
end
