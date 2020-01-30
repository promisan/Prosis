
<!--- passtru template --->

<cfparam name="URL.UNIT" default="-">
<cfparam name="URL.ID1"  default="Tree">
<!---- Added by Jorge Mazariegos on 9/22/2010 ---->
<cfparam name="URL.Mode" default="PRG">

<cf_screentop jquery="Yes" html="No">

<cfoutput>
	
	<script language="JavaScript">
	
	parent.Prosis.busy('yes')
	
	parent.window.treeselect.value = "&mode=#URL.mode#&ID1=#URL.ID1#&mission=#URL.ID2#&mandate=#URL.ID3#"
	
	// alert(parent.document.getElementById("SystemFunctionId").value)
	
	ptoken.location("AllotmentViewGeneral.cfm?Period=" + parent.document.getElementById("PeriodSelect").value + 
				"&Edition=" + parent.document.getElementById("edition").value + 
				"&ProgramGroup=" + parent.document.getElementById("ProgramGroup").value +
				"&SystemFunctionId=" + parent.document.getElementById("SystemFunctionId").value +
				"&UNIT=#URL.UNIT#&mode=#URL.mode#&ID1=#URL.ID1#&mission=#URL.ID2#&mandate=#URL.ID3#")
	
	</script>

</cfoutput>
