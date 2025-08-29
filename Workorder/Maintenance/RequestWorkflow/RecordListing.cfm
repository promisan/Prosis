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
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	R.*, 
			T.Description as requestTypeDescription, 
			S.Description as serviceDomainDescription,
			(SELECT C.EntityClassName 
			 FROM   Organization.dbo.Ref_EntityClass C
			 WHERE  R.entityClass = C.entityClass 
			 AND    C.EntityCode = 'WrkRequest') as EntityClassName
	FROM 	Ref_RequestWorkflow R,
			Ref_Request T,
			Ref_ServiceItemDomain S
	WHERE 	R.requestType = T.Code	
	AND		R.serviceDomain = S.Code
	ORDER BY ServiceDomain, requestType, requestAction
</cfquery>

<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<table width="94%" height="100%" align="center">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset Header       = "Request type workflow">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 850, height= 530, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1, id2, id3) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 + "&ID2=" + id2 + "&ID3=" + id3, "Edit", "left=80, top=80, width=850, height= 530, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>
	
<tr><td colspan="2">

<cf_divscroll>

<table width="97%" align="center" class="navigation_table">

<tr class="labelmedium2 line">
    <td width="60"></td> 
	<td></td>
	<td>Action</td>
	<td>Name</td>
	<td>Custom Form</td>
    <td>Custom Form Condition</td>
	<td>Workflow Class</td>
	<td align="center">Oper.</td>
	<td>Officer</td>
	<td>Created</td>
  
</tr>

<cfoutput query="SearchResult" group="serviceDomain">

	<tr><td colspan="10" style="height:40px;font-size:20px" class="labelmedium2"><b>#serviceDomain# - #serviceDomainDescription#</b></td></tr>
	
	<cfoutput group="requestType">
	
	<tr><td colspan="10" class="line labelmedium2">#requestType# - #requestTypeDescription#</td></tr>
	
	<cfoutput>
	  
	    <tr class="navigation_row line labelmedium2"> 
		<td></td>
		<td width="20" align="center">
			<cf_img icon="open" navigation="Yes" onclick="recordedit('#serviceDomain#','#requestType#','#requestAction#')">
		</td>		
		<td>#requestAction#</td>
		<td>#requestActionName#</td>
		<td>#customForm#</td>
		<td>#customFormCondition#</td>
		<td>#EntityClassName#</td>	
		<td align="center"><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	    	
	</cfoutput>
	
	</cfoutput>
	
</cfoutput>

</table>

</cf_divscroll>

</td>
</tr>

</table>

