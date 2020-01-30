
<cfset dateValue = "">
<CF_DateConvert Value="#url.selected#">
<cfset STR = dateValue>

<CF_DateConvert Value="#url.val#">
<cfset END = dateValue>

<cfoutput>

	<cfif STR gt END and url.mde eq "1">
	
		<script>
		 document.getElementById('#url.fld#').value = '#dateformat(STR+1,client.dateformatshow)#'
		 document.getElementById('#url.fld#').focus()
		</script>
		
		<!---
		<cfif url.source neq "Manual">		
			<cfset ajaxonload("doCalendar")>
		</cfif>
		--->
	
	</cfif>
	
	<script>
		getinformation('#url.id#')
	</script>

</cfoutput>


