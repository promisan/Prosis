
<cfparam name="Form.Selected" default="">

<!--- remove posts --->

<cftransaction>


<cfset sl = 0>

<cfloop index="Item" 
	           list="#Form.Selected#" 
	           delimiters="',">
			   
		<cfquery name="Get" 
		datasource="AppsVacancy" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">		
			SELECT *
			FROM   Employee.dbo.Position
			WHERE  PositionNo = '#Item#'
		</cfquery>   
		
		<cfif Get.recordcount eq "1">
		 <cfset sl = sl+1>
		</cfif>   
		
</cfloop>	

<!--- check if matching --->

<cfquery name="Check" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   DocumentCandidate
		WHERE  DocumentNo = '#FORM.DocumentNo#'
		AND    Status IN ('2s','3') 
		AND    EntityClass is not NULL		
</cfquery>	
			   
<cfif sl lt check.recordcount>
		
	<cftransaction action = "rollback"/>
	<cfif check.recordcount gt '1'>
		<cf_alert message="Problem, you must select at least #Check.recordcount# positions.">
	<cfelse>
		<cf_alert message="Problem, you must select at least #Check.recordcount# position.">
	</cfif>
	<cfabort>

</cfif>
		   

<cfif Form.Selected neq "">

	<cfquery name="Remove" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM DocumentPost 
		WHERE  DocumentNo = '#FORM.DocumentNo#'
	</cfquery>

	<!--- define selected items --->
	
	<cfloop index="Item" 
	           list="#Form.Selected#" 
	           delimiters="' ,">
	
		<cfquery name="Get" 
		datasource="AppsVacancy" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">		
			SELECT *
			FROM   Employee.dbo.Position
			WHERE  PositionNo = '#Item#'
		</cfquery>   
		
		<cfquery name="Check" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM DocumentPost 
			WHERE  DocumentNo = '#FORM.DocumentNo#'
			AND PositionNo = '#Item#'
		</cfquery>
		
		<cfif Check.recordcount eq "0">
			   		   
			<cfquery name="Insert" 
			datasource="AppsVacancy" 
			username=#SESSION.login# 
			password=#SESSION.dbpw#>
				INSERT INTO DocumentPost 
			         (DocumentNo, 
					  PositionNo,
					  Postnumber,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName,
					  Created)
			  	VALUES ('#FORM.DocumentNo#', 
			          '#Item#', 
					  '#get.SourcePostNumber#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#',
					  '#DateFormat(Now(),CLIENT.DateSQL)#')
			</cfquery>		
		
		</cfif>
	
	</cfloop>

</cfif>

</cftransaction>


<!--- close window --->

<script>
{   
parent.parent.history.go()
parent.parent.ColdFusion.Window.destroy('myassociate',true)	

}
</script>

