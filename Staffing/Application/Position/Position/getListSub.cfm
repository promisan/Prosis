
<cfquery name="GetList" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	 T.*	         							 
		FROM 	 Ref_PositionParentGroupList T 
		WHERE 	 T.GroupCode = '#url.cde#'  
		AND      ListCodeParent = '#url.val#'		
		ORDER BY T.GroupListOrder ASC
</cfquery>

<cfif getList.recordcount eq "0">

<cfelse>

<cfoutput>
<select class="regularxxl" name="ListCodeSub_#url.cde#" ID="ListCodeSub_#url.cde#">	
	<cfloop query="GetList">
		<option value="#GetList.GroupListCode#" <cfif url.sel eq GetList.GroupListCode>selected</cfif>>#GetList.Description#</option>
	</cfloop>
</select> 
</cfoutput>

</cfif>
