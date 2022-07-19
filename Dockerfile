#Using Debian as executable didn't work in alpine
FROM debian:11.4 as build

# Update dependencies
RUN apt-get update -y && apt-get install -y gnupg wget

# Copy manually the public key from the repository as the pgp.mit.edu seems unstable.
# It's returning timeouts often
#RUN gpg --recv-key FE3348877809386C 
COPY litecoin.pub.pgp .
RUN gpg --import litecoin.pub.pgp

# Download binaries, x86_64 pgp public key and signatures and sha256sum checkums.
RUN wget https://download.litecoin.org/litecoin-0.18.1/linux/litecoin-0.18.1-x86_64-linux-gnu.tar.gz \
    && wget https://download.litecoin.org/litecoin-0.18.1/linux/litecoin-0.18.1-x86_64-linux-gnu.tar.gz.asc \
    && wget https://download.litecoin.org/litecoin-0.18.1/linux/litecoin-0.18.1-linux-signatures.asc

# Verify .asc files
RUN gpg --verify litecoin-0.18.1-linux-signatures.asc \
    && gpg --verify litecoin-0.18.1-x86_64-linux-gnu.tar.gz.asc

# Check if checksum of binaries match
RUN sha256sum -c litecoin-0.18.1-linux-signatures.asc | grep OK

RUN tar -xvzf litecoin-0.18.1-x86_64-linux-gnu.tar.gz -C /tmp \
    && mv /tmp/litecoin-0.18.1/bin/litecoind /usr/local/bin \
    && rm -r /tmp/litecoin-0.18.1

# The executable asked for this path, means so that the app is writting data here
RUN useradd -d /home/litecoin -m litecoin

# Run as normal user
USER litecoin

ENTRYPOINT ["/usr/local/bin/litecoind"]
