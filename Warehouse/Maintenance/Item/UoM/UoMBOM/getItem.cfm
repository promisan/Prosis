
<cfparam name="url.Mode"   default="Item">
<cfparam name="url.UoM"    default="">
<cfparam name="url.Prefix" default="">

<cfquery name="GetItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Item I INNER JOIN Ref_Category R ON I.Category = R.Category
	WHERE	I.ItemNo = '#url.itemno#'				
</cfquery>
			
<cfoutput>


	<cfif url.mode eq "Item">					
				
		#GetItem.Classification# #GetItem.ItemDescription# (#getItem.ItemNo#)		
		<input type="hidden" required="true" name="itemNo#URL.Prefix#" id="itemNo#URL.Prefix#" value="#url.itemno#">		
		
		<script>
			ptoken.navigate('#session.root#/Warehouse/Maintenance/Item/UoM/UoMBOM/getItem.cfm?mode=uom&itemNo=#url.itemno#&prefix=#URL.Prefix#','uombox#URL.Prefix#')
			<cfif url.prefix eq "_inherit">			
			ptoken.navigate('#session.root#/Warehouse/Maintenance/Item/UoM/UoMBOM/RelatedBOM.cfm?itemno=#url.itemno#&mission='+document.getElementById("mission").value,'bom_box')			
			</cfif>
		</script>
		
	<cfelse>

			<!-- <cfform>-->	
			<cfquery name="GetUoM" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	U.*
			    FROM 	ItemUoM U
				WHERE	U.ItemNo = '#url.ItemNo#'
			</cfquery>		
										
			<cf_tl id="Select a valid UoM" var="1">						
			
			<cfif url.prefix eq "">
			
			<cfselect name="uom#URL.Prefix#" 
				  id="uom#URL.Prefix#" 
			      query="getUoM" 
				  required="true" 
				  message="#lt_text#" 
				  value="UoM" 
				  selected="#URL.UoM#"	  
				  display="UoMDescription" 				 
				  class="regularxl"/>			
				  
			<cfelse>
			
			<cfselect name="uom#URL.Prefix#" 
				  id="uom#URL.Prefix#" 
			      query="getUoM" 
				  required="true" 
				  message="#lt_text#" 
				  value="UoM" 
				  onchange="ptoken.navigate('#session.root#/Warehouse/Maintenance/Item/UoM/UoMBOM/RelatedBOM.cfm?itemno=#url.itemno#&uom='+this.value+'&mission='+getElementById('mission').value,'bom_box')"
				  selected="#URL.UoM#"	  
				  display="UoMDescription" 				 
				  class="regularxl"/>			
			
			
			</cfif>	  
			<!-- </cfform> -->
								
	</cfif>						

</cfoutput>