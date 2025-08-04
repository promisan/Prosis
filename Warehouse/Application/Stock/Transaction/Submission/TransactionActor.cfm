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
<cfquery name="Actors" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_TaskTypeActor
		WHERE     Code    = 'Internal'  
		AND       EnableDistribution = 1
		ORDER BY  ListingOrder
</cfquery>

<cfset setPerson = "">

<table width="100%" cellspacing="0" cellpadding="0" align="center">

<tr>
	<td width="20%"></td>
	<td>
		<table cellspacing="0" cellpadding="0">
			<tr>
				<td class="labelsmall" style="padding-left:16px;font:9px;width:80"><cf_tl id="Id"></td>
				<td class="labelsmall" style="font:9px;width:130;padding-left:7px"><cf_tl id="FirstName"></td>
				<td class="labelsmall" style="font:9px;width:210;padding-left:7px"><cf_tl id="LastName"></td>
			</tr>			
		</table>
	</td>   
</tr>

<cfoutput query="Actors">

	<tr>
		<td width="20%" class="labelit">
			<input type="hidden" class="roleRole" name="role_#role#" id="role_#role#" value="#role#">
			<input type="hidden" class="rolePersonNo" name="personno_#role#" id="personno_#role#" value="">
			<input type="hidden" class="roleObligatory" name="obligatory_#role#" id="obligatory_#role#" value="#obligatory#">
			#Description#:
		</td>
	
		<td height="16" style="padding-left:0px">  
		
			<table cellspacing="0" cellpadding="0">
			
				<cfif entrymode eq "Lookup"> 
				
					<!--- inherit the first person --->  
					
					<cfset link = "#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/getEmployee.cfm?field=Actor_#role#"> 
					
					<tr>
						<td>
						
							<cfif currentrow eq "1">
							<!--- inherit the officer / driver --->
							<cfdiv bind="url:#link#&selected=#SetPerson#" id="person_#role#"/>
							<cfelse>
							<cfdiv bind="url:#link#" id="person_#role#"/>
							</cfif>
						
						</td>
					
						<td style="padding-left:3px">
						
							<cf_selectlookup
								box        = "person_#role#"
								link       = "#link#"
								button     = "Yes"
								icon       = "contract.gif"
								style      = "height:18;width:18"
								close      = "Yes"
								type       = "employee"
								des1       = "Selected">
						
						</td>
					
					</tr>
					
				<cfelse>
					
					<cfif currentrow eq "1">
					
						<cfquery name="get" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT    *
								FROM      Person     
								WHERE     PersonNo = '#SetPerson#'          
						</cfquery>    
						
						<tr>
							<td style="padding-left:0px">
								<input type="text" class="regularxl roleReference" name="reference_#role#" id="reference_#role#" value="#get.Reference#" style="width:80" maxlength="20">
							</td>
							<td style="padding-left:7px">
								<input type="text" class="regularxl roleFirstName" name="firstname_#role#" id="firstname_#role#" value="#get.FirstName#" style="width:130" maxlength="30">      
							</td>         
							<td style="padding-left:7px">
								<input type="text" class="regularxl roleLastName"  name="lastname_#role#"  id="lastname_#role#"  value="#get.LastName#"  style="width:200" maxlength="40">      
							</td>
						</tr>
						
						<cfelse>
						
						<tr>
							<td style="padding-left:0px">
								<input type="text" class="roleReference" name="reference_#role#" id="reference_#role#" value="" style="width:100" maxlength="20">      
							</td>
							<td style="padding-left:7px">
								<input type="text" class="roleFirstName" name="firstname_#role#" id="firstname_#role#" value="" style="width:130" maxlength="40">      
							</td>         
							<td style="padding-left:7px">
								<input type="text" class="roleLastName" name="lastname_#role#" id="lastname_#role#" value="" style="width:130" maxlength="30">
							</td>
						</tr>
					
					</cfif>
				
				
				</cfif>   
			
			</table>
		
		</td> 
	</tr> 

</cfoutput> 

</table>
