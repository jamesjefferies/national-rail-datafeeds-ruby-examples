
National Rail datafeeds
=======================

You may have read one of the recent [articles](http://www.techweekeurope.co.uk/news/network-rail-open-data-feeds-83128)  about how Network Rail is opening up a number of it's datafeeds for developers to use. This repo contains my initial experiment in processing the datafeed data.

There are two types of data produced, one on a pub/sub basis using the [stomp](http://stomp.github.com)  protocol, the other downloading files from S3. This is about the former, using stomp.

You can download the [developer pack](http://www.networkrail.co.uk/data-feeds/), register and get started yourself. I'd use my ruby example though, changing the topic to which ever ones you have subscribed to.

Getting started
---------------

This is a ruby example so you need Ruby installed (I'm using 1.9.3 via RVM), rubygems installed and the stomp ruby gem installed `gem install stomp`

You will of course, also need to have signed up to the Network Rail datafeed programme and have your login credentials.

Receiving messages
------------------

Before running the code, ensure you have set the environment variables for your login credentials.

All being well, you should then slowly receive updates from the topic you have selected. The example below uses Train positioning data for the East Midlands (TD_MC_EM_SIG_AREA) and assumes that you have subscribed to that feed using the [network rail control panel](https://datafeeds.networkrail.co.uk/ntrod/myFeeds)

The updates you receive from this program are not formatted at all, it's just sending the message straight to string. Of course, this is just helping you know you're set up correctly. So you would get something like:

`<Stomp::Message headers={"message-id"=>"ID:blahblah", "destination"=>"/topic/TD_MC_EM_SIG_AREA", "timestamp"=>"1341436026840", "expires"=>"1341436326840", "persistent"=>"true", "priority"=>"4"} body='[{"CA_MSG":{"to":"1234","time":"1341435963000","area_id":"WH","msg_type":"CA","from":"5678","descr":"1Z99"}}]' command='MESSAGE' >`

Ultimately of course, you'd process the JSON from the body.
