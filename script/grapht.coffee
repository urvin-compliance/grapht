page          = require('webpage').create()
system        = require('system')
fs            = require('fs')
thisFile      = system.args[0]
graphType     = system.args[1]
graphData     = fs.read('/dev/stdin')
scriptPath    = fs.absolute(thisFile)
                  .replace(/[\w\s\-\.]+?\.(js|coffee)$/i, '')
vendorPath    = "#{scriptPath}../vendor/"
libPath       = "#{scriptPath}../lib/"
dependencies  = ['d3.min.js', 'json2.js']

# Logs the supplied message, and optional trace to STDERR and exits the process
# with an exit code of 1.
logError = (message, trace) ->
  fs.write '/dev/stderr', "<ERROR> #{message}\n"

  if trace
    traceString = trace.map (t) -> "\t#{t.file}: on line: #{t.line}"
    fs.write '/dev/stderr', traceString.join('\n')

  phantom.exit(1)

# Wraps the supplied graph definition in a function that executes the definition
# and returns the resulting content of the document body.  This function is intended
# to minimize boiler-plate in graph definitions, and reduce the likelihood of user
# error.
wrapGraphDef = (def) ->
  "function() { (#{def}).apply(this, arguments); return document.body.innerHTML; }"

# Configure the page context.
page.libraryPath = vendorPath
page.onError     = logError
dependencies.forEach (dp) -> page.injectJs(dp) || logError "could not load #{dp}!"

# Build a path to the graph definition, given a graph type.  If the name of the
# type does not match the name of a definition file, raise an error and exit.
graphDefPath  = "#{libPath}graph-definitions/#{graphType}.js"
logError "No graph definition could be found for '#{graphType}'" unless fs.exists(graphDefPath)

# load and evaluate the graph definition within the context of the JSON, supplied
# via STDIN.
graphDef    = fs.read(graphDefPath)
parsedData  = try
                JSON.parse(graphData)
              catch err
                logError(err)

content     = page.evaluate(wrapGraphDef(graphDef), parsedData)

# Write resulting content to STDOUT and exit.
fs.write '/dev/stdout', "#{content}\n"
phantom.exit()
