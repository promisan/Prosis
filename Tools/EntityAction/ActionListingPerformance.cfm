
	<!--- check if flow is completed --->
	
	<cfparam name="url.actionid" default="">
	
	<cfif url.actionid neq "">
	
	<cftry>
	<cfquery name="Update" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE   OrganizationObjectAction
			SET ActionTakeAction = '#url.hour#' 
			WHERE    ActionId = '#url.ActionId#' 			
	</cfquery>	
	
		<cfcatch></cfcatch>	
		
	</cftry>
	
	</cfif>
	
	<cfquery name="Check" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     OrganizationObjectAction
			WHERE    ObjectId = '#ObjectId#' 
			AND      ActionStatus = '0'			
	</cfquery>		
	
	<cfif Check.recordcount eq "0">
	
		<!--- closed --->
	
		<cfquery name="Perf" 
			datasource="AppsOrganization"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   ObjectId, 
				         SUM(ActionTakeAction) AS Planned, 
						 DATEDIFF([hour], MIN(Created), MAX(OfficerDate)) AS Actual, 
						 MIN(Created) AS StartStamp, 
				         MAX(OfficerDate) AS EndStamp
				FROM     OrganizationObjectAction
				WHERE    ObjectId = '#ObjectId#' 
				AND      ActionStatus >= '1'
				<!--- concurrent steps should be excluded from the available time --->
				AND      ActionConcurrent = 0
				GROUP BY ObjectId
		</cfquery>		
	
	
	<cfelse>
	
		<cfquery name="Perf" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   ObjectId, 
			         SUM(ActionTakeAction) AS Planned, 
					 DATEDIFF([hour], MIN(Created), getdate()) AS Actual, 
					 MIN(Created) AS StartStamp, 
			         getDate() AS EndStamp
			FROM     OrganizationObjectAction
			WHERE    ObjectId = '{#ObjectId#}'
			<!--- concurrent steps should be excluded from the available time --->
			AND      ActionConcurrent = 0 
			AND      (
			
					  ActionStatus >= '1' 
			  
			             OR 
						 
					  ActionId IN (SELECT TOP 1 ActionId 
						           FROM     OrganizationObjectAction
								   WHERE    ObjectId = '{#ObjectId#}'
								   AND      ActionStatus = '0'
								   ORDER BY ActionFlowOrder
								  )
			
					 )
			
			GROUP BY ObjectId
	    </cfquery>		
	
	
	</cfif>
	
	<cfoutput>
	
	<cfif Perf.Actual gt "0">			
		
		<table width="100%" bgcolor="D2EBF9">
			<tr class="labelmedium line">
			<td width="180"
			        height="20"
					align="center"
			        bgcolor="f1f1f1"
					class="labelit"><cf_tl id="Process Indicator"></td>
			<td width="50" style="padding-left:5px;padding-right:4px"><cf_tl id="Allowed"></td>
			<td><b>#Perf.Planned# <cfif Perf.Planned gt "1"><cf_tl id="hour"><cfelse><cf_tl id="hours"></cfif></td>
			<td width="40" style="padding-right:4px"><cf_tl id="Used"></td>
			<td><b>#Perf.Actual# hour<cfif Perf.Actual gt "1">s</cfif></b> since #dateformat(Perf.StartStamp,CLIENT.DateFormatShow)# #timeformat(Perf.StartStamp,"HH:MM")#</td>
			<td width="70" style="padding-right:4px"><cf_tl id="Compliance"></td>
			<cfset ratio = (Perf.Planned/Perf.Actual)*100>
			
			<cfif ratio lte "60">
				 <cfset color = "red">
				<cfelseif ratio lte "80">
				 <cfset color = "yellow"> 
				<cfelse>
				 <cfset color = "green"> 
				</cfif>
			
			<td width="70"><b><font color="#color#">#numberformat(ratio,"__._")# %</td>
			<td align="right">
				
				<table width="100" border="1" bordercolor="silver" cellspacing="0" cellpadding="0">
				<tr>					
					<td height="10" width="#ratio#" bgcolor="#color#"></td>
					<td width="#100-ratio#" bgcolor="fafafa"></td>
				</tr>
				</table>
			
			</td>
			<td width="10">&nbsp;</td>				
			</tr>
			
		</table>
							
	</cfif>
	
	</cfoutput>
	