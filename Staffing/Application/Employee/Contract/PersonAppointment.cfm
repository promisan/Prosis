
<!---
<cf_screentop height="100%" user="No" label="Appointment history" banner="yellow" option="Summary of appoitments and extensions (trial version)" layout="webapp">
--->

<cfquery name="List" 
 datasource="AppsEmployee">
 
	SELECT      PersonNo, ContractId, Mission, DateEffective, DateExpiration, ActionStatus, ActionCode, ContractType, ContractTime, ContractLevel, ContractStep, ServiceLocation, 
	            AppointmentStatus,HistoricContract,GroupListCode,
				(SELECT   Description
				 FROM     Ref_ContractType
				 WHERE    ContractType = C.ContractType ) as Description,
				 (SELECT   Description
				 FROM     Ref_Action
				 WHERE    ActionCode = C.ActionCode ) as ActionDescription

	FROM        PersonContract C
	WHERE       PersonNo = '#url.id#' 
	AND         ContractId IN (SELECT ActionSourceId 
	                           FROM   EmployeeAction 
							   WHERE  ActionStatus = '1' 
							   AND    ActionPersonNo = '#url.id#') 
	
	<!---
	UNION
		
	SELECT      PersonNo, ContractId, Mission, DateEffective, DateExpiration, ActionStatus, ActionCode, ContractType, ContractTime, ContractLevel, ContractStep, ServiceLocation, 
	            AppointmentStatus, HistoricContract,GroupListCode,
				(SELECT   Description
				 FROM     Ref_ContractType
				 WHERE    ContractType = C.ContractType ) as Description
				 
	FROM        PersonContract AS C
	WHERE       PersonNo = '#url.id#' 
	AND         NOT EXISTS    (SELECT   'X' AS Expr1
                               FROM    EmployeeAction
                               WHERE   ActionSourceId = C.ContractId)
	     						   
	--->	
	ORDER BY    DateEffective, ActionStatus	
	
</cfquery>	

<cfset hist = list.historiccontract>
<cfset takestep = 0>
<cfset row = 0>

<cfoutput query="List">
	
	<cfif hist neq historiccontract>
		<cfset takeStep = "1">		
	</cfif>
		
	<cfif ActionCode eq "3000" or 
	      ActionCode eq "3003" or 
		  ActionCode eq "3022" or 
		  ActionCode eq "3023" or 
		  ActionCode eq "3024" or 		
		  ActionCode eq "3006" or  
		 (ActionCode eq "3001" and GroupListCode eq "16" or GroupListCode eq "7" or GroupListCode eq "12")>
					
		<cfset row = row+1>
	    <cfset ar[row][1] = mission>
		<cfset ar[row][2] = description>		
		<cfset ar[row][3] = dateformat(DateEffective,client.datesql)>
		<cfset ar[row][4] = dateformat(DateExpiration,client.datesql)>
		<cfset ar[row][5] = contractlevel>
		<cfset ar[row][6] = contractTime>
		<cfset ar[row][7]   = actionstatus>
		<cfset ar[row][8] = actiondescription>		
	
			
	<cfelseif ActionCode eq "3005">	<!--- promotion --->
	
		<cfset row = row+1>
	    <cfset ar[row][1]   = mission>
		<cfset ar[row][2]   = description>
		
		<cfset ar[row][3]   = dateformat(DateEffective,client.datesql)>
		<cfset ar[row][4]   = dateformat(DateExpiration,client.datesql)>	
		<cftry>
		<cfset ar[row-1][4] = dateformat(DateEffective-1,client.datesql)>	
		<cfcatch>
		<cfset ar[row][4] = dateformat(DateEffective,client.datesql)>	
		</cfcatch>
		</cftry>
		<cfset ar[row][5]   = contractlevel>
		<cfset ar[row][6]   = contractTime>
		<cfset ar[row][7]   = actionstatus>
		<cfset ar[row][8] = actiondescription>	
	
	<!--- disabled 	
	
	<cfelseif ActionCode eq "3006">	
		
		<!--- we correct the prior appointment --->		
		<cfset ar[row-1][3] = dateformat(DateExpiration,client.dateformatshow)>	
	
	
	
	<cfelseif takeStep eq "1" and ActionCode eq "3004">
	
		<cfset row = row+1>
	    <cfset ar[row][1]   = mission>
		<cfset ar[row][2]   = description>		
		<cfset ar[row][3]   = dateformat(DateEffective,client.datesql)>
		<cfset ar[row][4]   = dateformat(DateExpiration,client.datesql)>	
		<cfset ar[row-1][4] = dateformat(DateEffective-1,client.datesql)>
		<cfset ar[row][5]   = contractlevel>
		<cfset ar[row][6]   = contractTime>
		<cfset ar[row][7]   = actionstatus>
	
		<cfset takestep = "0">
		
		--->
	</cfif>
	

	<cfset hist = HistoricContract>

</cfoutput>

<cfoutput>

<!---
<cfdump var="#ar#" output="browser">
--->

<cf_divscroll>

<table style="width:95%" align="center" class="navigation_table">

<tr><td style="height:8px"></td></tr>

<cfif List.recordcount gte "1">

	<cfloop array="#ar#" index="itm">
	
		<cfif itm[3] lte itm[4]>
	
		<tr class="labelmedium line navigation_row" style="height:18px">
			<td style="padding-left:5px">#itm[1]#</td>
			<td>#itm[8]#</td>
			<td>#itm[2]#</td>			
			<td>#itm[5]#</td>
			<td>#itm[6]#%</td>
			<td>#itm[7]#</td>
			<td align="right" style="width:90;padding-right:5px">#dateformat(itm[3],client.dateformatshow)#</td>
			<td style="width:5px">-</td>
			<td style="width:90;padding-left:5px">#dateformat(itm[4],client.dateformatshow)#</td>
		</tr>
		
		</cfif>
	
	</cfloop>
	
</cfif>	
	
</table>	

</cf_divscroll>

</cfoutput>

<cfset ajaxonload("doHighlight")>