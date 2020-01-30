
<cfparam name="url.id"             default="">
<cfparam name="url.mission"        default="">
<cfparam name="url.dateeffective"  default="">
<cfparam name="url.slots"          default="2">
<cfparam name="url.contractid"     default="">

<cfset dateValue = "">
<CF_DateConvert Value="#url.dateeffective#">
<cfset DTE = dateValue>

<cfoutput>

<table width="100%" height="100%">

	<tr>
						
	<cfset hourSlots = "">

	<cfloop index="day" from="0" to="7" step="1">
			
		<cfif day eq "0">	
		    <td style="width:100%">
		<cfelse>				  
		    <td style="min-width:70">
		</cfif>
  			  				
	    <cfif day eq "1" or day eq "7">			
		 <table width="100%" style="background-color:##DCEEEF80" class="navigation_table">
	    <cfelse>
	     <table width="100%" style="background-color:##f1f1f180" class="navigation_table">
	    </cfif>	
		
		<tr class="labelmedium">
		
		<cfif day eq "0">
		   <td class="line" align="center" style="height:35px;min-width:100;border-bottom:1px solid silver"><cf_tl id="Time"></td>
		<cfelse>					
		   <td colspan="1" class="line" style="border-left:1px solid silver;border-bottom:1px solid silver" align="center">#left(DayOfWeekAsString(day),3)#</td>
		</cfif>
		</tr>
		
		<cfif url.slots eq "2">
		
		<tr class="labelmedium">
		
		<cfif day eq "0">
		   <td class="line" align="right" style="min-width:100;border-bottom:1px solid silver;">
		   	<table>
				<td style="padding-top:2px;padding-right:10px;">
					<input class="button10g" style="width:100px;height:17" type="button" onclick="clearWSSelection();" name="btnClear" id="btnClear" value="Clear">
				</td>
				<td style="padding-top:2px;padding-right:10px;">
					<input class="button10g" style="width:100px;height:17" type="button" onclick="selectWS9To5();" name="btn9To5" id="btn9To5" value="Set 9 To 5">
				</td>
			</table>
		   </td>
		<cfelse>					
		   <td colspan="1" align="center">
		   <table style="width:100%;height:100%"><tr>
		   <cfloop index="itm" from="1" to="#url.slots#">
		   <td class="line" style="height:34px;border-left:1px solid silver;border-bottom:1px solid silver" align="center">
		   <cfif itm eq "1">00<cfelse>30</cfif>
		   </td>
		   </cfloop>
		   </tr></table>
		   </td>
		</cfif>
		</tr>
		
		</cfif>
						
		<cfloop index="hr" from="0" to="23" step="1">
									
			<tr class="line labelmedium navigation_row" style="height:23px">
			
			   <cfif day eq "0">
			   
				    <td bgcolor="white" align="center" style="height:24px;width:100%">
										
					<cfif hr lt "10">
						<cfset hour = "0#hr#:00 - :59">
					<cfelse>
						<cfset hour = "#hr#:00 - :59">
					</cfif>
					#hour#
					</td>
					
			  <cfelse>  				
									
				<td align="center" width="12%">
				
					<table style="width:100%">
					
					<tr style="height:20px">
					
					<cfloop index="slt" from="1" to="#url.slots#">
					
						<cfif url.contractid eq "">
																															
							<cfquery name="check" 
						  	datasource="AppsEmployee" 
						  	username="#SESSION.login#" 
						  	password="#SESSION.dbpw#">
						      SELECT *
							  FROM   PersonWorkSchedule
							  WHERE  PersonNo          = '#URL.id#'
							  AND    Mission           = '#url.mission#'
							  AND    DateEffective     = #dte#
							  AND    Weekday           = #day#
							  AND    CalendarDateHour  = '#hr#'
							  AND    CalendarDateSlot  = '#slt#'
							</cfquery>
						
						<cfelse>
						
							<cfquery name="check" 
						  	datasource="AppsEmployee" 
						  	username="#SESSION.login#" 
						  	password="#SESSION.dbpw#">
						      SELECT *
							  FROM   PersonWorkSchedule
							  WHERE  PersonNo          = '#URL.id#'
							  AND    ContractId        = '#url.contractid#'		
							  AND    Weekday           = #day#
							  AND    CalendarDateHour  = '#hr#'		
							  AND    CalendarDateSlot  = '#slt#'		 
							</cfquery>						
						
						</cfif>
						
						<cfif check.recordcount eq "1">
							<cfset color = "ffffcf">
							<cfset hourSlots = check.hourslots>
						<cfelse>
							<cfset color = "transparent">
						</cfif>
					  
					  <cfset v9To5 = "">
					  <cfif day gt 1 AND day lte 6 AND hr gte 9 AND hr lte 17>
					  	<cfif (hr eq 17 AND slt eq 2) OR hr eq 13>
							<!--- OFF --->
						<cfelse>
						  	<cfset v9To5 = "clsWSHrSlot95">
						</cfif>
					  </cfif>
							
					  <td align="center" style="padding-left:3px;background-color:#color#;min-width:35px;border-left:1px solid silver;" class="clsWSHrSlot #v9To5#">
							
				      <input type="checkbox" 
					      name="selecthour" 
						  id="selecthour" 
						  value="#day#_#hr#_#slt#" 
						  style="cursor: pointer;" <cfif check.recordcount eq "1">checked</cfif>>
						  
					  </td>	  
						  
					</cfloop>
					
					</tr>
					</table>
					  
				</td>
				
			   </cfif>  	
			
		  </tr>
				
		</cfloop>
		
		</table>

	</td>
			
	</cfloop>	
	
	</tr>

</table>
	
</cfoutput>

<cfset ajaxonload("doHighlight")>