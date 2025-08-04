/*
 * Copyright © 2025 Promisan
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
	$(function () {
    		
    	//<div id="fillAndMultiAxis" style="width: 800px;height: 400px;"></div>
    		
    	var d1 = [[20,20], [42,60], [54, 20], [80,80]];
    	var d2 = [[20,700], [80,300]];
  
		var options = { series: {
							 curvedLines: {
								 	 active: true 
							 }
					 },
						axis: { min:10, max: 100},
						yaxes: [{ min:10, max: 90}, { position: 'right'}]
   					};
									
		$.plot($("#fillAndMultiAxis"), 
				[
					{data: d1, lines: { show: true, fill: true, fillColor: "#C3C3C3", lineWidth: 3}, curvedLines: {apply:true}}, {data: d1,  points: { show: true }},
					{data: d2, lines: { show: true, lineWidth: 3}, curvedLines: {apply:true}, yaxis:2}, {data: d2,  points: { show: true }, yaxis:2}
				], options);
		});