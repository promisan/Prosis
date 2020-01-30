
<cfparam name="url.selected" default="">

<cfquery name="Reason" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_PersonGroup
	WHERE ActionCode = '#url.actionCode#'			
</cfquery>

<cfquery name="getList" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    *
    FROM     Ref_PersonGroupList
	WHERE    GroupCode = '#Reason.Code#' 
	ORDER BY GroupListOrder						
</cfquery>

<cfoutput>

<cfif getList.recordcount eq "0">

	<input type="hidden" name="GroupCode"     value="">
	<input type="hidden" name="GroupListCode" value="">

<cfelse>
	
	<input type="hidden" name="GroupCode" value="#getList.GroupCode#">
	
	<select name="GroupListCode" class="regularxl enterastab" style="width:300px">	
		<cfloop query="getlist">
			<option value="#grouplistcode#" <cfif url.selected eq grouplistcode>selected</cfif>>#Description#</option>
		</cfloop>
	</select>

</cfif>

</cfoutput>