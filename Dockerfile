#FROM erlang:onbuild
FROM erlang:17
RUN cd /usr/src && git clone https://github.com/rebar/rebar.git
RUN cd /usr/src/rebar && ./bootstrap
WORKDIR /usr/src/app
COPY apps/erlblog/src/* /usr/src/app/apps/erlblog/src/
COPY rebar.config /usr/src/app/
RUN mkdir rel
RUN cd rel && /usr/src/rebar/rebar create-node nodeid=erlblog
COPY rel/reltool.config  /usr/src/app/rel
RUN /usr/src/rebar/rebar clean
RUN /usr/src/rebar/rebar get-deps compile
RUN /usr/src/rebar/rebar generate
EXPOSE 8081
CMD ["rel/erlblog/bin/erlblog", "console"]
