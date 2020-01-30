
<cfif url.checked eq "false">

<cfquery name="Clear" 
    datasource="#url.alias#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    DELETE FROM #url.topicscope#
	WHERE  #url.topicfield#      = '#url.topic#'  
	AND    #url.topicscopefield# = '#url.class#'
</cfquery>

<cfelse>

	<cfquery name="Insert" 
	    datasource="#url.alias#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    INSERT INTO #url.topicscope#
		(#url.topicfield#,#url.topicscopefield#)
		VALUES ('#url.topic#','#url.class#')  
	</cfquery>


</cfif>
