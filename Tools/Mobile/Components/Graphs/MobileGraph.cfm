<cfparam name="attributes.id"					default="">
<cfparam name="attributes.type"					default=""> <!--- line, radar, bar, horizontalBar, doughnut, pie, polarArea, bubble, scatter, area --->
<cfparam name="attributes.series"				default="#ArrayNew(1)#"  type="array">
<cfparam name="attributes.height"				default="250px">
<cfparam name="attributes.width"				default="300px">
<cfparam name="attributes.dots"					default="30.0">
<cfparam name="attributes.responsive"			default="yes">
<cfparam name="attributes.grids"				default="true">
<cfparam name="attributes.stacked"				default="false">
<cfparam name="attributes.legend"				default="false">
<cfparam name="attributes.legendFont"			default="12">
<cfparam name="attributes.legendPosition"		default="bottom">
<cfparam name="attributes.dataPoints"			default="no">
<cfparam name="attributes.dataPointsPercentage"	default="no">
<cfparam name="attributes.labelDecimals"		default="1">
<cfparam name="attributes.labelThousands"		default="no">
<cfparam name="attributes.labelPrepend"			default="">
<cfparam name="attributes.labelAppend"			default="">
<cfparam name="attributes.nullValueLabel"		default="0">
<cfparam name="attributes.onclick"				default="">
<cfparam name="attributes.engine"				default="chartjs">
<cfparam name="attributes.color"				default="#ArrayNew(1)#"  type="array">

<cfset attributes.type = trim(lcase(attributes.type))>
<cfif attributes.type eq "horizontalbar">
	<cfset attributes.type = "horizontalBar">
</cfif>
<cfif attributes.type eq "polararea">
	<cfset attributes.type = "polarArea">
</cfif>

<cfset vResponsive = "">
<cfif trim(attributes.responsive) eq "yes" or trim(attributes.responsive) eq "1" or trim(attributes.responsive) eq "true">
	<cfset vResponsive = "prosisResponsiveGraph">
</cfif>

<cfset vLegend = "">
<cfif trim(attributes.legend) eq "yes" or trim(attributes.legend) eq "1" or trim(attributes.legend) eq "true">
	<cfset vLegend = "true">
<cfelse>
	<cfset vLegend = "false">
</cfif>

<cfset vShowGrids = "">
<cfif trim(attributes.grids) eq "yes" or trim(attributes.grids) eq "1" or trim(attributes.grids) eq "true">
	<cfset vShowGrids = "true">
<cfelse>
	<cfset vShowGrids = "false">
</cfif>

<cfset vStacked = "">
<cfif trim(attributes.stacked) eq "yes" or trim(attributes.stacked) eq "1" or trim(attributes.stacked) eq "true">
	<cfset vStacked = "true">
<cfelse>
	<cfset vStacked = "false">
</cfif>

<cfset vThousands = "">
<cfif trim(attributes.labelThousands) eq "yes" or trim(attributes.labelThousands) eq "1" or trim(attributes.labelThousands) eq "true">
	<cfset vThousands = "true">
<cfelse>
	<cfset vThousands = "false">
</cfif>
					
