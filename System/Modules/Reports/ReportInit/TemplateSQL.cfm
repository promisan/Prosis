
<!--- ----------- Prosis Template SQL.cfm     ------------------- --->
<!---

---------------------------------------------------------------------
How to declare a query
---------------------------------------------------------------------

---------------------------------------------------------------------
How to show progress 
---------------------------------------------------------------------

<cf_Wait text      = "Retrieving Report Data step 1 of 9"
	flush     = "yes" controlid = "#URL.controlid#">

---------------------------------------------------------------------	
How to trigger a condition
---------------------------------------------------------------------

<cfif CheckResult.recordcount gte "10000">

   <cfif URL.Mode eq "Form" or URL.Mode eq "Link" >
	  	<cf_message message = "You selected too many records." 
		return = "no">
   </cfif>
   <cfset status = "0">
   <cfexit method="EXITTEMPLATE">
      
</cfif>   	

--->
<!--- ----------------------------------------------------------- --->

<!--- ----------- SECTION : query definition  ------------------- --->
<!--- use this section to run one or more queries that result in  --->
<!--- one or more table that will be passed to the report         ---> 
<!--- ----------------------------------------------------------- --->







<!--- ----------- SECTION : condition definition  --------------- --->
<!--- use this section to define one or more condition ---------- --->
<!--- if the condition is not met assign a value status = 0  ---- --->
<!--- ----------------------------------------------------------- --->

<cfinclude template="Event.cfm">

<cfif condition eq "9">
	<cf_message message = "Attention: ......" return = "no">
	<cfset status = "0">
	<cfexit method="EXITTEMPLATE">
</cfif>


<!--- -----------------   END OF TEMPLATE    -------------------- --->