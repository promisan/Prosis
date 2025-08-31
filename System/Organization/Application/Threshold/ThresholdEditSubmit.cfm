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
<cfif Len(Form.Memo) gt 100>
  <cfset remarks = left(Form.Memo,100)>
<cfelse>
  <cfset remarks = Form.Memo>
</cfif> 

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = #dateValue#>

<!---
<cfset dateValue = "">

<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	
--->

<!--- verify if record exist --->

<cfquery name="Threshold" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT A.*
	FROM   OrganizationThreshold A
	WHERE  ThresholdId  = '#Form.ThresholdId#'
</cfquery>

<cfif Threshold.recordCount eq 1> 
	
	 <cfquery name="InsertContract" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   UPDATE OrganizationThreshold 
	   SET   DateEffective       = #STR#,	    	
			 Currency            = '#Form.Currency#', 
			 AmountThreshold     = '#Form.AmountThreshold#',			
			 Memo                = '#Remarks#'
	   WHERE ThresholdId  = '#Form.ThresholdId#'	 
	   </cfquery>
  
</cfif>	

<cfset url.id = Form.OrgUnit>	  
<cfinclude template="ThresholdListing.cfm">	  

	

