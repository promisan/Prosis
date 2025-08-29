<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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