require 'spec_helper'
require_relative '../lib/pem'

RSpec.describe RsaPemFromModExp::Pem do
  let(:modulus) { 'iz7sYHwIcY9XIvDJ_s7ujJnL-OPrSApxyR9cUmhB_YazFhFQOEBHviib46CwY-RLfTfsL6tBwZsI10RtgwVUGjZZ41G6gaZwzGtrrwRvx22_X1GROb1UO5wu0GVJKSD_9Hf7-SnzwkzJ73OiQAFkegiKqghDCRKRxlKQzRFIpdgXuSfdDxy7MPhhKC3YGfKj2S4jaNzNxFJm-8dY-oa2-7f2qQvgXvVnEnFG72FbJChy_Ol7cXkpXf03v6gRMOm8dQIrWh3VhRSm5HJNoOZb2X8Ubc6o-6CDN7OJFZMKlgNuLKT3s3xpY5j7qbvhMANOhAgPpYlDJTR9FHFFFRPFew' }
  let(:exponent) { 'AQAB' }
  let(:valid_pem) { "-----BEGIN RSA PUBLIC KEY-----\nMIIBCgKCAQEAiz7sYHwIcY9XIvDJ/s7ujJnL+OPrSApxyR9cUmhB/YazFhFQOEBH\nviib46CwY+RLfTfsL6tBwZsI10RtgwVUGjZZ41G6gaZwzGtrrwRvx22/X1GROb1U\nO5wu0GVJKSD/9Hf7+SnzwkzJ73OiQAFkegiKqghDCRKRxlKQzRFIpdgXuSfdDxy7\nMPhhKC3YGfKj2S4jaNzNxFJm+8dY+oa2+7f2qQvgXvVnEnFG72FbJChy/Ol7cXkp\nXf03v6gRMOm8dQIrWh3VhRSm5HJNoOZb2X8Ubc6o+6CDN7OJFZMKlgNuLKT3s3xp\nY5j7qbvhMANOhAgPpYlDJTR9FHFFFRPFewIDAQAB\n-----END RSA PUBLIC KEY-----" }

  it 'generates a valid PEM from a modulus and exponent' do
    pem = RsaPemFromModExp::Pem.from modulus, exponent
    expect(pem).to eq valid_pem
  end
end
