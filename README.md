nr-datafeeds
============

National Rail datafeeds

You may have read one of the recent [articles]("http://www.techweekeurope.co.uk/news/network-rail-open-data-feeds-83128")  about how Network Rail is opening up a number of it's datafeeds for developers to use. This repo contains my initial experiment in processing the datafeed data.

There are two types of data produced, one on a pub/sub basis using the [stomp]("http://stomp.github.com")  protocol, the other downloading files from S3. This is about the former, using stomp.
