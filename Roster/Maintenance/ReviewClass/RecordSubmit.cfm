
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cf_preventCache>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ReviewClass
WHERE 
Code  = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
 
		<cfquery name="Insert" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_ReviewClass
				         (Code,
						 Description,
						 <cfif '#Form.ExperienceCategory#' neq "">
						 ExperienceCategory,
						 </cfif> 
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName,	
						 Created)
				  VALUES ('#Form.Code#',
				          '#Form.Description#', 
						  <cfif '#Form.ExperienceCategory#' neq "">
						  '#Form.ExperienceCategory#',
						  </cfif>
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#'
						  )
		</cfquery>
		
		<cfquery name="owner" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_ParameterOwner
				WHERE	Operational = 1
		</cfquery>
		
		<cfloop query="owner">
			<cfset ownerId = replace(owner, " ","","ALL")>
			<cfif isDefined("Form.owner_#ownerId#")>
				<cfset vEntityClass = evaluate("Form.owner_entityClass_#ownerId#")>
				<cfquery name="InsertOwner" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Ref_ReviewClassOwner
							(
								Code,
								Owner,
								EntityClass,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							)
						VALUES
							(
								'#Form.Code#',
								'#owner#',
								'#vEntityClass#',
								'#SESSION.acc#',
						    	'#SESSION.last#',		  
							  	'#SESSION.first#'
							)
				</cfquery>
			</cfif>
		</cfloop>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_ReviewClass
			SET 
			    Code                 = '#Form.Code#',
			    Description          = '#Form.Description#',
				 <cfif '#Form.ExperienceCategory#' neq "">
				 ExperienceCategory       = '#Form.ExperienceCategory#',
				 <cfelse>
				 ExperienceCategory = NULL,
				 </cfif>
				Operational          = '#Form.Operational#'
			WHERE Code      = '#Form.CodeOld#'
	</cfquery>
	
	<cfquery name="clearOwner" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE	
			FROM	Ref_ReviewClassOwner
			WHERE	Code = '#Form.Code#'
	</cfquery>
	
	<cfquery name="owner" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_ParameterOwner
			WHERE	Operational = 1
	</cfquery>
	
	<cfloop query="owner">
		<cfset ownerId = replace(owner, " ","","ALL")>
		<cfif isDefined("Form.owner_#ownerId#")>
			<cfset vEntityClass = evaluate("Form.owner_entityClass_#ownerId#")>
			<cfquery name="InsertOwner" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Ref_ReviewClassOwner
						(
							Code,
							Owner,
							EntityClass,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#Form.Code#',
							'#owner#',
							'#vEntityClass#',
							'#SESSION.acc#',
					    	'#SESSION.last#',		  
						  	'#SESSION.first#'
						)
			</cfquery>
		</cfif>
	</cfloop>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT ReviewCode
      FROM ApplicantReview
      WHERE ReviewCode  = '#Form.Code#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert(" Event category is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
			
	<cfquery name="Delete" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_ReviewClass
WHERE Code = '#FORM.CodeOld#'
    </cfquery>
	
	</cfif>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  
