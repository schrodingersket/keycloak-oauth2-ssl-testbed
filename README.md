# Keycloak OAuth2 SSL Testbed

A barebones (but fully-featured) ephemeral test environment for working with a real operational
OAuth2 SSL server.

## Purpose

This repository aims to provide a testbed for the following use cases:

- Verifying OAuth2 and OpenID Connect client behavior.
- Verification (or lack thereof) of server SSL certificates.
- Verification of SSL chain of trust with a custom certificate authority (CA) bundle.

## Features

- Full implementation of OAuth2 and OpenID Connect protocols, thanks to
  [Keycloak](https://www.keycloak.org/).
- Containerized and ephemeral runtime in [Docker](https://www.docker.com/).
- Self-signed certificates with an included CA for SSL verification chain testing.
- Pre-populated [Insomnia](https://insomnia.rest/) environment to immediately try out authorization
  requests.
  
## Getting Started

If you haven't already [installed Docker](https://docs.docker.com/get-docker/), you'll need to do
that now. Then, grab your nearest and dearest terminal emulator, and run:

```shell script
./run.sh
```

After a minute or so, you'll have a Keycloak instance happily running at https://localhost:8443,
which is configured to use the certificates found in the `certs/` directory. You can log in to the
Keycloak's admin console by navigating to https://localhost:8443/auth/admin/, though doing so is not
necessary to utilize this testbed.

The default credentials (which can be changed by modifying the relevant environment variables in
`run.sh`) are:

```shell script
u: admin
p: admin
````

### Testing with Insomnia

Now that you have a fully-functional OAuth2 server configured with SSL running, let's test it out!
This repository is pre-configured for use with the Insomnia REST client, so we're going to run
through a couple of requests using that. If you'd like to use a different REST client, the
OpenID Connect Discovery URL for Keycloak's `master` realm (which contains all relevant OAuth2 URLs)
can be found on your Keycloak server at:

https://localhost:8443/auth/realms/master/.well-known/openid-configuration

Two methods of importing a collection are supported by this repository:

1) File Import
2) Git Sync

Only the former will be covered in this section, but this repository is configured as an Insomnia 
Git repository, and can therefore be managed via
[Git Sync](https://support.insomnia.rest/article/193-git-sync).

To get started with the File Import, start by navigating to the `Dashboard` view in the Insomnia
application, click the `Create` button, and then select the `File` option:

![File Import](screenshots/FileImport.png?raw=true "File Import")

Navigate to this repository, and import `Insomnia_2021-09-03_v2021.5.2.json`.

Once the import is complete, you should see something like after navigating to the `Debug` tab:

![Debug Screen](screenshots/DebugScreen.png?raw=true "Debug Screen")

You should now be all set to test out the requests on the left side of the screen. Note that by
default, these requests will fail since Keycloak is configured with self-signed certs; this is
intentional, as one of the express purposes of this environment is to test out SSL verification.

We can disable SSL verification for requests with Insomnia via two options in the settings dialog;
the first is the `Validate certificates` option, which can be found in the `Request/Response`
section and should be left unchecked - this disables SSL verification for the request itself 
(which in this case is the `/userinfo` endpoint):

![Validate Certificates Setting](screenshots/ValidateCertificatesSetting.png?raw=true "Validate Certificates Setting")

The second option - `Validate certificates during authentication` - disables SSL verification for
requests made during authentication, and can be found in the `Security` section. This option should
also be unchecked:

![Validate Authentication Certificates Setting](screenshots/ValidateAuthenticationCertificatesSetting.png?raw=true "Validate Authentication Certificates Setting")

Once you've made these changes, you should be all set to make any of the requests on the left 
in the `Get User Info` folder. As their respective names imply, these requests demonstrate the
`Authorization Code` and `Resource Owner Password Credentials` OAuth2 flows.

Happy testing!

#### A Quick Note on Certificate Generation

All of the certificates in this repository were generated with the `certs/generate-openssl-certs.sh`
script, which is included in this repository for reference. The root certificate authority and
server certificates are each configured to be valid for 10 years, and will expire on
September 3rd, 2031. If you'd like to generate new certificates for testing (for instance, to test
authentication against expired certificates), you can simply modify and re-run the certificate
generation script. If you have a running Keycloak server, you'll need to stop and restart that after
generating the new certificates in order for those new certificates to take effect. Note that the
certificate authority is also re-generated, so if you have imported that into any system trusts,
you'll need to delete the old one and re-add the new root certificate authority.
