
<cfparam name="url.cityid" default="">

<cfif url.cityid neq "">

	<cfif URL.claimtripid neq "">	
	
	<cfquery name="Update" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE   ClaimEventTrip
		SET      CountryCityId = '#url.cityid#'
		WHERE    ClaimTripId = '#URL.claimtripid#'	
	</cfquery>	
		
	</cfif>

</cfif>

<cfquery name="TripLine" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    C.*, R.Name as CountryName
	FROM      Ref_CountryCity C INNER JOIN
              System.dbo.Ref_Nation R ON C.LocationCountry = R.Code
	WHERE     C.CountryCityId = '#url.cityid#'	
</cfquery>	

<cfif TripLine.LocationCity eq "">
     <cfset l = "Select location">
<cfelseif find("/", TripLine.LocationCity)>
	  <cfset l = TripLine.LocationCity>
<cfelse>
	  <cfset l = "#TripLine.LocationCity# / #TripLine.CountryName#">
</cfif> 


<cfoutput>

	<table border="1" width="300" bordercolor="silver" cellspacing="1" cellpadding="1">
	<tr><td>
	<a href="javascript:selectcity('#url.fld#','#URL.claimtripid#')">#l#</a>
	<script language="JavaScript">
	se = document.getElementById('#URL.fld#')
	if (se) {	    
	    se.value = '#url.cityid#'				
	}
    </script>		
	</td></tr></table>
</cfoutput>   	