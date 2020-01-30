
<cfquery name="Lines" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT    *
	 FROM      RequisitionLine
	 WHERE     JobNo = '#Object.ObjectKeyValue1#'
	 AND       ActionStatus NOT IN ('0z','9')
</cfquery>	 

<cfquery name="Param" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT    *
	 FROM      Ref_ParameterMission
	 WHERE     Mission = '#Lines.Mission#'		
</cfquery>	 

<cfquery name="Address" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT    *
	 FROM      vwOrganizationAddress
	 WHERE     OrgUnit = '#Object.ObjectKeyValue2#'		
	 AND       AddressType = '#Param.AddressTypeRFQ#'
</cfquery>	

<!--- request for quotation email ---> 

<cfif isValid("email", Address.eMailAddress)>
	<cfset mailto = "#Address.eMailAddress#">
<cfelse>
    <cfset mailto = "vanpelt@promisan.com">
</cfif>	