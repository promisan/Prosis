
<cfset dateValue = "">
<CF_DateConvert Value="#url.selectedDate#">
<cfset vSelectedDate = dateValue>

<cfset link = "#session.root#/workOrder/Application/WorkOrder/ServiceDetails/ServiceLinePerson.cfm?workorderline=#url.workorderline#&workorderid=#URL.workorderid#&getDefaultPerson=0">	
<table cellspacing="0" cellpadding="0" width="96%">
	<tr>
						
	<td width="99%"><cfdiv bind="url:#link#" id="#url.boxName#"/></td>
	<td width="10" style="padding-left:2px">

		<cfset vWorkSchedule = url.workSchedule>
		<cfif vWorkSchedule eq "">
			<cfset vWorkSchedule = "__NotValidWS-84111d2">
		</cfif>
		
		<cf_selectlookup
		    box        = "#url.boxName#"
			link       = "#link#"
			button     = "Yes"
			close      = "Yes"							
			icon       = "search.png"
			iconheight = "25"
			iconwidth  = "25"
			class      = "employee"
			des1       = "PersonNo"
			filter1		 = "WorkSchedule"
			filter1Value = "#vWorkSchedule#"
			filter2Value = "#dateFormat(vSelectedDate,'yyyy-mm-dd')#"
			filter3Value = "#url.workorderid#">
			
	</td>	
	</tr>
</table>