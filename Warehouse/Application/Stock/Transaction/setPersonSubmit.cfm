
<cfparam name="form.Mission"        default="">
<cfparam name="form.IndexNo"        default="">
<cfparam name="form.FirstName"      default="">
<cfparam name="form.LastName"       default="">
<cfparam name="form.Remarks"        default="">
<cfparam name="form.Gender"         default="M">
<cfparam name="form.Nationality"    default="USA">
<cfparam name="form.Reference"      default="">
<cfparam name="form.ReferenceDate"  default="01/01/2010">

<cfif Len(Form.LastName) lt 2>
	 <cf_alert message = "You have not entered a valid Last name">
	 <cfabort>
</cfif>

<cfif Len(Form.Remarks) gt 200>
	 <cf_alert message = "You entered remarks that exceeded the allowed size of 200 characters.">
	 <cfabort>
</cfif>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.ReferenceDate#">
<cfset ReferenceDate = dateValue>

<cfparam name="Form.IndexNo" default="">

<cfset IndexNo = replace(Form.IndexNo," ","","ALL")>

<!--- verify if a person record exist --->

<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Person
	WHERE   
	        (LastName = '#Form.LastName#'
			           AND FirstName = '#Form.FirstName#' 
					   AND OrganizationCategory = '#Form.OrganizationCategory#')	                                  
			                           OR 
			(Reference = '#Form.Reference#' AND Reference IS NOT NULL AND Reference != '')
			
</cfquery>

<cfparam name="Person.RecordCount" default="0">

<cfparam name="url.force" default="0">

<cfif Person.recordCount gt 0 AND ParameterExists(Form.Submit) and url.force eq "0">  
	
	<cfoutput>
	<cf_tl id ="Already exists" var ="1">	
	<script>
		alert("#lt_text#")
	</script>
	</cfoutput>

<CFELSE>

	<script>
		document.getElementById('submitPerson').className = "hide"
	</script>

   <cftransaction>

	   <cfquery name="AssignNo" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	    	 UPDATE Parameter 
			 SET    PersonNo = PersonNo+1
	   </cfquery>
	
	   <cfquery name="LastNo" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	    	 SELECT *
		     FROM Parameter
	    </cfquery>	 
	 
	 	<cftry>
	 
		  <cfquery name="InsertPerson" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     INSERT INTO Person 
			        (PersonNo,
					 <!---  IndexNo, --->
					 LastName,			 
					 FirstName,			 
					 FullName,		
					 <!--- BirthDate, --->
					 Gender,			 
					 Nationality,			 
					 Reference,
					 ReferenceDate,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Remarks,	
					 Source)
			      VALUES ('#LastNo.PersonNo#',
			          <!--- '#IndexNo#', --->
					  '#Form.LastName#',
					  '#Form.FirstName#',			
					  '#Form.FirstName# #Form.LastName#',			  
					  <!--- #DOB#, --->
					  '#Form.Gender#',
					  '#Form.Nationality#',			 
					  '#Form.Reference#',
					  #referencedate#,
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  '#Form.Remarks#',
					  '#Form.Mission#')
	       </cfquery>		     
		
		   <cfcatch>
			
				<cfquery name="InsertPerson" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     INSERT INTO Person 
				        (PersonNo,
						 <!--- IndexNo, --->
						 LastName,			 
						 FirstName,
						 <!--- FullName,  --->
						 <!--- BirthDate, --->
						 Gender,
						 Nationality,			 
						 Reference,
						 ReferenceDate,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName,	
						 Remarks,	
						 Source)
				      VALUES ('#LastNo.PersonNo#',
				          <!--- '#IndexNo#', --->
						  '#Form.LastName#',
						  '#Form.FirstName#',
						   <!--- '#Form.FirstName# #Form.LastName#', --->
						   <!--- #DOB#, --->
						  '#Form.Gender#',
						  '#Form.Nationality#',			 
						  '#Form.Reference#',
						   #referencedate#,
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#',
						  '#Form.Remarks#',
						  '#Form.Mission#')
			        </cfquery>
					
			</cfcatch>
		
		</cftry>
		
		</cftransaction>
		
		<!--- -------------------------- --->
		<!--- track action of the insert --->
		<!--- -------------------------- 
		
		<cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
		   method             = "ActionRecord" 
		   PersonNo           = "#LastNo.PersonNo#"
		   ActionCode1        = "1000"
		   Field1             = "Record"
		   ActionStatus       = "1">	
		   
		<!--- Generate workflows --->
		
		<cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
		   method             = "ActionWorkFlow" 
		   PersonNo           = "#LastNo.PersonNo#">					   		
		  
		<cfquery name="Parameter" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM Parameter
		</cfquery>  
				
		<cfif Parameter.EnablePersonGroup eq "1">
		  
			<cfquery name="Topic" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT  *
			  FROM  Ref_PersonGroup
			  WHERE Code IN (SELECT GroupCode FROM Ref_PersonGroupList)
			</cfquery>
			  
			 <cfloop query="topic">
			 
			 	 <cfparam name="Form.ListCode_#Code#" default="">
						        
			     <cfset ListCode  = Evaluate("Form.ListCode_#Code#")>
				 
				 <cfif listcode neq "">
							  
				   <cfquery name="Insert" 
					 datasource="AppsEmployee" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 INSERT INTO PersonGroup
						 (PersonNo,
						  GroupCode,
						  GroupListCode, 
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
					 VALUES
					 ('#LastNo.PersonNo#', '#Code#', '#ListCode#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')
					</cfquery>
					
				  </cfif>	
				   
			  </cfloop>	 
		  
		 </cfif>  
		 
		 <cfset pers = LastNo.PersonNo>		 
		 
		 <cfif Parameter.GenerateApplicant eq "1">
		 				 
			 <cfset mode = "Copy">
			 <cfparam name="Form.EmployeeNo" default="#LastNo.PersonNo#">
			 <cfparam name="Form.ApplicantClass" default="2">
			 <cfinclude template="../../../Roster/Candidate/Details/Applicant/ApplicantEntrySubmit.cfm">
					 		 
		 </cfif>

	--->
	
	<cfoutput>
	
	<script>
	 	 try { ColdFusion.Window.destroy('dialogperson',true)} catch(e){};
	     document.getElementById('personselect').value = '#form.reference#'
		 ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getPerson.cfm?search=#form.reference#','personbox')
	</script>
	
	</cfoutput>
		
</cfif>	

