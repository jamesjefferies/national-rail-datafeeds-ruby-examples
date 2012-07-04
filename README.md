
National Rail datafeeds
=======================

You may have read one of the recent [articles](http://www.techweekeurope.co.uk/news/network-rail-open-data-feeds-83128)  about how Network Rail is opening up a number of it's datafeeds for developers to use. This repo contains my initial experiment in processing the datafeed data.

There are two types of data produced, one on a pub/sub basis using the [stomp](http://stomp.github.com)  protocol, the other downloading files from S3. This is about the former, using stomp.

You can download the [developer pack](http://www.networkrail.co.uk/data-feeds/), register and get started yourself. I'd use my ruby example though, changing the topic to which ever ones you have subscribed to.

Getting started
---------------

This is a ruby example so you need Ruby installed (I'm using 1.9.3 via RVM), rubygems installed and the stomp ruby gem installed `gem install stomp`

You will of course, also need to have signed up to the Network Rail datafeed programme and have your login credentials.
