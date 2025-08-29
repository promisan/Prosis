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
<cfparam name="url.go" 		  default="none">
<!--- added by JM 2/25/2014 --->
<cfparam name="url.mode" 	  default="standard">
<cfparam name="url.fieldname" default="">

<CF_DateConvert Value="#url.date#">
<cfset dateob = dateValue>
             
<cfoutput>

<cfif url.go eq "none">

   	<cfset newdate = DateAdd("m",0,dateob)>
		#year(newdate)# 
	<script>	
		calendarmonth('#url.date#','none','#url.mode#','#url.fieldname#');
	</script>
	
<cfelseif url.go eq "jump">

	<cfset newdate = CreateDate(Year(dateob),Month(dateob),Day(dateob))> 	
		#year(newdate)# 	
	<script>	
		calendarmonth('#url.date#','jump','#url.mode#','#url.fieldname#');
	</script>
	
<cfelseif url.go eq "back">

	<cfset newdate = DateAdd("m",-1,dateob)> 
		#year(newdate)# 	
	<script>	
		calendarmonth('#url.date#','back','#url.mode#','#url.fieldname#');
	</script>
	 
<cfelse>

   	<cfset newdate = DateAdd("m",1,dateob)>	
		#year(newdate)# 	
	<script>
		calendarmonth('#url.date#','forward','#url.mode#','#url.fieldname#');
	</script>
	
</cfif>

<script>	
	if (document.getElementById('divGotoPriorMonths')) { ColdFusion.navigate('#SESSION.root#/tools/Calendar/CalendarView/CalendarViewGoMonth.cfm?name=gotoPriorMonths&date=#dateFormat(newDate, "#client.dateFormatShow#")#&type=prior', 'divGotoPriorMonths'); }
    if (document.getElementById('divGotoNextMonths'))  { ColdFusion.navigate('#SESSION.root#/tools/Calendar/CalendarView/CalendarViewGoMonth.cfm?name=gotoNextMonths&date=#dateFormat(newDate, "#client.dateFormatShow#")#&type=next', 'divGotoNextMonths'); }
</script>
   	
</cfoutput>	