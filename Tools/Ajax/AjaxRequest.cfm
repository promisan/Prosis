
<!--- loads Ajax request --->

<!--- disabled dynamic link after ET issue --->

<script language="JavaScript" 
        src="<cfoutput>#SESSION.root#</cfoutput>/tools/Ajax/AjaxRequest.js" 
		type="text/javascript">
		
</script>

<!--- 

<cfset cnt = 0>

<cfloop index="itm" list="#CGI.SCRIPT_NAME#" delimiters="/">
	<cfset cnt = cnt+1>
</cfloop>

<cfswitch expression="#cnt#">

<cfcase value="1">
	 <cfset str = "">
</cfcase>
<cfcase value="2">
	 <cfset str = "../">
</cfcase>
<cfcase value="3">
	 <cfset str = "../../">
</cfcase>
<cfcase value="4">
	 <cfset str = "../../../">
</cfcase>
<cfcase value="5">
	 <cfset str = "../../../../">
</cfcase>
<cfcase value="6">
	 <cfset str = "../../../../../">
</cfcase>
<cfcase value="7">
	 <cfset str = "../../../../../../">
</cfcase>

</cfswitch>

<!--- crucial to keep cfoutput in the string --->
<script language="JavaScript" src="<cfoutput>#str#</cfoutput>Tools/Ajax/AjaxRequest.js" type="text/javascript"></script>
	
--->