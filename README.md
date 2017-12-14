# centralbank library / gem and command line tool

print your own money / cryptocurrency; run your own federated central bank nodes on the blockchain peer-to-peer over HTTP; revolutionize the world one block at a time


* home  :: [github.com/openblockchains/centralbank](https://github.com/openblockchains/centralbank)
* bugs  :: [github.com/openblockchains/centralbank/issues](https://github.com/openblockchains/centralbank/issues)
* gem   :: [rubygems.org/gems/centralbank](https://rubygems.org/gems/centralbank)
* rdoc  :: [rubydoc.info/gems/centralbank](http://rubydoc.info/gems/centralbank)




## Development 

For local development - clone or download (and unzip) the centralbank code repo.
Next install all dependencies using bundler with a Gemfile e.g.:

``` ruby
# Gemfile

source "https://rubygems.org"

gem 'sinatra'
```

run

```
$ bundle       ## will use the Gemfile (see above)
```

and now you're ready to run your own centralbank server node. Use the [`config.ru`](config.ru) script for rack:

``` ruby
# config.ru

$LOAD_PATH << './lib'

require 'centralbank'

run Centralbank::Service
```

and startup the money printing machine using rackup - the rack command line tool:

```
$ rackup       ## will use the config.ru - rackup configuration script (see above).
```

In your browser open up the page e.g. `http://localhost:9292`. Voila!

![](centralbank.png)


Happy mining! 



## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `centralbank` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.
