					
<cfquery name="Scope" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_AppointmentStatusMission
			WHERE  Mission = '#url.mission#'
</cfquery>			

<cfif scope.recordcount eq "0">

		<cfquery name="AppStatus" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_AppointmentStatus	
			WHERE  Operational = 1							
		</cfquery>				
								
<cfelse>
	
		<cfquery name="AppStatus" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  Ref_AppointmentStatus
			WHERE Code = '#url.appointment#'	
			<cfif scope.recordcount neq "0">
				OR Code IN ( 
					    SELECT AppointmentStatus
					    FROM   Ref_AppointmentStatusMission
						WHERE  Mission = '#url.mission#' OR Operational = 1)
					 
			</cfif>
		</cfquery>							
								
</cfif>	

<cfset val = quotedvalueList(AppStatus.Code)>
	
<cfquery name="list" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_AppointmentStatus
		WHERE  Code IN (SELECT AppointmentStatus 
		             	FROM   Ref_AppointmentStatusContract
						WHERE  ContractType = '#url.contracttype#'
						AND    AppointmentStatus IN (#preservesingleQuotes(val)#))
</cfquery>	

<cfif list.recordcount eq "0">
	
	<cfquery name="list" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_AppointmentStatus
				WHERE  Code IN (#preservesingleQuotes(val)#)
		</cfquery>	

</cfif>

<cfoutput>

<table width="100%">
<tr>
<td>

<cfset selected = list.code>

<select name="appointmentstatus" id="appointmentstatus" size="1" class="regularxxl" style="width:99%;border:0px" 
 onchange="ptoken.navigate('#SESSION.root#/staffing/Application/Employee/Contract/getAppointmentStatus.cfm?contractid=#url.Contractid#&appointmentstatus='+this.value,'appointmentmemo')">
	<cfloop query="List">	
	<option value="#Code#" <cfif Code eq url.appointment>selected</cfif>>
   		#Description#
	</option>
	<cfif list.code eq url.appointment>
		<cfset selected = list.code>
	</cfif>
	</cfloop>
</select>

</td>
</tr>

<tr>												
	<td style="width:100%;padding-left:3px">			   			
		<cfdiv bind="url:#SESSION.root#/staffing/Application/Employee/Contract/getAppointmentStatus.cfm?contractid=#url.contractid#&appointmentstatus=#selected#" id="appointmentmemo"/>						
	</td>												
</tr>

</table>

</cfoutput>
