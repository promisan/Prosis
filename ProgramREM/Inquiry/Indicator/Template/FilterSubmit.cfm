
<cfset client.programgraphfilter = "">

<cfparam name="form.filter1" default="">
<cfparam name="form.filtervalue1" default="">

<cfif form.filter1 neq "" and form.filtervalue1 neq "">
	<cfset client.programgraphfilter  = " AND #form.filter1# IN (#form.filtervalue1#)"> 
</cfif>

<cfparam name="form.gender" default="">

<cfif form.gender neq "">
    <cfset client.programgraphfilter  = " #client.programgraphfilter# AND gender = '#Form.gender#'"> 		
</cfif>	

<cfoutput>
<script>
	reload("#url.item#")		
</script>	
</cfoutput>
	


