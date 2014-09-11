function(data) {
  var margin     = { top: 50, right: 20, bottom: 30, left: 40 },
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

  // Axis Scales
  var x = d3.scale
          .ordinal()
          .domain(data.map(function(d) { return d.name; }))
          .rangeRoundBands([0, width], 0.2);

  var y = d3.scale
          .linear()
          .domain([0, d3.max(data, function(d) { return d.value; })])
          .range([height, 0])
          .nice();

  // Axes
  var xAxis = d3.svg
              .axis()
              .scale(x)
              .orient('bottom')
              .ticks(data.length);

  var yAxis = d3.svg
              .axis()
              .scale(y)
              .orient('left')
              .tickSize(width);

  svg.selectAll('.bar')
      .data(data)
    .enter().append('rect')
      .attr('class',    'bar')
      .attr('y',        function(d) { return y(d.value); })
      .attr('x',        function(d) { return x(d.name); })
      .attr('width',    x.rangeBand())
      .attr('height',   function(d) { return height - y(d.value); })
      .style('fill',    '#428bca')
      .style('opacity',  '0.3');

  svg.selectAll('label')
      .style('fill-opacity', '0.3')

  var xAxisElement = svg.append('g')
                     .attr('class',      'x axis')
                     .attr('transform',  "translate(0," +height+ ")")
                     .call(xAxis);

  var yAxisElement = svg.append('g')
                     .attr('class', 'y axis')
                     .attr("transform", "translate(" +width+ ",0)")
                     .call(yAxis);

  xAxisElement.selectAll('line')
    .style('fill', 'none')
    .style('stroke', 'black')
    .style('stroke-width', '1px')
    .style('stroke-opacity', 0.1)
    .style('shape-rendering', 'geometricPrecision');

  xAxisElement.selectAll('text')
    .style('fill', '#333333');

  yAxisElement.selectAll('line')
    .style('fill', 'none')
    .style('stroke', 'black')
    .style('stroke-width', '1px')
    .style('stroke-opacity', 0.1)
    .style('shape-rendering', 'geometricPrecision');

  yAxisElement.selectAll('text')
    .style('fill', '#333333');
}
