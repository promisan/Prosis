
<cfquery name="Show" 
	     datasource="AppsEPAS" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	    	SELECT     *
			FROM         Ref_Behavior
			WHERE    Code    = '#URL.ID2#' 
</cfquery>

<cfoutput>#Show.BehaviorMemo#</cfoutput>
