A bot to autopopulate commits and events for FooFoBerry to be used for demo
purposes of the app's real time capabilites.

To run cd into the root of the project and run

```
irb -r ./lib/api_bot.rb

> bot = ApiBot.new
> 10.times { bot.make_commit_and_event }
```
