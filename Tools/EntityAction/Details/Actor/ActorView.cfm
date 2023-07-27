
<!--- actors we obtain the enabled fly-actors for this action and allow them to record inputs (descision and comment --->

<cfparam name="url.formname" default="actorform">

<form name="<cfoutput>#url.formname#</cfoutput>">

<table style="width:100%">

<tr><td id="processactor">

    <cfinclude template="ActorViewContent.cfm">
		
	</td></tr></table>
	
</form>	
	
<cfset ajaxonload("doHighlight")>

