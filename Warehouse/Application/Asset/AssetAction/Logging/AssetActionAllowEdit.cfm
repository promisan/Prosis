
<cfif qAssetAction.ActionDate neq "">
	<cfset Days = DateDiff("d",qAssetAction.ActionDate,now())>
	<cfif Days gt qCategory.EditDays>
		<cfset disabled = "disabled='disabled'">
	<cfelse>
		<cfset disabled = "">
	</cfif>
<cfelse>
	<cfset disabled = "">
</cfif>


<cfif qAssetAction.ActionCategoryList eq "">
	<cfset list_selected = qAssetActionPrevious.ActionCategoryList>
<cfelse>	
	<cfset list_selected = qAssetAction.ActionCategoryList>
</cfif>