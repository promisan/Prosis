
<!--- determine item master --->

<cfparam name="session.hidestandard" default="0">

<cfquery name="Check" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT * 
		 FROM   ItemMaster I, Ref_EntryClass R
		 WHERE  I.EntryClass = R.Code
		 AND    I.Code = '#URL.ItemMaster#' 
</cfquery>

<cfif Check.CustomForm eq "1">
			
	<cfif Check.CustomDialog eq "Travel">		
		<cfinclude template="../Travel/TravelItem.cfm">
		<cfset session.hidestandard = "1">			
	<cfelseif Check.CustomDialog eq "Contract">	
	    <cfinclude template="../Position/PositionSelect.cfm">	
	<cfelse>	
		<cfinclude template="../Service/ServiceItem.cfm">
		<cfset session.hidestandard = "1">
	</cfif>
	
<cfelse>

	<cfif Check.CustomDialogOverwrite eq "Travel">
		<cfinclude template="../Travel/TravelItem.cfm">
		<cfset session.hidestandard = "1">
	<cfelseif Check.CustomDialogOverwrite eq "Contract">	
	    <cfinclude template="../Position/PositionSelect.cfm">	
	<cfelse>		
		<cfinclude template="../Service/ServiceItem.cfm">
		<cfset session.hidestandard = "1">
	</cfif>

</cfif>	
