
<!--- validate --->

 <cfquery name="get" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   Person 
	 WHERE  PersonNo = '#url.personno#'
</cfquery>

<cfoutput>

<cfif get.recordcount eq "0" or url.value eq "">

	<script>			   
		 document.getElementById('personselect').value = ""
		 document.getElementById('personidselect').value = ""		 
		 ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getPerson.cfm?mission=#url.mission#&personno=','personbox')
	</script>
	
<cfelse>

    <script>		
		 _cf_loadingtexthtml='';	
	     document.getElementById('personselect').value = "<cfif get.Reference neq "">#get.Reference#<cfelse>#get.IndexNo#</cfif>"
		 ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getPerson.cfm?mission=#url.mission#&personno=#get.personno#','personbox')
	</script>		

</cfif>	 

</cfoutput>