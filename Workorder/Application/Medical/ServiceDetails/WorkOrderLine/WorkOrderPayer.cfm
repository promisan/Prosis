
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    O.OrgUnitName,CP.*
    FROM      CustomerPayer CP INNER JOIN Organization.dbo.Organization O ON CP.OrgUnit = O.OrgUnit	
	WHERE     CustomerId = '#get.customerid#'	
	AND       Status != 9
	ORDER BY  CP.DateEffective
</cfquery>

<cfif searchresult.recordcount gte "1">
		
<table width="100%" align="center">
		
	<tr class="labelmedium line" style="border-top:1px solid silver;height:18px">	   	   
	    <td style="padding-left:4px"><cf_tl id="Insurance"></td>
		<td><cf_tl id="Policy"></td>
		<td><cf_tl id="Certification"></td>
		<td><cf_tl id="Effective"></td>
		<td><cf_tl id="Expiration"></td>   		
	</TR>
	
	<cfif searchresult.recordcount eq "0">
	
	<tr><td class="labelmedium" align="center" colspan="6"><font color="gray"><cf_tl id="There are no records found to be shown"></td></tr>
	
	</cfif>
	
	<cfoutput query="SearchResult">
	    
	    <tr class="navigation_row labelmedium" style="height:22px">			
			<td style="padding-left:4px">#OrgUnitName#</td>
			<td>#AccountNo#</td>		
			<td>#Reference#</td>
			<td>#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
			<td>#DateFormat(DateExpiration,CLIENT.DateFormatShow)#</td>			
	    </tr>
		
	</cfoutput>
	
</table>

</cfif>

