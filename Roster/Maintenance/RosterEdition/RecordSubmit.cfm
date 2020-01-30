
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = #dateValue#>

<cfset dateValue = "">
<cfif #Form.DateExpiration# neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = #dateValue#>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfparam name="form.Operational" default="0">

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_SubmissionEdition
	WHERE SubmissionEdition  = '#Form.SubmissionEdition#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
		
		<cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_SubmissionEdition
		         (SubmissionEdition,
				 EditionDescription,
				 EditionShort,
				 Owner,
				 ExerciseClass,
				 DefaultStatus,
				 EnableAsRoster,
				 RosterSearchMode,
				 EnableManualEntry,
				 DateEffective,
				 DateExpiration,
				 PostType,
				 EntityClass,
				 ForecastLevel,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		  VALUES ('#Form.SubmissionEdition#',
        		  '#Form.EditionDescription#', 
				  '#Form.EditionShort#',
				  '#Form.Owner#',
				  '#Form.ExerciseClass#',
				  '0',
				  '#Form.EnableAsRoster#',
				  '#Form.RosterSearchMode#',
				  '#Form.EnableManualEntry#',
				  #STR#,
				  #END#,
				  '#Form.PostType#',
				  '#Form.EntityClass#',
				  '#Form.ForecastLevel#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())</cfquery>
		     		  
    </cfif>		
	
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Old" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM Ref_SubmissionEdition		
		WHERE SubmissionEdition    = '#Form.CodeOld#'
	</cfquery>
	
	<cfquery name="Update" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  Ref_SubmissionEdition
		SET     SubmissionEdition  = '#Form.SubmissionEdition#',
			    EditionDescription = '#Form.EditionDescription#', 
			    EditionShort       = '#Form.EditionShort#',
				ExerciseClass      = '#Form.ExerciseClass#',
				EnableManualEntry  = '#Form.EnableManualEntry#',
				RosterSearchMode   = '#Form.RosterSearchMode#',
				EnableAsRoster     = '#Form.EnableAsRoster#',
				DefaultStatus      = '#Form.DefaultStatus#',
				ForecastLevel      = '#Form.ForecastLevel#',
				PostType           = '#Form.PostType#',
				EntityClass		   = '#Form.EntityClass#',
				Operational        = '#Form.Operational#',
				DateEffective      = #STR#,
				DateExpiration     = #END#
		WHERE 	SubmissionEdition    = '#Form.CodeOld#'
	</cfquery>
		
	<cfif Old.ForecastLevel neq Form.ForecastLevel>
	
		<cfquery name="Clean" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM FunctionBucket		
		WHERE SubmissionEdition    = '#Form.SubmissionEdition#'
		</cfquery>
		
	</cfif>	
	
	<cfif Form.ForecastLevel eq "Bucket">
	
		<cfquery name="List" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT     DISTINCT F.OccupationalGroup, 
		               FO.FunctionNo, 
				       FO.OrganizationCode, 
     				   FO.SubmissionEdition, 
		    		   FO.GradeDeployment
    		FROM       FunctionOrganization FO INNER JOIN
                       FunctionTitle F ON FO.FunctionNo = F.FunctionNo
    		WHERE      FO.SubmissionEdition = '#Form.SubmissionEdition#'
		</cfquery>
		
		<cfloop query="List">
		
			<cfquery name="Check" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT     *
	    		FROM       FunctionBucket
	    		WHERE      SubmissionEdition = '#SubmissionEdition#'
				AND        OccupationalGroup = '#OccupationalGroup#'
				AND        FunctionNo        = '#FunctionNo#'
				AND        OrganizationCode  = '#OrganizationCode#'
				AND        GradeDeployment   = '#GradeDeployment#'
			</cfquery>
			
			<cfif check.recordcount eq "0">
			
				<cfif gradedeployment neq ""> 
			
					<cfquery name="Insert" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">				
						INSERT INTO FunctionBucket
						(OccupationalGroup,FunctionNo,OrganizationCode,SubmissionEdition,GradeDeployment)
						VALUES
						('#OccupationalGroup#', 
						 '#FunctionNo#', 
						 '#OrganizationCode#', 
						 '#SubmissionEdition#', 
						 '#GradeDeployment#')						
				    </cfquery>
				
				</cfif>
				
			</cfif>		
		
		</cfloop>
		
	
	<cfelse>
	
		<cfquery name="List" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT     DISTINCT F.OccupationalGroup, 		             
				       FO.OrganizationCode, 
     				   FO.SubmissionEdition, 
		    		   FO.GradeDeployment
    		FROM       FunctionOrganization FO INNER JOIN
                       FunctionTitle F ON FO.FunctionNo = F.FunctionNo
    		WHERE      FO.SubmissionEdition = '#Form.SubmissionEdition#'
		</cfquery>
		
		<cfloop query="List">
		
			<cfquery name="Check" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT     *
	    		FROM       FunctionBucket
	    		WHERE      SubmissionEdition = '#SubmissionEdition#'
				AND        OccupationalGroup = '#OccupationalGroup#'				
				AND        OrganizationCode  = '#OrganizationCode#'
				AND        GradeDeployment   = '#GradeDeployment#'
			</cfquery>
			
			<cfif check.recordcount eq "0">
			
				<cfquery name="Insert" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				
					INSERT INTO FunctionBucket
					(OccupationalGroup, OrganizationCode, SubmissionEdition, GradeDeployment)
					VALUES
					('#OccupationalGroup#', '#OrganizationCode#', '#SubmissionEdition#', '#GradeDeployment#')						
			    </cfquery>
				
			</cfif>		
		
		</cfloop>
	
	
	</cfif>
	
</cfif>	

<cfif ParameterExists(Form.Delete)> 

	 <cfquery name="CountPos" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT *
      FROM   Ref_SubmissionEditionPosition
      WHERE  SubmissionEdition  = '#Form.SubmissionEdition#' 
    </cfquery>

    <cfquery name="CountRec" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT *
      FROM   FunctionOrganization
      WHERE  SubmissionEdition  = '#Form.SubmissionEdition#' 
    </cfquery>
    
    <cfif CountRec.recordCount gt 0 or CountPos.recordcount gt 0>
		 
	     <script language="JavaScript">
	    
		   alert("Edition is in use. Operation aborted.")
		        
	     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_SubmissionEdition
			WHERE SubmissionEdition = '#FORM.codeOld#'
	    </cfquery>
			
	</cfif>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
