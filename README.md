# rsa-pem-from-mod-exp

This gem is a Ruby translation of https://github.com/tracker1/node-rsa-pem-from-mod-exp, v0.8.4

It creates an RSA Public Key PEM from Modulus and Exponent value.

This allows you to use the modulus/exponent values for validating signed value.

# Usage

```
gem install rsa-pem-from-mod-exp

require 'rsa_pem'
```

If you're including this in a gemfile:

```
gem "rsa-pem-from-mod-exp", :git => "git://github.com/mypizza/rsa-pem-from-mod-exp.git"
```
