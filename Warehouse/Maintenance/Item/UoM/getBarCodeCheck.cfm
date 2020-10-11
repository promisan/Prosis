

<!--- check the barcode --->

<cfparam name="url.itemNo"      default="">
<cfparam name="url.UoM"         default="">
<cfparam name="url.Mission"     default="">
<cfparam name="url.ItemBarCode" default="">

<cfif url.ItemBarCode neq "">

	<cfif url.mission eq "">
		
		<cfquery name="get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   ItemUoM
				WHERE  ItemNo      != '#url.ItemNo#'
				AND    UoM         != '#url.UoM#'
				AND    ItemBarCode = '#url.itembarcode#'
		</cfquery>	
			
		<cfif get.recordcount eq "0">
		
			<font color="green"><cf_tl id="OK"></font>
		
		<cfelse>
			
		    <font color="FF0000"><cf_tl id="Exists"></font>
			
		</cfif>
		
	<cfelse>
	
		<cfquery name="get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   ItemUoMMission
				WHERE  ItemNo      != '#url.ItemNo#'
				AND    UoM         != '#url.UoM#'
				AND    Mission      = '#url.mission#'
				AND    ItemBarCode  = '#url.itembarcode#'
		</cfquery>	
			
		<cfif get.recordcount eq "0">
		
			<font color="green"><cf_tl id="OK"></font>
		
		<cfelse>
			
		    <font color="FF0000"><cf_tl id="Exists"></font>
			
		</cfif>
	
	</cfif>

</cfif>

