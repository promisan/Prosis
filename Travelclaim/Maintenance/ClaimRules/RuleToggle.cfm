<cfquery name="Rule"
 datasource="AppsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	    SELECT * 
		FROM Ref_Validation
		WHERE Code = '#URL.Code#'
</cfquery>

<cfoutput>
	
<cfif Rule.Operational eq "1">

	<cfquery name="Update"
	 datasource="AppsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	    UPDATE Ref_Validation
		Set operational = 0
		WHERE Code = '#URL.Code#'
	 </cfquery>
	
	<img src="#SESSION.root#/Images/light_red3.gif" 
	 style="cursor: hand;"
	onclick="toggle('#URL.Code#')" 
	alt="Activate" 
	width="24" 
	height="15" border="0">

<cfelse>

	<cfquery name="Update"
	 datasource="AppsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	    UPDATE Ref_Validation
		Set operational = 1
		WHERE Code = '#URL.Code#'
	</cfquery>
	
	<img src="#SESSION.root#/Images/light_green2.gif" 
	 style="cursor: hand;"
	onclick="toggle('#URL.Code#')" 
	alt="Disable" 
	width="24" height="15" border="0">

</cfif>

</cfoutput>
