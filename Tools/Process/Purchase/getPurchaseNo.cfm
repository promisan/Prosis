
<cfparam name="attributes.PurchaseNo" default="">
<cfparam name="attributes.Mode"       default="Both">

<cfquery name="get" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Purchase 
	  WHERE  PurchaseNo = '#attributes.purchaseno#'
</cfquery>

<cfquery name="parameter" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Ref_ParameterMission 
	  WHERE  mission = '#get.Mission#'
</cfquery>

<cfif parameter.PurchaseCustomField neq "">

	<cfset alternate = evaluate("get.UserDefined#parameter.PurchaseCustomField#")>
	
<cfelse>

	<cfset alternate = "">

</cfif>	

<cfif attributes.mode eq "Both">

	<cfoutput>
		#attributes.purchaseno# <cfif alternate neq ""> / #alternate# </cfif>
	</cfoutput>

<cfelseif attributes.mode eq "Only" and alternate neq "">

	<cfoutput>
		#alternate# 
	</cfoutput>
	
	<cfset caller.fResultPurchaseNo = alternate>

<cfelse>

	<cfoutput>
		#attributes.purchaseno#
	</cfoutput>
	
	<cfset caller.fResultPurchaseNo = attributes.purchaseno>
			
</cfif>




