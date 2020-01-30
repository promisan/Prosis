
<cfif URL.CountrySelect eq "" 
   and URL.CitySelect eq "" 
   and URL.CityCodeSelect eq "">
   	  
	<table width="100%" height="100%">
	<tr><td align="center" class="regular">
	<b><font color="FF0000">Please enter at least ONE criteria and press submit......</b>
	</td></tr>
	</table>
	
	<cfabort>   
   
</cfif>

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT TOP 300 * 
    FROM  Ref_CountryCity C, 
	      System.dbo.Ref_Nation R
    WHERE C.LocationCountry = R.Code 
	 <cfif #URL.CountrySelect# neq "">
	 AND C.LocationCountry = '#URL.CountrySelect#'
	 </cfif>
	AND   LocationCity      LIKE '%#URL.CitySelect#%' 
	<cfif URL.CityCodeSelect neq "">
	AND   LocationCityCode  LIKE '%#URL.CityCodeSelect#%' 
	</cfif>
	<!---
	AND CountryCityId IN (SELECT CountryCityId FROM Ref_CountryCityLocation)
	--->
	ORDER BY LocationCity	
</cfquery>
	    
<table width="99%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">   
							
	<TR class="labelmedium line">
	    <td height="17"></td>			
	    <TD>Name</TD>
		<TD>Country</TD>
		<td width="60" align="right">Code</td>
	</TR>
			
	<CFOUTPUT query="SearchResult">
				
	<TR class="navigation_row labelmedium line" style="cursor:pointer;height:20px">
		
	<td width="25" align="center">	
		<cf_img icon="open" navigation="Yes" onClick="javascript:cityselect('#url.field#','#url.id#','#CountryCityId#')">				   
	</td>
			
	<cfif URL.CitySelect neq "">
		<cfset city = ReplaceNoCase(LocationCity, URL.CitySelect, "<b><u><font color='0066CC'>#URL.CitySelect#</font></u></b>")>
		<cfelse>
		<cfset city = "#LocationCity#">
		</cfif>
			
	<TD>#city#</TD>					
	<TD>#Name# <cfif LocationState neq ""> (#LocationState#)</cfif>&nbsp;</TD>
	<TD align="right">#LocationCityCode#&nbsp;</TD>
		
	</TR>
		
	</CFOUTPUT>
			
</table>

<cfset ajaxonload("doHighlight")>
		
