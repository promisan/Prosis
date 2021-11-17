
<cfquery name="GetList" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	 T.*	         							 
		FROM 	 Ref_TopicList T 
		WHERE 	 T.Code = '#url.cde#'  
		AND      ListCodeParent = '#url.val#'
		AND 	 T.Operational = 1
		ORDER BY T.ListOrder ASC
</cfquery>

<cfif getList.recordcount eq "0">

<cfelse>

<cfoutput>
<select class="regularxxl" name="TopicSub_#url.cde#" ID="TopicSub_#url.cde#">	
	<cfloop query="GetList">
		<option value="#GetList.ListCode#" <cfif url.sel eq GetList.ListCode>selected</cfif>>#GetList.ListValue#</option>
	</cfloop>
</select> 
</cfoutput>

</cfif>
