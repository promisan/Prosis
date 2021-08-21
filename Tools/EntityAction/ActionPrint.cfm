
<title>Embedded Document</title>

<cfoutput>
<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#">

<script>
	window.open("ActionPrintDocument.cfm?#CGI.QUERY_STRING#","_self")
</script>

</cfoutput>

