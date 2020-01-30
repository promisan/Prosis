<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  Ref_OrderType
ORDER BY code
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfset Header       = "Order Type">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="97%" align="center" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" class="formpadding">

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=890, height=850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=890, height=850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr><td height="1" colspan="8" class="linedotted"></td></tr>

<tr class="labelmedium">
   
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
    
    <TR style="height:22px" class="labelmedium navigation_row">
	<TD align="center" style="padding-top:1px">
		<cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
	</TD>		
	<TD class="linedotted" height="20">#Code#</TD>
	<TD class="linedotted">#Description#</TD>
	<td class="linedotted"><cfif InvoiceWorkflow eq "1">Yes<cfelse></cfif></td>
	<TD class="linedotted"><cfif EnableFinanceFlow eq "1">Yes<cfelse></cfif></TD>
	<TD class="linedotted"><cfif Tracking eq "1">Yes<cfelse></cfif></TD>
	<TD class="linedotted"><cfif ReceiptEntry eq "1">Form <cfif ReceiptEntryForm neq "">[#ReceiptEntryForm#]</cfif><cfelseif ReceiptEntry eq "0">Line Based<cfelse><font color="gray">Disabled</font></cfif></TD>
	<td class="linedotted">
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

</td>
</tr>

</TABLE>

</cf_divscroll>

