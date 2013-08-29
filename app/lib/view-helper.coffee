# Application-specific view helpers
# http://handlebarsjs.com/#helpers
# --------------------------------

# Map helpers
# -----------

# Make 'with' behave a little more mustachey.
Handlebars.registerHelper 'with', (context, options) ->
  if not context or Handlebars.Utils.isEmpty context
    options.inverse(this)
  else
    options.fn(context)

# Inverse for 'with'.
Handlebars.registerHelper 'without', (context, options) ->
  inverse = options.inverse
  options.inverse = options.fn
  options.fn = inverse
  Handlebars.helpers.with.call(this, context, options)

# Get Chaplin-declared named routes. {{url "likes#show" "105"}}
Handlebars.registerHelper 'url', (routeName, params..., options) ->
  Chaplin.helpers.reverse routeName, params

moment.lang 'en',
  calendar :
    lastDay : '[Yesterday at] LT'
    sameDay : '[Today at] LT'
    nextDay : '[Tomorrow at] LT'
    lastWeek : '[last] dddd [at] LT'
    nextWeek : 'dddd [at] LT'
    sameElse : 'L [at] LT'

Handlebars.registerHelper 'timely', (options) ->
  string = options.fn this
  timely = moment(string).calendar()
  safe = new Handlebars.SafeString timely
  safe.string