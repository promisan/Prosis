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
<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0">
<cfset Header       = "Salary Scale Components">
 
<tr style="height:10px"><td><cfinclude template = "../HeaderPayroll.cfm"></td></tr>

<!--- initially set the class --->
 
<cfoutput>

<script LANGUAGE = "JavaScript">
	
	function recordadd(grp) {
         ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=780, height=770, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {	          
         ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=770, height=770, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput>

<tr><td height="100%">

	<table width="96%" height="100%" align="center">
	
	<tr class="line" style="height:20px">   
		<td style="height:45;font-size:20px;padding-left:10px" class="labelmedium" colspan="12">
		<table>
		<tr class="labelmedium2">
					
			<cfquery name="SearchResult"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT  *,  
				        R.Description as TriggerDescription
				FROM    Ref_PayrollComponent C,
				        Ref_PayrollTrigger R, 
						Ref_PayrollItem I
				WHERE   R.SalaryTrigger = C.SalaryTrigger
				AND     C.PayrollItem = I.PayrollItem	
				ORDER BY R.TriggerGroup,R.SalaryTrigger, C.EntitlementPointer, ListingOrder DESC
			</cfquery>
			
			<cfquery name="Trigger" dbtype="query">
				SELECT  DISTINCT TriggerGroup,SalaryTrigger, TriggerDescription
				FROM   SearchResult
			</cfquery>
	
			<!-- <cfform> -->
			<td style="padding-right:4px"><cf_tl id="Trigger"></td>
			<td>
			
			<cfselect name="Trigger"
	          group="TriggerGroup"
	          queryposition="below"
	          query="Trigger"
	          value="SalaryTrigger"
	          display="TriggerDescription"
	          visible="Yes"
	          enabled="Yes"
			  onchange="ptoken.navigate('RecordListingDetail.cfm?trigger='+this.value,'content')"
	          style="width:300px;font-size:16px"
	          class="regularxb">
			<option value="" selected>Any</option>		
			</cfselect>
			</td>
			<!-- </cfform> -->
			
		</tr>
		
		</table>	
		
		</td>	
	</tr>
	
	<tr><td height="100%">	
		<cf_divscroll style="height:100%" id="content">		
			<cfinclude template="RecordListingDetail.cfm">
		</cf_divscroll>
	
	</td></tr>
	
	</table>
	
</td></tr>

</table>