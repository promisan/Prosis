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
<cfparam name="URL.entryScope"    default="Backoffice">
<cfparam name="Form.LevelId"      default = "">
<cfparam name="url.applicantno"   default = "">
<cfparam name="base"              default = "#url.id#">

<cfquery name="Source" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Source 
	WHERE  Source = '#url.source#'
</cfquery>

<cfif url.entryScope eq "Backoffice">

	<cfinvoke component="Service.Access"  
 	method="roster" 
 	returnvariable="AccessRoster"
 	role="'AdminRoster','CandidateProfile'">
 	
<cfelse>

	<cfset AccessRoster = "ALL">

</cfif>

<cfquery name="qCheckOwnerSection" 
datasource="appsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ApplicantSectionOwner
	WHERE    Owner = '#URL.Owner#'
	AND      Code  = '#URL.Section#' 
</cfquery>

<cfif qCheckOwnerSection.recordcount eq 0>
	<cfset AccessLevelEdit = "2">
<cfelse>	
	<cfset AccessLevelEdit = qCheckOwnerSection.AccessLevelEdit>
</cfif>	

<cfset mode = "read">

<cfif Source.operational eq "1" and Source.allowedit eq "1">
			
 	<cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">
				
		<cfif AccessLevelEdit eq "2">
		
			<cfset mode = "edit">
		
		</cfif>
		
	</cfif>	

</cfif>

