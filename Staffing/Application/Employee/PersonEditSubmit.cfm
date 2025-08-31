<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="url.action" default="">

<cfif url.action eq "delete"> 

	<cftransaction>

	<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM EmployeeAction
		WHERE       ActionPersonNo = '#Form.PersonNo#'
	</cfquery>
	
	<cfquery name="Assignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM PersonAssignment
		WHERE       PersonNo = '#Form.PersonNo#'
	</cfquery>
	
	<cftry>
	
	<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Person
		WHERE       PersonNo = '#Form.PersonNo#'
	</cfquery>
	
	<cfcatch>
		 
			    <script>
			   	 alert("Was not able to remove this record. Please contact your administrator.")
				</script>
				<cfabort>
				
	</cfcatch>
	
	</cftry>
	
	<script LANGUAGE = "JavaScript">
		 
		 {	 
			parent.parent.parent.window.close()			    
		 }
	    
	</script>	
	
	</cftransaction>

<cfelseif url.action eq "update"> 
	
	<cfoutput>
	
		<cfif Form.EMailAddress neq "">
			
			<cfquery name="Check" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT EMailAddress 
				FROM   Person
				WHERE  Person.PersonNo != '#Form.PersonNo#'
				AND    EMailAddress     = '#Form.EMailAddress#'
			</cfquery>
			
			<cfif check.recordcount gte 1>
			     <script>
			    	 alert("You entered an eMail address (#Form.EMailAddress#) which is already in use.")
				 </script>
				 <cfabort>
			</cfif>
		
		</cfif>
				
		<cfquery name="Parameter" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM Parameter
		</cfquery>
		
		<cfif Form.IndexNo neq "">
			
			<cfquery name="Check" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Person
				WHERE  Person.PersonNo != '#Form.PersonNo#'
				AND    IndexNo = '#Form.IndexNo#'
			</cfquery>
			
			<cfif check.recordcount gte 1>
			
				<script>
			    	 alert("You entered an #Parameter.IndexNoName# (#Form.IndexNo#) which is already in use.")
				 </script>
				 <cfabort>
				
			</cfif>
		
		</cfif>
	</cfoutput>
	
	<cfif Len(Form.Remarks) gt 200>
		<script>
		  	 alert("You entered remarks that exceed the allowed length of 200 characters.")
		</script>
		<cfabort>		
	</cfif>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.BirthDate#">
	<cfset BDTE = dateValue>
	
	<cfset dateValue = "">
	<cfif Form.OrganizationStart neq ''>
	    <CF_DateConvert Value="#Form.OrganizationStart#">
	    <cfset STR = dateValue>
	<cfelse>
	    <cfset STR = 'NULL'>	   
	</cfif>		
	
	<cfparam name="Form.Gender" default="M">
	<cfparam name="Form.MaritalStatus" default="Single">
	
	<!--- verify is person record exist --->
	
	<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   top 1 *
		FROM     Person
		WHERE    Person.PersonNo = '#Form.PersonNo#'
	</cfquery>
	
	<cfif Person.recordCount eq 1> 	
	
		<cfif NOT IsDate(BDTE) OR (NOT IsDate(STR) AND STR neq "NULL")>
			<script>
				alert('Error in date format');
			</script>	
			<cfabort>
		</cfif>
		
		<cftransaction>
	
	     <cfquery name="UpdatePerson" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     UPDATE Person 
			 SET  IndexNo            = '#Form.IndexNo#', 
			      LastName           = '#Form.LastName#',
				  MaidenName         = '#Form.MaidenName#',
				  FirstName          = '#Form.FirstName#',
				  MiddleName         = '#Form.MiddleName#',
				  Bloodtype          = '#Form.Bloodtype#',
				  EMailAddress       = '#Form.EMailAddress#',
				  BirthDate          = #BDTE#,				 
				  PersonStatus       = '#Form.PersonStatus#',				
				  ParentOffice       = '#Form.ParentOffice#',
				  ParentOfficeLocation = '#Form.ParentLocation#',
				  Gender             = '#Form.Gender#',
				  Nationality        = '#Form.Nationality#',
				  MaritalStatus      = '#Form.MaritalStatus#',
				  BirthNationality   = '#Form.BirthNationality#',
				  BirthCity          = '#Form.BirthCity#',
				  OrganizationStart  = #STR#,
				  RecruitmentCountry = '#Form.RecruitmentCountry#',
				  RecruitmentCity    = '#Form.RecruitmentCity#',				 
				  Remarks            = '#Form.Remarks#',
				  Reference          = '#Form.Reference#',
				  ListingOrder       = '#Form.ListingOrder#'
			WHERE Person.PersonNo    = '#Form.PersonNo#'	 
	    </cfquery>
		 
		<!--- --------------------------------------------- ---> 
		<!--- -------------track action of the edit-------- --->
		<!--- --------------------------------------------- --->		
		
		<cfset oldbirth = dateformat(Person.BirthDate, CLIENT.DateFormatShow)>
		<cfset newbirth = dateformat(BDTE, CLIENT.DateFormatShow)>
									
		<cfif Person.LastName neq Form.LastName>
		
			   <cfparam name="Form.LastNameEffective" default="">
			   <cfparam name="Form.LastNameRemarks"   default="">
			   									  			  			
				<cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
				   method             = "ActionRecord" 
				   PersonNo           = "#Form.PersonNo#"			  
				   ActionStatus       = "0" 
				 			   
				   ActionCode1         = "1001"
				   Field1             = "LastName"
				   Field1New          = "#Form.LastName#"
				   Field1Old          = "#Person.LastName#"
				   Field1Effective    = "#Form.LastNameEffective#"
				   Field1Description  = "#Form.LastNameRemarks#"/>		
			   
		</cfif>
		
		<cfif Person.FirstName neq Form.FirstName>
		
			  <cfparam name="Form.FirstNameEffective" default="">
			  <cfparam name="Form.FirstNameRemarks"   default="">
		
			  <cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
				   method             = "ActionRecord" 
				   PersonNo           = "#Form.PersonNo#"			  
				   ActionStatus       = "0" 			
				   ActionCode1         = "1001"
				   Field1             = "FirstName"
				   Field1New          = "#Form.FirstName#"
				   Field1Old          = "#Person.FirstName#"
				   Field1Effective    = "#Form.FirstNameEffective#"
				   Field1Description  = "#Form.FirstNameRemarks#"/>		
		
		</cfif>
		
		<cfif Person.Nationality neq Form.Nationality>
		
			  <cfparam name="Form.NationalityEffective" default="">
			  <cfparam name="Form.NationalityRemarks"   default="">	
		
			  <cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
				   method             = "ActionRecord" 
				   PersonNo           = "#Form.PersonNo#"			  
				   ActionStatus       = "0" 								   
				   ActionCode1        = "1003"
				   Field1             = "Nationality"
				   Field1New          = "#Form.Nationality#"
				   Field1Old          = "#Person.Nationality#"
				   Field1Effective    = "#Form.NationalityEffective#"
				   Field1Description  = "#Form.NationalityRemarks#"/>			
		
		</cfif>
		
		<cfquery name="getAction" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		  FROM     Ref_Action
		  WHERE    ActionCode = '1004'
		  AND      Operational = 1			
		</cfquery>		
		
		<cfif getAction.operational eq "1">
		
			<cfif Person.eMailAddress neq Form.eMailAddress>
			
			      <cfparam name="Form.eMailAddressEffective" default="">
				  <cfparam name="Form.eMailAddressRemarks"   default="">			
			
				  <cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
					   method             = "ActionRecord" 
					   PersonNo           = "#Form.PersonNo#"			  
					   ActionStatus       = "0" 								   
					   ActionCode1        = "1004"
					   Field1             = "eMailAddress"
					   Field1New          = "#Form.eMailAddress#"
					   Field1Old          = "#Person.eMailAddress#"
					   Field1Effective    = "#Form.eMailAddressEffective#"
					   Field1Description  = "#Form.eMailAddressRemarks#"/>	
			
			
			</cfif>
		
		</cfif>		
		
		<cfif dateformat(Person.BirthDate,client.dateSQL) neq dateformat(BDTE,client.dateSQL)>
			
				 <cfparam name="Form.BirthdateEffective" default="">
				 <cfparam name="Form.BirthdateRemarks"   default="">	
						
				 <cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
				   method             = "ActionRecord" 
				   PersonNo           = "#Form.PersonNo#"			  
				   ActionStatus       = "0" 								   
				   ActionCode1        = "1002"
			 	   Field1             = "BirthDate"			   
				   Field1New          = "#dateformat(BDTE,client.dateFormatShow)#"
				   Field1Old          = "#dateformat(Person.BirthDate,client.dateFormatShow)#"
				   Field1Effective    = "#Form.BirthdateEffective#"
				   Field1Description  = "#Form.BirthdateRemarks#"/>		
				  		
		</cfif>	
						
		<cfquery name="Topic" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		  FROM    Ref_PersonGroup
		  WHERE   Code IN (SELECT GroupCode 
		                   FROM   Ref_PersonGroupList)
		  AND     Context = 'Person'
		 
		  <cfif getAdministrator("*") eq "0">
		  		  	
		  AND   Code IN (SELECT GroupCode 
		                 FROM   Ref_PersonGroupRole						
						 WHERE  Role IN (SELECT DISTINCT Role 
		                                 FROM   Organization.dbo.OrganizationAuthorization
										 WHERE  UserAccount = '#SESSION.acc#')
						)	
						 			
		  </cfif>	
		  
		    AND   Code IN (SELECT GroupCode
		                 FROM   Ref_PersonGroupOwner				
						 WHERE  Owner IN (SELECT MissionOwner
						                  FROM   Organization.dbo.Ref_Mission
										  WHERE  Mission IN (SELECT DISTINCT P.Mission 
										                     FROM   PersonAssignment PA, Position P 
														     WHERE  PA.PositionNo = P.PositionNo
														     AND    PA.PersonNo = '#Form.PersonNo#')
										 )		
						)									
		  AND Operational = 1							 
								 
		</cfquery>
		  
		<cfloop query="topic">
					   
			   <cfquery name="Check" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *  
					FROM   PersonGroup 
					WHERE  PersonNo = '#Form.PersonNo#'
					AND    GroupCode = '#Code#'
			   </cfquery>
			   			   
		       <cfquery name="Prior" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   	SELECT  Description
					FROM    Ref_PersonGroupList
					WHERE   GroupCode     = '#code#' 
					AND     GroupListCode = '#Check.GroupListCode#' 
			   </cfquery>
						   	
			   <cfset ListCode  = Evaluate("Form.ListCode_#Code#")>
			   <cfparam name="Form.#code#Effective" default="">
			   <cfparam name="Form.#code#Remarks"   default="">
			   
			   <cfset Effective = Evaluate("Form.#code#Effective")>
			   <cfset Memo      = Evaluate("Form.#code#Remarks")>
				
			   <cfif actionCode neq "" and Effective neq "">		   			  
				   
				   <cfif effective neq "">
					   <cfset dateValue = "">
					   <CF_DateConvert Value="#DateFormat(effective,CLIENT.DateFormatShow)#">
					   <cfset EFF = dateValue>
				   <cfelse>
				       <cfset EFF = "NULL">	   
				   </cfif>	
				   
				   <cfif isDate(eff)>				   
				   		<!--- FINE --->			   
				   <cfelse>
					   	<cfset eff = "NULL">				   
				   </cfif>
				   
			   <cfelse>
			   
			   	   <cfset EFF = "NULL">	   			   
			   
			   </cfif>
			   
			   <cfif listCode neq "">
			   
				   <cfif Check.recordcount eq "0">
							  
					   <cfquery name="Insert" 
						 datasource="AppsEmployee" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							 INSERT INTO PersonGroup
								 (PersonNo,
								  GroupCode,
								  GroupListCode, 
								  <cfif eff neq "NULL">
								  DateEffective,
								  </cfif>
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName)
							 VALUES
								 ('#Form.PersonNo#', 
								  '#Code#', 
								  '#ListCode#', 
								  <cfif eff neq "NULL">
								  #eff#,
								  </cfif>
								  '#SESSION.acc#', 
								  '#SESSION.last#', 
								  '#SESSION.first#') 
						</cfquery>
					
					<cfelse>
					
					  <cfif eff neq "NULL">
									 			   					
						  <cfquery name="Update" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								UPDATE PersonGroup
								SET    GroupListCode = '#ListCode#',
								       DateEffective = #eff#
								WHERE  PersonNo      = '#Form.PersonNo#'
								AND    GroupCode     = '#Code#'
						   </cfquery>			
					   
					   <cfelse>
					   
						    <cfquery name="Update" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								UPDATE PersonGroup
								SET    GroupListCode = '#ListCode#'
								WHERE  PersonNo      = '#Form.PersonNo#'
								AND    GroupCode     = '#Code#'
						   </cfquery>		
					   
					   </cfif>
																
						<cfif ActionCode neq "">
						
							<cfquery name="check" 
								datasource="AppsEmployee" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT * 
									FROM   Ref_Action
									WHERE  ActionCode = '#ActionCode#'							
							</cfquery>		
							
							<cfif check.operational eq "1">				
															
								<cfquery name="New" 
								datasource="AppsEmployee" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								   	SELECT  Description
									FROM    Ref_PersonGroupList
									WHERE   GroupCode     = '#code#' 
									AND     GroupListCode = '#ListCode#'
							    </cfquery>
																
								<cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
								   method             = "ActionRecord" 
								   PersonNo           = "#Form.PersonNo#"			  
								   ActionStatus       = "0" <!--- confirmed irreversable --->
								   ActionDescription  = "#Memo#"				   
								   ActionCode1        = "#ActionCode#"
								   Field1             = "#code#"
								   Field1Effective    = "#Effective#"
								   Field1New          = "#New.Description#"
								   Field1Old          = "#Prior.Description#"
								   Field1Description  = "#Memo#">	
							   
							 </cfif>
						 
						 </cfif>
				 
				    </cfif> 
				 
			   </cfif>	   
				  				   
		  </cfloop>
		  
		  </cftransaction>	
		  
		  <!--- Generate workflows --->
		
		   <cfinvoke component = "Service.Process.Employee.PersonnelAction"  
		   method              = "ActionWorkFlow" 
		   PersonNo            = "#Form.PersonNo#">		
		   
		  <cf_verifyOperational module = "Accounting" Warning = "No">
				
		  <cfif operational eq "1">
		  
		  	<cfquery name="ResetTopic" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM PersonGLedger
				WHERE  PersonNo = '#Form.PersonNo#'
			</cfquery>
			
			<cfquery name="Gledger" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			     SELECT *
			     FROM   Ref_AreaGLedger		
			</cfquery>
			
			<cfloop query="GLedger">
			
			   <cfparam name="Form.#Area#" default="">			
			   <cfset account  = Evaluate("Form.#Area#")>
			   
			   <cfif account neq "">
						  
				   <cfquery name="Insert" 
					 datasource="AppsEmployee" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 INSERT INTO PersonGLedger
							 (PersonNo,Area,GLAccount)
					 VALUES  ('#Form.PersonNo#', '#Area#', '#account#')
					</cfquery>
				
				</cfif>
			
			</cfloop>	
					
		  </cfif>	
		  	  
		  <cfquery name="UpdatePerson" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     UPDATE Applicant 
				 SET    IndexNo     = '#Form.IndexNo#'
				 WHERE  EmployeeNo  = '#Form.PersonNo#'	 
		    </cfquery>
		  		  
	</cfif>	  
	
	<script>
	
	    try {	
			parent.parent.right.document.getElementById('personedit').click()
			parent.parent.ProsisUI.closeWindow('personedit',true)		 	 
 		 } catch(e) {}
		 
		 // added to support a full dialog instead of embedded screen on the right 
		 
		 try {	
			parent.document.getElementById('personedit').click()
			parent.ColdFusion.Window.destroy('personedit',true)		 	 
 		 } catch(e) {} 
		
	</script>	
	
</cfif>	

