
<cfquery name="get" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_CategoryItem
		WHERE 	Category = '#url.category#'
		AND		CategoryItem = '#url.item#'
</cfquery>

<!---

<cfif url.item eq "">

	<cf_screentop height="100%" scroll="Yes" layout="webapp" banner="gray" user="no"
   		label="Generic Item">
   
<cfelse>

	<cf_screentop height="100%" scroll="Yes" layout="webapp" banner="yellow" user="no"
   		label="Generic Item">

</cfif>
--->

<cfoutput>

<table class="hide">
	<tr><td><iframe name="processCategoryItem" id="processCategoryItem" frameborder="0"></iframe></td></tr>
</table>

<cfform name="frmCategoryItem" action="CategoryItem/CategoryItemSubmit.cfm?idmenu=#url.idmenu#&category=#url.category#&item=#url.item#" target="processCategoryItem">

<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formspacing formpadding">
	<tr><td height="10"></td></tr>
	
	<tr>
		<td class="labelmedium" width="20%"><cf_tl id="Code">:</td>
		<td>
			<cfif url.item eq "">
				<cfinput type="Text" 
					name="CategoryItem" 
					required="Yes" 
					message="Please, enter a valid code." 
					value="#get.CategoryItem#" 
					size="30" 
					maxlength="50" 
					class="regularxl">
			<cfelse>
				#get.CategoryItem#
				<input type="Hidden" name="CategoryItem" id="CategoryItem" value="#get.CategoryItem#">
			</cfif>
		</td>
	</tr>
	<tr>
		<td class="labelmedium" width="20%"><cf_tl id="Description">:</td>
		<td>
			<!---
			<cfinput type="Text" 
				name="CategoryItemName" 
				required="Yes" 
				message="Please, enter a valid description." 
				value="#get.CategoryItemName#" 
				size="40" 
				maxlength="80" 
				class="regularxl">
			--->
			
			<cf_LanguageInput
				TableCode       = "Ref_CategoryItem" 
				Mode            = "Edit"
				Name            = "CategoryItemName"
				Type            = "Input"
				Required        = "Yes"
				Value           = "#get.CategoryItemName#"
				Key1Value       = "#get.Category#"
				Key2Value       = "#get.CategoryItem#"
				Message         = "Please enter a description"
				MaxLength       = "40"
				Size            = "50"
				Class           = "regularxl">
		</td>
	</tr>
	<tr>
		<td class="labelmedium" width="20%"><cf_tl id="Order">:</td>
		<td>
			<cfset vCategoryItemOrder = get.CategoryItemOrder>
			<cfif vCategoryItemOrder eq "">
				<cfset vCategoryItemOrder = 1>
			</cfif>
			<cfinput type="Text" 
				name="CategoryItemOrder" 
				required="Yes" 
				message="Please, enter a valid numeric order." 
				value="#vCategoryItemOrder#" 
				size="1" 
				maxlength="3"
				class="regularxl" 
				style="text-align:center;">
		</td>
	</tr>
	<tr><td height="1"></td></tr>
	<tr><td class="line" colspan="2"></td></tr>
	<tr><td height="1"></td></tr>
	<tr>
		<td colspan="2" align="center">
			<input type="Submit" value="  Save  " name="save" id="save" class="button10g">
		</td>
	</tr>
	
</table>

</cfform>
</cfoutput>


