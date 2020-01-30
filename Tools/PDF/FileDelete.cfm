<cfparam name="Form.Select" default="">
<cfparam name="CLIENT.DocDir" default="">

<cfif CLIENT.docDir neq "">

	<cfloop index="nme" list="#Form.select#" delimiters="',">
	
	   <cffile action="DELETE" file="#CLIENT.DocDir#/#form.subdir#/#nme#">
	
	</cfloop>

</cfif>

<cfoutput>
<script>
        window.location = "#form.path#";
</script>
</cfoutput>
