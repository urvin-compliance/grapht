function(data) {
  var margin     = { top: 50, right: 20, bottom: 30, left: 40 },
      width      = 400,
      height     = 400,
      svgWidth   = width + margin.right + margin.left,
      svgHeight  = height + margin.top + margin.bottom;

  var svg = d3.select("body").append("svg")
             .style("fill", "none")
             .attr("width", svgWidth)
             .attr("height", svgHeight)
             .attr('viewBox', "0 -10 " +svgWidth+ " " +svgHeight+ "")
            .append('g')
              .attr('transform', 'translate(' +margin.left+ ',' +margin.top+ ')')
              .style("fill", "none");

  var paddedExtent = function(data, pad) {
    return [
      d3.min(data, function(d) { return d.value-pad; }),
      d3.max(data, function(d) { return d.value+pad; })
    ]
  }

  // Axis Scales
  var x = d3.scale
          .linear()
          .domain(paddedExtent(data, 1))
          .range([0, width])
          .nice();

  var y = d3.scale
          .ordinal()
          .domain(data.map(function(d) { return d.name; }))
          .rangeRoundBands([0, height], 0.2);

  // Axes
  var xAxis = d3.svg
              .axis()
              .scale(x)
              .orient('bottom')
              .tickSize(-height);

  var yAxis = d3.svg
              .axis()
              .scale(y)
              .orient('right')
              .ticks(data.length);

  svg.selectAll('.bar')
      .data(data)
    .enter().append('rect')
      .attr('class',    'bar')
      .style('fill',    '#428bca')
      .attr('opacity',  '0.3')
      .attr('x',        0)
      .attr('y',        function(d) { return y(d.name); })
      .attr('width',    function(d) { return x(d.value); })
      .attr('height',   y.rangeBand());

  svg.selectAll('.text')
    .attr('font-family', 'Arial')
    .selectAll('label')
      .attr('fill-opacity', '0.3')

  var xAxisElement = svg.append('g')
                     .attr('class',      'x axis')
                     .style("fill", "none")
                     .attr('transform',  "translate(0," +height+ ")")
                     .call(xAxis);

  var yAxisElement = svg.append('g')
                     .attr('class', 'y axis')
                     .style("fill", "none")
                     .call(yAxis);

  xAxisElement.selectAll('line')
    .style('fill', 'none')
    .attr('stroke', 'black')
    .attr('stroke-width', '1px')
    .attr('stroke-opacity', 0.1)
    .attr('shape-rendering', 'geometricPrecision');

  xAxisElement.selectAll('text')
    .style('fill', '#333333')
    .attr('font-family', 'Arial');

  yAxisElement.selectAll('text')
    .style('fill', '#333333')
    .attr('font-family', 'Arial');
}
