page          = require('webpage').create()
system        = require('system')
fs            = require('fs')

thisFile      = system.args[0]
graphType     = system.args[1]
graphFormat   = false
dependencies  = ['d3.min.js', 'json2.js']

scriptPath    = fs.absolute(thisFile).replace(/[\w\s\-\.]+?\.(js|coffee)$/i, '')
vendorPath    = "#{scriptPath}../vendor/"
defsPath      = "#{scriptPath}../lib/graph-definitions/"
userDefsPath  = system.env['EXT_GRAPHT_DEFINITIONS_HOME']
niceDirPathRX = /\/$|$/
naughtyPathRX = /(?:\.{1,2}\/)+/



#------------------------------------------------------------------------------
# Helper Functions
#------------------------------------------------------------------------------

fns =
  # Logs the supplied message (and, optionally, the trace) to STDERR; then, 
  # exits the process with the supplied code.
  #
  # Return Codes:
  #    0 - Success
  #    1 - Naughty Type Path Error
  #    2 - Graph Defintion Not Found Error
  #    3 - Graph Dependency Load Error
  #    4 - Graph Data Not Found Error
  #    5 - Graph Data Parse Error
  #   99 - Unexpected Error
  #
  logError: (message, code, trace) ->
    fs.write '/dev/stderr', "<ERROR> #{message}\n"
    fs.write '/dev/stderr', formattedTrace(trace) if trace
    phantom.exit(code || 99)


  # Returns a formatted version of the trace object so it can 
  # be sent to std out.
  #
  formattedTrace: (trace) ->
    traceString = trace.map (t) -> "\t#{t.file}: on line: #{t.line}"
    traceString.join('\n')

    
  # Scrubs-out any leading '/' characters from the type, and raises an error
  # if any naughtier path manipulation is detected.
  #
  sanitizeType: (type) ->
    if naughtyPathRX.test(type)
      @logError('Naughty! There will be no backing out of the definition directory!', 1)

    type.replace(/^\/+/, '')


  # Searchs for a valid graph definition in the supplied definition paths.  If
  # no definition is found, we log an error to STDERR.
  #
  findDef: (type, defPaths...) ->
    type = @sanitizeType(type)

    for dir in defPaths when dir?
      dir   = dir.replace(niceDirPathRX, '/')
      path  = "#{dir}#{type}.js"
      return path if fs.exists(path)

    @logError("No graph definition could be found for '#{type}'", 2)


  # Reads in the graph defintion file.
  #  
  loadDef: (def) -> 
    fs.read(def)


  # Wraps the supplied graph definition in a function that executes the definition
  # and returns the resulting content of the document body.  This function is intended
  # to minimize boiler-plate in graph definitions, and reduce the likelihood of user
  # error.
  #
  wrapDef: (def) ->
    "function() {
      (#{def}).apply(this, arguments);
      return document.body.innerHTML;
    }"

  # Returns a hash composed of any optional arguments sent
  # with a command.
  #
  getOptions: ->
    optionsIn   = system.args[2..]
    optionsOut  = {}
    slice       = 2

    for i in [0...optionsIn.length] by slice
      [key, value]    = optionsIn[i...i+slice]
      optionsOut[key] = value

    optionsOut


  # Returns the value of the format option (nil if not
  # provided)
  #
  getFormat: ->
    options = @getOptions()
    options['-f'] || options['--format']


  # Returns the value of the include option (nil if not
  # provided)
  #
  getInclude: ->
    options = @getOptions()
    options['-i'] || options['--include']


  # Reads in json data for the graph.
  #
  readDataIn: ->
    try
      if (data = fs.read('/dev/stdin')).length
        data
      else
        fns.logError('No graph data was received!')

    catch err
      @logError(err, 4)


  # Renders the graph output based on the arguments and 
  # options provided.
  #
  renderGraph: ->
    # Load all dependencies.
    dependencies.forEach (dp) ->
      page.injectJs(dp) || fns.logError("Dependency could not be loaded: #{dp}", 3)
    
    # Load and evaluate the graph definition within the context of the 
    # arguments supplied via STDIN. Set the page content.
    graphData   = fns.readDataIn()
    graphDef    = fns.wrapDef fns.loadDef fns.findDef(graphType, userDefsPath, defsPath)
    parsedData  = try
                    JSON.parse(graphData)
                  catch err
                    fns.logError(err, 5)
    page.content = content = page.evaluate(graphDef, parsedData) 
    
    # Write resulting content to stdout.
    if graphFormat = fns.getFormat()
      page.render '/dev/stdout', { format: graphFormat, quality: 100 }
    else
      fs.write '/dev/stdout', "#{content}\n"
      
    # Exit with success code
    phantom.exit(0)
    
        
      
#------------------------------------------------------------------------------
# Core Graph Generation Logic
#------------------------------------------------------------------------------

# Configure the page context.
page.libraryPath = vendorPath
page.onError     = fns.logError

# Render the graph to std out. If include option provided, pull that
# in and render graph via callback.
if included_file = fns.getInclude()
  page.includeJs(included_file, fns.renderGraph)
else
  fns.renderGraph()
