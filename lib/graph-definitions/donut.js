function(data) {
  var margin     = { top: 20, right: 20, bottom: 10, left: 10 },
      width      = 400,
      height     = 400,
      svgWidth   = width + margin.right + margin.left,
      svgHeight  = height + margin.top + margin.bottom,
      radius     = Math.min(width, height) / 2;

  var svg = d3.select("body").append("svg")
             .style("fill", "none")
             .attr("width", svgWidth)
             .attr("height", svgHeight)
             .attr('viewBox', "0 -10 " +svgWidth+ " " +svgHeight+ "")
            .append('g')
              .attr('transform', 'translate(' +(width/2)+ ',' +(height/2)+ ')')
              .style("fill", "none");

  var color = d3.scale
                .ordinal()
                .range(["#428bca", "#5cb85c", "#5bc0de", "#f0ad4e", "#d9534f"]);

  var arc = d3.svg.arc()
              .outerRadius(radius - 10)
              .innerRadius(radius - 70);

  var pie = d3.layout.pie()
              .sort(null)
              .value(function(d) { return d.value; });

  var arcElement = svg.selectAll(".arc")
                      .data(pie(data))
                   .enter().append("g")
                      .attr("class", "arc");

  arcElement.append("path")
            .attr("d", arc)
            .style("fill", function(d) { return color(d.data.name); });

  arcElement.append("text")
            .attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
            .attr("dy", ".35em")
            .style('fill', '#FFFFFF')
            .attr('font-family', 'Arial')
            .attr('font-weight', 'bold')
            .style("text-anchor", "middle")
            .text(function(d) { return d.data.name; });
}
