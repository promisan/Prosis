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
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_OrderType
	ORDER BY Code
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0">
<cfset Header       = "Order Type">
 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>
	
	function recordadd(grp) {
	      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=890, height=850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
	      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=890, height=850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}

</script>	

</cfoutput>

<tr><td colspan="2">

<cf_divscroll>

	<table width="95%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line">
	   
	    <TD width="5%">&nbsp;</TD>
	    <TD>Code</TD>
		<TD>Description</TD>
		<TD>Inv</TD>
		<TD>Fin</TD>
		<TD>Track</TD>
		<TD>Receipt</TD>
		<TD>Enabled for</TD>
	  
	</TR>
	
	<cfoutput query="SearchResult">
	    
	    <TR style="height:22px" class="labelmedium2 navigation_row line">
		<TD align="center" style="padding-top:1px">
			<cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
		</TD>		
		<TD height="20">#Code#</TD>
		<TD>#Description#</TD>
		<td><cfif InvoiceWorkflow eq "1">Yes<cfelse></cfif></td>
		<TD><cfif EnableFinanceFlow eq "1">Yes<cfelse></cfif></TD>
		<TD><cfif Tracking eq "1">Yes<cfelse></cfif></TD>
		<TD><cfif ReceiptEntry eq "1">Form <cfif ReceiptEntryForm neq "">[#ReceiptEntryForm#]</cfif><cfelseif ReceiptEntry eq "0">Line Based<cfelse><font color="gray">Disabled</font></cfif></TD>
		<td>
			<cfquery name="MissionL" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	*
					FROM  	Ref_OrderTypeMission
					WHERE	Code = '#Code#'
			</cfquery>
			
			<cfset vMissionList = "">
			<cfloop query="MissionL">
				<cfset vMissionList = vMissionList & Mission & ", ">
			</cfloop>
			
			<cfif vMissionList neq "">
				<cfset vMissionList = mid(vMissionList, 1, len(vMissionList)-2)>
			</cfif>
			
			#vMissionList#
			
		</td>
	    </TR>
			
	</cfoutput>
	
	</TABLE>

</cf_divscroll>

</td>
</tr>

</TABLE>


