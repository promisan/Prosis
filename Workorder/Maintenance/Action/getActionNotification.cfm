 <cfquery name="getAction" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Action
	WHERE  Mission = '#url.mission#' 
	AND    ActionFulfillment = 'Message'			
</cfquery>
			
<select name="actionNotification" id="actionNotification" class="regularxl">
    <option value="">--select--</option>
	<cfoutput query="getAction">
	  <option value="#code#" <cfif url.action eq Code>selected</cfif>>#Description#</option>
  	</cfoutput>
</select>	