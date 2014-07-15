function(data) {
  var width  = 200,
      height = 200;

  var svg = d3.select("body").append("svg")
                             .attr("width", width)
                             .attr("height", height);

  // Axis Scales
  var x = d3.scale
          .linear()
          .domain(d3.extent(data, function(d) { return d.value; }))
          .range([0, width]);

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
      .attr('class',  'bar')
      .attr('x',      0)
      .attr('y',      function(d) { return y(d.name); })
      .attr('width',  function(d) { return x(d.value); })
      .attr('height', y.rangeBand());

  var xAxisElement = svg.append('g')
                     .attr('class',      'x axis')
                     .attr('transform',  "translate(0," +height+ ")")
                     .call(xAxis);

  var yAxisElement = svg.append('g')
                     .attr('class', 'y axis')
                     .call(yAxis);
}
