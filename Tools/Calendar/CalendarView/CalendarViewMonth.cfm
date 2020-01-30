
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