function(data) {
  var margin     = { top: 50, right: 20, bottom: 30, left: 40 },
      width      = 400,
      height     = 400,
      svgWidth   = width + margin.right + margin.left,
      svgHeight  = height + margin.top + margin.bottom;

  var svg = d3.select("body").append("svg")
             .attr("fill", "transparent")
             .attr("width", svgWidth)
             .attr("height", svgHeight)
             .attr('viewBox', "0 -10 #{svgWidth} #{svgHeight}")
            .append('g')
              .attr('transform', 'translate(#{margin.left},#{margin.top})');

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
      .attr('class',    'bar')
      .attr('fill',     '#428bca')
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
                     .attr('transform',  "translate(0," +height+ ")")
                     .call(xAxis);

  var yAxisElement = svg.append('g')
                     .attr('class', 'y axis')
                     .call(yAxis);

  xAxisElement.selectAll('line')
    .attr('fill', 'none')
    .attr('stroke', 'black')
    .attr('stroke-width', '1px')
    .attr('stroke-opacity', 0.1)
    .attr('shape-rendering', 'geometricPrecision');

  xAxisElement.selectAll('text')
    .attr('fill', '#333333')
    .attr('font-family', 'Arial');

  yAxisElement.selectAll('text')
    .attr('fill', '#333333')
    .attr('font-family', 'Arial');
}
