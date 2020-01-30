
<cfparam name="Attributes.item"      default="0">
<cfparam name="Attributes.quantity"  default="0">

<cfquery name="Item" 
datasource="AppsMaterials" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
    SELECT ItemPrecision 
	FROM Item 
	WHERE ItemNo = '#Attributes.itemNo#'
</cfquery>

<cfswitch expression="#Item.ItemPrecision#">
	
	<cfcase value="0">
	  <cfset val = #numberformat(Attributes.quantity,"__")#>
	</cfcase>
	
	<cfcase value="1">
	  <cfset val = #numberformat(Attributes.quantity,"__._")#>
	</cfcase>
	
	<cfcase value="2">
	  <cfset val = #numberformat(Attributes.quantity,"__.__")#>
	</cfcase>
	
	<cfcase value="3">
	  <cfset val = #numberformat(Attributes.quantity,"__.___")#>
	</cfcase>

</cfswitch>

<cfset caller.quantity = val>