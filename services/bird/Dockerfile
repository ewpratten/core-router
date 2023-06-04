FROM debian:stable as builder

ARG BIRD_VERSION="2.13"
ARG BIRD_URL="https://bird.network.cz/download/bird-${BIRD_VERSION}.tar.gz"

# Get build dependencies
RUN apt-get update -y
RUN apt-get install -y build-essential
RUN apt-get install -y autoconf
RUN apt-get install -y bison
RUN apt-get install -y flex
RUN apt-get install -y libreadline-dev
RUN apt-get install -y libncurses-dev
RUN apt-get install -y m4
RUN apt-get install -y wget

# Fetch the source code
RUN wget -O /tmp/bird.tar.gz ${BIRD_URL}
RUN tar -xzf /tmp/bird.tar.gz -C /tmp

# Build the binary
WORKDIR /tmp/bird-${BIRD_VERSION}
RUN autoconf
RUN autoheader
RUN ./configure
RUN make -j $(nproc)
RUN make install

# Init a clean image
FROM debian:stable
EXPOSE 179

# Copy bird binaries
COPY --from=builder /usr/local/sbin/bird /usr/local/sbin/bird
COPY --from=builder /usr/local/sbin/birdc /usr/local/sbin/birdc

# Install runtime dependencies
RUN apt-get update -y
RUN apt-get install -y iproute2
RUN apt-get install -y bash
RUN apt-get install -y libreadline8

# Set up dirs
RUN mkdir -p /usr/local/var/run

# Copy the entrypoint script
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Run
ENTRYPOINT ["bash", "/entrypoint.sh"]
