

<!--- address information tax code --->

<cfparam name="url.context"   default="">
<cfparam name="url.contextid" default="">
<cfparam name="url.addressid" default="">

<cfif url.addressid eq "">

	<cf_AssignId>
	<cfset AddressId = rowguid>
	
<cfelse>

	<cfset AddressId = url.addressid>

</cfif>	

<!--- address object --->	
<cf_address datasource="appsEmployee" 
          addressid="#addressid#" mode="save" 
		  addressscope="#url.context#">
		  
<cfswitch expression="#url.context#">
	
	<cfcase value="TaxCode">
	
	   <cfquery name="TaxCode" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE CountryTaxCode
				SET    AddressId = '#addressid#'
				WHERE  TaxCode = '#url.contextid#'		
		</cfquery>	
	
	</cfcase>

</cfswitch>		  

<script>
   ProsisUI.closeWindow('address')
</script>

