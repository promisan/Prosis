
<cfif not FileExists("#SESSION.rootPath#\#url.file#")>

	<b><font color="#FF0000">
	You entered an invalid schedule template path/file name
	</b>
	</font>
	
	<script>
		document.getElementById("update").className = "hide"
	</script>

<cfelse>

	<b><font color="green">
	You entered a valid schedule template path/file name
	</b>
	</font>

	<script>
		document.getElementById("update").className = "button10g"
	</script>
	
</cfif>