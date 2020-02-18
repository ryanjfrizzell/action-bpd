FROM docker:stable
RUN mkdir /bpd
COPY entrypoint.sh /bpd/entrypoint.sh
ENTRYPOINT ["/bpd/entrypoint.sh"]
