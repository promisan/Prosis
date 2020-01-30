
<!--- template to capture additional information on the PA action on the Profile level --->

<cfparam name="url.field"    default="Nationality">
<cfparam name="url.value"    default="">
<cfparam name="url.personno" default="">
<cfparam name="url.mode"     default="person">

<cfoutput>

<cfif url.mode eq "Person">
	
	<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Person
		WHERE  PersonNo = '#URL.personno#'
	</cfquery>
		
	<cfif evaluate("Person.#url.field#") neq url.value>
	
	    <cfinclude template="PersonEditAction.cfm">
	
		<script>
	    	document.getElementById("#url.field#_action").className = "regular"
		</script>
	
	<cfelse>
	
		<script>
		    document.getElementById("#url.field#_action").className = "hide"	 
		</script>
		
	</cfif>	
	
<cfelse>
	
	<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   PersonGroup
		WHERE  PersonNo = '#URL.personno#'
		AND    GroupCode = '#field#'
	</cfquery>
	
	<cfif Person.GroupListCode neq url.value>
	
	 <cfinclude template="PersonEditAction.cfm"> 
	
		<script>		
	    	document.getElementById("#url.field#_action").className = "regular"
		</script>
	
	<cfelse>
	
		<script>
		    document.getElementById("#url.field#_action").className = "hide"	 
		</script>
		
	</cfif>	

</cfif>	

</cfoutput>
