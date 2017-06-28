require 'base64'

def prepad_signed(hexStr)
  msb = hexStr[0]
  if (msb < '0' || msb > '7')
    '00' + hexStr
  else
   hexStr
  end
end

def encode_length_hex(n)
  if (n<=127)
    return int_to_hex(n)
  else
    n_hex = int_to_hex(n)
    length_of_length_byte = 128 + n_hex.length/2
    return int_to_hex(length_of_length_byte)+n_hex
  end
end

def int_to_hex(int)
  number_hex = int.to_s(16)
  number_hex.length.odd? ? '0' + number_hex : number_hex
end

def hex_to_base64_digest(hex)
  # https://stackoverflow.com/questions/9986971/converting-a-hexadecimal-digest-to-base64-in-ruby
  [[hex].pack("H*")].pack("m0")
end

def base64_to_hex_digest(base64)
  # http://anthonylewis.com/2011/02/09/to-hex-and-back-with-ruby/
  base64.unpack('H*').first
end

mod = "iz7sYHwIcY9XIvDJ_s7ujJnL-OPrSApxyR9cUmhB_YazFhFQOEBHviib46CwY-RLfTfsL6tBwZsI10RtgwVUGjZZ41G6gaZwzGtrrwRvx22_X1GROb1UO5wu0GVJKSD_9Hf7-SnzwkzJ73OiQAFkegiKqghDCRKRxlKQzRFIpdgXuSfdDxy7MPhhKC3YGfKj2S4jaNzNxFJm-8dY-oa2-7f2qQvgXvVnEnFG72FbJChy_Ol7cXkpXf03v6gRMOm8dQIrWh3VhRSm5HJNoOZb2X8Ubc6o-6CDN7OJFZMKlgNuLKT3s3xpY5j7qbvhMANOhAgPpYlDJTR9FHFFFRPFew"
exp = "AQAB"

modulus = Base64.urlsafe_decode64(mod)
exponent = Base64.urlsafe_decode64(exp)

modulus_hex = prepad_signed(base64_to_hex_digest modulus)
# "008b3eec607c08718f5722f0c9feceee8c99cbf8e3eb480a71c91f5c526841fd86b3161150384047be289be3a0b063e44b7d37ec2fab41c19b08d7446d8305541a3659e351ba81a670cc6b6baf046fc76dbf5f519139bd543b9c2ed065492920fff477fbf929f3c24cc9ef73a24001647a088aaa0843091291c65290cd1148a5d817b927dd0f1cbb30f861282dd819f2a3d92e2368dccdc45266fbc758fa86b6fbb7f6a90be05ef567127146ef615b242872fce97b7179295dfd37bfa81130e9bc75022b5a1dd58514a6e4724da0e65bd97f146dcea8fba08337b38915930a96036e2ca4f7b37c696398fba9bbe130034e84080fa5894325347d1471451513c57b"

exponent_hex = prepad_signed(base64_to_hex_digest exponent)
# "010001"

modlen = modulus_hex.length / 2
explen = exponent_hex.length / 2

encoded_modlen = encode_length_hex(modlen)
encoded_explen = encode_length_hex(explen)

# BUG HERE:
encoded_hex_len = encode_length_hex(modlen + explen + encoded_modlen.length/2 + encoded_explen.length/2 + 2) # SHOULD BE 82010a
encoded_pubkey = "30#{encoded_hex_len}02#{encoded_modlen}#{modulus_hex}02#{encoded_explen}#{exponent_hex}"
# =========

der_b64 = hex_to_base64_digest encoded_pubkey

pem = "-----BEGIN RSA PUBLIC KEY-----\n#{der_b64.scan(/.{1,64}/).join("\n")}\n-----END RSA PUBLIC KEY-----"

expected_pem = "-----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEAiz7sYHwIcY9XIvDJ/s7ujJnL+OPrSApxyR9cUmhB/YazFhFQOEBH
viib46CwY+RLfTfsL6tBwZsI10RtgwVUGjZZ41G6gaZwzGtrrwRvx22/X1GROb1U
O5wu0GVJKSD/9Hf7+SnzwkzJ73OiQAFkegiKqghDCRKRxlKQzRFIpdgXuSfdDxy7
MPhhKC3YGfKj2S4jaNzNxFJm+8dY+oa2+7f2qQvgXvVnEnFG72FbJChy/Ol7cXkp
Xf03v6gRMOm8dQIrWh3VhRSm5HJNoOZb2X8Ubc6o+6CDN7OJFZMKlgNuLKT3s3xp
Y5j7qbvhMANOhAgPpYlDJTR9FHFFFRPFewIDAQAB
-----END RSA PUBLIC KEY-----"

pem == expected_pem
