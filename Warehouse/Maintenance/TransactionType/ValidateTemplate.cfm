
<cfparam name="url.template" default="">

<cfif url.template neq "">

<cfoutput>

	<cftry>

		<cfif FileExists("#SESSION.root#/#url.template#")>					
			<img src="#SESSION.root#/Images/check_mark.gif" alt="" border="0" align="absmiddle">
			<input type="hidden" value="1" name="templateVal" id="templateVal">
		<cfelse>
			<img src="#SESSION.root#/Images/alert.gif" alt="File not found" border="0">
			<input type="hidden" value="0" name="templateVal" id="templateVal">
		</cfif>
		
	<cfcatch>
		<img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0">
		<input type="hidden" value="0" name="templateVal" id="templateVal">
	</cfcatch>
	
	</cftry>

</cfoutput>

</cfif>