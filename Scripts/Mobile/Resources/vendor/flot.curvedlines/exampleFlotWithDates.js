/*
 * Copyright © 2025 Promisan B.V.
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
$(function() {

	//<div id="exampleFlotWithDates" style="width: 800px;height: 400px;"></div>

	var d1 = [[new Date(2000, 8, 1, 10), 20], [new Date(2000, 8, 1, 12), 60], [new Date(2000, 8, 1, 14), 30], [new Date(2000, 8, 1, 22), 80]];

	var options = {
		series : {
			curvedLines : {
				active : true
			}
		},
		xaxis : {
			mode : "time",
			minTickSize : [1, "hour"],
			min : (new Date(2000, 8, 1)),
			max : (new Date(2000, 8, 2))
		},
		yaxis : {
			min : 10,
			max : 90
		}
	};

	$.plot($("#exampleFlotWithDates"), [{
		data : d1,
		lines : {
			show : true
		},
		curvedLines : {
			apply : true,
		}
	}, {
		data : d1,
		points : {
			show : true
		}
	}], options);
});
