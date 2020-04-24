<cf_param name="url.public"         default="0"         type="String">
<cf_param name="url.embed"          default="0"         type="String">
<cf_param name="url.scope"          default="applicant" type="String">
<cf_param name="url.owner"          default=""          type="String">
<cf_param name="url.entrymode"      default="Extended"  type="String">
<cf_param name="url.entryscope"     default="Profile"   type="String">
<cf_param name="url.ApplicantNo"    default=""          type="String">
<cfparam  name="url.section"        default="">

<cfif url.embed eq "0">
	<cf_screentop html="No" jquery="Yes">		
</cfif>	  

<cfif url.action eq "create">

	<cfinclude template="GeneralFormConfirm.cfm">
		
	<script>
	   try {
		document.getElementById('submitme').className = "hide"
		} catch(e) {}
	</script>

<cfelse>

    <cftry>	  
   		<cfset test = session.myform>		  	    
   			<cfif test.lastname neq "">
     			<cfset myform = structCopy(test)>	 
   			</cfif>
  	<cfcatch>
			<cfset myform = structCopy(form)>
   	</cfcatch>
	</cftry>	
			
	<cfparam name="MyForm.documentreference"     default="">
	<cfparam name="MyForm.Reference"             default="">
	<cfparam name="MyForm.nationalityadditional" default="">		
	<cfparam name="URL.TriggerGroup"             default="PHP">
	
	<!--- general parameters --->
	  
	<cfquery name="PHP" 
		datasource="appsSelection">
			SELECT   *
			FROM     Parameter
	</cfquery>
	
	<cfparam name="MyForm.source" default="">
	
	<cfif MyForm.source eq "">
		<cfset Source = PHP.PHPEntry>
	<cfelse>
		<cfset source = MyForm.Source>	
	</cfif>	
		   				   
	<cfif URL.ApplicantNo eq "">
	
		<cfif MyForm.DOB eq "">
	
	     <cfset DOB = "NULL">
		 
		<cfelse>
	
	     <cfset dateValue = "">
	     <CF_DateConvert Value="#MyForm.DOB#">
	     <cfset DOB = dateValue>
		 
		</cfif>
	      		   
		<!--- checking --->
				
		<cfif url.scope eq "applicant" or url.scope eq "Backoffice">
		
			     <cfquery name="CheckName" 
			     datasource="AppsSelection">
				 				 
			 	    SELECT *
			     	FROM   Applicant
				 	WHERE  LastName    = <cfqueryparam value="#MyForm.lastname#"    cfsqltype="CF_SQL_CHAR" maxlength="40">
				 	AND    Nationality = <cfqueryparam value="#MyForm.nationality#" cfsqltype="CF_SQL_CHAR" maxlength="10">
				 	AND    DOB         = #dob#
					AND    LEFT(FirstName,1) = '#left(MyForm.FirstName,1)#'
					
					<!---
				 	AND    FirstName   = <cfqueryparam value="#MyForm.firstname#"   cfsqltype="CF_SQL_CHAR" maxlength="30">
					--->
					
				 </cfquery>
				 
				 <cfif checkName.recordcount gte "1">
				
					<cf_message message="Sorry but it appears you already have a record. Operation aborted." return="No">	
					<cfabort>		
				
				</cfif>
				 
				 <cfquery name="CheckMail" 
			     datasource="AppsSystem">
				 				 
			 	    SELECT *
			     	FROM   UserNames
				 	WHERE  eMailAddress = <cfqueryparam value="#MyForm.EMailAddress#"  cfsqltype="CF_SQL_CHAR" maxlength="50">
				 	AND    Disabled = 0
				 						
					<!---
				 	AND    FirstName   = <cfqueryparam value="#MyForm.firstname#"   cfsqltype="CF_SQL_CHAR" maxlength="30">
					--->
					
				 </cfquery>
								 
				<cfif checkMail.recordcount gte "1">
				
					<cf_message message="Sorry but it appears your eMail address is already in use. Operation aborted." return="No">	
					<cfabort>		
				
				</cfif>
			
		</cfif>
			
		<cfif url.scope eq "applicant">
		   		
    		<cfset SESSION.last     = MyForm.LastName> 
			<cfset SESSION.first    = MyForm.FirstName> 
			<cfset client.eMail     = MyForm.eMailAddress>
		   			 
		</cfif>
	  
	    <cftransaction>
	  
		   <cfquery name="Last" 
		     datasource="AppsSelection">
		    	SELECT    TOP 1 ApplicantNo AS LastNo 
		     	FROM      ApplicantSubmission
			 	ORDER BY  ApplicantNo DESC
		     </cfquery>
			 
			<cfif Last.LastNo neq "">
			    <cfset new = Last.LastNo+1>
			<cfelse>	
			    <cfset new = "1">
			</cfif> 
					
		   <cfquery name="AssignNo" 
		     datasource="AppsSelection">
		     	UPDATE Parameter SET ApplicantNo = #new#
		     </cfquery>
			 
			<cfif MyForm.PersonNo eq "">
		     
			    <cfquery name="AssignNo" 
			     datasource="AppsSelection">
			     	UPDATE Parameter 
					SET    PersonNo    = PersonNo+1
				</cfquery>
			
			    <cfquery name="LastNo" 
			     datasource="AppsSelection">
				     SELECT *
				     FROM Parameter
				</cfquery>
				
				<cfset personNo = LastNo.PersonNo>
			
			<cfelse>
			
				<cfset personNo = MyForm.PersonNo>
			
			</cfif>			
			
		    <cfquery name="InsertApplicant" 
			     datasource="AppsSelection">
			  	   INSERT INTO Applicant 
			         (PersonNo,
					 <cfif ISDEFINED("MyForm.Salutation")>
						 Salutation,
					 </cfif>			        
					 <cfif ISDEFINED("MyForm.IndexNo")>
						 IndexNo,
					 </cfif>				
					 <!--- core fields --->			
					 LastName,
					 FirstName,
					 DOB,
					 Gender,
					 Nationality,								 			 
					 MaidenName,			 
					 <cfif url.entrymode eq "Extended">			 
					 LastName2,
					 MiddleName,
					 MiddleName2,			
					 BirthCity,			 
					 </cfif>			 			
					 NationalityAdditional,
					 ApplicantClass,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 <cfif ISDEFINED("MyForm.Remarks")>
					 Remarks,
					 </cfif>
					 Reference,
					 Source,
					 eMailAddress,
					 MobileNumber,
					 PhoneNumber,
					 DocumentReference
					 <cfif ISDEFINED("MyForm.MaritalStatus")>
					 ,MaritalStatus
					 </cfif>)
					 
			      VALUES ('#PersonNo#',
				  
				  		<cfif ISDEFINED("MyForm.Salutation")>
						 '#MyForm.Salutation#',
					    </cfif>	
						 
				  		<cfif ISDEFINED("MyForm.IndexNo")>
				          <cfqueryparam value="#MyForm.IndexNo#"        cfsqltype="CF_SQL_CHAR" maxlength="20">,
						 </cfif> 
						
						<!--- core fields --->
						<cfqueryparam value="#MyForm.lastname#"         cfsqltype="CF_SQL_CHAR" maxlength="40">,
						<cfqueryparam value="#MyForm.firstname#"        cfsqltype="CF_SQL_CHAR" maxlength="30">, 						 	
						#DOB#,
						<cfqueryparam value="#MyForm.gender#"           cfsqltype="CF_SQL_CHAR" maxlength="10">, 	
						<cfqueryparam value="#MyForm.nationality#"      cfsqltype="CF_SQL_CHAR" maxlength="3">,
						
						<cfqueryparam value="#MyForm.maidenname#"       cfsqltype="CF_SQL_CHAR" maxlength="50">, 						  
					  			  
						<cfif url.entrymode eq "Extended">
							  '#MyForm.LastName2#',
							  '#MyForm.MiddleName#',
							  '#MyForm.MiddleName2#',			 	
							  <cfqueryparam value="#MyForm.BirthCity#"  cfsqltype="CF_SQL_CHAR" maxlength="50">,
						</cfif>	
						 		  
					    <cfqueryparam value="#MyForm.NationalityAdditional#" cfsqltype="CF_SQL_CHAR" maxlength="3">,		  
					    <cfqueryparam value="#url.applicantclass#"      cfsqltype="CF_SQL_CHAR" maxlength="2">,			 
					    '#SESSION.acc#',
			    	    '#SESSION.last#',		  
				  	    '#SESSION.first#',
					  
					    <cfif ISDEFINED("MyForm.Remarks")>
					       <cfqueryparam value="#MyForm.Remarks#"        cfsqltype="CF_SQL_CHAR" maxlength="400">,				
					    </cfif>	  
					    <cfqueryparam value="#MyForm.Reference#"         cfsqltype="CF_SQL_CHAR" maxlength="20">,
					    '#source#',
					    <cfqueryparam value="#MyForm.eMailAddress#"      cfsqltype="CF_SQL_CHAR" maxlength="50">,	
						<cfqueryparam value="#MyForm.MobileNumber#"      cfsqltype="CF_SQL_CHAR" maxlength="50">,	
						<cfqueryparam value="#MyForm.PhoneNumber#"       cfsqltype="CF_SQL_CHAR" maxlength="50">,		      
					    <cfqueryparam value="#MyForm.DocumentReference#" cfsqltype="CF_SQL_CHAR" maxlength="20">		
					  
					    <cfif ISDEFINED("MyForm.MaritalStatus")>
					  	 <cfif MyForm.MaritalStatus neq "">
					      ,<cfqueryparam value="#MyForm.MaritalStatus#" cfsqltype="CF_SQL_CHAR" maxlength="10">
						 <cfelse>
						 ,NULL
						 </cfif>
					    </cfif>
					  )
				  
			  </cfquery>	  
			 
			  <!--- ATTENTION in case of portal access 
			  this is taken care of as part of the login as this can be for a varient of reasons and submission --->
	  
		      <!--- Submit submission --->
				
			  <cfquery name="InsertSubmission" 
			     datasource="AppsSelection">
			  	   INSERT INTO ApplicantSubmission
				         	(PersonNo,
						 	ApplicantNo,
							SubmissionId,
				  		 	SubmissionDate, 
							SubmissionReference,
						 	ActionStatus,
						 	Source,				 	
						 	eMailAddress,
						 	LanguageId,
					 	 	OfficerUserId,
						 	OfficerLastName,
						 	OfficerFirstName,	
						 	Created)
			      	VALUES ('#PersonNo#',
					       	'#new#', 
							 '#MyForm.submissionid#',
				           	'#DateFormat(Now(),CLIENT.dateSQL)#',
							<cfqueryparam value="#MyForm.reference#"    cfsqltype="CF_SQL_CHAR" maxlength="20">,
						  	'0',
						  	'#Source#',				  	
						  	<cfqueryparam value="#MyForm.eMailAddress#" cfsqltype="CF_SQL_CHAR" maxlength="50">,	
							'001',
						  	'#SESSION.acc#',
				    	  	'#SESSION.last#',		  
					  	  	'#SESSION.first#',
						  	getDate())
			  </cfquery>
			  
			  </cftransaction>			
			  
			  <cfif url.scope eq "applicant">		
		 	 	  <cfset url.source = "Portal">
			  <cfelse>
			  	  <cfset url.source = "">
			  </cfif>	
			  			  		
			  <cfset inputform = "MyForm">
			  <cfset url.parent = "Miscellaneous">			  			  
			  <cfset url.applicantno = new>
			  <cfinclude template="../Topic/TopicSubmit.cfm">
			  
			  <!--- create customer profile in both workorder and materials for this entity --->
			  
			  <cfif myForm.mission neq "">
								  
				   <cfquery name="InsertCustomer" 
				     datasource="AppsSelection">
				  	   INSERT INTO WorkOrder.dbo.Customer
					         	(PersonNo,
							 	Mission,
								Reference,
					  		 	CustomerName, 					 		 	
							 	eMailAddress,		
								MobileNumber,	
								PhoneNumber,		 	
						 	 	OfficerUserId,
							 	OfficerLastName,
							 	OfficerFirstName,	
							 	Created)
				      	VALUES ('#LastNo.PersonNo#',
					       	'#MyForm.Mission#', 
							<cfqueryparam value="#MyForm.Reference#"     cfsqltype="CF_SQL_CHAR" maxlength="20">,
				           	'#MyForm.firstname# #MyForm.lastname#',				  		  	
						  	<cfqueryparam value="#MyForm.eMailAddress#"  cfsqltype="CF_SQL_CHAR" maxlength="50">,		
							<cfqueryparam value="#MyForm.MobileNumber#"  cfsqltype="CF_SQL_CHAR" maxlength="50">,	
							<cfqueryparam value="#MyForm.PhoneNumber#"   cfsqltype="CF_SQL_CHAR" maxlength="50">,			
						  	'#SESSION.acc#',
				    	  	'#SESSION.last#',		  
					  	  	'#SESSION.first#',
						  	getDate())
				  </cfquery>
				  
				   <cfquery name="InsertCustomer" 
				     datasource="AppsSelection">
				  	   INSERT INTO Materials.dbo.Customer
					         	(PersonNo,
							 	Mission,
								Reference,
					  		 	CustomerName, 	
								CustomerDOB,				 		 	
							 	eMailAddress,	
								MobileNumber,		
								PhoneNumber,			 	
						 	 	OfficerUserId,
							 	OfficerLastName,
							 	OfficerFirstName,	
							 	Created)
				      	VALUES ('#LastNo.PersonNo#',
					       	'#MyForm.Mission#', 
							<cfqueryparam value="#MyForm.Reference#"     cfsqltype="CF_SQL_CHAR" maxlength="20">,
				           	'#MyForm.firstname# #MyForm.lastname#',			
							#DOB#,	  		  	
						  	<cfqueryparam value="#MyForm.eMailAddress#"  cfsqltype="CF_SQL_CHAR" maxlength="50">,		
							<cfqueryparam value="#MyForm.MobileNumber#"  cfsqltype="CF_SQL_CHAR" maxlength="50">,		
							<cfqueryparam value="#MyForm.PhoneNumber#"   cfsqltype="CF_SQL_CHAR" maxlength="50">,				
						  	'#SESSION.acc#',
				    	  	'#SESSION.last#',		  
					  	  	'#SESSION.first#',
						  	getDate())
				  </cfquery>
			  		  
			  </cfif>			 
						
			<cfif url.scope eq "applicant">
				 
				  <cfif url.public neq "0">
				  		<cfset client.PersonNo    = PersonNo>
				  		<cfset client.ApplicantNo = new>
				  </cfif>						  
				  				  
				  <cfset link = "Roster/Candidate/Details/PHPView.cfm?id=#PersonNo#">
				  
				  <!--- generate the workflow and open action to complete --->
					
				  <cf_ActionListing 
					    EntityCode       = "Candidate"
						EntityClass      = "Standard"
						EntityGroup      = ""
						EntityStatus     = ""
						Show             = "No"				
						PersonNo         = "#PersonNo#"
						PersonEMail      = "#MyForm.EMailAddress#"
						ObjectReference  = "#PersonNo#"
						ObjectReference2 = "#MyForm.FirstName# #MyForm.LastName#"
						ObjectKey1       = "#PersonNo#"			    
						ObjectURL        = "#link#">						
						
				<cfif url.public neq "0">
																	
					<cfif CLIENT.LanguageId eq "ENG">		
							
						<table width="100%">
							<tr><td height="120"></td></tr>
							<tr><td align="center" class="labellarge">			  		 
					     
							 Thank you, your request under No: <cfoutput>#PersonNo#</cfoutput> for an account has been received. <br><br>
							 You will be contacted by e-Mail with your assigned account which allows you to record your profile and more.
							 			 
							 </td></tr>
						 </table>
					 
					 <cfelseif CLIENT.LanguageId eq "ESP">
					 
						 <table width="100%">
							<tr><td height="120"></td></tr>
							<tr><td align="center" class="labellarge">			  		 
					     
							 Gracias, su numero de requerimiento es el : <cfoutput>#PersonNo#</cfoutput>. Pronto le contactaremos para darle sus credenciales<br><br>
							 Usted sera contactado por correo con las mismas.
							 			 
							 </td></tr>
						 </table>
					 
					 
					 <cfelse>
					 
						 <table width="100%">
							<tr><td height="120"></td></tr>
							<tr><td align="center" class="labellarge">			  		 
					     
							 Thank you, your request under No: <cfoutput>#PersonNo#</cfoutput> for an account has been received. <br><br>
							 You will be contacted by e-Mail with your assigned account which allows you to record your profile and more.
							 			 
							 </td></tr>
						 </table>				 
					 
					 </cfif>

					 <cfset StructDelete(Session,"myForm")>	
					 
				 </cfif>	 	
				 	 
			<cfelse>
			
					<cfset StructDelete(Session,"myForm")>
										
					<cfoutput>
						<script>
							ShowCandidate('#PersonNo#')
							history.go()
						</script>
					</cfoutput>
		    </cfif>	 
			 	   
	  <cfelse>  
	  
		  <cfquery name="Submission" 
		   datasource="AppsSelection">
			    SELECT *
				FROM   ApplicantSubmission
				WHERE  ApplicantNo = <cfqueryparam value="#URL.ApplicantNo#" cfsqltype="CF_SQL_INTEGER" maxlength="10">
		  </cfquery>	
		  
		   <cfquery name="get" 
		   datasource="AppsSelection">
			    SELECT * 
				FROM   Applicant 		
			    WHERE  PersonNo = '#Submission.PersonNo#'
		  </cfquery>
		  
		   <cfif get.CandidateStatus eq "0">	     
	  
		  	   <cfif MyForm.DOB eq "">
			
			     <cfset DOB = "NULL">
				 
			   <cfelse>
			
			     <cfset dateValue = "">
			     <CF_DateConvert Value="#MyForm.DOB#">
			     <cfset DOB = dateValue>
				 
			   </cfif>
		   
		  </cfif> 
		  
		   <cfquery name="UpdateApplicant" 
		   datasource="AppsSelection">
		   
			UPDATE   Applicant 
			
			SET      <cfif ISDEFINED("MyForm.IndexNo")>
						 IndexNo                = '#MyForm.IndexNo#',				
					 </cfif>	 
					 
					 <cfif ISDEFINED("MyForm.Salutation")>
						 <cfif MyForm.Salutation neq "">
						 	Salutation =  '#MyForm.Salutation#',
						 <cfelse>	
						 	Salutation =  NULL,
						 </cfif>	
				     </cfif>	
									 				 
					 <cfif get.CandidateStatus eq "0">
						 <!--- core fields --->
						 LastName               = <cfqueryparam value="#MyForm.lastname#"          cfsqltype="CF_SQL_CHAR" maxlength="40">,
						 FirstName              = <cfqueryparam value="#MyForm.firstname#"         cfsqltype="CF_SQL_CHAR" maxlength="30">,
						 DOB                    = #DOB#,
						 Gender                 = <cfqueryparam value="#MyForm.Gender#"            cfsqltype="CF_SQL_CHAR" maxlength="6">,
						 Nationality            = <cfqueryparam value="#MyForm.nationality#"       cfsqltype="CF_SQL_CHAR" maxlength="6">,
						  <!--- core fields end --->
					 </cfif>	
					 
					 <cfif url.entrymode eq "Extended">						 				 				 
						 LastName2              = '#MyForm.LastName2#',				 
						 MiddleName             = '#MyForm.MiddleName#', 
						 MiddleName2            = '#MyForm.MiddleName2#', 				 
						 BirthCity              	= <cfqueryparam value="#MyForm.BirthCity#"     cfsqltype="CF_SQL_CHAR" maxlength="50">,				 
					 </cfif>
					 					 
					 MaidenName           		= <cfqueryparam value="#MyForm.maidenname#"        cfsqltype="CF_SQL_CHAR" maxlength="50">,				 
					 NationalityAdditional  	= <cfqueryparam value="#MyForm.NationalityAdditional#" cfsqltype="CF_SQL_CHAR" maxlength="3">,
					 eMailAddress           	= <cfqueryparam value="#MyForm.eMailAddress#"      cfsqltype="CF_SQL_CHAR" maxlength="50">,
					 MobileNumber           	= <cfqueryparam value="#MyForm.MobileNumber#"      cfsqltype="CF_SQL_CHAR" maxlength="50">
					 <cfif ISDEFINED("MyForm.Remarks")>
					 	,Remarks             	= <cfqueryparam value="#MyForm.Remarks#"           cfsqltype="CF_SQL_CHAR" maxlength="400">	
					 </cfif>	 
					
					 <cfif ISDEFINED("MyForm.MaritalStatus")>
						<cfif MyForm.MaritalStatus neq "">
							,MaritalStatus      = '#MyForm.MaritalStatus#'
						<cfelse>	
							,MaritalStatus      = NULL
						</cfif>	
					 </cfif>	 	
					
			WHERE    PersonNo = '#Submission.PersonNo#'
			
		  </cfquery>
		 
		  <cfset url.parent = "Miscellaneous">
		  
		  <cfset url.embed = "1">
		  
		  <cfif url.scope eq "applicant">		
		 	  <cfset url.source = "Portal">
		  <cfelse>
		  	  <cfset url.source = "">
		  </cfif>	  
		  <cfinclude template="../Topic/TopicSubmit.cfm">
		  	  	  
		  <cfset PersonNo = Submission.PersonNo>
		  
		  <cfif url.scope eq "applicant">
		  	  		  		  
		  	  <!--- we control the navigation at this moment --->
		  	    
			  <cf_Navigation Alias         = "AppsSelection"
							 TableName     = "ApplicantSubmission"
							 Object        = "Applicant"
							 ObjectId      = "No"
							 Group         = "#URL.TriggerGroup#"
							 Section       = "#URL.Section#"
							 SectionTable  = "Ref_ApplicantSection"
							 Id            = "#URL.ApplicantNo#"
							 Owner         = "#url.owner#"
							 BackEnable    = "1"
							 HomeEnable    = "1"
							 ResetEnable   = "1"
							 ResetDelete   = "0"	
							 ProcessEnable = "0"
							 NextEnable    = "1"
							 NextSubmit    = "1"
							 OpenDirect    = "1"
							 SetNext       = "1"
							 NextMode      = "1"
							 IconWidth 	   = "32"
				 			 IconHeight	   = "32">	
							 						 
		  </cfif>			 
		  
	</cfif> 
	
	<script>
	   try {
		document.getElementById('submitme').className = "hide"
		} catch(e) {}
	</script>

</cfif>