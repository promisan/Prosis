
<cfparam name="Form.AreaSelect" default="All">  

<!--- remove prior background --->

	<cfquery name="Remove" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM PersonContractBackground
    WHERE    PersonNo   = '#Object.ObjectKeyvalue1#'
	AND      ContractId = '#Object.ObjectKeyvalue4#'
</cfquery>
	
<cfparam name="Form.Selected" default="">	

<cfif Form.Selected is not ""> 
	
	<!--- define selected users --->
	
	<cfloop index="Item" 
	           list="#Form.Selected#" 
	           delimiters="' ,">
			   
		<cfquery name="Get" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   ApplicantBackground
			WHERE  ExperienceId = '#Item#'
		</cfquery>		
		
		<cfif Get.ExperienceEnd gte "01/01/1901">
		 	<cfset end = "#dateFormat(Get.ExperienceEnd,CLIENT.DateSQL)#">
		<cfelse>
			<cfset end = "#dateFormat(now(),CLIENT.DateSQL)#"> 
		</cfif> 	
		
		<cfquery name="Insert" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO PersonContractBackground
		         (PersonNo,ContractId,
				 ApplicantNo,
				 ExperienceId,
				 ExperienceCategory,
				 ExperienceDescription)
		  VALUES ('#Object.ObjectKeyvalue1#',
				 '#Object.ObjectKeyvalue4#',
				 '#Get.ApplicantNo#',
				 '#Get.ExperienceId#',
				 '#Get.ExperienceCategory#',
				 '#Get.ExperienceDescription#')
		</cfquery>		
		
	
	</cfloop>

</cfif>


