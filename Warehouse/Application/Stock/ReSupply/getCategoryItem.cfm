
<!--- getCategory --->

<cfparam name="form.Category" default="">

<cfset val = "">

<cfloop index="itm" list="#form.Category#">

	<cfif val eq "">
	   <cfset val = "'#itm#'">
	<cfelse>
		<cfset val = "#val#,'#itm#'">
	</cfif>

</cfloop>

  <cfquery name="CategoryItemSelect" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_CategoryItem
		<cfif form.Category eq "">
		WHERE 1=0
		<cfelse>
		WHERE     Category IN (#preservesingleQuotes(val)#)		
		</cfif>
				
	</cfquery>
	
	
	<cf_UISelect name   = "categoryitem"
		     class          = "regularxxl"						     
		     query          = "#CategoryItemSelect#"
		     value          = "CategoryItem"
		     message        = "Please select a sub category"						     
		     display        = "CategoryItemName"
		     filter         = "contains"
			 style          = "width:200px"
			 separator      = ","
		     multiple       = "yes"/>		

<!---	
<select name="categoryitem" id="categoryitem" style="border:0px;width:300px;height:105px" class="regularxl" multiple>						
		<cfoutput query="CategoryItemSelect">
		<option value="'#CategoryItem#'">#CategoryItemName#</option>
		</cfoutput>
</select>

--->	