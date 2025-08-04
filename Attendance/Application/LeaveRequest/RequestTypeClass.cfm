<!--
    Copyright © 2025 Promisan

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
		
<!--- prepopulate so ajax is not bother in case of refresh --->		

<cfquery name="get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_LeaveType								
		WHERE    LeaveType   = '#url.leavetype#'				
</cfquery>

<script language="JavaScript">

	  se = document.getElementsByName("backup")
	  cnt = 0
	  while (se[cnt]) {   
	    <cfif get.HandoverActionCode neq "">  
		  	se[cnt].className = "regular"
		<cfelse>
		    se[cnt].className = "hide"	
		</cfif>
	   cnt++	  
	  } 
  
</script>

<cfquery name="ListAll" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_LeaveTypeClass								
		WHERE    LeaveType   = '#url.leavetype#'		
		AND      Operational = 1		
</cfquery>

<cfquery name="List" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_LeaveTypeClass								
		WHERE     LeaveType   = '#url.leavetype#'		
		AND       Operational = 1
		<cfif url.source neq "Manual">
		AND       UserEntry = 1		
		</cfif>
		ORDER BY  ListingOrder
</cfquery>

<cfinvoke component  = "Service.Access" 
      method         = "RoleAccess"				  	
	  role           = "'LeaveClearer'"		
	  returnvariable = "manager">		   
		  
<cfif manager eq "Granted">
	<cfset access = "ALL">
</cfif>	  

<cfoutput>

	<table><tr><td>	
			
	<cfset initclass = "">
		
		<select name="leavetypeclass" id="leavetypeclass" style="border-left:1px solid silver;background-color:f1f1f1;min-width:220px;min-width:101%;border:0px" class="regularxxl" 
		    onchange="getreason('#url.id#','#url.leavetype#',this.value);">
			
			<!--- we look through the classes --->					
						
			<cfloop query="List">
															
					<cfquery name="Checkappointment" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_LeaveTypeClassAppointment								
							WHERE    LeaveType      = '#url.leavetype#'
							AND      LeaveTypeClass = '#Code#'	
							
					</cfquery>		
					
					<cfif manager eq "Granted">
					
							<cfif initclass eq "">
								<cfset initclass = code>
							</cfif>
			
							<option value="#Code#">#Description#</option>	
								
										
					<cfelseif CheckAppointment.recordcount eq "0">
										
					        <!--- no filter has been set for this class in that case we always show it --->
					
							<cfif initclass eq "">
								<cfset initclass = code>
							</cfif>
			
							<option value="#Code#">#Description#</option>	
							 
				    <cfelse>										
										
						<!--- we only show the class for for the relevant appointment status the class --->
					
						<cfquery name="check" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_LeaveTypeClassAppointment								
							WHERE    LeaveType       = '#url.leavetype#'
							AND      LeaveTypeClass  = '#Code#'		
							AND      AppointmentStatus IN (SELECT AppointmentStatus 
							                               FROM   PersonContract	
														   WHERE  Personno = '#url.id#'
														   AND    ActionStatus IN ('0','1')														   
														   AND    DateExpiration >= getdate())
													   
					    </cfquery>
						
						<cfif check.recordcount eq "0" and url.source eq "Manual">
						
						    <cfif initclass eq "">
								<cfset initclass = code>
							</cfif>
			
					        <option value="#Code#">#Description#</option>													
					
					    <cfelseif check.recordcount gte "1">
						
							<cfif initclass eq "">
								<cfset initclass = code>
							</cfif>
			
					        <option value="#Code#">#Description#</option>	
							
						</cfif>			
							
					</cfif>		
			</cfloop>	
		</select>
	
	</td>
	
	<td id="reason" style="padding-left:3px">
				
		<cfquery name="getClass" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_LeaveTypeClass								
				WHERE    LeaveType   = '#url.leavetype#'	
				AND      Code        = '#initclass#'		
					
		</cfquery>
		
		<cfif getClass.GroupCode neq "">
		
			<cfset url.leaveclass = initclass>		
			<cfinclude template="getReason.cfm">
			
		<cfelse>
				
			<script> 		
				 ptoken.navigate('#session.root#/Attendance/Application/LeaveRequest/setBalance.cfm?id=#url.id#','result')	
			</script>	
		
		</cfif>
	
	</td>
	
	</tr>
	</table>

</cfoutput>

<cfif ListAll.recordcount lte "1" and getClass.GroupCode eq "">

	<script language="JavaScript">
         document.getElementById('rowaction').className = "hide"
	</script>

<cfelse>

	<script language="JavaScript">
         document.getElementById('rowaction').className = "regular"
	</script>

</cfif>


