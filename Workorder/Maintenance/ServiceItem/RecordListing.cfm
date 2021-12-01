
<cf_screentop html="No" jquery="Yes">

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

<table width="94%" height="100%" align="center">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset Header       = "Order Class">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

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

<cf_divscroll>

	<table width="97%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line fixlengthlist">
	   
		<TD width="5%">&nbsp;</TD>
	    <TD><cf_tl id="Code"></TD>
		<TD><cf_tl id="Description"></TD>	
		<TD>S</TD>	
		<td><cf_tl id="Interface"></td>
		<td align="center">Cl</td>
		<td title="Operational"><cf_tl id="Active"></td>
		<TD><cf_tl id="Entity"></TD>
	    <TD><cf_tl id="Entered"></TD>
	  
	</TR>
	<cfoutput query="SearchResult" group="ServiceClassOrder">
	
	<tr class="line"><td style="height:40px;font-size:18px" colspan="9" class="labellarge">#serviceClass# #ServiceClassDescription#</font></td></tr>
	
	<cfoutput>
	
		<cfset row = currentrow>
		
	    <TR class="navigation_row line labelmedium2 fixlengthlist"> 
		
			<TD align="center" style="padding-top:1px;" class="navigation_action" onClick="javascript:recordedit('#Code#')">
				<cf_img icon="edit">					  
			</TD>		
			<TD>#Code#</TD>
			<TD>#Description#</TD>		
			<TD>#ListingOrder#</TD>
			<td><cfif CustomForm eq "">None<cfelse>#CustomForm#</cfif></td>
			<td align="center">
				<table align="center">
					<tr>
						<td align="center" width="16" height="16" bgcolor="#ServiceColor#" title="#ServiceColor#" style="border:1px solid black;"></td>
					</tr>
				</table>
			</td>
			<td><cfif operational eq "No">No<cfelse>Yes</cfif></td>
			<TD>
			
				<cfquery name="Mission" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     ServiceItemMission
					WHERE    ServiceItem = '#Code#' 		
				</cfquery>
				
				<cfloop query="Mission">
				    #Mission#<cfif currentrow neq recordcount>|</cfif>
				</cfloop>			
			
			</TD>
			<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
	    </TR>	
			
	</CFOUTPUT>
	</CFOUTPUT>
	
	</TABLE>

</cf_divscroll>

</td>
</tr>

</TABLE>

