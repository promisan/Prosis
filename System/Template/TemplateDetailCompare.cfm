
<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#">
<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css"  media="print">

<cftry>

<cfinclude template="../../cfrstage/user/#SESSION.acc#/compare.html">

<cfcatch>
	 Code comparison utility has not been installed
</cfcatch>

</cftry>

