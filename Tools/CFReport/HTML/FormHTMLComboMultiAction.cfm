
<!--- apply --->

<cfif url.action eq "add">

	<cfset select = "#Form.multivalue##url.value#,"> 

<cfelseif url.action eq "delete">


	<cfset select = replaceNoCase(Form.multivalue,"#url.value#,",'')> 
	
<cfelseif url.action eq "deleteall">	

	<cfset select = ""> 
	
<cfelse>	

	<cfset select = "#Form.allv#"> 	

</cfif>


<cfoutput>

<script>
	_cf_loadingtexthtml='';		
    document.getElementById('multivalue').value = '#select#'
	multiselected('#url.fld#','#url.fly#','1')	
	multisearch('#url.fld#','#url.fly#','1')	
</script>

</cfoutput>