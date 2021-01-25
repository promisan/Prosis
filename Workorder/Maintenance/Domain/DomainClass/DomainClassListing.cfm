
<cfdiv id="domainClassListing">

<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	 *
	FROM 	 Ref_ServiceItemDomainClass
	WHERE	 ServiceDomain = '#URL.ID1#'
	ORDER BY ListingOrder
</cfquery>

<cfoutput>

<table width="99%" align="center">  

<tr><td colspan="2">

	<table width="100%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line">
	    <TD align="center"><a href="javascript:showDomainClass('#URL.ID1#', '')">[Add]</a></TD> 
		<td align="center">Sort</td>
	    <TD>Code</TD>
		<td>Description</td>	
		<TD>Type</TD>	
		<td align="center">Request</td>		
		<td align="center">Overdraw</td>
		<td align="center">Ope.</td>	
	    <TD align="right">Entered</TD>  
	</TR>
	
	</cfoutput>
	
	<cfoutput query="SearchResult">   
	    <TR class="labelmedium line navigation_row"> 
		<td width="5%">
			<table>
				<tr>
					<td></td>
					<td style="padding-left:6px;padding-top:3px">
						<cf_img icon="open" navigation="Yes" onclick="showDomainClass('#URL.ID1#', '#Code#')">
					</td>
					<td style="padding-top:1px">
						<cfquery name="CountRec" 
						      datasource="AppsWorkOrder" 
						      username="#SESSION.login#" 
						      password="#SESSION.dbpw#">
						      	SELECT	RequestId as id
								FROM	Request
								WHERE	ServiceDomain = '#URL.ID1#'
								AND 	ServiceDomainClass = '#Code#'
								UNION
								SELECT	WorkorderId as id
								FROM	Workorderline
								WHERE	ServiceDomain = '#URL.ID1#'
								AND 	ServiceDomainClass = '#Code#'
						</cfquery>
						<cfif countRec.recordcount eq 0>
							<cf_img icon="delete" onclick="if (confirm('Do you want to remove this record ?')) { ptoken.navigate('DomainClass/DomainClassPurge.cfm?id1=#url.id1#&id2=#code#','process'); }">
						</cfif>
					</td>
					
				</tr>
			</table>
			  
		</td>		
		<TD align="center">#listingOrder#</TD>
		<TD>#Code#</TD>
		<TD>#Description#</TD>	
		<TD>#ServiceType#</TD>	
		<TD align="center"><cfif PointerRequest eq 0><b>No</b><cfelse>Yes</cfif></TD>			
		<TD align="center"><cfif PointerOverdraw eq 0><b>No</b><cfelse>Yes</cfif></TD>		
		<TD align="center"><cfif operational eq 0><b>No</b><cfelse>Yes</cfif></TD>
		<TD align="right">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
	    </TR>    	
	
	</CFOUTPUT>
	
	<tr><td class="line" colspan="8" id="process"></td></tr>
	
	</TABLE>

</td>

</TABLE>

</cfdiv>
