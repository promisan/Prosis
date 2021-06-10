
<!--- set history --->

<cfoutput>
	
	<cfif url.action eq "hide">
	
		<script>
		document.getElementById('logheader').className = "hide"
		document.getElementById('log').className = "hide"	
		</script>
		
		<a href="javascript:ptoken.navigate('#session.root#/staffing/application/Assignment/Review/setHistory.cfm?action=show','logset')">Show history</a>
	
	<cfelse>
	
		<script>
		document.getElementById('logheader').className = "regular"
		document.getElementById('log').className = "regular"
		</script>
		
		<a href="javascript:ptoken.navigate('#session.root#/staffing/application/Assignment/Review/setHistory.cfm?action=hide','logset')">Hide history</a>
	
	</cfif>

</cfoutput>