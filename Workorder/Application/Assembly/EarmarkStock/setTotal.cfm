<!--- show the total selected --->

<cfset tot = 0>

<cfoutput>

<cfloop index="fld" list="#form.fieldnames#">
   <cfif left(fld,8) eq "Transfer">
      
        <cfset val = evaluate(fld)>
		<cfset val = replaceNoCase(val,",","","ALL")>		
		
        <cfif isnumeric(val)>
		   	<cfset tot = tot + val>
		</cfif>
   </cfif>
</cfloop>


<cfif tot eq "0">

	<script>	
	 document.getElementById('processbox').className = "hide"	 
	</script>
	
<cfelse>

	
	<script>
	 document.getElementById('processbox').className = "regular"	 
	</script>

</cfif>

<b>#tot#</b>

</cfoutput>