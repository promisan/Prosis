<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  I.*, C.Listingorder as ServiceClassorder, C.Description as ServiceClassDescription
	FROM     ServiceItem I, ServiceItemClass C
	WHERE   I.ServiceClass = C.Code
	<cfif getAdministrator("*") eq "0">
	AND I.Code in (SELECT ClassParameter 
	             FROM   Organization.dbo.OrganizationAuthorization 
				 WHERE  Role = 'AdminWorkOrder' 
				 AND    UserAccount = '#SESSION.acc#')
	</cfif>	
	ORDER BY C.Code, C.Listingorder, I.ListingOrder
</cfquery>

<cfif SearchResult.recordcount eq "0" and getAdministrator("*") eq "0">

<table align="center">
<tr><td align="center" height="60"><font face="Verdana">There are no service items for which you have been assigned as system manager</td></tr></table>
<cfabort>

</cfif>

<cf_divscroll>

<table width="94%" border="0"  align="center" cellspacing="0" cellpadding="0">

<cfset add          = "1">
<cfset Header       = "Order Class">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfoutput>

<script>

function recordadd(grp) {
	ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#&ID1=", "AddServiceItem", "left=80, top=80, width= 1150, height= 850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
	ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "_blank");
}

</script>	

</cfoutput>
	
<tr><td colspan="2" style="padding-top:5px">

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="line">
   
	<TD width="5%">&nbsp;</TD>
    <TD class="labelit">Code</TD>
	<TD class="labelit">Description</TD>	
	<TD class="labelit">S</TD>	
	<td class="labelit">Interface</td>
	<td class="labelit" align="center">Cl</td>
	<td class="labelit">Oper.</td>
	<TD class="labelit">Mission</TD>
    <TD class="labelit">Entered</TD>
  
</TR>
<cfoutput query="SearchResult" group="ServiceClassOrder">

<tr><td style="height:35" colspan="9" class="labellarge">#serviceClass# #ServiceClassDescription#</font></td></tr>

<cfoutput>

	<cfset row = currentrow>
	
    <TR class="navigation_row line"> 
		<TD align="center" style="padding-top:3px;" class="navigation_action" onClick="javascript:recordedit('#Code#')">
			<cf_img icon="edit">					  
		</TD>		
		<TD class="labelit">#Code#</TD>
		<TD class="labelit">#Description#</TD>		
		<TD class="labelit">#ListingOrder#</TD>
		<td class="labelit"><cfif CustomForm eq "">None<cfelse>#CustomForm#</cfif></td>
		<td align="center">
			<table align="center">
				<tr>
					<td align="center" width="16" height="16" bgcolor="#ServiceColor#" title="#ServiceColor#" style="border:1px solid black;"></td>
				</tr>
			</table>
		</td>
		<td class="labelit" style="padding-left:4px"><cfif operational eq "No">No<cfelse>Yes</cfif></td>
		<TD class="labelit" style="width:30%">
		
			<cfquery name="Mission" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     ServiceItemMission
				WHERE    ServiceItem = '#Code#' 		
			</cfquery>
			
			<cfloop query="Mission">
			    #Mission#&nbsp;
			</cfloop>			
		
		</TD>
		<TD class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>	
		
</CFOUTPUT>
</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>

</cf_divscroll>