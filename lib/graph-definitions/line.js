function(data) {
  var fns = {
    extentOf: function(data, axis) {
      var values    = d3.values(data),
          flatVals  = Array.prototype.concat.apply([], values),
          axisVals  = flatVals.map(function(o) { return o[axis]; });

      return d3.extent(axisVals);
    }
  };

  var margin     = { top: 40, right: 80, bottom: 40, left: 40 },
      width      = 400,
      height     = 400,
      svgWidth   = width + margin.right + margin.left,
      svgHeight  = height + margin.top + margin.bottom;

  var svg = d3.select("body").append("svg")
              .attr('viewBox', "0 -10 " +svgWidth+ " " +svgHeight+ "")
              .attr("width", svgWidth)
              .attr("height", svgHeight)
              .style("font-family", "Arial")
              .style("font-size", "14px")
              .style("fill", "none")
              .style("background-color", "#ffffff")
            .append('g')
              .attr('transform', 'translate(' +margin.left+ ',' +margin.top+ ')')
              .style("fill", "none");

  var x     = d3.scale
                .linear()
                .range([0, width])
                .domain(fns.extentOf(data, 'x')),
      y     = d3.scale
                .linear()
                .range([height, 0])
                .domain(fns.extentOf(data, 'y')),
      color = d3.scale
                .ordinal()
                .range(["#428bca", "#5cb85c", "#5bc0de", "#f0ad4e", "#d9534f"]);

  var xAxis  = d3.svg
                 .axis()
                 .scale(x)
                 .orient('bottom')
                 .tickSize(-height),
      yAxis  = d3.svg
                 .axis()
                 .scale(y)
                 .orient('left')
                 .tickSize(width),
      line   = d3.svg
                 .line()
                 .interpolate('basis')
                 .x(function(d) { return x(d.x); })
                 .y(function(d) { return y(d.y); });

  var xAxisElement = svg.append('g')
                     .attr('class',      'x axis')
                     .attr('transform',  "translate(0," +height+ ")")
                     .call(xAxis);

  var yAxisElement = svg.append('g')
                     .attr('class', 'y axis')
                     .attr("transform", "translate(" +width+ ",0)")
                     .call(yAxis);

  var lineElements = svg.selectAll('.line')
                       .data(d3.entries(data))
                     .enter().append('g')
                       .attr('class', 'line');

  lineElements.append('path')
    .attr('class', 'line')
    .attr('d', function(d) { return line(d.value) })
    .style('stroke-width', '2px')
    .style('opacity',  '0.3')
    .style('stroke', function(d) { return color(d.key); });

  lineElements.append('text')
    .datum(function(d) { return { name: d.key, value: d.value[d.value.length - 1] }; })
    .attr('transform', function(d) { return "translate(" +x(d.value.x)+ "," +y(d.value.y)+ ")"; })
    .attr('x', 3)
    .attr('dy', '5px')
    .style('fill', '#333333')
    .text(function(d) { return d.name; });

  // axis styling
  xAxisElement.selectAll('line')
    .style('fill', 'none')
    .style('stroke', 'black')
    .style('stroke-width', '1px')
    .style('stroke-opacity', 0.1)
    .style('shape-rendering', 'geometricPrecision');

  xAxisElement.selectAll('text')
    .attr('dy', '20px')
    .style('fill', '#333333');

  yAxisElement.selectAll('line')
    .style('fill', 'none')
    .style('stroke', 'black')
    .style('stroke-width', '1px')
    .style('stroke-opacity', 0.1)
    .style('shape-rendering', 'geometricPrecision');

  yAxisElement.selectAll('text')
    .attr('dx', '-10px')
    .style('fill', '#333333');
}
