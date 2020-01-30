
<!--- get the relative Multiplier between two UoM for an item --->

<cfparam name="attributes.DataSource"  default="AppsMaterials">
<cfparam name="attributes.ItemNo"      default="">
<cfparam name="attributes.UoMFrom"     default="">
<cfparam name="attributes.UoMTo"       default="">

<cfquery name="FromUoM" 
      datasource="#Attributes.DataSource#"  
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	 
		 SELECT * 
		 FROM   Materials.dbo.ItemUoM 
		 WHERE  ItemNo = '#attributes.ItemNo#'
		 AND    UoM = '#Attributes.UoMFrom#'		 		
</cfquery>

<cfquery name="FromTo" 
     datasource="#Attributes.DataSource#"  
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	 
		 SELECT * 
		 FROM   Materials.dbo.ItemUoM 
		 WHERE  ItemNo = '#attributes.ItemNo#'
		 AND    UoM = '#Attributes.UoMTo#'		 		
</cfquery>

<cfif FromTo.UoMMultiplier gte "1">
	<cfset caller.UoMMultiplier = FromUoM.UoMMultiplier / FromTo.UoMMultiplier>
<cfelse>
   	<cfset caller.UoMMultiplier = FromUoM.UoMMultiplier>
</cfif>
