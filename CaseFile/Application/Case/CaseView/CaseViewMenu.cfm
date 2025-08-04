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

<table height="100%" cellspacing="0" cellpadding="0">
	
	<cfquery name="Claim" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  Claim
			WHERE ClaimId = '#URL.claimid#'	
	</cfquery>
	
	<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			    SELECT *
			    FROM  Person
				WHERE PersonNo = '#Claim.PersonNo#'	
			</cfquery>
	
	<cfoutput>
	
	<tr>
			
	<cfquery name="Object" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  OrganizationObject
				WHERE ObjectKeyValue4 = '#URL.claimid#'	
	</cfquery>		
	
	<cfoutput>
		
		<script language="JavaScript">
		
			function details(objectid,itm) {
			   w = #CLIENT.width# - 100;
			   h = #CLIENT.height# - 130;
			   ptoken.open("#SESSION.root#/tools/entityaction/details/DetailsSelect.cfm?mode=window&objectid=#object.objectid#&item="+itm,itm)
			}
		
		</script>
	
	</cfoutput>
	
	<td align="right" width="350">
	
	<!--- disabled hanno 18/8/2020 
	
	<cfmenu 
	    name="claimmenu"
	    font="verdana"
	    fontsize="12"
	    bgcolor="transparent"
	    selecteditemcolor="C0C0C0"
	    selectedfontcolor="FFFFFF">
			 
		<cfinvoke component = "Service.Access"  
			    method           = "CaseFileManager" 
				mission          = "#claim.Mission#" 
			    claimtype        = "#claim.ClaimType#"   
			    returnvariable   = "accessLevel">				
				
		<cfif Accesslevel neq "NONE">		
			
			<cf_tl Id="Time and Expense Sheet" var="1">			  
					  
			<cfmenuitem 
			    display="#lt_text#"
			    name="addact"
			    href="javascript:details('#Object.objectid#','cost')"
			    image="#SESSION.root#/Images/activity.gif"/>			
			
		</cfif>	
		
		<!--- deprecated we now have the messaenger
				  
		<cf_tl Id="Mail and Notes" var="1">			  
					  
		<cfmenuitem 
		     display="#lt_text#"
		     name="addnote"
		     href="javascript:details('#Object.objectid#','mail')"
		     image="#SESSION.root#/Images/broadcast.png"/>		 
			 
		 --->	 
	
	</cfmenu>
	
	--->

</td></tr>

</cfoutput>

</table>
