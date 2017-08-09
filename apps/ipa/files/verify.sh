#!/bin/sh

munpack -q $1 2>/dev/null

if [ ! -f ./smime.p7s ]; then
  echo "Couldn't find S/MIME certificate"
  exit 255
fi

openssl pkcs7 -in smime.p7s -inform DER -print_certs > cert.pem

if ! grep -q "BEGIN CERTIFICATE" cert.pem; then
  echo "Failed to convert S/MIME to certificates"
  exit 255
fi

if ! openssl verify -CApath /dev/null -CAfile all.pem cert.pem; then
  echo "Certificate is not signed by a DoD CA."
  exit 255
fi

cert=$(openssl x509 -in cert.pem -text -noout | grep email | cut -d ':' -f 2)
envelope=$(grep "From " email | awk '{ print $2 }' | head -1)

if ! [ "$cert" == "$envelope" ]; then 
  echo "Certificate address and envelope address do not match"
  exit 255
fi

echo "Certificate is valid."

exit 0
