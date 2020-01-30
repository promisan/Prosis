
<cfparam name="Attributes.Datasource"   default="appsLedger">
<cfparam name="Attributes.Mission"      default="">
<cfparam name="Attributes.GLAccount"    default="">

<cfquery name="Param" 
  datasource="AppsLedger" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT AmountPresentation
  FROM   Ref_ParameterMission
  WHERE  Mission  = '#attributes.Mission#' 
</cfquery>

<cfoutput>

<cfif Param.AmountPresentation eq "Account">

	#attributes.GLAccount#
	
<cfelse>
	
	<cfquery name="getAccount" 
	  datasource="AppsLedger" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Ref_Account
	  WHERE  GLAccount = '#attributes.glaccount#'  
	</cfquery>
	
	<cfif getAccount.AccountLabel eq "">
	#attributes.GLAccount#
	<cfelse>
	#getAccount.AccountLabel#
	</cfif>

</cfif>

</cfoutput>