<cfif attributes.engine eq "chartjs">

	<cfif thisTag.ExecutionMode is "start">
		<cf_MobileGraphScripts>
		<!--- Default serie --->
		<cfset vSeries = StructNew()>
		<cf_MobileGraphValidateSeriesStruct struct="#attributes.series[1]#">
		<cfset vDefaultQuery = vSeries.query>
		<cf_MobileGraphPalette 
			color="#vSeries.color#" 
			mode="#vSeries.colorMode#"
			transparency="#vSeries.transparency#">
		<cfset vDefaultColors = colors>
		<cfset vDefaultHighlightColor = highlightColor>
			
		<cfoutput>
			<div>
				<canvas class="#vResponsive#" id="#attributes.id#" height="#attributes.height#" width="#attributes.width#"></canvas>
			</div>
		</cfoutput>
		
	<cfelse>	
	
		<cfoutput>
		
			<cfset vDots = vDefaultQuery.recordCount / attributes.dots>
			<cfset vDots = INT(vDots)>
			<cfif vDots eq 0>
				<cfset vDots = 1>
			</cfif>
			
			<cfsavecontent variable="doChart_#attributes.id#">
				
				var afterDataSetDrawPlugin = {};

				<cfif trim(attributes.dataPoints) eq "true" or trim(attributes.dataPoints) eq "yes" or trim(attributes.dataPoints) eq "1">
					// Define a plugin to provide data labels
					afterDataSetDrawPlugin = {
						afterDatasetsDraw: function(chart) {
							var ctx = chart.ctx;
							var vSum = 0.0;

							chart.data.datasets.forEach(function(dataset, i) {
								var meta = chart.getDatasetMeta(i);
								if (!meta.hidden) {
									meta.data.forEach(function(element, index) {
										// Draw the text in black, with the specified font
										ctx.fillStyle = 'rgb(70,99,99)';

										var fontSize = #attributes.legendFont*0.8#;
										var fontStyle = 'normal';
										var fontFamily = 'Verdana';
										ctx.font = Chart.helpers.fontString(fontSize, fontStyle, fontFamily);

										// Just natively convert to string for now
										var dataString = formatLabels(dataset.data[index], #attributes.labelDecimals#, #vThousands#, '#attributes.labelPrepend#', '#attributes.labelAppend#').toString();

										<cfif trim(attributes.dataPointsPercentage) eq "true" or trim(attributes.dataPointsPercentage) eq "yes" or trim(attributes.dataPointsPercentage) eq "1">
											vSum = 0.0;
											dataset.data.map(data => {
												vSum += parseFloat(data);
											});
											dataString = String((parseFloat(dataset.data[index])*100 / vSum).toFixed(1)) + '%';
										</cfif>

										// Make sure alignment settings are correct
										ctx.textAlign = 'left';
										ctx.textBaseline = 'left';

										var padding = -5;
										var position = element.tooltipPosition();

										var xPosition = position.x;
										if (element._chart.controller.config.type == 'horizontalBar') {
											xPosition = position.x - 30;
											if (xPosition < 55) { xPosition = position.x + 5; }
										}
										if (element._chart.controller.config.type == 'pie') {
											xPosition = position.x - 10;
										}
										
										ctx.fillText(dataString, xPosition, position.y - (fontSize / 2) - padding);
									});
								}
							});
						}
					};

				</cfif>
				
				var chartData_#attributes.id# = {
					labels: [
						<cfloop query="#vDefaultQuery#">
							<cfif currentrow neq 1>,</cfif>
							<cfif (currentrow mod vDots) eq 0 OR currentrow eq 1>
								"#evaluate("vDefaultQuery.#vSeries.label#")#"
							<cfelse>
								""
							</cfif>
						</cfloop>
						],
					datasets: [
						<cfset cnt = 0>
						<cfloop index="currentSerie" from="1" to="#ArrayLen(attributes.series)#">
						
							<cfset cnt = cnt + 1>
							<cfif cnt neq 1>, </cfif>
							
							<cfset vSeries = StructNew()>
							<cf_MobileGraphValidateSeriesStruct struct="#attributes.series[currentSerie]#">
							<cfset vQuery = vSeries.query>
						
							<cf_MobileGraphPalette 
								color="#vSeries.color#" 
								mode="#vSeries.colorMode#"
								transparency="#vSeries.transparency#">
							<cf_tl id="#trim(vSeries.name)#" var="1">
							{	
								label: "#trim(vSeries.name)#",
								<cfif trim(vSeries.type) neq "">
									<cfif trim(vSeries.type) eq "area">
										type: "line",
									<cfelse>
										type: "#trim(vSeries.type)#",
									</cfif>
								</cfif>
								<cfif trim(attributes.type) eq "area">
									fill: true,
								<cfelse>
									fill: false,
								</cfif>
								pointRadius: 5,
								pointBackgroundColor: "#colors[currentSerie]#",
								<cfif trim(attributes.type) eq "area" OR trim(attributes.type) eq "line" OR trim(vSeries.type) eq "area" OR trim(vSeries.type) eq "line">
									borderColor: "#colors[currentSerie]#",
								</cfif>
								data: [
								<cfset cntSerie = 0>
								
								<cfloop query="#vQuery#">
									<cfset cntSerie = cntSerie + 1>
									<cfif cntSerie neq 1>, </cfif>
									"#evaluate("vQuery.#vSeries.value#")#"
								</cfloop>
								],
								backgroundColor: [

								<cfset GlobalColor = 0>
								<cfif  ArrayLen(attributes.color) neq 0>
									<cfset vColor = attributes.color[1]>
									<cfset vColorQuery = vColor.query>
									<cfif vColorQuery.recordcount neq 0>
										<cfset GlobalColor = 1>
									</cfif>	
								</cfif>	
								
								<cfif GlobalColor neq 0>
									<cfset cntColor = 0>
									
									<cfloop query="#vQuery#">
										<cfquery name="qColor" dbtype="query">
											SELECT 	Color
											FROM 	vColorQuery
											WHERE 	Description = '#evaluate("vQuery.#vSeries.label#")#'
										</cfquery>	

										<cfif cntColor eq 0>
											"#qColor.Color#"
										<cfelse>
											,"#qColor.Color#"
										</cfif>
										<cfset cntColor = cntSerie + 1>
									</cfloop>
								<cfelse>	
									<cfset cntSerie = 0>
									<cfloop query="#vQuery#">
										<cfset cntSerie = cntSerie + 1>
										<cfif cntSerie neq 1>, </cfif>
										"#colors[cntSerie]#"
									</cfloop>
								</cfif>	
								]
							}
							
						</cfloop>
					]
				};
			
				var chartOptions_#attributes.id# = {
					<cfif trim(attributes.onclick) neq "">
						onClick: chartClickEvent_#attributes.id#,
					</cfif>
					layout: {
			            padding: {
			                left: 10,
			                right: 10,
			                top: 10,
			                bottom: 10
			            }
			        },
					responsive: true,
					maintainAspectRatio: false,
					legend: { display:#vLegend#, position:'#attributes.legendPosition#', labels: { fontSize: #attributes.legendFont# } },
					<cfif attributes.type neq "pie" AND attributes.type neq "doughnut" AND attributes.type neq "polarArea" AND vShowGrids>
						scales: {
				            yAxes: [{
				            	<cfif vStacked>
					            	stacked: true,
				            	</cfif>
				                ticks: {
				                    callback: function(value, index, values) {
				                        return formatLabels(value, #attributes.labelDecimals#, #vThousands#, '#attributes.labelPrepend#', '#attributes.labelAppend#');
				                    }
				                }
				            }],
				            xAxes: [{
				            	<cfif vStacked>
					            	stacked: true,
				            	</cfif>
				                ticks: {
				                    callback: function(value, index, values) {
				                        return formatLabels(value, #attributes.labelDecimals#, #vThousands#, '#attributes.labelPrepend#', '#attributes.labelAppend#');
				                    }
				                }
				            }]
				        },
				        
			        </cfif>
			        tooltips: {
			            callbacks: {
			                label: function(tooltipItem, data) {
			                    var label = data.datasets[tooltipItem.datasetIndex].label || '';
			                    if (label) {
			                        label += ': ';
			                    } else {
			                    	label = data.labels[tooltipItem.index] || '';
			                    	if (label) {
			                    		label += ': ';
			                    	}
			                    }
			                    
			                    var vValue = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
			                    if ($.trim(vValue) == '') { 
			                    	vValue = '#attributes.nullValueLabel#'; 
			                    }

			                    label += formatLabels(vValue, #attributes.labelDecimals#, #vThousands#, '#attributes.labelPrepend#', '#attributes.labelAppend#')
			                    return label;
			                }
			            }
			        }
				};
				
				var CTX_#attributes.id# = document.getElementById("#attributes.id#").getContext("2d");
				var _Chart_#attributes.id# = new Chart(CTX_#attributes.id#, {
					<cfif trim(attributes.type) eq "area">
						type : 'line',
					<cfelse>
						type : '#attributes.type#',
					</cfif>
					data : chartData_#attributes.id#,
					options : chartOptions_#attributes.id#,
					plugins: [afterDataSetDrawPlugin]
				});



				<cfif trim(attributes.onclick) neq "">
					
					function chartClickEvent_#attributes.id#(e, array) {  
						var active = _Chart_#attributes.id#.getElementAtEvent(e);
						var elementIndex = active[0]._datasetIndex;

						var chartData = array[elementIndex]['_chart'].config.data;
						var idx = array[elementIndex]['_index'];

						var __mobile_elements = {};
						__mobile_elements.label = chartData.labels[idx];
						__mobile_elements.value = chartData.datasets[elementIndex].data[idx];
						__mobile_elements.series = chartData.datasets[elementIndex].label;

				    	(#trim(attributes.onclick)#)(__mobile_elements);
					};    

				</cfif>
			 
			</cfsavecontent>
		</cfoutput>
		
		<cfset "caller.doChart_#attributes.id#" = evaluate("doChart_#attributes.id#")>
		
	</cfif>

</cfif>