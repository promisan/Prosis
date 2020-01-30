<cfquery name="Dates"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   SalaryScheduleComponentDate D, SalaryScheduleComponent C
	WHERE  D.SalarySchedule = C.SalarySchedule
	AND    D.ComponentName  = C.ComponentName
	AND    ComponentId      = '#URL.ComponentId#'
</cfquery>
		
<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">

	<cfset row = 1>

	<cfoutput query="Dates">
			
		<cfif row eq 1>
		    <tr>	
		    <td width="100" class="labelit"><cf_tl id="Pay only on">:</td>
		</cfif>	
			
		<td class="labelit">&nbsp;
				
			<input type="Text"
		      name="c#url.ComponentId#"
		      value="#dateformat(EntitlementDate,CLIENT.DateFormatShow)#"		            
			  onchange="savedates('#URL.ComponentId#')"
			  class="regularxl"
		      visible="Yes"
		      enabled="Yes"
		      size="9"
		      style="text-align:center">
			  
		</td>
		
		<cfset row = row + 1>
		<cfif row eq "6">
		     </tr>
		     <cfset row = 1>
	    </cfif>
	
	</cfoutput>
	<tr>
	<td width="100" class="labelit"><cf_tl id="Pay only on">:</td>
	<td class="labelit">&nbsp;
	<cfoutput>
	    
	
		<input type="Text"
	      name="c#url.ComponentId#"
	      value=""	            
	      visible="Yes"
		  onchange="savedates('#URL.ComponentId#')"
		  class="regularxl"
	      enabled="Yes"
	      size="9"
	      style="text-align:center">
		  
	</cfoutput>	  
	</td>
	</tr>
	
</table>
