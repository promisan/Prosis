<cfset actionform = "Contract">

<!--- show the contract edit screen by creating a contract with the objectid of the Id code --->

<cfquery name="Candidate" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   DocumentCandidate
		WHERE  DocumentNo   = '#Object.ObjectKeyValue1#'		
		AND    PersonNo     = '#Object.ObjectKeyValue2#'
</cfquery>

<cfquery name="check" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonContract
	WHERE  ContractId  = '#Candidate.CandidateId#'		
</cfquery>

<cfif check.recordcount eq "1">

	<!--- to trigger specific behavior for the creation in the workflow --->	
	
	<table width="100%" height="100%">
			<tr class="line"><td style="height:20px;font-size:17px;font-weight:200;padding-left:10px">
				<font color="FF0000">Contract was recorded</font>
			</td></tr>
			<tr><td>
			<cfoutput>
				<iframe src="#session.root#/Staffing/Application/Employee/Contract/EmployeeContract.cfm?header=0&id=#check.personno#" width="100%" height="100%" frameborder="0"></iframe>
			</cfoutput>
			</td></tr>
	</table>	

<cfelse>
	
	<cfquery name="Applicant" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Applicant
		WHERE  PersonNo   = '#Object.ObjectKeyValue2#'		
	</cfquery>
	
	<cfquery name="Candidate" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   DocumentCandidate
		WHERE  DocumentNo   = '#Object.ObjectKeyValue1#'		
		AND    PersonNo     = '#Object.ObjectKeyValue2#'
	</cfquery>
	
	<cfquery name="getPosition" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   DocumentPost
		WHERE  DocumentNo   = '#Object.ObjectKeyValue1#'		
	</cfquery>
	
	<cfif getPosition.recordcount eq "1">		
		<cfset positionno = getPosition.PositionNo>		
	<cfelse>	
		<cfset positionno   = "">			
	</cfif>
	
	<cfif Applicant.EmployeeNo neq "">
	
		<cfset url.id  = "#Applicant.EmployeeNo#">
		
		<!--- to trigger specific behavior for the creation in the workflow --->		
		<cfoutput>
		<iframe src="#session.root#/Staffing/Application/Employee/Contract/ContractEntry.cfm?id=#url.id#&id1=#Candidate.CandidateId#&objectid=#Object.ObjectId#&wf=1&positionno=#PositionNo#" width="100%" height="100%" frameborder="0"></iframe>
		</cfoutput>
					
	<cfelseif Applicant.IndexNo neq "">
		
		<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Person
			WHERE  IndexNo = '#Applicant.IndexNo#'		
		</cfquery>
	
		<cfif Person.recordcount eq "1">
	
			<cfset url.id  = "#Person.PersonNo#">					
			<cfoutput>
			<iframe src="#session.root#/Staffing/Application/Employee/Contract/ContractEntry.cfm?id=#url.id#&id1=#Candidate.CandidateId#&objectid=#Object.ObjectId#&wf=1&positionno=#trackpositionno#" width="100%" height="100%" frameborder="0"></iframe>
			</cfoutput>
						
		<cfelse>
		
			<table width="100%" height="80">
			<tr><td align="center" style="font-size:19px;font-weight:200">
			<font color="FF0000">Problem no employee record found. please associate first.</font>
			</td></tr>
			</table>		
				
		</cfif>
	
	<cfelse>
	
			<table width="100%" height="80">
				<tr><td align="center" style="font-size:19px;font-weight:200">
				<font color="FF0000">Problem no employee record found</font>
				</td></tr>
			</table>		
	
	</cfif>	
	
</cfif>	




