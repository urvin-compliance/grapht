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

logError = (message, trace) ->
  console.log "<ERROR>", message

  if trace
    traceString = trace.map (t) ->"\t#{t.file}: on line: #{t.line}"
    console.log traceString.join('\n')

  phantom.exit(1)

wrapGraphDef = (def) ->
  "function() { (#{def}).apply(this, arguments); return document.body.innerHTML; }"

page.libraryPath = vendorPath
page.onError     = logError

dependencies.forEach (dp) -> page.injectJs(dp) || logError "could not load #{dp}!"

graphDef = fs.read("#{libPath}graph-definitions/#{graphType}.js")
content  = page.evaluate(wrapGraphDef(graphDef), JSON.parse(graphData))

fs.write '/dev/stdout', "#{content}\n"
phantom.exit()
