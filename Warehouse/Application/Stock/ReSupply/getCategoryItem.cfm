
<!--- getCategory --->

<cfparam name="form.Category" default="">

  <cfquery name="CategoryItemSelect" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_CategoryItem
		<cfif form.Category eq "">
		WHERE 1=0
		<cfelse>
		WHERE     Category IN (#preservesingleQuotes(form.Category)#)		
		</cfif>
				
	</cfquery>
	
<select name="categoryitem" id="categoryitem" style="border:0px;width:300px;height:105px" class="regularxl" multiple>						
		<cfoutput query="CategoryItemSelect">
		<option value="'#CategoryItem#'">#CategoryItemName#</option>
		</cfoutput>
</select>	