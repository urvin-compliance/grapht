<img src='http://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Graft_182_%28PSF%29.png/320px-Graft_182_%28PSF%29.png' style='width: 320px; margin: 0 auto; display: block;'/>

# Grapht

Grapht is a server-side graphing library built on [PhantomJS](https://github.com/ariya/phantomjs/wiki)
and utilizing [D3.js](http://d3js.org/).  Grapht provides a CLI for simple Bash scripting.
It also profides a light-weight [Ruby](https://www.ruby-lang.org/en/)
API to make service-level integration simple.

### Why was Grapht built on PhantomJS?

- PhantomJS allows us to leverage D3.js, a best-of-breed data visualization library
authored by the formidable data visualization expert, Mike Bostock.  D3.js is a
battlefield tested library.
- Using PhantomJS allows us to reuse existing data visualization logic, originally
authored for our client-side application. This means we get consistent visualizations
across the various layers of our stack, and we minimize developer effort.

### How well does Grapht perform?

While PhantomJS is able to run Javascript extremely fast, it has a slow startup
time.  When measured on a 2.4GHz Intel Core i7 laptop, with 16GB of DDR3 RAM, the
benchmarks<sup>†</sup> are as follows _(averaged over 10 runs)_:

<table style='width: 100%;'>
  <thead>
    <tr>
      <th>Bytes-In</th>
      <th>Average, Real Time <small style='color:gray;'>( Seconds )</small></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>1,323</td>
      <td>1.559</td>
    </tr>
    <tr>
      <td>13,527</td>
      <td>1.675</td>
    </tr>
    <tr>
      <td>135,252</td>
      <td>1.715</td>
    </tr>
  </tbody>
</table>

Note that even when incrementing the amount of data-in by an order of magnitude,
time increased minimally.  From this, we can infer a start-up time of ~1.5 seconds,
for PhantomJS, on the aforementioned hardware.

<sup>†</sup> _All measurements were collected using the following command: `time -p bin/grapht bar-horizontal < data/bar_data.json > /dev/null`_

## CLI

Grapht provides a CLI, accessed using the `bin/grapht` command.  The basic invocation
requires one argument specifying the desired graph type, and a JSON string provided
via `STDIN`.  For example, if we want a **horizontal bar graph**:

    bin/grapht bar-horizontal < ~/my-data.json

The result will be a string of **svg** markup:

    <svg width="200" height="200">
      <rect class="bar" x="0" y="13" width="0" height="50"></rect>
      <rect class="bar" x="0" y="75" width="200" height="50"></rect>
      <rect class="bar" x="0" y="137" width="150" height="50"></rect>
      <g class="x axis" transform="translate(0,200)">
        <g class="tick" style="opacity: 1; " transform="translate(0,0)">
          <line y2="-200" x2="0"></line>
          <text y="3" x="0" dy=".71em" style="text-anchor: middle; ">20</text>
        </g>
        <g class="tick" style="opacity: 1; " transform="translate(20,0)">
          <line y2="-200" x2="0"></line>
          <text y="3" x="0" dy=".71em" style="text-anchor: middle; ">22</text>
        </g>
        <g class="tick" style="opacity: 1; " transform="translate(40,0)">
          <line y2="-200" x2="0"></line>
          <text y="3" x="0" dy=".71em" style="text-anchor: middle; ">24</text>
        </g>
        <g class="tick" style="opacity: 1; " transform="translate(60.00000000000001,0)">
          <line y2="-200" x2="0"></line>
          <text y="3" x="0" dy=".71em" style="text-anchor: middle; ">26</text>
        </g>
        <g class="tick" style="opacity: 1; " transform="translate(80,0)">
          <line y2="-200" x2="0"></line>
          <text y="3" x="0" dy=".71em" style="text-anchor: middle; ">28</text>
        </g>
        <g class="tick" style="opacity: 1; " transform="translate(100,0)">
          <line y2="-200" x2="0"></line>
          <text y="3" x="0" dy=".71em" style="text-anchor: middle; ">30</text>
        </g>
        <g class="tick" style="opacity: 1; " transform="translate(120.00000000000001,0)">
          <line y2="-200" x2="0"></line>
          <text y="3" x="0" dy=".71em" style="text-anchor: middle; ">32</text>
        </g>
        <g class="tick" style="opacity: 1; " transform="translate(140,0)">
          <line y2="-200" x2="0"></line>
          <text y="3" x="0" dy=".71em" style="text-anchor: middle; ">34</text>
        </g>
        <g class="tick" style="opacity: 1; " transform="translate(160,0)">
          <line y2="-200" x2="0"></line>
          <text y="3" x="0" dy=".71em" style="text-anchor: middle; ">36</text>
        </g>
        <g class="tick" style="opacity: 1; " transform="translate(180,0)">
          <line y2="-200" x2="0"></line>
          <text y="3" x="0" dy=".71em" style="text-anchor: middle; ">38</text>
        </g>
        <g class="tick" style="opacity: 1; " transform="translate(200,0)">
          <line y2="-200" x2="0"></line>
          <text y="3" x="0" dy=".71em" style="text-anchor: middle; ">40</text>
        </g>
        <path class="domain" d="M0,-200V0H200V-200"></path>
      </g>
      <g class="y axis">
        <g class="tick" style="opacity: 1; " transform="translate(0,38)">
          <line x2="6" y2="0"></line>
          <text x="9" y="0" dy=".32em" style="text-anchor: start; ">foo</text>
        </g>
        <g class="tick" style="opacity: 1; " transform="translate(0,100)">
          <line x2="6" y2="0"></line>
          <text x="9" y="0" dy=".32em" style="text-anchor: start; ">bar</text>
        </g>
        <g class="tick" style="opacity: 1; " transform="translate(0,162)">
          <line x2="6" y2="0"></line>
          <text x="9" y="0" dy=".32em" style="text-anchor: start; ">baz</text>
        </g>
        <path class="domain" d="M6,0H0V200H6"></path>
      </g>
    </svg>

## Ruby API

To generate the same **horizontal bar graph** using the Ruby API, we can do the
following:

    json   = "[{ \"name\": \"foo\", \"value\": 20 },{ \"name\": \"bar\", \"value\": 40 },{ \"name\": \"baz\", \"value\": 35 }]"
    type   = Grapht::Type::BAR_HORIZONTAL
    graph  = Grapht::Shell.exec type, json
