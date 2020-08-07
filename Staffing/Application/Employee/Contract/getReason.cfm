
<cfparam name="client.contractreason" default="">
<cfparam name="url.scope" default="add">

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
		AND      (Operational = 1 or GroupListCode = '#client.contractreason#') 
		ORDER BY GroupListOrder						
</cfquery>


<cfoutput>


<cfif getList.recordcount eq "0">

	<input type="hidden" name="GroupCode"     id="GroupCode" value="">
	<input type="hidden" name="GroupListCode" id="GroupListCode" value="">

<cfelse>
	
	<input type="hidden" id="GroupCode" name="GroupCode" value="#getList.GroupCode#">
	
	<select id="GroupListCode" name="GroupListCode" class="regularxl enterastab" style="width:99%;<cfif url.scope neq 'add'>border:0px</cfif>">	
		<cfloop query="getlist">
			<option value="#grouplistcode#" <cfif client.contractreason eq grouplistcode>selected</cfif>>#Description#</option>
		</cfloop>
	</select>

</cfif>

</cfoutput>