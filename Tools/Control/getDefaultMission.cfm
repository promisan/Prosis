
<!--- get default mission --->
<cfset row = 0>
<cfloop index="itm" list="#CGI.Remote_addr#" delimiters=".">
		
	<cfset row = row+1>
			
	<cfif row neq "1">
			<cfif len(itm) eq "1">
			  <cfset nm = "00#itm#">
			<cfelseif len(itm) eq "2">
			  <cfset nm = "0#itm#">  
			<cfelse>
			  <cfset nm = itm>  
			</cfif>								
			<cfset val = "#val##nm#">
		<cfelse>
		    <cfset val = "#itm#">	
	</cfif>
			
</cfloop>

<cfquery name="RedirectIP" 
	datasource="AppsSystem">
	SELECT  TOP 1 * 
	FROM    stRedirection
	WHERE #val# >= IPRangeStartNum
	AND   #val# <= IPRangeEndNum 
	AND   ServerURL != 'DISABLED' 
</cfquery>

<CFSET Caller.Mission = RedirectIP.Mission>