

<!--- get position --->

<cfparam name="url.action" default="insert">

<cfif url.action eq "insert">

 <cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT      *
	FROM        Position
	WHERE       PositionNo = '#url.positionno#'		
</cfquery>		

<cfoutput>
<script>
    
	<cfif Position.SourcePostNumber neq "">
    document.getElementById('#url.class#_1').innerHTML = "#Position.SourcePostNumber#"
	<cfelse>
	document.getElementById('#url.class#_1').innerHTML = "#Position.PositionParentId#"
	</cfif>
	document.getElementById('#url.class#_2').innerHTML = "#Position.FunctionDescription#"
		
</script>
</cfoutput>

<!--- record --->

 <cfquery name="check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT      *
	FROM        PositionRelation
	WHERE       PositionNo    = '#url.pos#'	
	AND         RelationClass = '#url.class#'	
</cfquery>	

<cfif check.recordcount eq "0">
	
	 <cfquery name="Insert" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO PositionRelation
		(PositionNo,RelationClass,PositionNoRelation,OfficerUserId,OfficerLastName,OfficerFirstName)
		VALUES 
		('#url.pos#','#url.class#','#url.positionno#','#session.acc#','#session.last#','#session.first#')		
	</cfquery>	

<cfelse>
	
	 <cfquery name="update" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE      PositionRelation
			SET         PositionNoRelation = '#url.positionno#'
			WHERE       PositionNo         = '#url.pos#'	
			AND         RelationClass      = '#url.class#'	
	</cfquery>	

</cfif>

<cfelseif url.action eq "delete">
	
	 <cfquery name="check" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM PositionRelation
		WHERE       PositionNo    = '#url.pos#'	
		AND         RelationClass = '#url.class#'	
	</cfquery>	
	
		
	<cfoutput>
	<script>
	    		
	    document.getElementById('#url.class#_1').innerHTML = ""		
		document.getElementById('#url.class#_2').innerHTML = ""
			
	</script>
	</cfoutput>

</cfif>