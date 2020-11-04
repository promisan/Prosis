
<!--- passtru template --->

<cfparam name="URL.UNIT" default="-">
<cfparam name="URL.MID" default="-">
<!---- Added by Jorge Mazariegos on 9/22/2010 ---->
<cf_screentop html="no" jquery="yes">

<cfoutput>
	
	<script language="JavaScript">
			
	parent.window.treeselect.value = "&mode=#URL.mode#&ID1=#URL.ID1#&mission=#URL.ID2#&mandate=#URL.ID3#&mid=#url.mid#"
	
	// alert(parent.document.getElementById("SystemFunctionId").value)
	
	ptoken.location("AllotmentActionListing.cfm?Period=" + parent.document.getElementById("PeriodSelect").value + 
				"&Edition=" + parent.document.getElementById("edition").value + 
				"&ProgramGroup=" + parent.document.getElementById("ProgramGroup").value +
				"&SystemFunctionId=" + parent.document.getElementById("SystemFunctionId").value +
				"&UNIT=#URL.UNIT#&mode=#URL.mode#&ID1=#URL.ID1#&id2=#URL.ID2#&id3=#URL.ID3#&systemfunctionid=#url.systemfunctionid#&mid=#url.mid#")
	
	</script>

</cfoutput>
