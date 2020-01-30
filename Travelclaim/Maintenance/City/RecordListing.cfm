	
<cfif URL.CountrySelect eq "" 
   and URL.CitySelect eq "" 
   and URL.CityCodeSelect eq "">
   	  
	<table width="99%" align="center" height="100%">
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
SELECT TOP 250 * 
    FROM  Ref_CountryCity C, 
	      System.dbo.Ref_Nation R
    WHERE C.LocationCountry = R.Code 
	 <cfif URL.CountrySelect neq "">
	 AND C.LocationCountry = '#URL.CountrySelect#'
	 </cfif>
	AND   LocationCity      LIKE '%#URL.CitySelect#%' 
	<cfif URL.CityCodeSelect neq "">
	AND   LocationCityCode  LIKE '%#URL.CityCodeSelect#%'  
	</cfif>
	ORDER BY LocationCity 
</cfquery>

    
<table width="100%" cellspacing="0" cellpadding="0" >   
	
	<tr class="line">
	    <td height="17" width="15"></td>
		<td width="10%">Id</td>
	    <td>Name</td>
		<td>Country</td>
		<td width="20%">Code</td>
		<td width="20%">Entered</td>
		<td></td>
	</tr>
		
	<cfset show = "1">
			
	<CFOUTPUT query="SearchResult">
	
	<cfset des = "#Replace(LocationCity,'"',"","ALL")#">
	
	<tr>
		
	<td width="20" height="22" align="center">
	#currentrow#.	
	</td>
	
	<td width="60">#CountryCityId#</td>
	
	<cfif URL.CitySelect neq "">
		<cfset city = #ReplaceNoCase(#LocationCity#, #URL.CitySelect#, "<b><u><font color='0066CC'>#URL.CitySelect#</font></u></b>")#>
	<cfelse>
		<cfset city = "#LocationCity#">
	</cfif>
			
	<td><font size="2"><b>#city#</font></td>
	<td>#LocationCountry# <cfif locationstatecode neq "">(#LocationStateCode#)</cfif>&nbsp;</td>
	<td>#LocationCityCode#&nbsp;</td>
	<td>#DateFormat(Created, CLIENT.DateFormatShow)#&nbsp;</td>
	<td align="right">
		<a href="javascript:dsaNew('#CountryCityId#','','add')">Add DSA location</a>&nbsp;
	</td>	
	</tr>
		
	<tr><td colspan="7" id="city_#CountryCityId#">
		<cfinclude template="CityDSA.cfm">	
	</td></tr>
	<tr><td colspan="7" class="linedotted"></td></tr>
		
	</cfoutput>
			
</table>
	
		
