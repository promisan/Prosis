
<cfquery name="Class" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_EntryClass		
		WHERE Code IN (SELECT EntryClass 
		               FROM ItemMaster 
					   WHERE (Mission = '#url.mission#' or Mission is NULL or Mission = ''))
		ORDER BY Code
</cfquery>
 
 
<select name="entryclass" id="entryclass" class="regularxl" onChange="search('<cfoutput>#URL.view#</cfoutput>')">
  <option value="" selected>Any</option>
	   <cfoutput query="Class">
		 <option value="#Code#">#Description#</option>
	   </cfoutput>        
</select>