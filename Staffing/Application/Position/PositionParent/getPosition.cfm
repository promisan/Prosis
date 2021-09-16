

<!--- get position --->

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
    document.getElementById('#url.class#_1').innerHTML = "#Position.SourcePostNumber#"
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
	WHERE       PositionNo = '#url.positionno#'	
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






