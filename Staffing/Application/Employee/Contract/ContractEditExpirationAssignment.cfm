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

<!--- determine a reassignment --->

<!---
<cfoutput>
#url.mission#
#url.personNo#
#url.expiration#
</cfoutput>
--->

<cfset dateValue = "">
<CF_DateConvert Value="#url.effective#">
<cfset EFF = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#url.expiration#">
<cfset EXP = dateValue>

<cfif IsDate(EXP)>
	
	<!--- check the last valid assignment  --->
	
	<!--- if the last assignment has status = 0 
	we need to close this action as well in my views, we observed this with --->
	
	<cfquery name="PersonAssignment" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT    TOP 1 *
		    FROM      PersonAssignment A INNER JOIN Position P ON A.PositionNo = P.PositionNo
			WHERE     A.PersonNo           = '#URL.PersonNo#'
			AND       P.MissionOperational = '#URL.Mission#'		 			  
			AND       A.AssignmentStatus IN ('0','1')
			AND       A.Incumbency     = '100'
			AND       A.AssignmentType = 'Actual'	
			<!--- added to find the assignment better --->	
			AND       A.DateEffective <= #EXP#	    
			ORDER BY  A.DateEffective DESC <!--- last one --->			 
	</cfquery>
	
	<cfquery name="LastAssignment" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT    *
		    FROM      PersonAssignment A INNER JOIN Position P ON A.PositionNo = P.PositionNo
			WHERE     A.PersonNo           = '#URL.PersonNo#'
			AND       A.AssignmentStatus IN ('0','1')
			AND       A.AssignmentClass = '#PersonAssignment.AssignmentClass#'						
			ORDER BY  A.DateEffective DESC 		 
	</cfquery>
	
	<!--- check for reappointment --->
	
	<!--- in case of a continuous period we allow it --->
	
	<cfset dte = dateAdd("d","-1",eff)>
		
	<cfquery name="hasAssignmentInPeriod" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT    TOP 1 *
		    FROM      PersonAssignment A INNER JOIN Position P ON A.PositionNo = P.PositionNo
			WHERE     A.PersonNo         = '#URL.PersonNo#'
			  AND     P.Mission          = '#URL.Mission#'		 			  
			  AND     A.AssignmentStatus IN ('0','1')
			  AND     A.Incumbency       = '100'
			  AND     A.AssignmentType   = 'Actual'		
			  <!--- in the period --->
			  AND     A.DateExpiration  >= #dte#
			  
			  AND     A.DateEffective   <= #EXP#	    
			ORDER BY  A.DateEffective DESC			 
	</cfquery>
			
	<cfquery name="Mandate" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		
		    SELECT  *
		    FROM    Ref_Mandate
			WHERE   Mission        = '#PersonAssignment.Mission#'		 
			AND     MandateNo      = '#PersonAssignment.MandateNo#'		
	</cfquery>
	
	<cfquery name="Check" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT  *
		    FROM    PersonAssignment
			WHERE   ContractId = '#URL.ContractId#'		
	</cfquery>
	
	<cfoutput>
	
	<cfset dateValue = "">
			
	<CF_DateConvert Value="#dateformat(PersonAssignment.DateExpiration,CLIENT.DateFormatShow)#">
	<cfset ASSEXP = dateValue>
	
	<cfif mandate.DateExpiration lt exp>
				
		<cfset dateValue = "">
		<CF_DateConvert Value="#dateformat(mandate.DateExpiration,CLIENT.DateFormatShow)#">
		<cfset CTREXP = dateValue>
		
	<cfelse>
		
	    <cfset CTREXP = EXP> 
		
	</cfif>
		
	<cfif hasAssignmentInPeriod.recordcount eq "0">
	
		<table height="100%" cellspacing="0" cellpadding="0" align="center">
				<tr class="labelmedium">
					<td style="width:7px"></td>
					<td style="border-left:1px solid silver;padding-left:4px;padding-left:8px;padding-right:5px"><font color="FF0000">Record a Post incumbency for this period!</font></td>
					<td style="padding-right:5px">
				</tr>
		</table>		
		
		<script>
			try { 
			
			    document.getElementById('positionbox').className = "regular"	
				_cf_loadingtexthtml='';	
				ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Contract/getAssignment.cfm?positionno='+document.getElementById('PositionNo').value+'&dateeffective='+document.getElementById('DateEffective').value+'&dateexpiration='+document.getElementById('DateExpiration').value,'assignmentbox')
				} catch(e) {}		
		</script>
	
	<cfelse>
	
		<script>
		   try {
			document.getElementById('positionbox').className = "hide";	
			$('##PositionNo').val('');
			$('##Position').val('');					
			} catch(e) {}
			
		</script>
		
		<cfquery name="CheckPosition" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		      SELECT * 
			  FROM   Position 		    
			  WHERE  PositionNo  = '#PersonAssignment.PositionNo#'
		      AND    DateEffective  <= #EFF#
			  AND    DateExpiration >= #EXP#  
		</cfquery>	
		
		<cfquery name="CheckParentPosition" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		      SELECT * 
			  FROM   Position 		    
			  WHERE  PositionParentId = '#PersonAssignment.PositionParentId#'
		      AND    DateEffective  <= #EFF#
			  AND    DateExpiration >= #EXP#  
		</cfquery>	
						
		<cfif checkParentPosition.recordcount gte "1" and checkPosition.recordcount eq "0">
		
		<table height="100%" cellspacing="0" cellpadding="0" align="center">
					<tr class="labelmedium">
						<td style="width:7px"></td>
						<td style="border-left:1px solid silver;padding-left:4px;padding-left:8px;padding-right:5px"><font color="FF0000">Position has moved, record Post Assignment.</font></td>
						<td style="padding-right:5px">
					</tr>
				</table>	
		
		<cfelseif checkPosition.recordcount eq "0">
		
			<table height="100%" cellspacing="0" cellpadding="0" align="center">
					<tr class="labelmedium">
						<td style="width:7px"></td>
						<td style="border-left:1px solid silver;padding-left:4px;padding-left:8px;padding-right:5px"><font color="FF0000">Update assignment separately.</font></td>
						<td style="padding-right:5px">
					</tr>
				</table>	
		
		<cfelse>					
		
			<cfif PersonAssignment.recordcount gte "1" 
			        and LastAssignment.AssignmentNo eq PersonAssignment.AssignmentNo>
				
					<cfif (url.expiration neq "" and CTREXP neq ASSEXP) OR (check.DateExpiration eq PersonAssignment.DateExpiration)>
							  									  
								<cfif CTREXP eq ASSEXP>
												
									<table height="100%" cellspacing="0" cellpadding="0" align="center">
										<tr class="labelmedium">
										<td style="width:7px"></td>
										<td style="border-left:1px solid silver;padding-left:4px;padding-left:8px;padding-right:5px"><cf_tl id="Set Assignment to">:&nbsp;#dateformat(CTREXP,CLIENT.DateFormatShow)#</td>
										<td style="padding-right:5px">
											<input type="checkbox"
											       name="ExtendAssignment" 
												   class="radiol"
												   id="ExtendAssignment" 
												   value="#PersonAssignment.AssignmentNo#" <cfif check.contractid eq "" and check.recordcount gte "1"><!--- nada ---><cfelse>checked</cfif>>
										</td>
										</tr>
									</table>
											
								<cfelseif CTREXP gt ASSEXP>
									
									<table height="100%" cellspacing="0" cellpadding="0" align="center">
										<tr class="labelmedium">
										<td style="width:7px"></td>
										<td style="border-left:1px solid silver;padding-left:4px;padding-left:8px;padding-right:5px;"><cf_tl id="Set Assignment to">:&nbsp;#dateformat(CTREXP,CLIENT.DateFormatShow)#</td>
										<td style="padding-right:5px">
											<input type="checkbox" class="radiol"
											       name="ExtendAssignment" 
												   id="ExtendAssignment" 
												   value="#PersonAssignment.AssignmentNo#" <cfif check.contractid eq "" and check.recordcount gte "1"><!--- nada ---><cfelse>checked</cfif>>
										</td>
										</tr>
									</table>
									
								<cfelseif CTREXP lt ASSEXP>
																		
									<table height="100%" cellspacing="0" cellpadding="0" align="center">
										<tr>
										<td style="width:7px"></td>
										<td class="labelit" style="border-left:1px solid silver;padding-left:4px;padding-left:8px;padding-right:5px"><cf_tl id="Set Assignment to">:&nbsp;#dateformat(CTREXP,CLIENT.DateFormatShow)#</td>
										<td style="padding-right:5px">
											<input type="checkbox"
											       name="ExtendAssignment" class="radiol" 
												   id="ExtendAssignment" 
												   value="#PersonAssignment.AssignmentNo#" <cfif check.contractid eq "" and check.recordcount gte "1"><!--- nada ---><cfelse>checked</cfif>>
										</td>
										</tr>
									</table>
									
								
								</cfif>
						
						</cfif>
						
				<cfelseif PersonAssignment.recordcount gte "1" 
			        and LastAssignment.AssignmentNo neq PersonAssignment.AssignmentNo>
					
					<!--- we support the checkbox only for the last active incumbency record of the same class --->
					
					<table height="100%" cellspacing="0" cellpadding="0" align="center">
					<tr class="labelmedium">
						<td style="width:7px"></td>
						<td style="border-left:1px solid silver;padding-left:4px;padding-left:8px;padding-right:5px"><font color="FF0000">Update assignment separately!</font></td>
						<td style="padding-right:5px">
					</tr>
					</table>							
				
				</cfif>
				
			</cfif>	
		
	 </cfif>
	 
	</cfoutput>

<cfelse>

		<script>
		alert("This is an invalid date")		
		</script>
		
		<input type="hidden" name="ExtendAssignment" value="">

</cfif>


	