
<title>Embedded Document</title>

<cfoutput>
<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#">

<cf_wait1 text="Preparing Requested Document in PDF format" flush="force">

<script>
	window.open("ActionPrintDocument.cfm?#CGI.QUERY_STRING#","_self")
</script>

</cfoutput>

