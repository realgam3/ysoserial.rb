FROM ruby:2.6.8-alpine3.13

WORKDIR /usr/src/app

COPY . .

RUN adduser -u 9000 -D app; \
    chown -R app:app /usr/src/app; \
    chmod -R +x /usr/src/app/bin
USER app

RUN bundle install --jobs 4

ENTRYPOINT [ "/usr/src/app/bin/ysoserial" ]