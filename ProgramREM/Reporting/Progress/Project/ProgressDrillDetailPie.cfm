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
   <cfchart
       format="png"
       chartheight="130"
       chartwidth="150"
       showygridlines="yes"
       seriesplacement="default"
       labelformat="number"
	   showlegend="no"
	   backgroundcolor="ffffff"
	   showborder="no"
       show3d="no"
	   fontsize="9"
	   font="Verdana"				   
	   pieslicestyle="solid"
	   showxgridlines="yes"
       sortxaxis="no"
       xAxisTitle="Status"
	   yAxisTitle="Projects">
														   
	   <cfchartseries
        type="pie"
        query="Chart"
        itemcolumn="Description"
        valuecolumn="Total"
        serieslabel="Output status"
        paintstyle="light"
        markerstyle="circle"/> 
					
	</cfchart>	

<!---
	tipbgcolor="E9E9D1" --->
		