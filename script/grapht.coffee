page          = require('webpage').create()
system        = require('system')
fs            = require('fs')
thisFile      = system.args[0]
graphType     = system.args[1]
graphFormat   = false
scriptPath    = fs.absolute(thisFile)
                  .replace(/[\w\s\-\.]+?\.(js|coffee)$/i, '')
vendorPath    = "#{scriptPath}../vendor/"
defsPath      = "#{scriptPath}../lib/graph-definitions/"
userDefsPath  = system.env['EXT_GRAPHT_DEFINITIONS_HOME']
dependencies  = ['d3.min.js', 'json2.js']
niceDirPathRX = /\/$|$/
naughtyPathRX = /(?:\.{1,2}\/)+/

# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

fns =
  # Logs the supplied message, and optional trace to STDERR and exits the process
  # with an exit code of 1.
  logError: (message, trace) ->
    fs.write '/dev/stderr', "<ERROR> #{message}\n"

    if trace
      traceString = trace.map (t) -> "\t#{t.file}: on line: #{t.line}"
      fs.write '/dev/stderr', traceString.join('\n')

    phantom.exit(1)

  # Scrubs-out any leading '/' characters from the type, and raises an error
  # if any naughtier path manipulation is detected.
  sanitizeType: (type) ->
    if naughtyPathRX.test(type)
      @logError "Naughty! There will be no backing out of the definition directory!"

    type.replace(/^\/+/, '')

  # Searchs for a valid graph definition in the supplied definition paths.  If
  # no definition is found, we log an error to STDERR and exit with an exitcode
  # of 1.
  findDef: (type, defPaths...) ->
    type = @sanitizeType(type)

    for dir in defPaths when dir?
      dir   = dir.replace(niceDirPathRX, '/')
      path  = "#{dir}#{type}.js"
      return path if fs.exists(path)

    @logError "No graph definition could be found for '#{type}'"

  loadDef: (def) -> fs.read(def)

  # Wraps the supplied graph definition in a function that executes the definition
  # and returns the resulting content of the document body.  This function is intended
  # to minimize boiler-plate in graph definitions, and reduce the likelihood of user
  # error.
  wrapDef: (def) ->
    "function() {
      (#{def}).apply(this, arguments);
      return document.body.innerHTML;
    }"

  getOptions: ->
    optionsIn   = system.args[2..]
    optionsOut  = {}
    slice       = 2

    for i in [0...optionsIn.length] by slice
      [key, value]    = optionsIn[i...i+slice]
      optionsOut[key] = value

    optionsOut

  getFormat: ->
    options = @getOptions()
    options['-f'] || options['--format']

  readDataIn: ->
    try
      if fs.size('/dev/stdin') == 0
        fns.logError('No graph data was received!')
      else
        fs.read('/dev/stdin')

    catch err
      @logError err


# -----------------------------------------------------------------------------
# Core Graph Generation Logic
# -----------------------------------------------------------------------------

# Configure the page context.
page.libraryPath = vendorPath
page.onError     = fns.logError

dependencies.forEach (dp) ->
  page.injectJs(dp) || fns.logError "could not load #{dp}!"

# load and evaluate the graph definition within the context of the JSON, supplied
# via STDIN.
graphData   = fns.readDataIn()
graphDef    = fns.wrapDef fns.loadDef fns.findDef(graphType, userDefsPath, defsPath)
graphFormat = fns.getFormat()
parsedData  = try
                JSON.parse(graphData)
              catch err
                fns.logError(err)

page.content = content = page.evaluate(graphDef, parsedData)

# Write resulting content to STDOUT and exit.
if graphFormat
  page.render '/dev/stdout', { format: graphFormat, quality: 100 }
else
  fs.write '/dev/stdout', "#{content}\n"

phantom.exit()
