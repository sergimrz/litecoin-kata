# litecoin-kata

On this kata are training the following concepts

## Dockerization
We dockerized the Litecoin 0.18.1 validating the binaries with PGP and running the application with a normal user following some DevSecOps good practices. Some remarkable notes on this point are the next:
* We weren't able to run the release litecoin-0.18.1-x86_64-linux-gnu in a lightweight distribution as alpine so we used a debian to not fight with distributions incompatibilities.
* Also we found that the command "gpg --recv-key FE3348877809386C" specified in the litecoin PGP Instructions (https://download.litecoin.org/README-HOWTO-GPG-VERIFY-TEAM-MEMBERS-KEY.txt) returns timeout ocasionally so we copied manually the public key. This is not the best scenario as someone could compromise the key.
