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
<!--- old dev based dialog

<cfparam name="url.doctypemode"         default="quirks">
<cfparam name="url.context"             default="day">

<cfif url.context eq "undefined">
	<cfset context = "day">
<cfelse>
	<cfset context = url.context>
</cfif>

<cf_divscroll 
          zindex    = "9100" 
          modal     = "no" 
		  float     = "yes" 
		  width     = "920px" 
		  height    = "790px" 
		  id        = "timebox" 
		  close     = "yes"
		  mode      = "#url.doctypemode#" 
		  overflowy = "hidden"
		  resize    = "yes">		
				  
	<cf_tableround totalwidth="880px" totalheight="750px">		

		<cfoutput>
		
		<!--- time information --->
		
		<iframe src="#SESSION.root#/attendance/application/TimeSheet/Dialog/HourView.cfm?context=#context#&id=#url.id#&day=#url.day#&startmonth=#url.startmonth#&startyear=#url.startyear#&hour=#url.hour#&slot=#url.slot#&actionclass=#url.actionclass#&actioncode=#url.actioncode#"
		 style="background-color:white" width="880" height="750" name="dataentry" scrolling="no" frameborder="0">
		 
		 </iframe>
		 
		</cfoutput>	 					

	</cf_tableround>
			
</cf_divscroll>	

--->

<table width="100%" height="100%"><tr><td>

	<cfoutput>
		
		<!--- time information --->
		
		<cfparam name="url.mid" default="">
		
		<iframe src="#SESSION.root#/attendance/application/TimeSheet/Dialog/HourView.cfm?context=#context#&id=#url.id#&day=#url.day#&startmonth=#url.startmonth#&startyear=#url.startyear#&hour=#url.hour#&slot=#url.slot#&actionclass=#url.actionclass#&actioncode=#url.actioncode#&mid=#url.mid#"
		 style="background-color:white" width="100%" height="100%" name="dataentry" scrolling="no" frameborder="0"/>
		 		 
	</cfoutput>	 	

</td></tr></table>
