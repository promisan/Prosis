
<cfquery name="GetBOM"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT IBD.*
		FROM   ItemBOMDetail IBD INNER JOIN ItemBOM IB
			ON IBD.BomId = IB.BomId  
		WHERE  
		<cfif URL.BomId eq "">
			1=0
		<cfelse>
			IBD.BomId = '#URL.BomId#'
		</cfif>
</cfquery>

<cfoutput>
	<cfset vMaterials = ValueList(GetBOM.MaterialId)>
	<input type="hidden" name="_materials_" id="_materials_" value="#vMaterials#">	
	<cfset AjaxOnLoad("doEditBOM")>
</cfoutput>