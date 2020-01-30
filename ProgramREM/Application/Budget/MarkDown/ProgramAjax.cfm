
<cfoutput>

<cfif url.field eq "program">

	<cfif action eq "add">

		<cfif url.prior eq "">
			<cfset sel = "'#url.val#'">
		<cfelse>
			<cfset sel = "#url.prior#,'#url.val#'">
		</cfif>
		
	<cfelse>
	
		<cfset sel = replaceNoCase("#url.prior#",",'#url.val#'","")> 
		<cfset sel = replaceNoCase(sel,"'#url.val#'","")> 
		<cfif left(sel,1) eq ",">
			<cfset sel = right(sel,len(sel)-1)>
		</cfif>
		
		<cfif right(sel,1) eq ",">
			<cfset sel = left(sel,len(sel)-1)>
		</cfif>				
				
	</cfif>
	
	<input type="text" id="program" name="program" value="#sel#">	

<cfelseif url.field eq "object">
	
	<cfif action eq "add">

		<cfif url.prior eq "">
			<cfset sel = "'#url.val#'">
		<cfelse>
			<cfset sel = "#url.prior#,'#url.val#'">
		</cfif>
		
	<cfelse>
		
		<cfset sel = replaceNoCase("#url.prior#",",'#url.val#'","")> 
		<cfset sel = replaceNoCase(sel,"'#url.val#'","")> 
		<cfset sel = replaceNoCase(sel,",,",",")> 
		
		<cfif left(sel,1) eq ",">		
			<cfset sel = right(sel,len(sel)-1)>
		</cfif>
				
		<cfif right(sel,1) eq ",">
			<cfset sel = left(sel,len(sel)-1)>
		</cfif>		
		
	</cfif>
	
	<input type="text" id="object" name="object" value="#sel#">	

</cfif>


</cfoutput>
