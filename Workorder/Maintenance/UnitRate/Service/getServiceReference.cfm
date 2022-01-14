
<!--- activity --->

<cfquery name="getLookup" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   WorkOrderService 
			WHERE ServiceDomain = '#url.servicedomain#'
</cfquery>
	
<select name="Reference" id="Reference" class="regularxxl">
	<cfoutput query="getLookup">
	  <option value="#Reference#" <cfif reference eq url.selected>selected</cfif>>#description#</option>
  	</cfoutput>
</select>	 