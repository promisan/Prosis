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

<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    select *, (select count(*) from serviceItemUnit where frequency = f.code) as serviceItemUnitOccurrences
	from Ref_Frequency f
</cfquery>


<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset Header       = "Billing mode">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

<cfoutput>

<script>

function recordadd(grp) {
       ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 225, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1, id2) {
       ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 + "&OC=" + id2, "Edit", "left=80, top=80, width= 500, height= 225, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">

	<cf_divscroll>
	
	<table width="95%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line" style="height:20px;">
	    <td></td> 
	    <td>Code</td>
		<td>Description</td>
		<td>Units</td>
	    <td>Entered</td>
	  
	</tr>
	
	<cfoutput query="SearchResult">
	
	    <tr class="labelmedium2 line navigation_row"  bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f6f6f6'))#"> 
		<td width="5%" align="center" style="padding-top:1px;">
			  <cf_img icon="open" navigation="yes" onclick="recordedit('#code#', '#serviceItemUnitOccurrences#')">
		</td>		
		<td>#code#</td>
		<td>#description#</td>
		<td>#serviceItemUnitOccurrences#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	   
	</cfoutput>
	
	</TABLE>
	
	</cf_divscroll>

</td>

</tr>

</TABLE>


