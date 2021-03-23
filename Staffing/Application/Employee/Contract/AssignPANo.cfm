
<cfparam name="url.wf" default="0">

<cfquery name="Parameter" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_ParameterMission
		WHERE     Mission = '#URL.Mission#'		
	</cfquery>
	
<cfif Parameter.PersonActionEnable eq "0" or 
      Parameter.PersonActionNo eq "" or 
	  Parameter.PersonActionPrefix eq "">

	<input type="text" name="PersonnelActionNo" class="regularxxl"  size="12" maxlength="20">

<cfelse>

   | number will be generated | 

</cfif>	

<!--- we reset also the position --->

<cfif url.wf eq "0">
	
	<script>
	    try {
		document.getElementById('PositionNo').value = ""
		document.getElementById('Position').value = ""
		document.getElementById('assignmentbox').innerHTML = ""
		} catch(e) {}
	</script>

</cfif>