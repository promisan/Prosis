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
<cfparam name="url.initial" default="no">

	<cfquery name="Entry" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM     Ref_EntryClass
			WHERE Code = '#url.entryclass#'
		</cfquery>
		
  <cfif Entry.CustomDialog neq "Contract">
		
	   <cfset link = "#SESSION.root#/Procurement/Maintenance/Item/Budgeting/RecordStandard.cfm?itemmaster=#URL.ID1#">	
	
	   <cf_tl id="Procurement Standards" var="vProcurement">
	
	   <cf_selectlookup
	    class    = "Standard"
	    box      = "l#URL.ID1#_standard"
		title    = "#vProcurement#"
		link     = "#link#"		
		icon     = "insert.gif"						
		dbtable  = "Procurement.dbo.ItemMasterStandard"
		des1     = "StandardCode">
	
  <cfelse>
  
	  <cfset link = "#SESSION.root#/Procurement/Maintenance/Item/Budgeting/RecordFunction.cfm?itemmaster=#URL.ID1#">
	  
	  <cf_tl id="Functional Titles" var="vFunction">
	  
	  <cf_selectlookup
	    class    = "Function"
	    box      = "l#URL.ID1#_standard"
		title    = "#vFunction#"
		link     = "#link#"			
		icon     = "insert.gif"					
		dbtable  = "Procurement.dbo.ItemMasterFunction"
		des1     = "FunctionNo">	
		
  </cfif>	
  
  <cfif url.initial eq "No">
  
	  <cfoutput>
		  <script>
			  ptoken.navigate('#link#','l#url.id1#_standard')
		  </script>
	  </cfoutput>
  
  </cfif>