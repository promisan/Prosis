<cfquery name="getLookup" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	'Class' as Unit, S.unitClass as Parent, U.Description as Description
		FROM	ServiceItemUnit S,
				Ref_UnitClass U
		WHERE	S.unitClass  = U.code
		AND		ServiceItem  = '#URL.ID1#'
		AND 	UnitClass   != 'regular'
		
		UNION
		
		SELECT	'Unit' as Unit, unit as Parent, UnitDescription as Description
		FROM	ServiceItemUnit 
		WHERE	ServiceItem = '#URL.ID1#'
		AND 	UnitClass  != 'regular'
		AND		UnitClass   = '#URL.unitClass#'
		AND     Unit       != '#URL.ID2#'
		AND     UnitParent is NULL or UnitParent = ''
</cfquery>

<select name="unitParent" id="unitParent" class="regularxl">
	<option value="">N/A</option>
	<cfoutput query="getLookup">
	  <option value="#Parent#" <cfif Parent eq URL.unitParent>selected</cfif>>#Description# (#Parent#)</option>
  	</cfoutput>
</select>