<cftransaction>

	<cfparam name="Form.FieldId" default="">
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.ExperienceStart#">
	<cfset start = dateValue>
	
	<cfset end   = "NULL">
	<cfif trim(Form.ExperienceEnd) neq "">
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.ExperienceEnd#">
		<cfset end   = dateValue>
		
		<cfif end lt start>
		   <cf_tl id="You entere an incorrect period" var="1">
		   <cfset msg1 = lt_text>
		   <cf_tl id="the end date lies before the start date"  var="1">
		   <cfset msg2 = lt_text>
		   
		   <cfoutput>
		
			   <script language="JavaScript">			   
				   alert("#msg1# /n/n #msg2#!")		  				  				   
			   </script>
		   
		   </cfoutput>			
		   <cfabort>
		</cfif>
		
	</cfif>
	
	<cfset class = "">
	
	<cfif Form.OrganizationClass neq "">
	
		<cfquery name="Class" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		     SELECT *
			 FROM   Ref_Experience
			 WHERE  ExperienceFieldId = '#Form.OrganizationClass#'
		</cfquery>	
		
		<cfset class = Class.Description>
		
	</cfif>	
	
	<!--- verify if a submission record exists --->
			
	<cfif URL.ID eq ""> 
		
		<cfif url.applicantno eq "">
			<cfinclude template="../SubmissionSubmit.cfm">
		<cfelse>
			<cfset appno = url.applicantno>
		</cfif>
	
	<cfelse>
	
	 <cfquery name="Verify" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		     SELECT ApplicantNo
			 FROM   ApplicantBackground
			 WHERE  ExperienceId = '#URL.ID#'
		</cfquery>	
		
		<cfset appno = Verify.ApplicantNo>
	
	</cfif>	
	
	
	 
	<cfif URL.ID eq "">			<!--- insert mode --->
						
		<cf_assignId>					
		<cfset ExperienceUID = rowguid>  <!--- save new id if needed for details --->
				
		<cfquery name="InsertBackground" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO ApplicantBackground
	            (ApplicantNo,
				 ExperienceID,
				 ExperienceCategory,
				 ExperienceDescription,
				 ExperienceStart,
				 ExperienceEnd,
				 <cfif Form.ExperienceType eq "Employment">
				   SupervisorName,
				   OrganizationEMail,
				   StaffSupervised,
				 </cfif>
				 OrganizationName,
				 OrganizationClass,
				 OrganizationCountry,
				 OrganizationCity,
				 OrganizationAddress,
				 Status,				
				 Updated,
			 	 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
	      VALUES ('#AppNo#',
		  		  '#RowGuid#',
		          '#Form.ExperienceType#', 
			      '#Form.ExperienceDescription#', 
			      #start#,
			      #end#,
			      <cfif Form.ExperienceType eq "Employment">
				     '#Form.Supervisor#',
					 '#Form.Email#',
				     '#Form.StaffSupervised#',
			      </cfif>
			      '#Form.OrganizationName#', 
			      '#Class#', 
			      '#Form.OrganizationCountry#', 
				  '#Form.OrganizationCity#',
				  '#Form.OrganizationAddress#',
			      '5',				 
			      getDate(),
	              '#SESSION.acc#',
	    	      '#SESSION.last#',		  
		  	      '#SESSION.first#',
			      getdate())
		</cfquery>
		
		<cfset url.id = rowguid>
	
	<cfelse>
	
		<cfset ExperienceUID = URL.ID>
	
		<cfquery name="UpdateBackground" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		     UPDATE ApplicantBackground
				SET <cfif mode eq "edit">
					OrganizationName      = '#Form.OrganizationName#',
					ExperienceDescription = '#Form.ExperienceDescription#',
					OrganizationCountry   = '#Form.OrganizationCountry#',
					</cfif>					
					ExperienceStart       = #start#,
					ExperienceEnd         = #end#,
					<cfif Form.ExperienceType eq "Employment">
						 SupervisorName    = '#Form.Supervisor#',
						 OrganizationEMail = '#Form.EMail#',
						 StaffSupervised   = '#Form.StaffSupervised#',
					</cfif>					
					OrganizationClass     = '#Class#',					
					OrganizationCity      = '#Form.OrganizationCity#',
					OrganizationAddress   = '#Form.OrganizationAddress#',
					Status                = '0',
					Updated               = getDate(),
				 	OfficerUserId         = '#SESSION.acc#',
					OfficerLastName       = '#SESSION.last#',
					OfficerFirstName      = '#SESSION.first#'
			  WHERE ExperienceId          = '#URL.ID#'	
			  		      
		</cfquery>

	</cfif>
	
	<cfif Form.ExperienceType eq "Employment">
	
	<!--- populate contact information --->
	
	<cfquery name="clearBackground" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 DELETE ApplicantBackgroundContact
			 WHERE  ApplicantNo = '#appno#'
			 AND    ExperienceId = '#url.id#'		  
	</cfquery>
	
	<cfloop index="itm" from="1" to="3">
	 
	 	<cfset contactclass     = evaluate("Form.ContactClass_#itm#")>
		<cfset contactReference = evaluate("Form.ContactReference_#itm#")>
		<cfset contactCallSign  = evaluate("Form.ContactCallSign_#itm#")>
		
		<cfif contactReference neq "">		
		
			<cfquery name="InsertBackground" 
			 datasource="AppsSelection" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 INSERT INTO ApplicantBackgroundContact
				            (ApplicantNo,
							 ExperienceId,
							 ContactSerialNo,
							 ContactClass,						 
							 ContactReference,
							 ContactCallSign,
						 	 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
			      VALUES ('#AppNo#',
				  		  '#URL.ID#',
				          '#itm#', 				  
					      '#contactclass#', 
						  '#contactReference#',
						  '#contactCallSign#',			     
			              '#SESSION.acc#',
			    	      '#SESSION.last#',		  
				  	      '#SESSION.first#')
			</cfquery>
				
		</cfif>
			 
	</cfloop>
	
 </cfif>	
			
 <!--- now handle details --->
	
 <cfif Form.ExperienceType eq "Employment">
  
	<cfquery name="Detail" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  Topic, Description, Question
			FROM    Ref_Topic
			WHERE   Parent      = 'Experience'
			AND     Source      = '#url.source#'
			AND     ValueClass  = 'Memo'
			AND     Operational = 1 
	</cfquery>		
		
	<cfloop query = "Detail">
		
		<cfparam name="Form.DT#Topic#" default="">
		
		<cfset TopicDetail = Evaluate("Form.DT" & #Topic#)>
		<cfset UpdateDetail = "Insert">
			
		<cfif URL.ID neq "">
		
				<cfquery name="DetailExists" 
				 datasource="AppsSelection" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT ExperienceID 
				 FROM   ApplicantBackgroundDetail
				 WHERE  ExperienceId = '#ExperienceUID#'
				 AND    ApplicantNo  = #AppNo#
				 AND    Topic        = '#Detail.Topic#'
				</cfquery>
				
				<cfif DetailExists.RecordCount neq "0">
					<cfset UpdateDetail = "Update">
				</cfif> 
				
		</cfif>
			
		<cfif UpdateDetail eq "Insert" and TopicDetail neq "">
		
			<cfquery name="InsertBackgroundDetail" 
			 datasource="AppsSelection" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			     INSERT INTO ApplicantBackgroundDetail
			         (ApplicantNo,
						 ExperienceID,
						 Topic,
						 TopicValue,
					 	 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName,	
						 Created)
			      VALUES ('#AppNo#',
					   '#ExperienceUID#',
					   '#Detail.Topic#',
					   '#TopicDetail#',
			           '#SESSION.acc#',
			    	   '#SESSION.last#',		  
				  	   '#SESSION.first#',
					   '#DateFormat(Now(),CLIENT.DateSQL)#')
			</cfquery>	   				   
			
		<cfelse>
		
			<cfquery name="InsertBackgroundDetail" 
				 datasource="AppsSelection" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
			       UPDATE  ApplicantBackgroundDetail
					SET	   TopicValue        = '#TopicDetail#',
					 	   OfficerUserId     = '#SESSION.acc#',
						   OfficerLastName   = '#SESSION.last#',		
						   OfficerFirstName  = '#SESSION.first#',	
						   Created           = getDate()
				   WHERE   ExperienceId      = '#ExperienceUID#'
				   AND     ApplicantNo       = #AppNo#
				   AND     Topic             = '#Detail.Topic#'
			</cfquery>	   				   										
		
		</cfif>
	
	</cfloop>	
			
</cfif>
		
		<cfquery name="Clear" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			UPDATE ApplicantBackgroundField
			SET    Status = '9'
			WHERE  ExperienceId = '#ExperienceUID#' 
		</cfquery>
	
		<!--- add background fields level, geo, exp after identifying the assigned serialNo --->
				
		<cfif URL.Mode eq "1">
		     <!--- extended entry --->
			<cfif base eq "">
				<cfset suf = "">	
			<cfelse> 
				<cfset suf = replaceNoCase(ExperienceUID,"-","","ALL")>	
			</cfif>
			<cfparam name="form.fieldid_#suf#" default="">	
			<cfset fields = evaluate("form.fieldid_#suf#")>
			
		     <cfset lst = "#Form.LevelId#,#fields#,#Form.OrganizationClass#">
		<cfelse>
			 <cfset lst = "#Form.LevelId#,#Form.OrganizationClass#">
		</cfif>	 
						 
		<cfloop index="Item" 
		        list="#lst#" 
		        delimiters="' ,">
											
			<cfquery name="Check" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				SELECT   ApplicantNo
				FROM     ApplicantBackgroundField
				WHERE    ApplicantNo       = '#AppNo#'
				AND      ExperienceId      = '#ExperienceUID#'
				AND      ExperienceFieldId = '#Left(Item,10)#'
				
			</cfquery>
						
			<cfif Check.recordCount eq "0">
			
				<cftry>
					<cfquery name="InsertExperience" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					INSERT INTO ApplicantBackgroundField 
					         (ApplicantNo,
							 ExperienceId,
							 ExperienceFieldId,
							 Status,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					  VALUES ('#AppNo#', 
					          '#ExperienceUID#', 
					      	  '#Left(Item,10)#',
							  '1',
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
				</cfquery>
					<cfcatch>
						<cfoutput>
						<cf_logpoint>
							#Item#
						</cf_logpoint>
						</cfoutput>						
					</cfcatch>
					
				</cftry>
					  
			<cfelse>
			
				<cfquery name="Clear" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					UPDATE ApplicantBackgroundField
					SET   Status = '1'
					WHERE ApplicantNo = '#AppNo#'
					AND   ExperienceId = '#ExperienceUID#'
					AND   ExperienceFieldId = '#Item#'
				</cfquery>
			
			</cfif>
									
		</cfloop>		
			
	<cfif URL.Mode eq "1">
	
		<cfquery name="Clear" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			DELETE FROM ApplicantBackgroundField
			WHERE  Status = '9' 
			AND    ApplicantNo = '#AppNo#'
			AND    ExperienceId = '#ExperienceUID#' 
		</cfquery>								
		
		<cfquery name="UpdateBackground" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	        UPDATE ApplicantBackground
		    SET    Status = '0'
		    WHERE  ExperienceId = '#ExperienceUID#'
	   </cfquery>
						
	<cfelse>
	
			<cfquery name="Clear" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				DELETE FROM ApplicantBackgroundClassTopic
				WHERE  ExperienceId = '#ExperienceUID#'
			</cfquery>
			
			<cfloop index="rec" from="1" to="#Form.Line#">
			
			<cfset class        = Evaluate("FORM.classId_" & #Rec#)>
			<cfparam name="FORM.topicid_#Rec#" default="">
			<cfset topic         = Evaluate("FORM.topicid_" & #Rec#)>
				
			<cfif topic neq "">
					
				<cfquery name="InsertTopic" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO dbo.[ApplicantBackgroundClassTopic] 
				         (ApplicantNo,
						  ExperienceId,
						  ExperienceClass,
						  FieldTopicId,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName,
						  Created)
				VALUES  ('#AppNo#', 
				         '#ExperienceUID#',
				      	 '#class#',
						 '#topic#',
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#',
						 getdate())
				  </cfquery>
					  
			</cfif>				  
			
			</cfloop>
		
	</cfif>	
	
</cftransaction>

<cfoutput>	
		
		<cfif url.entryScope eq "Backoffice">
			
			<script>
				ptoken.open("../General.cfm?source=#url.source#&ID=#PersonNo#&ID2=#URL.ID2#&Topic=#URL.Topic#","right")
			</script>
			
		<cfelseif URL.entryScope eq "Track">	
		
		   <script>
		       parent.history.go()
		       parent.ProsisUI.closeWindow('myexperience')			   
		   </script>
			
		<cfelseif URL.entryScope eq "Portal">
		
			<cfparam name="url.applicantno" default="0">
			<cfparam name="url.section" default="">
			<cfif url.id2 eq "Employment">
				<cfset template="Background.cfm">
			<cfelse>
				<cfset template="Education.cfm">
			</cfif>		
			
			<script>
				ptoken.location('#SESSION.root#/Roster/PHP/PHPEntry/Background/#template#?owner=#url.owner#&ID=#url.id#&entryScope=#url.entryScope#&applicantno=#url.applicantno#&section=#url.section#');
			</script>
		
		<cfelseif URL.entryScope eq "Validation">
		
			<script>			
				parent.validationsubmit()				
			</script>
							
		</cfif>	
		
</cfoutput>
	

