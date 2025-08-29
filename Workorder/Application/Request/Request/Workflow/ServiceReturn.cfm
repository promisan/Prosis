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
<!--- PURPOSE : worflow workorder dialog to be embedded --->
<!--- -assign the request to a user and a service id--- --->
<!--- ------------------------------------------------- --->

<cfquery name="get"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Request
	WHERE    RequestId = '#Object.ObjectKeyValue4#'	
</cfquery>		

<table width="96%" align="center">
<tr><td height="10"></td></tr>

<!--- ------------------------------------------------- --->
<!--- ------------- EXPIRATION DATE ------------------- --->
<!--- ------------------------------------------------- --->

<tr>
	<td><font color="808080"><cf_tl id="Expiration">:</td>
	<td height="#ht#">	
		
	 <cfif get.DateExpiration eq "">
			
		  <cf_intelliCalendarDate9
			FieldName="dateexpiration"
			Manual="True"	
			Class="regular"	
			ToolTip="Request Expiration Date" 				
			Default=""				
			AllowBlank="True">	
		
	 <cfelse>
	 
		  <cf_intelliCalendarDate9
			FieldName="dateexpiration"
			Manual="True"	
			Class="regular"	
			ToolTip="Request Effective Date" 				
			Default="#Dateformat(get.DateExpiration, CLIENT.DateFormatShow)#"				
			AllowBlank="True">	
	 
	 </cfif>	
		
	</td>
</tr>


<input type="hidden" name="savecustom" id="savecustom" value="WorkOrder/Application/Request/Request/Workflow/ServiceReturnSubmit.cfm">

</table>
