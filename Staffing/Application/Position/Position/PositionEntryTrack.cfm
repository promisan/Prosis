
<!--- define the classes to be selected --->

<cfinvoke component      = "Service.Process.Vactrack.Vactrack"  
   method                = "verifyAccess"    
   orgunitadministrative = "0" 
   orgunit               = "#url.orgunit#" 
   mission               = "#url.mission#"
   mandate               = "#url.mandate#"
   posttype              = "#url.postType#"
   returnvariable        = "accessTrack">	 
         
<cfif accessTrack.status eq "0">

	<table><tr class="labelmedium"><td><cfoutput>#accessTrack.reason#</cfoutput></td></tr></table>

<cfelse>  
	
  <cfset list = accesstrack.tracks>
			
  <table>	
   		
		<cfset row = "1">
		<tr>
		<td><cfoutput>#AccessTrack.Owner#</cfoutput><input type="hidden" name="Owner" value="<cfoutput>#AccessTrack.Owner#</cfoutput>">:</td>
		<td><input type="radio" name="EntityClass" class="radiol" value="" checked><td><td stylle="padding-right:4px">N/A</td>
	    <cfoutput query="list">		
			<cfset row = row+1>
			<cfif row eq "1"><tr></cfif>		
			<td>
			<input type="radio" name="EntityClass" class="radiol" value="#EntityClass#">
			</td><td class="labelmedium" style="padding-left:5px">#EntityClassName#</td>
			<cfif row eq "1">
			</tr>
			<cfset row = "0">
			</cfif>
		</cfoutput>
  </table>
  
</cfif>  