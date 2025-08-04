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


<cfquery name="Domain" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_ServiceItemDomain
		   
			<cfif getAdministrator(url.mission) eq "0">	
						
			WHERE   (
			
			      Code IN (SELECT ServiceDomain 
			               FROM   ServiceItem 
						   WHERE  Operational = 1
						   AND    Code IN (SELECT ClassParameter
								           FROM   Organization.dbo.OrganizationAuthorization
										   WHERE  UserAccount = '#SESSION.acc#'
										   AND    Role = 'WorkOrderProcessor')	
						  )		
				
				<!--- to be removed was used when requester was granted access 
				25/10/2011 reverted 
						
				OR
				
				  Code IN (SELECT ServiceDomain 
			               FROM   ServiceItem 
						   WHERE  Operational = 1
						   AND    Code IN (SELECT ClassParameter
								           FROM   Organization.dbo.OrganizationAuthorization
										   WHERE  UserAccount = '#SESSION.acc#'
										   AND    Role = 'ServiceRequester')	
						  )		
						  
						  --->
				
				)
			<cfelse>		
				
			WHERE  	
			      Code IN (SELECT ServiceDomain 
			               FROM   ServiceItem 
						   WHERE  Operational = 1) 
						  
			</cfif>		
			
			<!--- used in this mission --->
			
			AND   Code IN (SELECT ServiceDomain FROM ServiceItem WHERE Code IN (SELECT ServiceItem FROM ServiceItemMission WHERE Mission = '#url.mission#'))
						  											
</cfquery>

<cfoutput>
	   
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	
	<tr><td height="20" colspan="2" align="center" style="padding:2px">
	
				
			<cfquery name="hasPerson" 
				datasource="#url.dsn#"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     WL.PersonNo
				FROM	   WorkOrderLine WL INNER JOIN
			               WorkOrder W ON WL.WorkOrderId = W.WorkOrderId
				WHERE      W.Mission = '#url.mission#' 
				AND        WL.PersonNo IN
			                   (
							    SELECT   PersonNO
			                    FROM     Employee.dbo.Person
			                    WHERE    PersonNo = WL.PersonNo
			         		   )
			</cfquery>
	
			<select name="domaininv" id="domaininv" class="regularxl" style="width:96%;"
			onchange="find('#url.mission#',this.value,document.getElementById('searchme').value,document.getElementById('mode').value,'#url.dsn#','#url.systemfunctionid#')">
					<option value="Customer"><cf_tl id="Customer"></option>
					<cfif hasPerson.recordcount gte "1">
					<option value="Person"><cf_tl id="Assigned Employee"></option>
					</cfif>
					<cfloop query="Domain">
					<option value="#Code#">#Description#</option>			
					</cfloop>
				</select>
			</td>
			
		
		</td>
	</tr>	
	
	<tr><td height="20" colspan="2" align="center" style="padding:2px">
					
			<cfquery name="DeactivateIsValid" 
				datasource="#url.dsn#"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     TOP 1 *
				FROM       Ref_ServiceItemDomain R INNER JOIN
			               ServiceItem S ON R.Code = S.ServiceDomain INNER JOIN
			               ServiceItemMission W ON S.Code = W.ServiceItem
				WHERE      R.AllowConcurrent = '0' AND W.Mission = '#url.mission#'    
			</cfquery>		

				
			<select name="mode" id="mode" class="regularxl"
	        style="width:96%;"
			onchange="find('#url.mission#',document.getElementById('domaininv').value,document.getElementById('searchme').value,this.value,'#url.dsn#','#url.systemfunctionid#')">
					
					
					<cfif DeactivateIsValid.recordcount gte "1">
					<!--- on ore more items for this mission has conccurency disabled --->
					<option value="Active"><cf_tl id="Active record"></option>
					<option value="Expired"><cf_tl id="Expired Records"></option>		
					<cfelse>
					<option value="Active"><cf_tl id="Active record"></option>
					</cfif>
					
								
					<option value="Disabled"><cf_tl id="Disabled Records"></option>		
					<option value="Any"><cf_tl id="All Records"></option>		
			</select>	
			
	</td></tr>
	
	<tr>
	<td colspan="2" height="20" style="padding:1px">
	
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr>
	<td width="40"><img src="#SESSION.root#/images/join.gif" alt="" border="0"></td>
	<td width="90%">
	
		<table width="98%" border="0" cellspacing="0" cellpadding="0" style="height:28;border:1px solid silver">
							
			<tr>
			<td style="padding-left:4px;padding-top:1px">
			
			<input type="text" class="regularxl" id="searchme" name="searchme" value="" style="border:0px solid silver;width:100%" class="enterastab regular3" onKeyUp="dosearch()">
			
			</td>
			
			<td width="20" align="center" style="padding-right:1px">
			
				<img src="#SESSION.root#/images/search.png" 
				   align="absmiddle" 
				   height="24" width="24" style="cursor:pointer"
				   id="searchicon"  				   
				   alt="" 
				   border="0" 
				   onclick="find('#url.mission#',document.getElementById('domaininv').value,document.getElementById('searchme').value,document.getElementById('mode').value,'#url.dsn#','#url.systemfunctionid#')">
				   
			</td>
			</tr>
		
		</table>
		
		
	</td>
	<td width="10%"></td>
	</tr>
	
	</table>
	
	</td>
	</tr>
			
	<tr><td height="4"></td></tr>
	
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>	
		
	<tr><td colspan="2" height="100%" style="padding:3px">	
    <cf_divscroll id="findme">
	   <cfinclude template="CustomerSearchResult.cfm">
	</cf_divscroll>
	</td></tr>
	
</table>

</cfoutput>