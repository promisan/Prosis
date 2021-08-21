
<cfparam name="url.row"  default="1">
<cfparam name="url.col"  default="1">
<cfparam name="url.cols" default="1">
<cfparam name="url.rows" default="1">

<cfoutput>

<script>

<cfif url.row neq "99">

	base = document.getElementById("c#url.row#_1").value	

	<cfloop index="c" from="2" to="#url.cols#">
                 
	   se= document.getElementById("c#url.row#_#c#")	   	  
	   se.value = base
	  
	</cfloop>

<cfelse>

	<cfset url.row = "1">
		
</cfif>

ptoken.navigate('RequestDialogFormMatrixScript.cfm?row=#url.row#&col=#url.col#&rows=#url.rows#&cols=#url.cols#','ctotal')


</script>

</cfoutput>
