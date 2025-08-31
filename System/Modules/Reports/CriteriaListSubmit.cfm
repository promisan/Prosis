<!--
    Copyright © 2025 Promisan B.V.

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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.Operational" default="0">

<cfquery name="Check" 
    datasource="AppsSystem" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ReportControlCriteriaList
	WHERE ControlId = '#URL.ID#'
	AND CriteriaName = '#URL.ID1#'
	AND ListValue = '#Form.ListValue#'
</cfquery>

<cfif #Check.recordCount# eq "1">

	   <cfquery name="Update" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE  Ref_ReportControlCriteriaList
			  SET Operational = '#Form.Operational#',
			      ListDisplay = '#Form.ListDisplay#',
				  ListOrder   = '#Form.Listorder#'
			 WHERE ControlId = '#URL.ID#'
			 AND CriteriaName = '#URL.ID1#'
			 AND ListValue = '#Form.ListValue#'
	    	</cfquery>

<cfelse>
	
	<cfif #URL.ID2# eq "">
	
		<cfquery name="Insert" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Ref_ReportControlCriteriaList
		         (ControlId,
				 CriteriaName,
				 ListValue,
				 ListDisplay,
				 ListOrder,
				 Operational,
				 Created)
		      VALUES ('#URL.ID#',
				  '#URL.ID1#',
		      	  '#Form.ListValue#',
				  '#Form.ListDisplay#',
				  '#Form.ListOrder#',
				  '#Form.Operational#',
				  getDate())
		</cfquery>
		
	<cfelse>
		
		   <cfquery name="Update" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE  Ref_ReportControlCriteriaList
			  SET Operational = '#Form.Operational#',
			  ListDisplay = '#Form.ListDisplay#'
			 WHERE ControlId = '#URL.ID#'
			 AND CriteriaName = '#URL.ID1#'
			 AND ListValue = '#URL.ID2#'
	    	</cfquery>
		
	</cfif>
	
</cfif>	
 	
<script>
 <cfoutput>
	 window.location = "CriteriaList.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#"
 </cfoutput> 
</script>	
  
