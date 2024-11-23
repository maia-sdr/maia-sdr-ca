# Maia SDR CA

**WARNING:** Before proceeding, please understand the security implications of
installing a CA certificate in your device. See the security considerations
below for more details.

## Introduction

The Maia SDR CA is used to sign SSL certificates that are used within the Maia
SDR project. An SSL certificate is needed to use some features of maia-wasm, the
web UI of Maia SDR:

- [Progressive Web
  App](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps)
  (PWA). A PWA can be installed to an Android or iOS device (and in some cases
  also to a desktop computer). It enables the Maia SDR web UI to run without
  displaying the web browser bar and other UI elements, which occupy valuable
  screen space. See the [Maia SDR demo
  video](https://www.youtube.com/watch?v=pEthYJoAqII) for how this looks
  like. Unfortunately, current web browsers require PWAs to be accessed by HTTPS
  with a valid certificate to be installable (a self-signed certificate is not
  allowed, except for an app running on `localhost`, which is an exception for
  local development). This was not the case when Maia SDR was first released in
  2023. It could be installed as a PWA through HTTP on Android Chrome.

- [HTML 5 Geolocation
  API](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation_API). This
  is used by the Maia SDR web UI to obtain the current location of the device
  (using GPS and other sensors), which is optionally added to the metadata in
  SigMF recordings. Using the Geolocation API requires accessing the web app
  through HTTPS, although self-signed certificates are allowed (as long as the
  user accepts them manually to access the web app).

For this reason, the Maia SDR project provides a CA certificate that is used to
sign SSL certificates as needed by the project.

## Installation of CA certificate on Android

First download the file [`maia_sdr_ca.crt`](maia_sdr_ca.crt) to your device.

Then go to the Android Settings and navigate to "Passwords & security >
Privacy > More security settings > Encryption and credentials >
Install a certificate > CA certificate". Select "Install anyway" in the
security warning, confirm your PIN, and choose the `maia_sdr_ca.crt` file.

The CA certificate can be uninstalled at any time by navigating to "Passwords &
security > Privacy > More security settings > Encryption and credentials >
Trusted credentials", selecting the "User" tab, clicking on the Maia SDR
certificate, and choosing "Uninstall".

## Security considerations

The private key for the CA is stored in encrypted form in the repository
[daniestevez/maia-sdr-ca-private](https://github.com/daniestevez/maia-sdr-ca-private),
which is included as a git submodule in the directory `private` in this
repository. The repository `daniestevez/maia-sdr-ca-private` is a private Github
repository to which only [Daniel Estévez](https://github.com/daniestevez/) has
access. The private key is stored in this repository encrypted with the GPG key
`A718425BBA6A583AD151EEC3DB530987B94299D2`, which is only owned by Daniel
Estévez.

The commands used to generate the CA key and the certificates are included as a
[`Makefile`](Makefile) in this repository, giving full transparency to how the
process works. The private key for the CA is the only file that is not publicly
available.

All the certificates that have been signed with the CA key, as well as their
private keys are included in the [`certs`](certs) directory in this
repository. A list is provided below describing how each of these certificates
is used in the Maia SDR project. New certificates that are signed by the CA will
also be included and listed in this repository, so that the list of certificates
that have been signed is always available.

Certificates are signed for very long durations, such as 20000 days for the CA
certificate and 10000 days for other certificates, to avoid having to renew the
certificates during the lifetime of the project.

Since private keys for certificates are publicly available, a user that has
installed the Maia SDR CA certificate on their device should assume that an
attacker has access to these keys and their certificates (but not to the CA
private key). Therefore, the user should not trust that a connection to any of
the CNs used in these certificates (which are listed below) does not have a
man-in-the-middle attack. Realistically speaking, the attack surface is low,
because the Maia SDR CA only signs certificates for private IP addresses.

All the commits in this repository are to be signed with the GPG key with
fingerprint `A718425BBA6A583AD151EEC3DB530987B94299D2`.

## Certificates signed by the Maia SDR CA

- [SSL certificate for
  maia-httpd](https://github.com/maia-sdr/maia-sdr/tree/main/maia-httpd/src/httpd/ssl):
  `certs/maia_httpd.{crt,key}`. This certificate is used by maia-httpd to run a
  HTTPS server on port 443. The private key is publicly available. The CN for
  this certificate is `maia-httpd`. All the 256 IP addresses matching
  `192.168.*.1` are included as Subject Alternative Names. These is the set of
  IP addresses normally used by Maia SDR.
