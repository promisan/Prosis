
<!--- set calendardate --->

<cfoutput>
	<script>
		document.getElementById('fselected').value = "#dateformat(url.dte,client.dateformatshow)#"
	</script>
</cfoutput>