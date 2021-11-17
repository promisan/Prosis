<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<cffunction name="AddQuote"
             access="public"
             returntype="any"
             displayname="Create a new quote for a store">
		
		<cfargument name="Warehouse"   type="string"  required="false"  default="">
		
		<cfreturn quote>
		
	</cffunction>	
	
	<cffunction name="addQuoteItem"
             access="public"
             returntype="any"
             displayname="Add an item to a quote">
		
		<cfargument name="RequestNo"      type="string"  required="true"  default="0">
		<cfargument name="PriceSchedule"  type="string"  required="true"  default="">
		<cfargument name="ItemNo"         type="string"  required="true"  default="">
		<cfargument name="UoM"            type="string"  required="true"  default="">
		<cfargument name="Warehouse"      type="string"  required="true"  default="">
		<cfargument name="Quantity"       type="string"  required="true"  default="">
				
	</cffunction>	
	
</cfcomponent>	
