Soapy
=====

A collection of software that will help me sell my mother's homemade soap bars.

How to do stuff
---------------

All these scripts are meant to be run from the top-level.

### deploy the site


```
pushd src/ansible
$ (export WEBSERVER_PUBLIC_DNSNAME=soapshop.pb.co.za WEBSERVER_PUBLIC_PORT=443; ../../render.sh && ansible-playbook provision_web.yml --tags=copy-html && terminal-notifier -title "Done" -message "deploy finished" -appIcon ~/Source/seep-besigheid/output/hugo/apple-touch-icon.png -open "$WEBSERVER_PUBLIC_DNSNAME")
popd
```

Reason for existence
--------------------

My mother has been making high quality soap at home for a few years. As she has been trying different recipes and trying out different ideas, she's been getting us (her family) to try it out and we all love it! Also, her personality is such that she enjoys sharing her joy and she has been doing that by gifting soap througout her current network by giving it away to friends and family. This network is not large enough for the supply.

My aim in this is to secure my future supply of good body soap. In order to do that, I have to achieve exactly two things:

 - Help my mother make as much soap as gives her pleasure, so she can make it well
 - Balance the demand for good soap with the supply of good soap, so that no precious resource is wasted
 
In economic terms: Soap goes left, money goes right, such that left and right stays in balance.

Software use cases
------------------

 - Enable the announcement of new batches of soap
 - Enable an open bidding process, to fullfill the demand
 - Enable a referral process that grows the demand-side network

Content License
---------------

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">soapy</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://pb.co.za/" property="cc:attributionName" rel="cc:attributionURL">Pieter Breed</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

The full text of the license can be found inside this repo in a file called `LICENSE.md`.


