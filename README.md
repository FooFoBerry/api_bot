A bot to autopopulate commits and events for FooFoBerry to be used for demo
purposes of the app's real time capabilites.

To run cd into the root of the project and run

```
# FOR LOCAL DEV
irb -r ./lib/api_bot.rb

> bot = ApiBot.new(:dev)
> 10.times { bot.make_commit_and_event }
```

```
# FOR PROD
irb -r ./lib/api_bot.rb

> bot = ApiBot.new
> 10.times { bot.make_commit_and_event }
```

Defaults are to make a commit on repo.id = 1 and make a tracker\_event on pt\_project_id = 1
