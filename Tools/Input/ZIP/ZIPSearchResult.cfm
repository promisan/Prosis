
<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM  PostalCode C
    WHERE PostalCode  LIKE '%#Form.PostalCode#%' 
	<cfif Form.Location neq "">
	AND   Location LIKE '%#Form.Location#%'
	</cfif>
	<!---
	<cfif FORM.PCountry neq "">
	AND   C.Country = '#Form.PCountry#'
	</cfif>
	--->
	ORDER BY PostalCode
</cfquery>
	    
<table width="99%" class="navigation_table">   
							
	<TR class="labelmedium line fixrow">
	    <td height="17"></td>					    
	    <TD><cf_tl id="Code"></TD>
		<TD><cf_tl id="Location"></TD>
		<td align="right" style="padding-right:5px"><cf_tl id="Country"></td>
	</TR>
	
	<CFOUTPUT query="SearchResult">
			
		<cfset des = Replace(Location,'"','','ALL')>
														
		<TR class="labelmedium line navigation_row" style="height:20px" onClick="<cfif searchresult.recordcount lte '10'>zipselected('#PostalCode#','#Location#','#Country#')</cfif>" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F1E7AB'))#">
			<td width="60" height="20" align="center" style="padding-top:5px">		
				<cf_img icon="select" class="navigation_action" onClick="zipselected('#PostalCode#','#Location#','#Country#')">				   
			</td>
			<TD width="70">#PostalCode#</TD>
			<TD>#Location#</TD>
			<TD align="right" style="padding-right:5px">#Country#</TD>			
		</TR>
					
	</CFOUTPUT>
	
</table>
	
<cfset ajaxonload("doHighlight")>
		
