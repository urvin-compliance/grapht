<img src='http://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Graft_182_%28PSF%29.png/320px-Graft_182_%28PSF%29.png' style='width: 320px; margin: 0 auto; display: block;'/>

# Grapht

Grapht is a server-side graphing library built on [PhantomJS](https://github.com/ariya/phantomjs/wiki)
and utilizing [D3.js](http://d3js.org/).

### CLI

#### Single Argument

Grapht provides a CLI, accessed using the `bin/grapht` command.  The basic invocation
requires one argument specifying the desired graph type, and a JSON string provided
via `STDIN`.  For example, if we want a **bar graph**:

    bin/grapht bar < ~/my-data.json

The result will be a string of **svg** markup.
