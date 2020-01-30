$(document).ready(function() {

	$('#today_blocked').sparkline('html', {type:'bar', barColor:'red'});
	$('#today_logged').sparkline('html', {type:'bar'});
	$('#yesterday_blocked').sparkline('html', {type:'bar', barColor:'red'});
	$('#yesterday_logged').sparkline('html', {type:'bar'});
	$('#month_blocked').sparkline('html', {type:'bar', barColor:'red'});
	$('#month_logged').sparkline('html', {type:'bar'});
	$('#year_blocked').sparkline('html', {type:'bar', barColor:'red'});
	$('#year_logged').sparkline('html', {type:'bar'});

	$('.pieChart').each(function() {
		$(this).sparkline('html', {type:'pie', width:75, height:75, sliceColors:['red','#FF9900','#1E90FF','green','#9900CC','pink','brown','orange','yellow','#F0F8FF','#7FFFD4','#FFD700','black']}); 
	});

	$('.backbtn').click(function() {
		history.go(-1);
		return false;
	})

	$('#byDayChart').each(function() {
		var byDay = [];
		var points = $('#byDayData .p');
		for (var p=0;p<points.length;p++) {
			pArray = [0,0];
			pArray[0] = $(points[p]).data('x');
			pArray[1] = $(points[p]).data('y');
			byDay.push(pArray);
		}
		var byDayOptions = {
	        	xaxis: { mode: "time" },
	        	selection: { mode: "x" },
	        	grid: { markings: weekendAreas, hoverable: true, clickable: true },
	        	points: { show: true },
	        	lines: { show: true },
	        	shadowSize: 4
	        }
	        var plot = $.plot($("#byDayChart"), [byDay], byDayOptions);
	        $('#byDayChart').show();
	        function weekendAreas(axes) {
		        var markings = [];
		        var d = new Date(axes.xaxis.min);
		        // go to the first Saturday
		        d.setUTCDate(d.getUTCDate() - ((d.getUTCDay() + 1) % 7))
		        d.setUTCSeconds(0);
		        d.setUTCMinutes(0);
		        d.setUTCHours(0);
		        var i = d.getTime();
		        do {
		            markings.push({ xaxis: { from: i, to: i + 2 * 24 * 60 * 60 * 1000 } });
		            i += 7 * 24 * 60 * 60 * 1000;
		        } while (i < axes.xaxis.max);
		
		        return markings;
		    }
		    function showTooltip(x, y, contents) {
		        $('<div id="tooltip">' + contents + '</div>').css( {
		            position: 'absolute',
		            display: 'none',
		            top: y + 5,
		            left: x + 5,
		            border: '1px solid #fdd',
		            padding: '2px',
		            'background-color': '#fee',
		            opacity: 0.80
		        }).appendTo("body").fadeIn(200);
	    	}
	    	
	    	var previousPoint = null;
		    $("#byDayChart").bind("plothover", function (event, pos, item) {
				
				if (item) {
					
	                if (previousPoint != item.datapoint) {
	                    previousPoint = item.datapoint;
	                    
	                    $("#tooltip").remove();
	                    var x = item.datapoint[0],
	                        y = item.datapoint[1];
	                    var xd = new Date(x);
	                    var dt = new Date();
	                    dt.setUTCDate(xd.getDate());
	                    dt.setUTCFullYear(xd.getFullYear());
	                    dt.setUTCMonth(xd.getMonth());
	                    //dt = new Date(x);
	                    var tip = dt.toDateString() + " - " + y + " Threat";
	                    if (y > 1) { tip+="s";}
	                    showTooltip(item.pageX, item.pageY, tip);
	                }
	            }
	            else {
	                $("#tooltip").remove();
	                previousPoint = null;            
	            }
		        
		    });
		
		    $("#byDayChart").bind("plotclick", function (event, pos, item) {
		       
		        if (item) {
		        	plot.highlight(item.series, item.datapoint);
		        	var dt = new Date(item.datapoint[0]);
		        	document.location = 'log.cfm?year=' + dt.getFullYear() + '&month=' + (dt.getMonth() + 1) + '&day=' + dt.getDate(); 
		        	
		        }
		    });
	    	
		    $("#byDayChart").bind("plotselected", function (event, ranges) {
		        plot = $.plot($("#byDayChart"), byDay,
	                          $.extend(true, {}, byDayOptions, {
	                              xaxis: { min: ranges.xaxis.from, max: ranges.xaxis.to }
	                          }));
		    });
	})

});