<cf_screentop html="no"> 

<cfoutput>

<cf_submenuleftscript>

<script language="JavaScript">

function edition() {
    parent.right.location =  "FunctionRoster.cfm?ID=#URL.ID#"
}

</script>

</cfoutput>

<body>


<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left" class="menu">

<tr><td>

to be defined
<cfset heading = "Function">
<cfset module = "'Roster'">
<cfset selection = "'Function'">
<cfset menuclass = "'Main'">
<cfinclude template="../../../../Tools/SubmenuLeft.cfm">
</td></tr> 

</table>
