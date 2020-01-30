
<cfoutput>

<cfparam name="URL.ID" default="">
<cfparam name="URL.Mode" default="PRG">
<cfparam name="URL.ID1" default="Tree">

<cf_systemscript>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfif url.mode neq "">

	<script language="JavaScript">
	
	   parent.window.treeselect.value = "ID=#URL.Mode#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#"
	   window.location="ProgramViewGeneral.cfm?Period=" + parent.document.getElementById("PeriodSelect").value + 
	                     "&Mode=" + parent.document.getElementById("Mode").value +
	                     "&ProgramGroup=" + parent.document.getElementById("ProgramGroup").value +
						 "&ReviewCycleId=" + parent.document.getElementById("CycleId").value +
						 "&ProgramClass=" + parent.document.getElementById("ProgramClass").value +
	                     "&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&mid=#mid#"
	</script>					 
					 
<cfelse>					 

	<script language="JavaScript">
	
	   if (parent.window.treeselect.value != "") {
			   window.location="ProgramViewGeneral.cfm?Period=" + parent.document.getElementById("PeriodSelect").value + 
	                     "&Mode=" + parent.left.document.getElementById("Mode").value +
	                     "&ProgramGroup=" + parent.document.getElementById("ProgramGroup").value +
						 "&ReviewCycleId=" + parent.document.getElementById("CycleId").value +
						 "&ProgramClass=" + parent.document.getElementById("ProgramClass").value +
	                     "&"+parent.document.getElementById("treeselect").value+"&mid=#mid#"
		}	
			
	</script>						 

</cfif>

</cfoutput>

