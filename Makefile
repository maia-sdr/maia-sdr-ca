all:

ca:
	rm -f private/maia_sdr_ca.key.enc
	openssl req -x509 -noenc -days 20000 -newkey rsa:4096 \
            -subj "/C=ES/ST=Madrid/L=Madrid/O=Maia SDR/OU=Maia SDR CA/CN=Maia SDR CA" \
	    -keyout - -out maia_sdr_ca.crt \
            -reqexts v3_req -extensions v3_ca \
	| gpg --batch --encrypt --recipient A718425BBA6A583AD151EEC3DB530987B94299D2 \
            --output private/maia_sdr_ca.key.enc

maia-httpd:
	openssl req -new -noenc -newkey rsa:4096 \
            -subj "/C=ES/ST=Madrid/L=Madrid/O=Maia SDR/OU=maia-httpd/CN=maia-httpd" \
            -config configs/maia-httpd.txt \
	    -keyout certs/maia_httpd.key -out maia_httpd.csr
	gpg --batch --decrypt private/maia_sdr_ca.key.enc \
	| openssl x509 -req -days 10000 -copy_extensions copyall \
	    -in maia_httpd.csr -CA maia_sdr_ca.crt -CAkey /dev/stdin \
	    -CAcreateserial -CAserial ca/maia_sdr_ca.srl -out certs/maia_httpd.crt
	rm -f maia_httpd.csr

.PHONY: ca maia-httpd
