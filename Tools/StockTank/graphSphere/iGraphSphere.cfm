<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<script src="../../../Scripts/Graphics/graphEngine.js" type="text/javascript"></script>
<script>

	Raphael.fn.ball = function (x, y, r, hue) {
            hue = hue || 0;
            return this.set(
                this.ellipse(x, y + r - r / 5, r, r / 2).attr({fill: "rhsb(" + hue + ", 1, .25)-hsb(" + hue + ", 1, .25)", stroke: "none", opacity: 0}),
                this.ellipse(x, y, r, r).attr({fill: "r(.5,.9)hsb(" + hue + ", 1, .75)-hsb(" + hue + ", .5, .25)", stroke: "none"}),
                this.ellipse(x, y, r - r / 5, r - r / 20).attr({stroke: "none", fill: "r(.5,.1)#ccc-#ccc", opacity: 0})
            );
        };

	function draw_ball()
	{
			var container = document.getElementById('graphcontainer');
			var x = document.getElementById('x').value;
			var y = document.getElementById('y').value;
			var rad = document.getElementById('radius').value;
			var col = document.getElementById('color').value;
						
			var paper = Raphael(container);
			
            paper.ball(x, y, rad, col);				
	}
	
	window.onload = function () {draw_ball();}
	
</script>

<body style="background-color:transparent;">
<cfoutput>	
	<input type="hidden" name="x" id="x" value="#url.center#">
	<input type="hidden" name="y" id="y" value="#url.center#">
	<input type="hidden" name="radius" id="radius" value="#url.radius#">
	<input type="hidden" name="color" id="color" value="#url.color#">
	
	<div id="graphcontainer" style="width:#url.size#; height:#url.size#;"></div>
		
</cfoutput>
</body>

