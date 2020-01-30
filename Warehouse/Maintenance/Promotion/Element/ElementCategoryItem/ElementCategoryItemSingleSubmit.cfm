
<cftry>

	<cfif url.action eq "insert">
	
		<cfquery name="Insert" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				INSERT INTO PromotionElementItem
					(
						ElementSerialNo,
						PromotionId,
						Category,
						CategoryItem,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#url.serial#',
						'#url.promotionId#',
						'#url.category#',
						'#url.categoryItem#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
	
	<cfelseif url.action eq "delete">
	
		<cfquery name="delete" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				DELETE
				FROM 	PromotionElementItem
				WHERE	PromotionId = '#url.promotionId#'
				AND		ElementSerialNo = '#url.serial#'
				AND		Category = '#url.category#'
				AND		CategoryItem = '#url.categoryItem#'
		</cfquery>
	
	</cfif>
	
	<cfset vText = "Saved">
	<cfset vColor = "71A6F4">
	
	<cfoutput>
	<script>
		parent.elementrefresh('#url.promotionid#')
	</script>
	</cfoutput>
	
	<cfcatch>
		<cfset vText = "Error trying to save.">
		<cfset vColor = "FF0000">
	</cfcatch>

</cftry>

<cfoutput>
	<table width="100%" align="center">
		<tr>
			<td align="center" style="color:#vColor#;"><b>#vText#</b></td>
		</tr>
	</table>
</cfoutput>