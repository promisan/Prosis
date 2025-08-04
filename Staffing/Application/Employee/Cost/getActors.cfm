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


<cfset act = "">

<cfloop index="itm" from="1" to="10">
	
	 <cfset ecl = evaluate("Form.EntityClass_#itm#")>
	 
	 <cfif ecl neq "">
	     <cfif act eq "">
		     <cfset act = "'#ecl#'">
		 <cfelse>
		 	<cfset act = "#act#,'#ecl#'">
		 </cfif>	
	 </cfif>
	 
</cfloop>

<cfif act neq "">

	<script>
		document.getElementById('actors').className = "regular"
	</script>
	
	<cfquery name="getAction" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
		SELECT   DISTINCT EP.ActionCode, R.ActionDescription, R.ListingOrder, 
                          (SELECT     TOP (1) ActionDescription
                            FROM          Ref_EntityActionPublish
                            WHERE      (ActionCode = EP.ActionCode)
                            ORDER BY ActionPublishNo DESC) AS Description

		FROM     Ref_EntityActionPublish AS EP INNER JOIN
		         Ref_EntityClassPublish AS CP ON EP.ActionPublishNo = CP.ActionPublishNo INNER JOIN
		         Ref_EntityAction AS R ON EP.ActionCode = R.ActionCode
		WHERE    CP.EntityClass IN (#preserveSingleQuotes(act)#) 
		AND      CP.EntityCode = 'Entcost' 
		AND      EP.ActionAccess <> ''
		ORDER BY R.ListingOrder
		
	</cfquery>

	<table>
	
	<cfoutput>
	<input type="hidden" name="Actions" value="#quotedvalueList(getAction.ActionCode)#">
	</cfoutput>
	
	<cfoutput query="getAction">
	
	  <tr class="labelmedium" style="height:30px">
	  
	  	  <td style="padding-right:6px">#Description#</td>
	  	  <td>
	  
		  <table style="border:0px solid silver">
				<tr>
						
					<cfset link = "#session.root#/Staffing/Application/Employee/Cost/getPerson.cfm?personno=#url.personno#&field=#ActionCode#">						
																
					<td style="width:140px"><cfdiv bind="url:#link#&Account=" id="#ActionCode#_box"/></td>
					
					<td width="20" style="padding-left:4px">
						
					   <cf_selectlookup
						    box        = "#ActionCode#_box"
							link       = "#link#"
							button     = "Yes"
							close      = "Yes"						
							icon       = "lookup.png"
							iconheight = "26"
							iconwidth  = "26"
							style      = "border:0px solid silver"
							filter2    = "onboard"							
							class      = "user"
							des1       = "Account">
							
					</td>	
				    								
				</tr>
			</table>	
						 
		  </td>
	  </tr>
	  
	</cfoutput>
	</table>	
	
<cfelse>

	<script>
		document.getElementById('actors').className = "hide"
	</script>

</cfif>	

