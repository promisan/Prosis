<!--
    Copyright © 2025 Promisan

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

<!--- ----------------------- --->
<!--- -----ORGANIZATION----- --->
<!--- ---------------------- --->

<cf_insertRoles  Role="OrganizationActor"    	    Area="System"  
				 SystemModule="Organization"        SystemFunction="Organization actions"
				 OrgUnitLevel="All"      	        Parameter="Entity" 
				 Description="Organization actions" Memo="Role for processing unit actions or events">	

<cf_insertEntity Code="OrgAction"
	Description="Organization Event" 
	Role="OrganizationActor"	
	EntityTableName="Organization.dbo.OrganizationAction"
	EntityKeyField4="OrgUnitActionId"
	EntityAcronym="ORGA">	


<!--- -------------------- --->
<!--- -----SYSTEM--------- --->
<!--- -------------------- --->


<cf_insertRoles  Role="OrgUnitManager" 		Area="System"  
				 SystemModule="System" 		SystemFunction="User administration"
				 OrgUnitLevel="Parent"  	Description="Tree Role Manager" 
				 AccessLevels="4" 	    	AccessLevelLabel="READ,Tree 1,User 2,Support 3"				
				 Parameter="Owner"			Memo="Role for registering units as well as providing user admin and/or support to a tree/units">

<cf_insertRoles  Role="AdminUser"      		Area="System"  
				 SystemModule="System" 	    SystemFunction="User administration"
				 OrgUnitLevel="Global"  	Parameter="Owner" 
				 Description="User administrator"
				 Memo="Role for administering user accounts, groups and global roles">

<cf_insertRoles  Role="AdminSystem"    		Area="System"  
				 SystemModule="System" 		SystemFunction="System administration"
				 OrgUnitLevel="Global"  	Parameter="Owner" Description="System Manager"
				 Memo="Role for administering system information (modules, reports) and any module reference tables, example : <b>creation of a tree</b>">

<cf_insertRoles  Role="Support"    			Area="System"  
				 SystemModule="System" 		SystemFunction="System administration"
				 OrgUnitLevel="Global"  	Description="System Support Manager"
				 Memo="Role for used to provide full privilages to all system functions and features">

<cf_insertRoles  Role="ReportManager"    	  Area="System"  
				 SystemModule="System" 		  SystemFunction="System administration"
				 OrgUnitLevel="Global"  	  Parameter="Entity" 
				 Description="Report Manager" Memo="Role for deploying report">
	 

<!--- Development --->

<cf_insertRoles  Role="ModuleOfficer" 		Area="System"  
				 SystemModule="System" 		SystemFunction="Module Ticket Officer"
				 OrgUnitLevel="Tree"     	Parameter="Entity" 
				 Description="Module Ticket Officer" Memo="Role for Ticket Observations">

<cf_insertEntity Code="SysTicket"
	Description="System Observation Ticket" 
	Role="ModuleOfficer"
	PersonClass="Employee"
    PersonReference="Requester"
	EntityTableName="Control.dbo.Observation"
	EntityKeyField4="ObservationId"
	EntityAcronym="TIC">	
	
	<cfquery name="Apps" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT Code,Description
		FROM  Ref_Application		
		WHERE Usage != 'System' AND Operational = 1
	</cfquery>				  	
	
	<cfloop query="Apps">
		     				  
		<!--- used for granting access by server --->	  				  
		<cf_insertEntityGroup  
		      EntityCode="SysTicket"   
	          EntityGroup="#Code#"
              EntityGroupName="#Description#">		  		
					
	</cfloop>					

<cf_insertRoles  Role="CMOfficer" 			Area="System"  
				 SystemModule="System" 		SystemFunction="CM Officer"
				 OrgUnitLevel="Global"  	Parameter="Entity" 
				 Description="CM Officer" 	Memo="Role for System Change Management">	

<cf_insertEntity Code="SysChange"
	Description="System Amendment" 
	Role="CMOfficer"
	PersonClass="Employee"
    PersonReference="Requester"
	EntityTableName="Control.dbo.Observation"
	EntityKeyField4="ObservationId"
	EntityAcronym="CHG">	
		
<cf_insertEntity Code="AuthRequest"
	Description="System Authorization" 
	Role="CMOfficer"
	PersonClass="Employee"
    PersonReference="Requester"
	EntityTableName="System.dbo.UserRequest"
	EntityKeyField4="RequestId"
	EntityAcronym="AUT">	
	
	<cfquery name="Application" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT Code,Description
		FROM   Ref_Application		
	</cfquery>				  	
	
	<cfloop query="Apps">
		     				  
		<!--- used for granting access by server --->	  				  
		<cf_insertEntityGroup  
		      EntityCode="AuthRequest"   
	          EntityGroup="#Code#"
              EntityGroupName="#Description#">		  		
					
	</cfloop>					
	
	<cf_insertEntityDocument
          Code="AuthRequest"   
		  DocumentType="script" 
		  DocumentCode="S001"
		  DocumentDescription="Apply access"
		  DocumentTemplate="System/AccessRequest/Workflow/ApplyAccess.cfm"
		  DocumentMode="Embed">		
		  
	<cf_insertEntityDocument
          Code="AuthRequest"   
		  DocumentType="script" 
		  DocumentCode="S002"
		  DocumentDescription="Revert access"
		  DocumentTemplate="System/AccessRequest/Workflow/RevertAccess.cfm"
		  DocumentMode="Embed">		
		  
	<cf_insertEntityDocument
          Code="AuthRequest"   
		  DocumentType="dialog" 
		  DocumentCode="D001"
		  DocumentDescription="Apply Role access"
		  DocumentTemplate="System/AccessRequest/Workflow/FormRoleAccess.cfm"
		  DocumentMode="ajax">		
		  
  <cf_insertEntityClass  
				  Code="AuthRequest"   
	              Class="NewAccount" 
	     		  Description="New User Account and Access">			
				  
  <cf_insertEntityClass  
				  Code="AuthRequest"   
	              Class="EditAccess" 
	     		  Description="Edit User Access">		

<cf_insertRoles  Role="ReleaseManager" 			Area="System"  
				 SystemModule="System" 			SystemFunction="System administration"
				 OrgUnitLevel="Global"  		Parameter="Entity" 
				 Description="Release Manager" 	Memo="Role for release distribution">

<cf_insertEntity  Code="Release" 
	 Description="Release Distribution" 
	 Role="ReleaseManager"
	 PersonClass="Site"
	 PersonReference="Site Manager"
	 EntityTableName="Control.dbo.ParameterSiteVersion"
	 EntityKeyField4="VersionId"
	 EntityAcronym="REL"
	 StandardFlow="Yes">	
   
<!--- generate workflow classes and groups --->			  
				  
	<cfquery name="Site" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM ParameterSite
		WHERE ServerRole = 'Production'
	</cfquery>				  	
	
	<cfloop query="Site">
					  
			<!--- used for granting access by server --->	  				  
			<cf_insertEntityGroup  
			      EntityCode="Release"   
	              EntityGroup="#ApplicationServer#"
                  EntityGroupName="#ApplicationServer#">		  		
					
	</cfloop>			   
   
<cf_insertRoles  Role="ErrorManager"    		 Area="System"  
				 SystemModule="System" 			 SystemFunction="System administration"
				 OrgUnitLevel="Global"  		 Parameter="Entity" 
				 Description="Exception Manager" Memo="Role for reviewing exception or error messages">

<cf_insertEntity  Code="SysError" 
                  Description="System Exception/Error" 
				  Role="ErrorManager"
				  EntityTableName="System.dbo.UserError"
				  EntityKeyField4="ErrorId"
				  EntityAcronym="ERR"
				  StandardFlow="No">	
				  
	<!--- generate workflow classes and groups --->			  
				  
	<cfquery name="Host" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT HostServer
		FROM  UserError
		<!--- limit creation --->
		WHERE HostServer <> ''
		AND   Created > getDate() - 50
	</cfquery>				  	
	
	<cfloop query="Host">
	
	        <!--- used for creating a workflow per server --->	
			<cf_insertEntityClass  
			      Code="SysError"   
                  Class="#HostServer#" 
     			  Description="#HostServer#">	
				  
			<!--- used for granting access by server --->	  				  
			<cf_insertEntityGroup  
			      EntityCode="SysError"   
	              EntityGroup="#HostServer#"
                  EntityGroupName="#HostServer#">		  		
					
	</cfloop>								  
	
<!--- ------------------ --->
<!--- STRATEGIC PLANNING --->
<!--- ------------------ --->

<cf_verifyOperational module="Program" Warning="No">
<cfif Operational eq "1">

	
	<!--- added for donor contribution --->
	
	<cf_insertRoles   Role="ProgramOfficer"   			Area="Program Management"  
					  SystemModule="Program"    		SystemFunction="Program"
					  OrgUnitLevel="All"     			Description="Planning officer" 
					  Parameter = "ProgramClass"		Memo="Role for entering and/or editing program/project information"
					  ListingOrder = "1">
	
	<cf_insertRoles   Role="ProgramManager"   			Area="Program Management"  
					  SystemModule="Program" 			SystemFunction="Program Workflow"
					  OrgUnitLevel="All"  				Parameter="Entity" 
					  Description="Planning manager"  	Memo="Role for assigning access to different review/clearance steps which are defined by the customer"
					  ListingOrder="2">
	
	<cf_insertRoles   Role="ProgressOfficer"   			Area="Program Management"  
					  SystemModule="Program" 			SystemFunction="Program"
					  OrgUnitLevel="All"     			Description="Progress officer" 
					  Memo="Role for entering and/or editing program/projects activity progress"
					  ListingOrder = "3">
	
	<cf_insertRoles   Role="ProgramAuditor"   			Area="Program Management"  
					  SystemModule="Program" 			SystemFunction="Program"
					  OrgUnitLevel="All"  				Parameter="Indicator" 
					  Description="Program indicator auditor" 	Memo="Role for entering and updating program indicator measurements"
					  ListingOrder="4">
	
	<cf_insertRoles   Role="ContributionOfficer"   		Area="Program Management"  
					  SystemModule="Program" 			SystemFunction="Program"
					  OrgUnitLevel="All"     		    Description="Contributions officer" 
					  Memo="Role for entering and/or editing donor contributions"
					  ListingOrder="10">
	
	<cf_insertRoles   Role="ContributionManager"   		Area="Program Management"  
				      SystemModule="Program" 			SystemFunction="Program"
					  OrgUnitLevel="All"  				Parameter="Entity"   
					  Description="Contributions Manager" 	Memo="Role for processing donor contributions"
					  ListingOrder="11">	

	<cf_insertRoles   Role="BudgetOfficer"    			Area="Program Management"  
					  SystemModule="Program" 			SystemFunction="Program"
					  OrgUnitLevel="All"     			Description="Budget officer"  
					  Parameter="Edition" 				Memo="Role for entering and/or editing program/project allotment information"
					  ListingOrder="20">
	
	<cf_insertRoles   Role="BudgetManager"    			Area="Program Management"  
					  SystemModule="Program" 			SystemFunction="Program"
					  OrgUnitLevel="All"     			Description="Budget manager"  
					  Parameter="Edition" 				Memo="Role for clearing entered program/project allotment information"
					  ListingOrder="21">
					  
	<cf_insertRoles   Role="AdminProgram"     			Area="Program Management"  
					  SystemModule="Program" 			SystemFunction="System administration"
					  OrgUnitLevel="Global"  			Description="Program administrator" 
					  Memo="May update reference inforomation and has always access to all add/edit functions"
					  ListingOrder = "99">
	
	<cf_insertEntity  Code="EntDonor"   
	                  Description="Donor Contribution" 
					  Role="ContributionManager"
					  EntityTableName="Program.dbo.Contribution"
					  EntityKeyField4="ContributionId"					
					  ListingOrder="1"
					  EntityAcronym="CTD">
					  
	<cf_insertEntity  Code="EntTrench"   
	                  Description="Contribution Line" 
					  Role="ContributionManager"
					  EntityTableName="Program.dbo.ContributionLine"
					  EntityKeyField4="ContributionLineId"					
					  ListingOrder="2"
					  EntityAcronym="CTRE">		
					  
	<cf_insertEntity  Code="EntDonorEvent"   
	                  Description="Contribution Reporting Event" 
					  Role="ContributionManager"
					  EntityTableName="Program.dbo.ContributionEvent"
					  EntityKeyField4="ContributionEventId"					
					  ListingOrder="3"
					  EntityAcronym="CTDE">								  		  
			
	<cf_insertEntity  Code="EntProgram"   
	                  Description="Program Instantiation" 
					  Role="ProgramManager"
					  EntityTableName="Program.dbo.ProgramPeriod"
					  EntityKeyField1="ProgramCode"
					  EntityKeyField2="Period"
					  ListingOrder="4"
					  EntityAcronym="PRP">				  
			 
			  <cf_insertEntityClass  
				  Code="EntProgram"   
	              Class="Component" 
	     		  Description="Component">								  
				  
			 <cf_insertEntityClass  
				  Code="EntProgram"   
	              Class="Project" 
	     		  Description="Project">					  
					  
					  					  
	<cf_insertEntity  Code="EntProgramReview"   
	                  Description="Program Review" 
					  Role="ProgramManager"
					  EntityTableName="Program.dbo.ProgramPeriodReview"
					  EntityKeyField1="ProgramCode"
					  EntityKeyField4="ReviewId"
					  ListingOrder="5"
					  EntityAcronym="PRC">				  
					  
		    <cf_insertEntityDocument
				      Code="EntProgramReview"   
			          DocumentType="dialog" 
					  DocumentCode="fCategory"
					  DocumentDescription="Assign Comments to a category"
					  DocumentTemplate="ProgramREM/Application/Program/ReviewCycle/Workflow/CategoryDocument.cfm"
					  DocumentMode="Embed">		
					  
			 <cf_insertEntityDocument
				      Code="EntProgramReview"   
			          DocumentType="dialog" 
					  DocumentCode="fRequest"
					  DocumentDescription="Financials implications"
					  DocumentTemplate="ProgramREM/Application/Budget/Request/RequestResource.cfm"
					  DocumentMode="Embed">		
					  
			<cf_insertEntityDocument
			          Code="EntProgramReview"   
					  DocumentType="script" 
					  DocumentCode="S002"
					  DocumentDescription="Apply Clearance"
					  DocumentTemplate="ProgramREM/Application/Program/ReviewCycle/applyReviewCycleClear.cfm"
					  DocumentMode="Process">				  
					  
			<cf_insertEntityDocument
			          Code="EntProgramReview"   
					  DocumentType="script" 
					  DocumentCode="S001"
					  DocumentDescription="Apply Program Denial"
					  DocumentTemplate="ProgramREM/Application/Program/ReviewCycle/applyReviewCycleDeny.cfm"
					  DocumentMode="Process">				  		  
					  
	<cf_insertEntity  Code="EntProjectEvent"   
	                  Description="Project Event" 
					  Role="ProgramManager"
					  EntityTableName="Program.dbo.ProgramEventAction"
					  EntityKeyField1="ProgramCode"		
					  EntityKeyField2="ProgramEvent"					 
					  EntityKeyField4="Eventid"
					  ListingOrder="5"
					  EntityAcronym="PEV">					  
		  
	<cf_insertEntity  Code="EntBudgetAction"   
	                  Description="Budget Allotment Action" 
					  Role="ProgramManager"
					  EntityTableName="Program.dbo.ProgramAllotmentAction"
					  EntityKeyField4="ActionId"					 
					  ListingOrder="6"
					  EntityAcronym="ALL">			
					  
	<cf_insertEntityDocument
              Code="EntBudgetAction"   
			  DocumentType="script" 
			  DocumentCode="S001"
			  DocumentDescription="Revert Budget Action"
			  DocumentTemplate="ProgramREM/Application/Budget/Action/resetBudgetAction.cfm"
			  DocumentMode="Embed">		
			  
	<cf_insertEntity  Code="EntProgramAction"   
	                  Description="Program Activity" 
					  Role="ProgramManager"
					  EntityTableName="Program.dbo.ProgramActivity"
					  EntityKeyField1="ProgramCode"
					  EntityKeyField2="ActivityPeriod"
					  EntityKeyField3="ActivityId"
					  ListingOrder="7"
					  EntityAcronym="PAA">			  
			  
	<cf_insertEntity  Code="EntProgramActivity"   
	                  Description="Program Activity Milestone" 
					  Role="ProgramManager"
					  EntityTableName="Program.dbo.ProgramActivityOutput"
					  EntityKeyField1="ProgramCode"
					  EntityKeyField2="ActivityPeriod"
					  EntityKeyField3="OutputId"
					  ListingOrder="8"
					  EntityAcronym="PAO">		 
					  
	<cf_insertEntity  Code="EntIndicator" 
	                  Description="Indicator Audit Clearance" 
					  Role="ProgramManager"	
					  EntityTableName="Program.dbo.ProgramPeriodAudit"				
					  EntityKeyField4="ReviewId"
					  ListingOrder="7"
					  EntityAcronym="IND">
					  
</cfif>

<!--- --------------- --->
<!--- ---- EPAS ----- --->
<!--- --------------- --->

<cf_verifyOperational module="ePas" Warning="No">

<cfif Operational eq "1">

	<cf_insertEntity  Code="EntPAS" 
	                  Description="PAS preparation" 
					  Role="ProgramManager"	
					  PersonClass="Employee"
					  PersonReference="PAS Holder"
					  EntityTableName="ePas.dbo.Contract"				
					  EntityKeyField4="ContractId"
					  ListingOrder="20"
					  EntityAcronym="PAS">
							  
	<cf_insertEntity  Code="EntPASEvaluation" 
	                  Description="PAS evaluation" 
					  Role="ProgramManager"	
					  PersonClass="Employee"
					  PersonReference="PAS Holder"
					  EntityTableName="ePas.dbo.ContractEvaluation"				
					  EntityKeyField1="EvaluationType"
					  EntityKeyField4="ContractId"
					  ListingOrder="21"
					  EntityAcronym="PASE">

</cfif>


<!--- --------------- --->
<!--- HUMAN RESOURCES --->
<!--- --------------- --->

<cf_verifyOperational module="Attendance" Warning="No">

<cfif Operational eq "1">					  
	
	<!--- Attendance --->
	<cf_insertRoles   Role="LeaveApprover"   		Area="Human Resources"  
					  SystemModule="Attendance" 	SystemFunction="Leave"
					  OrgUnitLevel="All"  			Parameter="Entity"  
					  Group="LeaveType" 			Description="Leave approver"
					  Memo="Processes one or more leave clearance steps" >
	
	<cf_insertEntity  Code="EntLVE"   
	                  Description="Leave request" 
					  Role="LeaveApprover"
					  PersonClass="Employee"
					  PersonReference="Employee"
					  EntityTableName="Employee.dbo.PersonLeave"
					  EntityKeyField1="PersonNo"
					  EntityKeyField4="LeaveId"
					  EntityAcronym="LVE">
					  
	<cf_insertEntityDocument
          Code="EntLVE"   
		  DocumentType="dialog" 
		  DocumentCode="L001"
		  DocumentDescription="Show Leave Balance"
		  DocumentTemplate="Staffing/Application/Employee/Workflow/Leave/LeaveBalance.cfm"
		  DocumentMode="ajax">		
		  
	  <cf_insertEntityDocument
	      Code="EntLVE"   
		  DocumentType="dialog" 
		  DocumentCode="L002"
		  DocumentDescription="Manage Requisitions"
		  DocumentTemplate="Staffing/Application/Employee/Workflow/Requisition/Document.cfm"
		  DocumentMode="ajax">		
		  
	  <cf_insertEntityDocument
	      Code="EntLVE"   
		  DocumentType="dialog" 
		  DocumentCode="L003"
		  DocumentDescription="Home Leave Form"
		  DocumentTemplate="Custom/STL/HomeLeave/Document.cfm"
		  DocumentMode="ajax">			    				  
					  			  
					  
	<!--- disabled 	not needed			  
					  
	<cfquery name="Group" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_LeaveType 
		</cfquery>				  	
		
		<cfloop query="Group">
		
			<cf_insertEntityGroup  
			      EntityCode="EntLVE"   
	              EntityGroup="#Group.LeaveType#"
                  EntityGroupName="#Group.Description#">	
			
		</cfloop>		
		
		--->				  
	
	<cf_insertRoles   Role="TimeKeeper"      		Area="Human Resources"  
					  SystemModule="Attendance" 	SystemFunction="Attendance"
					  OrgUnitLevel="All"     		Description="Time keeper">
	
	<cf_insertRoles   Role="Warden"          		Area="Human Resources"  
					  SystemModule="Attendance" 	SystemFunction="Attendance"
					  OrgUnitLevel="All"   			Parameter="WardenZone"  
					  Description="Zone Warden">
	
</cfif>

<cf_verifyOperational module="TravelClaim" Warning="No">

<cfif Operational eq "1">		
	
	<!--- Travel claim --->
	<cf_insertRoles   Role="AdminTravelClaim"  		Area="Human Resources"  
					  SystemModule="TravelClaim" 	SystemFunction="System Administration"
					  OrgUnitLevel="Global"  		Description="Travel Claim Administrator" 
					  Parameter="Owner"				Memo="Has access to the Travel claim maintenance functions and Exchange routined">	
	
	<cf_insertRoles   Role="SSTravelClaim"     		Area="Human Resources"  
					  SystemModule="TravelClaim" 	SystemFunction="Travel claim"
					  OrgUnitLevel="Parent"  		Description="Travel Claim Actor" 
					  Parameter="Entity"			Memo="Performs a function in the travel claim review and certification process">
	
	<cf_insertRoles   Role="InqTravelClaim"     	Area="Human Resources"  
					  SystemModule="TravelClaim" 	SystemFunction="Travel claim"
					  OrgUnitLevel="Parent"  		Description="Travel Claim Manager" 
					  Parameter="Owner" 			Memo="Has on-line inquiry and report access">
	
	<cf_insertEntity  Code="EntClaim"   
	                  Description="Travel Claims" 
					  Role="SSTravelClaim"
					  PersonClass="Employee"
					  PersonReference="Claimant"
					  EntityTableName="TravelClaim.dbo.Claim"					 
					  EntityKeyField4="ClaimId"
					  EntityAcronym="CLM"
					  TemplateSearch="Payroll/Application/Claim/Inquiry/ClaimView.cfm"
					  ClassEntry="0">		
					  
	<cf_insertEntityClass  Code="EntClaim"   
	                       Class="ClaimAsIs" 
	     				   Description="Claim as requested">	
						   
	<cf_insertEntityClass  Code="EntClaim"   
	                       Class="ClaimEO" 
	     				   Description="Certification by EO">		
						   
	<cf_insertEntityClass  Code="EntClaim"   
	                       Class="ClaimManager" 
	     				   Description="Certification EO/Accounts">	
	
</cfif>	

<cf_verifyOperational module="Roster" Warning="No">

<cfif Operational eq "1">		
		
	<!--- Roster --->
	<cf_insertRoles   	Role="AdminRoster"      	Area="Human Resources"  
						SystemModule="Roster" 		SystemFunction="System Administration"
						OrgUnitLevel="Global"  		Description="Roster administrator" 
						Parameter="Owner" 			AccessLevels="2" 
						AccessLevelLabel="EDIT (1), ALL (2)"
						Memo="May update candidate profile and may grant processing rights for roster buckets to technical experts">
	
	<cf_insertEntity  Code="Candidate"   
	                  Description="Candidate Enrollment" 
					  Role="CandidateClear"
					  PersonClass="Candidate"
					  PersonReference="Candidate"
					  ListingOrder="1"
					  EntityTableName="Applicant.dbo.Applicant"
					  EntityKeyField1="PersonNo"
					  EntityAcronym="CAN">
					  
	<!--- workflow to review the completeness of the submission (optional) --->				  
					  
	<cf_insertEntity  Code="CanSubmission"   
	                  Description="Candidate Submission" 
					  Role="CandidateClear"
					  PersonClass="Candidate"
					  PersonReference="Applicant"
					  ListingOrder="2"
					  EntityTableName="Applicant.dbo.ApplicantSubmission"
					  EntityKeyField1="ApplicantNo"
					  EntityAcronym="CSUB">		
					  
	<!--- workflow to process a formally issued mail correspondence/broadcast --->						  
					  
	<cf_insertEntity  Code="CanMail"   
	                  Description="Candidate Mail" 
					  Role="RosterClear"
					  PersonClass="Candidate"
					  PersonReference="Applicant"
					  ListingOrder="3"
					  EntityTableName="Applicant.dbo.ApplicantMail"
					  EntityKeyField4="MailId"
					  EntityAcronym="CMAI">							  		  
	
	<cf_insertRoles   Role="FunctionAdmin"    		Area="Human Resources"  
					  SystemModule="Roster" 		SystemFunction="Roster"
					  OrgUnitLevel="Global"  		Description="Function Administrator" Group="OccGroup"
					  Parameter="Owner"				Memo="Maintain roster reference information and maintains/enters functions and buckets">
	
	<cf_insertRoles   Role="CandidateProfile" 		Area="Human Resources"  
					  SystemModule="Roster" 		SystemFunction="Roster"
					  OrgUnitLevel="Global"  		Description="Profile Manager" 
					  Parameter="Owner"				Memo="Can update candidates profile, ALL access will allow for deletion only">
	
	<cf_insertRoles   Role="EditionManager"     	Area="Human Resources"  
					  SystemModule="Roster" 		SystemFunction="Roster"
					  OrgUnitLevel="Global"  		Description="Roster Edition Workflow actor" 
					  Parameter="Entity"			Memo="May process one or more actions that follow a roster edition inception.">
	
	<cf_insertRoles   Role="RosterClear"   			Area="Human Resources"  
					  SystemModule="Roster" 		SystemFunction="Roster"
					  OrgUnitLevel="Global"  		Description="Roster Bucket Processor" 
					  Parameter="Owner" 			Group="OccGroup" 
					  AccessLevels="5" 				AccessLevelLabel="READ,Level 1,Level 2,Level 3,Level 4"
					  Memo="Has access to all buckets to define the candidate bucket status">
	
	<cf_insertRoles   Role="RosterAction"     		Area="Human Resources"  
					  SystemModule="Roster" 		SystemFunction="Roster"
					  OrgUnitLevel="Global"  		Description="Roster Bucket Workflow actor" 
					  Parameter="Entity" 			Group="OccGroup"
					  Memo="May process one or more actions that follow a roster action (like a TC).">
	
	<cf_insertRoles   Role="CandidateReview"  		Area="Human Resources"  
					  SystemModule="Roster" 		SystemFunction="Roster"
					  OrgUnitLevel="Global"  		Description="Candidate reviewer" 
					  Parameter="Entity" 			Group="Owner"
					  Memo="May process one or more actions related to an candidate clearance request (reference check, medical etc.).">
	
	<cf_insertRoles   Role="CandidateClear"  		Area="Human Resources"  
					  SystemModule="Roster" 		SystemFunction="Roster"
					  OrgUnitLevel="Global"  		Description="Candidate Event Clearer" 
					  Parameter="Entity" 			Group="Owner"
					  Memo="May process one or more actions related to an candidate event (do not hire etc.).">
	
	<cf_insertEntity  Code="RosterEdition"   
	                  Description="Roster Edition" 
					  Role="EditionManager"		
					  ListingOrder="3"			  
					  EntityTableName="Applicant.dbo.Ref_SubmissionEdition"
					  EntityKeyField1="SubmissionEdition"
					  EntityAcronym="SED">					  
					  
	<cf_insertEntityDocument
	                  Code="RosterEdition"   
					  DocumentType="script" 
					  DocumentCode="S001"
					  DocumentDescription="Publish Edition buckets and recruitment tracks"
					  DocumentTemplate="Roster/Maintenance/RosterEdition/Publish/PublishEdition.cfm"
					  DocumentMode="Embed">		

	 <cf_insertEntityDocument
				      Code="RosterEdition"   
			          DocumentType="dialog" 
					  DocumentCode="D001"
					  DocumentDescription="Prepare and view materials"
					  DocumentTemplate="Roster/Maintenance/RosterEdition/Materials/PublishView.cfm"
					  DocumentMode="ajax">	
					  						  
	<cf_insertEntityDocument
		      Code="RosterEdition"   
	          DocumentType="dialog" 
			  DocumentCode="D003"
			  DocumentDescription="Publish Text"
			  DocumentTemplate="Roster/Maintenance/RosterEdition/Materials/PublishText.cfm"
			  DocumentMode="Ajax">		
					  
	 <cf_insertEntityDocument
				      Code="RosterEdition"   
			          DocumentType="dialog" 
					  DocumentCode="D002"
					  DocumentDescription="Set recipients and trigger sending"
					  DocumentTemplate="Roster/Maintenance/RosterEdition/Recipient/RecipientView.cfm"
					  DocumentMode="ajax">							   					  				  
		
	<cf_insertEntity  Code="EntRosterClearance"   
	                  Description="Roster Bucket Status" 
					  Role="RosterAction"
					  PersonClass="Candidate"
					  PersonReference="Candidate"
					  ListingOrder="4"
					  EntityTableName="Applicant.dbo.ApplicantFunctionAction"
					  EntityKeyField1="RosterActionId"
					  EntityAcronym="ROS">
					  
					  
	<cfquery name="Group" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM OccGroup 
	</cfquery>				  	
		
	<cfloop query="Group">
		
			<cf_insertEntityGroup  
			      EntityCode="EntRosterClearance"   
	              EntityGroup="#Group.OccupationalGroup#"
                  EntityGroupName="#Group.Description#">	
			
	</cfloop>				  
					  
	<cf_insertEntity  Code="EntCandidate"   
	                  Description="Candidate Events" 
					  Role="CandidateClear"
					  ListingOrder="5"
					  PersonClass="Candidate"
					  PersonReference="Candidate"
					  EntityTableName="Applicant.dbo.ApplicantEvent"
					  EntityKeyField1="PersonNo"
					  EntityKeyField4="EventId"
					  EntityAcronym="ROC"
					  EnableCreate="1"
					  TemplateCreate="Roster/Candidate/Events/LocateCandidateView.cfm"
					  TemplateSearch="Roster/Candidate/Events/DocumentView.cfm"
					  TemplateListing="">	
					  
	<cfquery name="Group" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterOwner
		WHERE Operational = 1 
	</cfquery>				  	
		
	<cfloop query="Group">
		
			<cf_insertEntityGroup  
			      EntityCode="EntCandidate"   
	              EntityGroup="#Owner#"
                  EntityGroupName="#Owner#">	
			
	</cfloop>			  
					  
	<cfquery name="Class" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ReviewClass
	</cfquery>						  
	
	<cfloop query="Class">							  
					  
		<cf_insertEntity  Code="Rev#Code#"   
	                  Description="Check #Description#" 
					  Role="CandidateReview"
					  PersonClass="Candidate"
					  PersonReference="Candidate"
					  ListingOrder="7"
					  Operational="#operational#"
					  EntityTableName="Applicant.dbo.ApplicantReview"
					  EntityKeyField1="PersonNo"
					  EntityKeyField4="ReviewId"
					  EntityAcronym="#Code#">	
					  
		<cf_insertEntityDocument
	                  Code="Rev#Code#"   
					  DocumentType="script" 
					  DocumentCode="S001"
					  DocumentDescription="Review Rostered Status for Clearance"
					  DocumentTemplate="Tools/Process/EntityAction/RCL002_Submit.cfm"
					  DocumentMode="Embed">		
					  
		<cf_insertEntityDocument
	                  Code="Rev#Code#"   
					  DocumentType="script" 
					  DocumentCode="S002"
					  DocumentDescription="Review Rostered Status for Denial"
					  DocumentTemplate="Tools/Process/EntityAction/RCL002_Deny.cfm"
					  DocumentMode="Embed">				  				  
					  
		<cfquery name="Group" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterOwner
		WHERE Operational = 1
		</cfquery>				  	
		
		<cfset cde = "Rev#Code#">
		
		<cfloop query="Group">
		
				<cf_insertEntityGroup  
				      EntityCode="#cde#"   
		              EntityGroup="#Group.Owner#"
	                  EntityGroupName="#Group.Owner#">	
			
		</cfloop>
		
	</cfloop>	
	
</cfif>

<cf_verifyOperational module="Payroll" Warning="No">

<cfif Operational eq "1">			  	  				  			  
	
	<!--- Payroll --->
	<cf_insertRoles   Role="AdminPayroll"     	Area="Human Resources"    
					  SystemModule="Payroll" 	SystemFunction="System Administration"
					  OrgUnitLevel="Global"  	Description="Payroll administrator">
					  
	<cf_insertRoles   Role="PayrollStatement"     Area="Human Resources"  
					  SystemModule="Payroll" 	SystemFunction="Payroll"
					  OrgUnitLevel="Tree"     	Description="Payroll Statements to be issued">				  
	
	<cf_insertRoles   Role="PayrollOfficer"     Area="Human Resources"  
					  SystemModule="Payroll" 	SystemFunction="Payroll"
					  OrgUnitLevel="Parent"  	Description="Payroll Officer">
	
	<cf_insertRoles   Role="PayrollClear"     	Area="Human Resources"    
					  SystemModule="Attendance" SystemFunction="Payroll"
					  OrgUnitLevel="Parent"  	Description="Payroll clearer" 
					  Parameter="Entity">
		
	<cf_insertEntity 	
			 Code="EntOvertime"   
             Description="Employee overtime" 
		     Role="PayrollClear"
			 PersonClass="Employee"
			 PersonReference="Requester"
			 EntityTableName="Payroll.dbo.PersonOvertime"
			 EntityKeyField1="PersonNo"
			 EntityKeyField4="OvertimeId"
			 EntityAcronym="OVT"
			 EnableCreate="0"
			 TemplateCreate=""
			 TemplateListing="Payroll/Application/Overtime/OvertimeListingAction.cfm">	
					  
	 <cf_insertEntityClass  
			 Code="EntOvertime"   
	         Class="Payroll" 
	     	 Description="Payroll">		
				  
	 <cf_insertEntityClass  
			 Code="EntOvertime"   
	         Class="Compensation" 
	     	 Description="Compensation">	
							  				  				  
	
	<cf_insertEntity  
			Code="EntEntitlement"   
	        Description="Employee entitlements" 
			Role="PayrollClear"
			PersonClass="Employee"
			PersonReference="Requester"
			EntityTableName="Payroll.dbo.PersonEntitlement"
			EntityKeyField1="PersonNo"
			EntityKeyField4="EntitlementId"
			EntityAcronym="ENT"
			EnableCreate="0"
			TemplateCreate=""
			TemplateSearch=""
			TemplateListing="">	
					  
		<cf_insertEntityGroup  
			EntityCode="EntEntitlement"   
			EntityGroup="Individual"
		    EntityGroupName="Individual">		
						  
		<cf_insertEntityGroup  
			EntityCode="EntEntitlement"   
			EntityGroup="Rate"
		    EntityGroupName="Rate">		
				
		<cf_insertEntityDocument
            Code="EntEntitlement"   
			DocumentType="script" 
			    DocumentCode="sCommit"
			    DocumentDescription="Clear Entitlement action"
			    DocumentTemplate="Staffing/Application/Employee/Entitlement/EntitlementSubmitCommit.cfm"
			    DocumentMode="Embed">		
					  
		<cf_insertEntityDocument
                Code="EntEntitlement"   
			    DocumentType="script" 
			    DocumentCode="sDeny"
			    DocumentDescription="Deny Entitlement action"
			    DocumentStringList="Deny"
			    DocumentTemplate="Staffing/Application/Employee/Entitlement/EntitlementSubmitRevert.cfm"
			    DocumentMode="Embed">		
				
		<cf_insertEntityDocument
                Code="EntEntitlement"   
			    DocumentType="script" 
			    DocumentCode="sRevert"
			    DocumentDescription="Initiatlize Entitlement action"
			    DocumentStringList="Revert"
			    DocumentTemplate="Staffing/Application/Employee/Entitlement/EntitlementSubmitRevert.cfm"
			    DocumentMode="Embed">									  
					  
		<cf_insertEntity  Code="EntCost"   
	                  Description="Employee Costs" 
					  Role="PayrollClear"
					  PersonClass="Employee"
					  PersonReference="Requester"
					  EntityTableName="Payroll.dbo.PersonMiscellaneous"
					  EntityKeyField1="PersonNo"
					  EntityKeyField4="CostId"
					  EntityAcronym="ECST"
					  EnableCreate="0"
					  TemplateCreate=""
					  TemplateSearch=""
					  TemplateListing="">	
					  
			<cf_insertEntityDocument
	          Code="EntCost"   
			  DocumentType="dialog" 
			  DocumentCode="F001"
			  DocumentDescription="Set transactionamount and reason"
			  DocumentTemplate="Staffing/Application/Employee/Workflow/Cost/Document.cfm"
			  DocumentMode="Embed">			  
					  
			<cfquery name="Class" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT EntityClass
				FROM   Ref_PayrollItem
				WHERE  Source = 'Miscellaneous'	
			</cfquery>				  	
	
			<cfloop query="Class">
		
				<cf_insertEntityClass  
				      Code="EntCost"   
	                  Class="#EntityClass#" 
	     			  Description="#EntityClass#">		
						
			</cfloop>					  
							   
</cfif>

<cf_verifyOperational module="Staffing" Warning="No">
<cfif Operational eq "1">						   						   					   				  		  
	
	<!--- Staffing Actor Roles --->
	
	<cf_insertRoles   Role="HRAssistant"      	Area="Human Resources"   
					  SystemModule="Staffing" 	SystemFunction="Staffing" 
					  AccessLevels="3" 			AccessLevelLabel="READ, EDIT (1), ALL (2)"
					  OrgUnitLevel="All"        Description="Personnel Assistant" 
					  Parameter="PostType"      Memo="Registers assignments, index Nos, adjusts position level"
					  ListingOrder="1">
	
	<cf_insertRoles   Role="HRLoaner"        	Area="Human Resources"  
					  SystemModule="Staffing" 	SystemFunction="Staffing" 
					  AccessLevels="2" 			AccessLevelLabel="EDIT (1), ALL (2)"
					  OrgUnitLevel="All"  		Description="Post Loaner"      
					  Parameter="PostType" 		Memo="May loan positions once mandate has been locked"
					  ListingOrder="2">

	<cf_insertRoles   Role="HRLocator"       	Area="Human Resources"  
					  SystemModule="Staffing" 	SystemFunction="Staffing" 
					  AccessLevels="2" 			AccessLevelLabel="EDIT (1), ALL (2)"
					  OrgUnitLevel="All"  		Description="Post Locator"     
					  Parameter="PostType" 		Memo="May associate a position to a different location once the mandate has been locked"
					  ListingOrder="3">
	
	<cf_insertRoles   Role="HROfficer"      	Area="Human Resources"   
					  SystemModule="Staffing"   SystemFunction="Staffing" 
					  AccessLevels="3" 			AccessLevelLabel="READ, EDIT (1), ALL (2)"
					  OrgUnitLevel="All"  		Description="Personnel Officer" 
					  Parameter="PostType" 		Memo="In addition to personnel assistant rights approves assignments"
					  ListingOrder="4">
	
	<cf_insertRoles   Role="ContractManager"    Area="Human Resources"   
					  SystemModule="Staffing"   SystemFunction="Staffing" 
					  AccessLevels="2" 			AccessLevelLabel="EDIT (1), ALL (2)"
					  OrgUnitLevel="All"  		Description="Contract and PA Processor" 
					  Parameter="Entity" 		Memo="May Process one or more actions"
					  ListingOrder="7">
	
	<cf_insertRoles   Role="HRPosition"      	Area="Human Resources"  
					  SystemModule="Staffing" 	SystemFunction="Staffing" 
					  AccessLevels="2" 			AccessLevelLabel="EDIT (1), ALL (2)"
					  OrgUnitLevel="All"  		Description="Post Manager"      
					  Parameter="PostType" 		Memo="Builds and locks the structure and positions, adjusts if it is locked"
					  ListingOrder="10">	
	
	<!--- Staffing Inquiry Role --->
	
	<cf_insertRoles   Role="HRClassification"	Area="Human Resources"   
					  SystemModule="Staffing"   SystemFunction="Staffing" 
					  AccessLevels="2"   		AccessLevelLabel="EDIT (1), ALL (2)"
					  OrgUnitLevel="All"  		Description="Post classification"  
					  Parameter="Entity"  		Memo="May process one or more actions related to a position classification."
					  ListingOrder="11">

	<!--- Other roles --->
	<cf_insertRoles   Role="WardenOfficer"    	Area="Human Resources"   
					  SystemModule="Staffing" 	SystemFunction="Staffing" 
					  AccessLevels="2" 			AccessLevelLabel="EDIT (1), ALL (2)"
					  OrgUnitLevel="Parent"  	Description="Security and Warden Manager" 
					  Parameter="Entity" 		Memo="May Process one or more warden actions"
					  ListingOrder="15">	
	
	<cf_insertRoles   Role="HRInquiry"      	Area="Human Resources"   
					  SystemModule="Staffing" 	SystemFunction="Staffing" 
					  AccessLevels="1" 			AccessLevelLabel="READ"
					  OrgUnitLevel="All"  		Description="HR Inquiry" 
					  Parameter="PostType" 		Memo="Role to be configured for limited access to HR information"
					  ListingOrder="20">

	<cf_insertRoles   Role="HRAdmin"   			Area="Human Resources"  
					  SystemModule="Staffing" 	SystemFunction="Staffing"
					  OrgUnitLevel="Global"  	Description="Staffing Table Administrator" 
					  AccessLevels="3"			AccessLevelLabel="READ,EDIT (1), ALL (2)"
					  Memo="May update reference inforomation and has always access to all add/edit maintenance functions in HR"
					  ListingOrder = "99">
					  
	<cf_insertEntity  Code="PostClassification" 
	                  Description="Position Classification" 
					  Role="HRClassification"
					  EntityTableName="Employee.dbo.PositionParent"
					  EntityKeyField1="PositionParentId"
					  ListingOrder="0"
					  EntityAcronym="PCL">				  
	
		
	<!--- contract --->			 
		
	<cf_insertEntity  Code="PersonContract" 
	                  Description="Employee Contract" 
					  Role="ContractManager"
					  EntityTableName="Employee.dbo.PersonContract"
					  EntityKeyField1="PersonNo"
					  EntityKeyField4="ContractId"
					  ListingOrder="1"
					  EntityAcronym="SCTR">		
					  					  				  
			 <cf_insertEntityDocument
				      Code="PersonContract"   
			          DocumentType="dialog" 
					  DocumentCode="SAL"
					  DocumentDescription="Salary Recommendation"
					  DocumentTemplate="Staffing/Application/Employee/Workflow/ContractBackground/Document.cfm"
					  DocumentMode="Embed">							  
					  
			<cf_insertEntityDocument
	                  Code="PersonContract"   
					  DocumentType="script" 
					  DocumentCode="sCommit"
					  DocumentDescription="Clear contract personnel action"
					  DocumentTemplate="Staffing/Application/Employee/Contract/ContractEditSubmitCommit.cfm"
					  DocumentMode="Embed">		
					  
			<cf_insertEntityDocument
	                  Code="PersonContract"   
					  DocumentType="script" 
					  DocumentCode="sDeny"
					  DocumentDescription="Deny contract personnel action"
					  DocumentStringList="Deny"
					  DocumentTemplate="Staffing/Application/Employee/Contract/ContractEditSubmitRevert.cfm"
					  DocumentMode="Embed">			
					  
			<cf_insertEntityDocument
	                  Code="PersonContract"   
					  DocumentType="script" 
					  DocumentCode="sRevert"
					  DocumentDescription="Reinitialise contract personnel action"
					  DocumentStringList="Revert"
					  DocumentTemplate="Staffing/Application/Employee/Contract/ContractEditSubmitRevert.cfm"
					  DocumentMode="Embed">					  		  		  
					  
	<cf_insertEntity  Code="Assignment" 
	                  Description="Position Incumbency" 
					  Role="ContractManager"
					  EntityTableName="Employee.dbo.PersonAssignment"
					  EntityKeyField1="AssignmentNo"
					  ListingOrder="2"
					  EntityAcronym="ASS">	
					  
	<cf_insertEntity  Code="PersonRequest" 
	                  Description="Personal Request" 
					  Role="ContractManager"
					  EntityTableName="Employee.dbo.PersonRequest"					
					  EntityKeyField4="RequestId"
					  ListingOrder="3"
					  EntityAcronym="REV">								  
					  
	<cf_insertEntity  Code="PersonEvent" 
	                  Description="Employee Events" 
					  Role="ContractManager"
					  EntityTableName="Employee.dbo.PersonEvent"					
					  EntityKeyField4="EventId"
					  ListingOrder="4"
					  EntityAcronym="PEV">	
					  
	  <cf_insertEntityDocument
	      Code="PersonEvent"   
		  DocumentType="dialog" 
		  DocumentCode="L002"
		  DocumentDescription="Manage Requisitions"
		  DocumentTemplate="Staffing/Application/Employee/Workflow/Requisition/Document.cfm"
		  DocumentMode="ajax">						  	
					  
	<!--- general personnel action container --->	
	
	<cf_insertEntity  Code="PersonAction" 
	                  Description="Employee Record Actions" 
					  Role="ContractManager"
					  EntityTableName="Employee.dbo.EmployeeAction"
					  EntityKeyField1="ActionDocumentNo"	
					  EntityKeyField4="ActionSourceId"					
					  ListingOrder="5"
					  EntityAcronym="PACT">						  				  	
					  
	<cf_insertEntity  Code="PersonAddress" 
	                  Description="Address and Warden" 
					  Role="WardenOfficer"
					  EntityTableName="Employee.dbo.PersonAddress"
					  EntityKeyField1="PersonNo"
					  EntityKeyField4="AddressId"
					  ListingOrder="6"
					  EntityAcronym="ADD">					  					  
					  
	<!--- SPA --->					  
					  
	<cf_insertEntity  Code="PersonSPA" 
	                  Description="Special Post Allowance" 
					  Role="ContractManager"
					  EntityTableName="Employee.dbo.PersonContractAdjustment"
					  EntityKeyField1="PersonNo"
					  Listingorder="7"
					  EntityKeyField4="PostAdjustmentId"
					  EntityAcronym="SSPA">		
					  
	<cf_insertEntityDocument
	                  Code="PersonSPA"   
					  DocumentType="script" 
					  DocumentCode="sCommit"
					  DocumentDescription="Clear SPA action"
					  DocumentTemplate="Staffing/Application/Employee/Contract/Adjustment/ContractSPASubmitCommit.cfm"
					  DocumentMode="Embed">		
					  
			<cf_insertEntityDocument
	                  Code="PersonSPA"   
					  DocumentType="script" 
					  DocumentCode="sDeny"
					  DocumentDescription="Deny SPA action"
					  DocumentStringList="Deny"
					  DocumentTemplate="Staffing/Application/Employee/Contract/Adjustment/ContractSPASubmitRevert.cfm"
					  DocumentMode="Embed">			
					  
			<cf_insertEntityDocument
	                  Code="PersonSPA"   
					  DocumentType="script" 
					  DocumentCode="sRevert"
					  DocumentDescription="Reinitialise SPA"
					  DocumentStringList="Revert"
					  DocumentTemplate="Staffing/Application/Employee/Contract/Adjustment/ContractSPASubmitRevert.cfm"
					  DocumentMode="Embed">									  
					  
	<!--- HR Actions --->					  						  				  			  
					  
	<cf_insertEntity  Code="HRAction" 
	                  Description="Payroll Actions" 
					  Role="ContractManager"
					  EntityTableName="Employee.dbo.PersonAction"
					  EntityKeyField1="PersonNo"
					  EntityKeyField4="PersonActionId"
					  Listingorder="8"
					  EntityAcronym="HRAC">			
					  
	<!--- HR Actions --->					  						  				  			  
					  
	<cf_insertEntity  Code="FinalPayment" 
	                  Description="Process Final Payment" 
					  Role="ContractManager"
					  EntityTableName="Payroll.dbo.EmployeeSettlement"
					  EntityKeyField1="PersonNo"
					  EntityKeyField4="SettlementId"
					  Listingorder="9"
					  EntityAcronym="PFNL">		
					  
	<cf_insertEntityDocument
	                  Code="FinalPayment"   
					  DocumentType="script" 
					  DocumentCode="PFN1"
					  DocumentDescription="Process final payment calculation"
					  DocumentTemplate="Payroll/Application/Calculation/CalculationProcessExecuteWorkflow.cfm"
					  DocumentMode="Embed">						  				  			  
					  
	   <cf_insertEntityDocument
				      Code="FinalPayment"   
			          DocumentType="dialog" 
					  DocumentCode="fEntitlement"
					  DocumentDescription="Define separation grants"
					  DocumentTemplate="Payroll/Application/Payroll/FinalPayment/Document.cfm"
					  DocumentMode="Embed">						  
						  
	<!--- dependents --->				  
			  
	<cf_insertEntity  Code="Dependent" 
	                  Description="Dependent entitlements" 
					  Role="ContractManager"
					  EntityTableName="Employee.dbo.PersonDependent"
					  EntityKeyField1="PersonNo"
					  EntityKeyField4="DependentId"
					  Listingorder="10"
					  EntityAcronym="SDEP">		
					  
		<cf_insertEntityDocument
	                  Code="Dependent"   
					  DocumentType="script" 
					  DocumentCode="sDeny"
					  DocumentDescription="Deny dependent personnel action"
					  DocumentStringList="Deny"
					  DocumentTemplate="Staffing/Application/Employee/Dependents/DependentEditSubmitRevert.cfm"
					  DocumentMode="Embed">		
					  
		<cf_insertEntityDocument
	                  Code="Dependent"   
					  DocumentType="script" 
					  DocumentCode="sRevert"
					  DocumentDescription="Initialise dependent personnel action"
					  DocumentStringList="Revert"
					  DocumentTemplate="Staffing/Application/Employee/Dependents/DependentEditSubmitRevert.cfm"
					  DocumentMode="Embed">		
					  
		<cf_insertEntityDocument
	                  Code="Dependent"   
					  DocumentType="script" 
					  DocumentCode="sApprove"
					  DocumentDescription="Approval dependent action [1]"
					  DocumentStringList="Approve"
					  DocumentTemplate="Staffing/Application/Employee/Dependents/DependentEditSubmitApprove.cfm"
					  DocumentMode="Embed">		
					  
		<cf_insertEntityDocument
	                  Code="Dependent"   
					  DocumentType="script" 
					  DocumentCode="sConfirm"
					  DocumentDescription="Confirm dependent action [2]"
					  DocumentStringList="Confirm"
					  DocumentTemplate="Staffing/Application/Employee/Dependents/DependentEditSubmitApprove.cfm"
					  DocumentMode="Embed">		
					 
						  
	<cf_insertEntity  Code="PositionReview" 
	                  Description="Assignment Expiration review" 
					  Role="HRClassification"
					  EntityTableName="Employee.dbo.Position"
					  EntityKeyField1="PositionNo"
					  ListingOrder="10"
					  EntityAcronym="PORV">		
					 					  
				   <cf_insertEntityDocument
				      Code="PositionReview"   
			          DocumentType="dialog" 
					  DocumentCode="sEdition"
					  DocumentDescription="Assign Position to an edition"
					  DocumentTemplate="Roster/Maintenance/RosterEdition/Workflow/ApplyEdition/Document.cfm"
					  DocumentMode="Embed">		
		  
					  
	<!--- FPD specific to be removed			  
					  
	<cf_insertRoles   Role="HROpening"     
	        Area="Human Resources"  
			SystemModule="Staffing" 
			SystemFunction="Staffing"
	        OrgUnitLevel="Tree"  Description="Post opening manager"      
			Parameter="Entity" 
	        Memo="May process one or more actions related to a position opening.">				  
					  
	<cf_insertEntity  Code="PostOpening" 
	                  Description="Position Opening Manager" 
					  Role="HROpening"
					  EntityTableName="Employee.dbo.PositionOpening"
					  EntityKeyField4="PositionOpeningId"
					  ListingOrder="9"
					  EntityAcronym="POP">	
					  
	--->					  
					  
</cfif>		

<cf_verifyOperational module="Vacancy" Warning="No">

<cfif Operational eq "1">					  			  
	
	<!--- Vacancy --->
	<cf_insertRoles   Role="VacOfficer"      	Area="Human Resources"  
					  SystemModule="Vacancy" 	SystemFunction="Vacancy"
					  OrgUnitLevel="Parent"  	Description="Recruitment Officer"  
					  Parameter="Posttype"		Memo="May initiate a vactrack or submit remarks. PS. Vactrack step access defined through Vacprocess role">
	
	<cf_insertRoles   Role="VacProcess"      	Area="Human Resources"  
					  SystemModule="Vacancy" 	SystemFunction="Vacancy"
					  OrgUnitLevel="All"  		Description="Vactrack Step Processor"  
					  Parameter="Entity"		Memo="May process one or more workflow actions related to an vacancy/candidate action.">
	
	<cf_insertEntity  Code="VacDocument" 
	                  Description="Vacancy Processing" 
					  Role="VacProcess"
					  EntityParameter="PostType"				  
					  EntityTableName="Vacancy.dbo.Document"
					  EntityKeyField1="DocumentNo"
					  EntityAcronym="VAD">
					  
		<cfquery name="Group" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ParameterOwner  
			WHERE  Operational = 1 
		</cfquery>		
					
		<cfloop query="Group">
			
			<cf_insertEntityGroup  
			      EntityCode="VacDocument"   
		          EntityGroup="#Group.Owner#"
		          EntityGroupName="#Group.Owner#">	
			
		</cfloop>	
		
		<cfquery name="Domain" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT DISTINCT TextAreaDomain
			FROM   Ref_TextArea  			
		</cfquery>		
		
		<!--- add a ToR mode which does not require yet to define JO fields only requirements --->		
			
	    <cf_insertEntityDocument
		      Code="VacDocument"   
	          DocumentType="dialog" 
			  DocumentCode="VA"
			  DocumentDescription="Job Requirement"
			  DocumentTemplate="Vactrack/Application/Announcement/Document.cfm"
			  DocumentStringList="#ValueList(Domain.TextAreaDomain)#,ToR"
			  DocumentMode="Embed">		
			  
		  <cf_insertEntityDocument
		      Code="VacDocument"   
	          DocumentType="dialog" 
			  DocumentCode="ADD"
			  DocumentDescription="Identify candidates"
			  DocumentStringList="LIMITED,FULL"
			  DocumentTemplate="Vactrack/Application/Candidate/Identify/Document.cfm"			  			  
			  DocumentMode="Ajax">			  			
		
		<cf_insertEntityDocument
		      Code="VacDocument"   
	          DocumentType="dialog" 
			  DocumentCode="RS"
			  DocumentDescription="Roster Search"
			  DocumentStringList="ROSTER,ALL"
			  DocumentTemplate="javascript:rostersearch"
			  DocumentMode="PopUp">		
			  
		<!--- this form has 6 carefully defined stages to be supported, refer to the form for additional information --->
			  
		<cf_insertEntityDocument
		      Code="VacDocument"   
	          DocumentType="dialog" 
			  DocumentCode="REV"
			  DocumentDescription="Review Candidates"
			  DocumentTemplate="Vactrack/application/candidate/CandidateReview.cfm"
			  DocumentStringList="VIEW,MARK,TEST,SCORE,INTERVIEW,SELECT,INIT,CLOSE"
			  DocumentMode="Embed">		
			  
		<cf_insertEntityDocument
		      Code="VacDocument"   
	          DocumentType="session" 
			  DocumentCode="SES"
			  DocumentDescription="Test submission session"
			  DocumentTemplate="Vactrack/application/candidate/Interaction/TestForm.cfm"
			  DocumentStringList="BASIC,EXTENDED"
			  DocumentMode="Embed">			  	  	
		
		<cf_insertEntityDocument
		      Code="VacDocument"   
	          DocumentType="dialog" 
			  DocumentCode="ARR"
			  DocumentDescription="Arrival"
			  DocumentTemplate="javascript:arrival"
			  DocumentMode="PopUp">		
			  
		<cf_insertEntityDocument
	          Code="VacDocument"   
			  DocumentType="script" 
			  DocumentCode="S001"
			  DocumentDescription="Apply Rostering"
			  DocumentTemplate="Vactrack/application/WorkFlow/Roster/applyRoster.cfm"
			  DocumentMode="Process">		
			  
		<cf_insertEntityDocument
	          Code="VacDocument"   
			  DocumentType="script" 
			  DocumentCode="S009"
			  DocumentDescription="Close Track"
			  DocumentTemplate="Vactrack/application/WorkFlow/Arrival/closeTrack.cfm"
			  DocumentMode="Process">		  	  	
					  
		<cf_insertEntity  Code="VacCandidate" 
	          Description="Recruitment and Travel" 
			  Role="VacProcess"
			  EntityParameter="PostType"
			  PersonClass="Candidate"
			  PersonReference="Recruit"
			  EntityTableName="Vacancy.dbo.DocumentCandidate"
			  EntityKeyField1="DocumentNo"
			  EntityKeyField2="PersonNo"
			  EntityAcronym="VAP">	
					  
	 <cfloop query="Group">
			
			<cf_insertEntityGroup  
			      EntityCode="VacCandidate"   
		          EntityGroup="#Group.Owner#"
		          EntityGroupName="#Group.Owner#">	
			
	 </cfloop>	
							  
	 <cf_insertEntityDocument
		      Code="VacCandidate"   
	          DocumentType="dialog" 
			  DocumentCode="FRM"
			  DocumentDescription="Withdraw Reasons"
			  DocumentTemplate="Vactrack/Application/Workflow/Withdraw/Document.cfm"
			  DocumentMode="Embed">		
			  
	  <cf_insertEntityDocument
		      Code="VacCandidate"   
	          DocumentType="dialog" 
			  DocumentCode="CDO"
			  DocumentDescription="Candidate documents"
			  DocumentTemplate="Staffing/Application/Employee/Document/EmployeeDocumentContent.cfm"			  
			  DocumentMode="Embed">					  
			  
	 <cf_insertEntityDocument
		      Code="VacCandidate"   
	          DocumentType="dialog" 
			  DocumentCode="CTR"
			  DocumentDescription="Contract Preparation"
			  DocumentTemplate="Vactrack/Application/Workflow/Contract/Document.cfm"
			  DocumentMode="Embed">		
			  
	 <cf_insertEntityDocument
		      Code="VacCandidate"   
	          DocumentType="dialog" 
			  DocumentCode="BUD"
			  DocumentDescription="Mentor Assignment"
			  DocumentTemplate="Vactrack/Application/Workflow/Mentor/Document.cfm"
			  DocumentMode="Embed">				  		  				  		  
	
</cfif>
	
<!--- ------------------- --->
<!--- MATERIAL MANAGEMENT --->
<!--- ------------------- --->
				  
<cf_verifyOperational module="Procurement" Warning="No">
<cfif Operational eq "1">	

	<!--- Procurement --->
	<cf_insertRoles   Role="ProcReqEntry"   		Area="Material Management" 
					  SystemModule="Procurement" 	SystemFunction="Requisition"
					  OrgUnitLevel="All"   			Description="Requisition Creator" 
					  Parameter="EntryClass" 		Memo="Enter and submits procurement requisitions"
					  ListingOrder="1">

	<cf_insertRoles   Role="ProcReqDefine"    		Area="Material Management" 
					  SystemModule="Procurement" 	SystemFunction="Requisition"
					  OrgUnitLevel="All"   			Description="Requisition Definer" 
					  Parameter="Entity"     		Memo="Defines requisition content"
					  ListingOrder="2">
	
	<!--- --------------------------------- --->
	<!--- procurement request collaboration --->
	<!--- --------------------------------- --->

	<cf_insertRoles   Role="ProcReqReview"  		Area="Material Management" 
					  SystemModule="Procurement" 	SystemFunction="Requisition"
					  OrgUnitLevel="All"      		Description="Requisition Reviewer" 
					  Parameter="EntryClass" 		Memo="May clear prepared requisitions"
					  ListingOrder="3">
	
	<cf_insertEntity  Code="ProcReq"   
	                  Description="Request Preparation" 
					  Role="ProcReqDefine"
					  ListingOrder="1"
					  EntityTableName="Purchase.dbo.RequisitionLine"
					  EntityKeyField1="RequisitionNo"
					  EntityAcronym="PREQ">		
					  
	 <cf_insertEntityDocument
	      Code="ProcReq"   
          DocumentType="dialog" 
		  DocumentCode="FRM"
		  DocumentDescription="Requisition Fields"
		  DocumentTemplate="Procurement/Application/Requisition/Requisition/RequisitionEditForm.cfm"
		  DocumentMode="Embed">								  					  				  			  			  

	
	<cfsavecontent variable="script">
		SELECT L.RequisitionNo 
		FROM PurchaseLine AS L INNER JOIN RequisitionLine AS R ON L.RequisitionNo = R.RequisitionNo
		WHERE (R.RequisitionNo = '@key1') 	
	</cfsavecontent>
		
	<!--- ----------------------------- --->
	<!--- procurement execution request --->
	<!--- ----------------------------- --->
		
	<cf_insertEntity  Code="ProcExecution"   
	                  Description="Open Contract Request" 
					  Role="ProcReqDefine"
					  ListingOrder="5"
					  EntityTableName="Purchase.dbo.PurchaseExecutionRequest"
					  EntityKeyField4="RequestId"
					  EntityAcronym="PEXE">	
					  
	<!--- ------------------------------------ --->
	<!--- procurement requisition review flow --->
	<!--- ----------------------------------- --->				  	
		
	<cf_insertEntity  Code="ProcReview"   
	                  Description="Request Review" 
					  Role="ProcReqDefine"
					  ListingOrder="1"
					  EntityTableName="Purchase.dbo.RequisitionLine"
					  EntityKeyField1="RequisitionNo"
					  ConditionAlias="appsPurchase"
					  ConditionScript="#script#"
					  EntityAcronym="PREV">		
		  
	<cf_insertEntityDocument
			          Code="ProcReview"   
					  DocumentType="script" 
					  DocumentCode="S001"
					  DocumentDescription="Process Request"
					  DocumentTemplate="Procurement/Application/Requisition/Process/RequisitionClearSubmit.cfm"		 
					  DocumentMode="Embed">		
		  		  				  
	<cf_insertRoles   Role="ProcReqBudget" 		 	Area="Material Management" 
					  SystemModule="Procurement" 	SystemFunction="Requisition"
					  OrgUnitLevel="Parent"   		LevelOverwrite="0" 
					  Parameter="EntryClass"		Description="Requisition Approver Level 2"  
  					  ListingOrder="4"				Memo="Approve reviewed requisitions 2nd level">
								  
	<cf_insertRoles   Role="ProcReqApprove" 		Area="Material Management" 
					  SystemModule="Procurement" 	SystemFunction="Requisition"
					  OrgUnitLevel="Parent"   		LevelOverwrite="0" 
					  Parameter="EntryClass" 		Description="Requisition Approver Level 1"  
					  ListingOrder="5"				Memo="Approve reviewed requisitions 1st level">
	
	<cf_insertRoles   Role="ProcReqObject"  		Area="Material Management" 
					  SystemModule="Procurement"    SystemFunction="Requisition"
					  OrgUnitLevel="Parent"   		Description="Requisition Funding clearer" 
					  ListingOrder="6"				Memo="May clear funding of prepared requisitions">
	
	<!--- Note both roles below can be set to either parent or all : Parent is default and has been set for SAT Guatemala --->
	
	<cf_insertRoles   Role="ProcReqCertify" 				Area="Material Management" 
					  SystemModule="Procurement" 			SystemFunction="Requisition"
					  OrgUnitLevel="Parent"   				LevelOverwrite="0" 
					  Description="Requisition Certifier" 	Parameter="EntryClass" 
					  Memo="Certifies cleared requisitions"
					  ListingOrder="7">
	
	<cf_insertRoles   Role="ProcReqInquiry" 							Area="Material Management" 
					  SystemModule="Procurement" 						SystemFunction="Procurement"
					  OrgUnitLevel="All"   								Leveloverwrite="0" 
					  Parameter="Edition"								AccessLevels="1" 
					  Description="Requisition and Obligation Inquiry"  AccessLevelLabel="READ"
					  Memo="Review Budget Execution and General Inquiry"
					  ListingOrder="8">
	
	<cf_insertRoles   Role="ProcManager"    			Area="Material Management" 
					  SystemModule="Procurement" 		SystemFunction="Procurement"
					  OrgUnitLevel="Parent"   			Leveloverwrite="0" 
					  Parameter="EntryClass" 			Description="Procurement Supervisor" 
					  ListingOrder="9"					Memo="Tasks certified requisitions to a responsible buyer">
	
	<cf_insertRoles   Role="ProcApprover"   			Area="Material Management" 
					  SystemModule="Procurement" 		SystemFunction="Procurement"
					  OrgUnitLevel="Parent"   			Description="Purchase approver"  
					  Parameter="OrderClass" 			Memo="Approves a purchase order"
					  ListingOrder="10">
	
	<cf_insertRoles   Role="ProcJob"    				Area="Material Management" 
					  SystemModule="Procurement" 		SystemFunction="Invoice"
					  OrgUnitLevel="All"   				Parameter="Entity"
					  ListingOrder="11"					Description="Procurement Job Processing"  
					  Memo="Processes and clears procurement proposals (workflow)">
	
	<cf_insertRoles   Role="ProcRI"         			Area="Material Management" 
					  SystemModule="Procurement" 		SystemFunction="Inspection"
					  OrgUnitLevel="All"   				Description="Receipt and Inspection" Parameter="OrderClass" 
					  ListingOrder="12"					Memo="Register item/service receipt (ALL : clearance of receipt)">
	
	<cf_insertRoles   Role="ProcInvoice"    			Area="Material Management" 
					  SystemModule="Procurement" 		SystemFunction="Invoice"
					  OrgUnitLevel="Parent"   			Parameter="Entity"
					  Description="Invoice Processing"  Memo="Processes and clears invoices (workflow)"
					  ListingOrder="13">

	<cf_insertRoles   Role="ProcBuyer"      			Area="Material Management" 
					  SystemModule="Requisition" 		SystemFunction="Procurement"
					  OrgUnitLevel="Fly"      			Description="Procurement Buyer" 
					  ListingOrder = "14">
	
	<cf_insertRoles   Role="AdminProcurement"     		Area="Material Management"  
					  SystemModule="Procurement" 		SystemFunction="System administration"
					  OrgUnitLevel="Tree"  				GrantAllTrees = "1" 
					  ListingOrder="20"					Description="Procurement administrator"  
					  Memo="Role reserved to grant access to maintenace reference and lookup tables">

	
	<!--- disabled 25/10/2011
	<cf_insertRoles   Role="ProcAcc"        Area="Material Management" SystemModule="Procurement" SystemFunction="Procurement"
	OrgUnitLevel="Parent"   Description="Accountant"  Parameter="Fund" ListingOrder = "7" memo="Fund prepared purchase orders">
	
	<cf_insertRoles   Role="ProcAccManager" Area="Material Management" SystemModule="Procurement" SystemFunction="Procurement"
	OrgUnitLevel="Parent"   Description="Accountant Manager" Parameter="Fund" ListingOrder = "8" memo="Clear funding for purchase orders">
		
	--->
			
	<cfsavecontent variable="script">
		SELECT L.RequisitionNo 
		FROM   PurchaseLine AS L INNER JOIN RequisitionLine AS R ON L.RequisitionNo = R.RequisitionNo
		WHERE  R.JobNo = '@key1' 
		AND    (
		          (L.RequisitionNo IN (SELECT RequisitionNo FROM PurchaseLineReceipt WHERE  ActionStatus <> '9')) OR (L.PurchaseNo IN (SELECT PurchaseNo FROM InvoicePurchase))
			   )		
	</cfsavecontent>
	
	<cf_insertEntity Code="ProcJob" 
          Description="Procurement Job" 
		  Role="ProcJob"
		  ListingOrder="2"
		  EntityTableName="Purchase.dbo.Job"
		  EntityClassField="OrderClass"
		  EntityKeyField1="JobNo"
		  ConditionAlias="appsPurchase"
		  ConditionScript="#script#"
		  EntityAcronym="JOB">
					  
		<cf_insertEntityDocument
		      Code="ProcJob"   
	          DocumentType="dialog" 
			  DocumentCode="PUR"
			  DocumentDescription="Generate Purchase Order"
			  DocumentTemplate="javascript:purchase"
			  DocumentMode="PopUp">				  
		  				  				  
		<cfquery name="Class" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_OrderClass
				WHERE  PreparationMode != 'Direct'
		</cfquery>				  	
			
		<cfloop query="Class">		
			  <!--- used for creating a workflow per class : bidding etc. --->	
			  <cf_insertEntityClass  
				  Code="ProcJob"   
	              Class="#Code#" 
	     		  Description="#Description#">						
		</cfloop>	
			
		<cfquery name="Check" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE  Ref_EntityGroup
			SET     Operational = 0
			WHERE   EntityCode = 'ProcJob'
		</cfquery>		
				
		<cfquery name="Group" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_JobCategory
			</cfquery>				  	
			
			<cfloop query="Group">
				
				  <cf_insertEntityGroup  
					      EntityCode="ProcJob"   
			              EntityGroup="#Code#"
		                  EntityGroupName="#Description#">	
						 
			</cfloop>	
		
		<!--- standard dialog --->	
		
		<!--- Vendor --->
			
		<cf_insertEntityDocument
		      Code="ProcJob"   
	          DocumentType="dialog" 
			  DocumentCode="VDR"
			  DocumentDescription="Vendor registration"
			  DocumentTemplate="Procurement/Application/Quote/QuotationView/JobViewVendor.cfm"
			  DocumentMode="Ajax">	
			  
		<cf_insertEntityDocument
		      Code="ProcJob"   
	          DocumentType="dialog" 
			  DocumentCode="INS"
			  DocumentDescription="Vendor Insurance registration"
			  DocumentTemplate="Procurement/Application/Quote/Insurance/Insurance.cfm"
			  DocumentMode="Ajax">		
			  
			  
		<!--- HR --->	  	  
			  
		<cf_insertEntityDocument
		      Code="ProcJob"   
	          DocumentType="dialog" 
			  DocumentCode="RS"
			  DocumentDescription="Roster Search"
			  DocumentStringList="ROSTER,ALL"
			  DocumentTemplate="javascript:rostersearch"
			  DocumentMode="PopUp">				
			  
		<cf_insertEntityDocument
		      Code="ProcJob"   
	          DocumentType="dialog" 
			  DocumentCode="REV"
			  DocumentDescription="Review Candidates"
			  DocumentTemplate="Procurement/application/quote/candidates/CandidateReview.cfm"
			  DocumentStringList="MARK,INTERVIEW,SELECT"
			  DocumentMode="Embed">					  
				
			  
	<cf_insertEntity Code="ProcVendor" 
          Description="Request For Quotation" 
		  Role="ProcJob"
		  ListingOrder="3"		 
		  EntityTableName="Purchase.dbo.JobVendor"		 
		  EntityKeyField1="JobNo"
		  EntityKeyField2="OrgUnitVendor"
		  ConditionAlias="appsPurchase"
		  EntityAcronym="JVDR">	
		  
		  <cf_insertEntityDocument
		      Code="ProcVendor"   
	          DocumentType="report" 
			  DocumentCode="RFQ"
			  DocumentMode="PDF"
			  DocumentDescription="Invitation"
			  DocumentTemplate="Procurement/Application/Quote/Invitation/InvitationToBid.cfm">	
			  
		  <cf_insertEntityDocument
		      Code="ProcVendor"   
	          DocumentType="report" 
			  DocumentCode="RFQD"
			  DocumentMode="PDF"
			  DocumentDescription="Requested Information"
			  DocumentTemplate="Procurement/Application/Quote/Invitation/InvitationToBidData.cfm">	  	
			  
		<cfloop query="Group">
				
				  <cf_insertEntityGroup  
					      EntityCode="ProcVendor"   
			              EntityGroup="#Code#"
		                  EntityGroupName="#Description#">	
						 
			</cfloop>	  	    
			  		  					  
		  
	<!--- receipt processing --->	
		
	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  Ref_EntityGroup
		SET     Operational = 0
		WHERE   EntityCode = 'ProcReceipt'
	</cfquery>	
	
	<cf_insertEntity  Code="ProcReceipt" 
              Description="Receipt Processing" 
			  Role="ProcInvoice"
			  ListingOrder="4"
			  EntityTableName="Purchase.dbo.Receipt"
			  EntityClassField="EntityClass"
			  EntityKeyField1="ReceiptNo"
			  EntityAcronym="PRCT">
					  
	<cf_insertEntityDocument
              Code="ProcReceipt"   
			  DocumentType="script" 
			  DocumentCode="S001"
			  DocumentDescription="Post receipts"
			  DocumentTemplate="Procurement/Application/Receipt/ReceiptEntry/ReceiptPost.cfm"
			  DocumentMode="Embed">						  
					  
	<!---				  
					  
	<cfquery name="Class" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_OrderClass
		</cfquery>				  	
		
		<cfloop query="Class">
		
			  <!--- used for creating a workflow per class : bidding etc. --->	
				<cf_insertEntityClass  
			      Code="ProcReceipt"   
                  Class="#Code#" 
     			  Description="#Description#">	
					
		</cfloop>		
		
	--->			  
				 
	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  Ref_EntityGroup
		SET     Operational = 0
		WHERE   EntityCode = 'ProcInvoice'
	</cfquery>	
	
	<cf_insertEntity  Code="ProcInvoice" 
	        Description="Invoice Processing" 
			Role="ProcInvoice"
			ListingOrder="3"
			EntityTableName="Purchase.dbo.Invoice"
			EntityClassField="EntityClass"
			EntityKeyField4="InvoiceId"			
			TemplateListing="Procurement/Application/Invoice/InvoiceListingAction.cfm"
			EntityAcronym="INV">
					  
	<cfquery name="Group" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_OrderType
		WHERE   InvoiceWorkflow = '1'
		</cfquery>				  	
		
		<cfloop query="Group">
		
			<cf_insertEntityGroup  
			      EntityCode="ProcInvoice"   
	              EntityGroup="#Group.Code#"
                  EntityGroupName="#Group.Description#">	
			
		</cfloop>		  

</cfif>
		  
<cf_verifyOperational module="Warehouse" Warning="No">

<cfif Operational eq "1">	

    <cf_insertRoles   Role="WhsItem"      		Area="Material Management" 
					  SystemModule="Warehouse" 		SystemFunction="Warehouse"
					  OrgUnitLevel="All"   			Description="Process Item Classification" 
					  Parameter="Entity"			Memo="Initiates or Process item classification">	

	<cf_insertRoles   Role="WhsRequirement"   		Area="Material Management" 
					  SystemModule="Warehouse" 		SystemFunction="Warehouse"
					  OrgUnitLevel="All"   			Description="Process Item Authorization Requirement" 
					  Parameter="Entity"			Memo="Initiates or Clears requests for stock">	
		
	<cf_insertRoles   Role="WhsRequester"   		Area="Material Management" 
					  SystemModule="Warehouse" 		SystemFunction="Warehouse"
					  OrgUnitLevel="All"   			Description="Process Stock Request" 
					  Parameter="Entity"			Memo="Initiates or Clears requests for stock">	
			
	<!--- Warehouse legacy roles for amazon type of request picklist --->
	
	<cf_insertRoles   Role="ReqClear"     			Area="Material Management" 
					  SystemModule="Warehouse" 		SystemFunction="Warehouse"
					  OrgUnitLevel="All"        	Description="Requisition Clearer" 
					  Memo="May clear submitted supply request">
	
	<cf_insertRoles   Role="WhsClear"     			Area="Material Management" 
					  SystemModule="Warehouse" 		SystemFunction="Warehouse"
					  OrgUnitLevel="Warehouse"  	Description="Requisition Reviewer" 
					  Parameter="ItemCategory">
					  
	<cf_insertRoles   Role="WhsAssist"     			Area="Material Management" 
					  SystemModule="Warehouse" 		SystemFunction="Warehouse"
					  OrgUnitLevel="Warehouse"  	Description="Warehouse Assistant" 
					  Parameter="LocationClass">				  
	
	<!--- Warehouse roles for extended types of request --->
	
	 <cf_insertEntity  Code="WhsItem"   
	                  Description="Item Definition" 
					  Role="WhsItem"
					  EntityTableName="Materials.dbo.Item"
					  EntityKeyField1="ItemNo"
					  EntityAcronym="WIT"> 
	
	<cf_insertEntity  Code="WhsRequirement"   
	                  Description="Item Authorization" 
					  Role="WhsRequirement"
					  EntityTableName="Materials.dbo.ItemRequirement"
					  EntityKeyField4="RequirementId"
					  EntityAcronym="WRQ">	
	
	<cf_insertEntity  Code="WhsQuote"   
	                  Description="Request for Sale" 
					  Role="WhsRequester"
					  ConditionAlias="appsMaterials"					  
					  EntityTableName="Materials.dbo.CustomerRequest"
					  EntityKeyField1="RequestNo"
					  EntityAcronym="WQT">	
					  
	<!--- do not reset if we have a stockorder for one of the lines --->	  	
			  
	<cfsavecontent variable="script">
			 SELECT  * 
			 FROM    Request R INNER JOIN
                     RequestHeader H ON R.Mission = H.Mission AND R.Reference = H.Reference INNER JOIN
                     RequestTask RT ON R.RequestId = RT.RequestId INNER JOIN
                     TaskOrder S ON RT.StockOrderId = S.StockOrderId
			 WHERE   H.RequestHeaderId = '@key4'
	</cfsavecontent>				  
		
	<cf_insertEntity  Code="WhsRequest"   
	                  Description="Request for Stock" 
					  Role="WhsRequester"
					  ConditionAlias="appsMaterials"
					  ConditionScript="#script#"
					  EntityTableName="Materials.dbo.RequestHeader"
					  EntityKeyField4="RequestHeaderId"
					  EntityAcronym="WHR">	
					  
		<cf_insertEntityDocument
		      Code="WhsRequest"   
	          DocumentType="dialog" 
			  DocumentCode="REQ"
			  DocumentDescription="Stock Request History"
			  DocumentTemplate="Warehouse/Application/StockOrder/Request/Workflow/RequestHistory.cfm"
			  DocumentMode="Ajax">		
			  
		<cf_insertEntityDocument
		      Code="WhsRequest"   
	          DocumentType="dialog" 
			  DocumentCode="PRG"
			  DocumentDescription="Project Request History"
			  DocumentTemplate="Warehouse/Application/StockOrder/Request/Workflow/ProjectHistory.cfm"
			  DocumentMode="Ajax">	
			  			  			  
		<cf_insertEntityDocument
		      Code="WhsRequest"   
	          DocumentType="dialog" 
			  DocumentCode="TSK"			 
			  DocumentDescription="Taskorder Preparation"
			  DocumentTemplate="Warehouse/Application/StockOrder/Request/Create/DocumentLinesView.cfm"
			  DocumentMode="Ajax">		
			  
	   <!--- Warehouse roles for extended types of taskordering, do not reset if we have receipts already recorded --->
	
	<cfsavecontent variable="script">
		  SELECT     *
	      FROM      RequestTask RT INNER JOIN
	                TaskOrder S ON RT.StockOrderId = S.StockOrderId INNER JOIN
	                ItemTransaction T ON RT.RequestId = T.RequestId AND RT.TaskSerialNo = T.TaskSerialNo
	      WHERE     (RT.StockOrderId = '@key4')
	</cfsavecontent>
	
	<cf_insertEntity  Code="WhsTaskOrder"   
	                  Description="Stock Taskorder" 
					  Role="WhsRequester"
					  EntityTableName="Materials.dbo.TaskOrder"
					  EntityKeyField4="StockOrderId"
					  ConditionAlias="appsMaterials"
					  ConditionScript="#script#"
					  EntityAcronym="WHT">		
				
			  <cf_insertEntityClass  
				  Code="WhsTaskOrder"   
	              Class="Internal" 
	     		  Description="Internal Delivery">		
				  
			  <cf_insertEntityClass  
				  Code="WhsTaskOrder"   
	              Class="Purchase" 
	     		  Description="External Delivery">					  
				  
			  <cf_insertEntityDocument
			      Code="WhsTaskOrder"   
		          DocumentType="dialog" 
				  DocumentCode="TRF"
				  DocumentDescription="Stock Transfer"
				  DocumentTemplate="Warehouse/Application/Stock/Transfer/TransferView.cfm"
				  DocumentMode="Ajax">		
				  
			  <cf_insertEntityDocument
			      Code="WhsTaskOrder"   
		          DocumentType="dialog" 
				  DocumentCode="SEAL"
				  DocumentDescription="Fuel Seal Registration"
				  DocumentTemplate="Warehouse/Application/StockOrder/Task/ShipMent/TaskOrderWorkflowFuelDetails.cfm"
				  DocumentMode="Ajax">			  
				  
			  <cf_insertEntityDocument
			      Code="WhsTaskOrder"   
		          DocumentType="dialog" 
				  DocumentCode="RCT"
				  DocumentDescription="Stock Receipt"
				  DocumentTemplate="Warehouse/Application/StockOrder/Task/Process/TaskFormReceipt.cfm"
				  DocumentMode="Ajax">			  					
				  		  		  
	
	<cf_insertRoles   Role="WhsProcessor"   	Area="Material Management" 
					  SystemModule="Warehouse" 	SystemFunction="Warehouse"
					  OrgUnitLevel="All"   		Description="Stock Transaction Controller" 
					  Parameter="Entity"		Memo="Processes stock transactions (like unaccepted Variances)">			
		  
	<cf_insertEntity  Code="WhsTransaction"   
                Description="Stock Transaction" 
		  Role="WhsProcessor"
		  EntityTableName="Materials.dbo.ItemTransaction"
		  EntityKeyField4="TransactionId"
		  EntityAcronym="WHTR">		
			  
	    <cf_insertEntityDocument
	                Code="WhsTransaction"   
			  DocumentType="script" 
			  DocumentCode="sDeny"
			  DocumentDescription="Deny and revoke transaction"
			  DocumentStringList="Deny"
			  DocumentTemplate="Warehouse/Application/Stock/Batch/BatchDeleteScript.cfm"
			  DocumentMode="Embed">					  
		  
	<cf_insertEntity  Code="WhsInspection"   
                Description="Facility Inspection" 
		  Role="WhsProcessor"
		  EntityTableName="Materials.dbo.WarehouseLocationInspection"
		  EntityKeyField4="InspectionId"
		  EntityAcronym="WISP">			  
					  
	
	<!--- Extended Warehouse roles for various transactions and inquiry of a warehouse --->
	
	<cf_insertRoles   Role="WhsPick"      		Area="Material Management" 
					  SystemModule="Warehouse" 	SystemFunction="Warehouse"
					  OrgUnitLevel="Warehouse"  Description="Warehouse Stock Manager" 
					  Parameter="Warehouse">
		
	<!--- Extended Warehouse roles for various transactions and inquiry of a warehouse --->
	
	<cf_insertRoles   Role="WhsShip"      		Area="Material Management" 
					  SystemModule="Warehouse" 	SystemFunction="Warehouse"
					  OrgUnitLevel="Warehouse"  Description="Warehouse Shipping Officer" 
					  Parameter="TaskType">
					  			
	<!---Asset --->
	
	<cf_insertRoles   Role="AdminAsset"     	Area="Material Management" 
					  SystemModule="Warehouse" 	SystemFunction="Asset"
					  OrgUnitLevel="Global"   	Description="Asset System Manager"
					  Memo="Mantains asset reference information and initiates yearly depreciation.">
	
	<cf_insertRoles   Role="AssetManager"   	Area="Material Management" 
					  SystemModule="Warehouse" 	SystemFunction="Asset"
					  OrgUnitLevel="All"   		Description="Asset Movement Control" 
					  Parameter="Entity"		Memo="Clears equipment movement and maintenance and depreciation">
	
	<cf_insertRoles   Role="AssetHolder"     	Area="Material Management" 
					  SystemModule="Warehouse" 	SystemFunction="Asset"
					  OrgUnitLevel="Parent"   	Description="Asset Holder" 
					  Parameter="ItemCategory"	Memo="Initiate equipment movement and maintenance">
	
	<cf_insertRoles   Role="AssetDisposal"  	Area="Material Management" 
					  SystemModule="Warehouse" 	SystemFunction="Asset"
					  OrgUnitLevel="All"   		Description="Disposal Manager" 
					  Parameter="Entity">
	
	<cf_insertRoles   Role="AssetUser"     		Area="Material Management" 
					  SystemModule="Warehouse" 	SystemFunction="Asset"
					  OrgUnitLevel="All"   		Description="Asset Unit Manager">
	
	<cf_insertEntity  Code="AssDisposal"   
	                  Description="Asset Disposal" 
					  Role="AssetDisposal"
					  EntityTableName="Materials.dbo.AssetItemDisposal"
					  EntityKeyField4="DisposalId"
					  EntityAcronym="ADI">					  
					  
		<cf_insertEntityDocument
		                  Code="AssDisposal"   
						  DocumentType="script" 
						  DocumentCode="S001"
						  DocumentDescription="Apply disposal in General Ledger"
						  DocumentTemplate="Warehouse/Application/Asset/Disposal/DisposalProcess.cfm"
						  DocumentMode="Embed">						  
					  
	<cf_insertEntity  Code="AssMovement"   
	                  Description="Asset Movement" 
					  Role="AssetManager"
					  EntityTableName="Materials.dbo.AssetMovement"
					  EntityKeyField4="MovementId"
					  EntityAcronym="AMV">		
					  
	<cf_insertEntity  Code="AssObservation"   
	                  Description="Asset Observation" 
					  Role="AssetManager"
					  EntityTableName="Materials.dbo.AssetItemObservation"
					  EntityKeyField4="ObservationId"
					  EntityAcronym="AOB">			
					  
	<cf_insertEntity  Code="WhsSale"   
	                  Description="Sale" 
					  Role="WhsProcessor"
					  EntityTableName="Materials.dbo.WarehouseBatch"
					  EntityKeyField4="BatchId"
					  EntityAcronym="SALE">	
					  
					  			  
</cfif>					  		  


<!--- -------------------- --->
<!--- WORKORDER MANAGEMENT --->
<!--- -------------------- --->
			  
<cf_verifyOperational module="WorkOrder" Warning="No">

<cfif Operational eq "1">	

	<cf_insertRoles   Role="AdminWorkOrder"     	Area="WorkOrder Management" 
					  SystemModule="WorkOrder" 		SystemFunction="WorkOrder"
					  OrgUnitLevel="Global"   		Description="WorkOrder System Manager" 
					  Parameter="ServiceItem"		Memo="Role reserved for maintaining workorder reference information">
	
	<cf_insertRoles   Role="ServiceRequester"   	Area="WorkOrder Management" 
					  SystemModule="WorkOrder" 		SystemFunction="WorkOrder"
					  OrgUnitLevel="All"   			Description="Service Requester" 
					  Parameter="ServiceItem"		AccessLevels="3" 
					  AccessLevelLabel="READ,EDIT (1),ALL (2)" Memo="Initiates requests for services.">
	
	<cf_insertRoles   Role="WorkRequestManager"   	Area="WorkOrder Management" 
					  SystemModule="WorkOrder" 		SystemFunction="WorkOrder"
					  OrgUnitLevel="All"   			Description="WorkOrder Request Manager" 
					  Parameter="Entity"			Memo="Processes services request as part of the defined workflow.">
					  
	<cf_insertEntity  Code="WrkRequest"   
	                  Description="Service Request" 
					  Role="WorkRequestManager"
					  ListingOrder="1"
					  EntityClassField="EntityClass"
					  EntityTableName="WorkOrder.dbo.Request"					
					  EntityKeyField4="RequestId"
					  EntityAcronym="REQW">								  
	
	<cf_insertEntity  Code="WrkStatus"   
	                  Description="WorkOrder Status" 
					  Role="WorkOrderManager"
					  ListingOrder="2"					  
					  EntityTableName="WorkOrder.dbo.WorkOrder"					
					  EntityKeyField4="WorkOrderId"					  
					  EntityAcronym="WRKS">				  
					  
		<cf_insertEntityDocument
	          Code="WrkStatus"   
			  DocumentType="script" 
			  DocumentCode="S001"
			  DocumentDescription="Apply Production"
			  DocumentTemplate="WorkOrder/Application/Assembly/Items/HalfProduct/ApplyHalfProduct.cfm"
			  DocumentMode="Embed">		  			  
					  
		<cfquery name="Class" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      ServiceItemClass
			WHERE     Code IN
	                        (SELECT  ServiceClass
	                         FROM    ServiceItem
	                         WHERE   ServiceMode = 'WorkOrder')
		</cfquery>				  	
		
		<cfloop query="Class">
		
			  <!--- used for creating a workflow per class : bidding etc. --->	
				<cf_insertEntityClass  
			      Code="WrkStatus"   
                  Class="#Code#" 
     			  Description="#Description#">	
					
		</cfloop>		
		
	<cf_insertEntity  Code="WrkCustomer"   
	                  Description="Customer Actions" 
					  Role="WorkRequestManager"
					  ListingOrder="1"
					  EntityClassField="EntityClass"
					  EntityTableName="WorkOrder.dbo.CustomerAction"					
					  EntityKeyField4="CustomerActionId"
					  EntityAcronym="CUSW">									  	
		
	<cf_insertEntity  Code="WrkEvent"   
	                  Description="WorkOrder Event" 
					  Role="WorkOrderManager"
					  ListingOrder="4"
					  EntityClassField="EntityClass"
					  EntityTableName="WorkOrder.dbo.WorkOrderEvent"					
					  EntityKeyField4="WorkOrderEventId"					  
					  EntityAcronym="WEVT">				  	
	
	<cf_insertEntity  Code="WrkAgreement"   
	                  Description="Service Level Agreement" 
					  Role="WorkRequestManager"
					  ListingOrder="3"
					  EntityClassField="EntityClass"
					  EntityTableName="WorkOrder.dbo.WorkOrderBaseLine"					
					  EntityKeyField4="TransactionId"					  
					  EntityAcronym="SLAW">			
					  
		<!--- custom form/scripts --->	
		
		<cf_insertEntityDocument
		      Code="WrkRequest"   
	          DocumentType="dialog" 
			  DocumentCode="ASS"
			  DocumentDescription="Service Request Details"
			  DocumentTemplate="Workorder/Application/Request/Request/Workflow/ServiceDetail.cfm"
			  DocumentStringList=""
			  DocumentMode="Embed">		
			  
		<cf_insertEntityDocument
		      Code="WrkRequest"   
	          DocumentType="dialog" 
			  DocumentCode="FUL"
			  DocumentDescription="Service Fullfillment Details"
			  DocumentTemplate="Workorder/Application/Request/Request/Workflow/FullfillmentWorkOrder.cfm"
			  DocumentStringList=""
			  DocumentMode="Ajax">		
			  
		<cf_insertEntityDocument
		      Code="WrkRequest"   
	          DocumentType="dialog" 
			  DocumentCode="ENC"
			  DocumentDescription="Medical Encounter"
			  DocumentTemplate="Workorder/Application/Medical/Complaint/Workflow/FullfillmentWorkOrder.cfm"
			  DocumentStringList=""
			  DocumentMode="Ajax">			  	  	  
		
		<cf_insertEntityDocument
	          Code="WrkRequest"   
			  DocumentType="script" 
			  DocumentCode="S001"
			  DocumentDescription="Apply request"
			  DocumentTemplate="Workorder/Application/Request/Request/Apply/RequestApply.cfm"
			  DocumentMode="Embed">	
			  
		<cf_insertEntityDocument
	          Code="WrkRequest"   
			  DocumentType="script" 
			  DocumentCode="S009"
			  DocumentDescription="Return Service to Original"
			  DocumentTemplate="Workorder/Application/Request/Request/Apply/RequestApplyReturn.cfm"
			  DocumentMode="Embed">			  	
			  
		<cf_insertEntityDocument
	          Code="WrkRequest"   
			  DocumentType="script" 
			  DocumentCode="S002"
			  DocumentDescription="Revert Service Item"
			  DocumentTemplate="Workorder/Application/Request/Request/Apply/RequestRevert.cfm"
			  DocumentMode="Embed">		
			  
		<cf_insertEntityDocument
	          Code="WrkRequest"   
			  DocumentType="report" 
			  DocumentCode="R001"
			  DocumentDescription="Status of Service"
			  DocumentTemplate="Workorder/Application/WorkOrder/ServiceDetails/Billing/BillingDetailPrint.cfm"
			  DocumentMode="Embed">			  				  
							  
		<cfquery name="Domain" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT     Code, 
				           Description 						 
				FROM       Ref_ServiceItemDomain
				WHERE      Code IN
                          	(	SELECT  ServiceDomain
                            	FROM    ServiceItem
                            	WHERE   Operational = 1
							)	  					
		</cfquery>	
		
		<!--- create different workgroups --->			  	
			
		<cfloop query="Domain">		
		
			<cf_insertEntityGroup  
			      EntityCode="WrkRequest"   
	              EntityGroup="#Code#"
                  EntityGroupName="#Description#">	
							
		</cfloop>	
		
	<cf_insertRoles   Role="WorkOrderProcessor"  	Area="WorkOrder Management" 
					  SystemModule="WorkOrder" 		SystemFunction="WorkOrder"
					  OrgUnitLevel="All"   			Description="WorkOrder Processor" 
					  Parameter="ServiceItem"		Memo="Manages workorder lines and details and manages service item specific settings like rates.">		
	
	<cf_insertRoles   Role="WorkOrderFunder"  		Area="WorkOrder Management" 
					  SystemModule="WorkOrder" 		SystemFunction="WorkOrder"
					  OrgUnitLevel="All"   			Description="Service Funder" 
					  Parameter="ServiceItem"		Memo="Manages workorder funding and financials information.">	
					  
	<cf_insertRoles   Role="WorkOrderBiller"  		Area="WorkOrder Management" 
					  SystemModule="WorkOrder" 		SystemFunction="WorkOrder"
					  OrgUnitLevel="All"   			Description="Service Blling" 
					  Parameter="ServiceItem"		Memo="Manages workorder billing and financials information.">		   				  	    
	
	<!--- the below role is not defined yet --->
	
	<cf_insertRoles   Role="WorkOrderManager"   	Area="WorkOrder Management" 
					  SystemModule="WorkOrder" 		SystemFunction="WorkOrder"
					  OrgUnitLevel="All"   			Description="WorkOrder Manager" 
					  Parameter="Entity"			Memo="Processes workorder related workflows.">
	
	<cf_insertEntity  Code="Workorder"   
	                  Description="WorkOrder Actions" 
					  Role="WorkOrderManager"
					  ListingOrder="5"
					  EntityTableName="WorkOrder.dbo.WorkOrderLineAction"					
					  EntityKeyField4="WorkActionId"
					  EntityAcronym="WORD">		  
					  
	<cf_insertEntity  Code="WorkOrderLoad"   
	                  Description="WorkOrder Usage Load" 
					  Role="WorkOrderManager"
					  ListingOrder="5"					 
					  EntityTableName="WorkOrder.dbo.ServiceItemload"		
					  EntityKeyField1="Mission"					
					  EntityKeyField2="ServiceItem"					  
					  EntityKeyField3="ServiceUsageSerialNo"
					  EntityAcronym="WLOA">								  				  		
	
	<cf_insertEntity  Code="SrvClosing"   
	                  Description="Batch Billing" 
					  Role="WorkRequestManager"
					  ListingOrder="7"					 
					  EntityTableName="WorkOrder.dbo.ServiceItemMissionPosting"					
					  EntityKeyField4="PostingId"					  
					  EntityAcronym="WRCL">						  
					  
	<!--- workgroups --->				  
					  
	<cfquery name="Domain" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT     Code, 
				           Description 						 
				FROM       Ref_ServiceItemDomain
				WHERE      Code IN
                          	(	SELECT  ServiceDomain
                            	FROM    ServiceItem
                            	WHERE   Operational = 1
							)	  					
	</cfquery>	
		
	<!--- create different workgroups --->			  	
			
	<cfloop query="Domain">		
		
		<cf_insertEntityGroup  
		    EntityCode="Workorder"   
	        EntityGroup="#Code#"
            EntityGroupName="#Description#">	
					
	</cfloop>		
	
	<cf_insertEntity  Code="WrkPublish"   
	                  Description="Publication" 
					  Role="WorkOrderManager"
					  ListingOrder="8"
					  EntityClassField="EntityClass"
					  EntityTableName="WorkOrder.dbo.Publication"					
					  EntityKeyField4="PublicationId"					  
					  EntityAcronym="WPUB">		
					  
	<cf_insertEntity  Code="WrkPubReview"   
	                  Description="Publication Node" 
					  Role="WorkOrderManager"
					  ListingOrder="9"
					  EntityClassField="EntityClass"
					  EntityTableName="WorkOrder.dbo.PublicationClusterElement"					
					  EntityKeyField4="PublicationElementId"					  
					  EntityAcronym="WPEL">		
					  
		
	

</cfif>

<!--- ---------------------- --->
<!--- CASE Claim MANAGEMENT- --->
<!--- ---------------------- --->
				  
<cf_verifyOperational module="Insurance" Warning="No">

<cfif Operational eq "1">	

	<cf_insertRoles  Role="ClaimProcessor"     	Area="CaseFile"  
					 SystemModule="Insurance"  	SystemFunction="Insurance"
					 OrgUnitLevel="Parent"     	Description="Case File Element Processor"  
					 Parameter="Entity" 		Memo="Role for processing workflow within a certain element">

	<cf_insertEntity  Code="ClmNoticasDocument"   
	  Description="Case Document" 
	  Role="ClaimProcessor"
	  PersonClass="Employee"
	  EntityCodeParent="ClmNoticas"
	  PersonReference="Claimant"
	  EntityTableName="CaseFile.dbo.stQuestionaireContent"					  
	  EntityKeyField4="TopicId"
	  EntityAcronym="CDOC">	
		
	<cf_insertRoles  Role="CaseFileManager"    	Area="CaseFile"  
					 SystemModule="Insurance" 	SystemFunction="CaseFile"
					 OrgUnitLevel="All"  		Description="Case File Manager"  
					 Parameter="CaseType" 		Memo="May create and oversee all casefiles for a certain type">	
	
	<cf_insertRoles  Role="CaseFileOfficer"    	Area="CaseFile"  
					 SystemModule="Insurance" 	SystemFunction="CaseFile"
					 OrgUnitLevel="Parent"  	Description="Case File Processor"  
					 Parameter="Entity">	
	
	<cfquery name="Class" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ClaimType
	</cfquery>						  
	
	<cfloop query="Class">							  
					  
		<cf_insertEntity  Code="Clm#Code#"   
		                  Description="#Description#" 
						  Role="CaseFileOfficer"
						  PersonClass="Employee"
						  PersonReference="Claimant"
						  Operational="#operational#"
						  EntityTableName="CaseFile.dbo.Claim"					  
						  EntityKeyField4="ClaimId"
						  EntityAcronym="ICH">		
						  
		<cf_insertEntity  Code="Clm#Code#Line"   
		                  Description="#Description# Payment" 
						  Role="CaseFileOfficer"
						  PersonClass="Employee"
						  PersonReference="Claimant"
						  Operational="#operational#"
						  EntityTableName="CaseFile.dbo.ClaimLine"					  
						  EntityKeyField4="ClaimLineId"
						  EntityAcronym="ICL">	
						  
		<cf_insertEntity  Code="Clm#Code#Action"   
						  Description="Case Element Actions" 
						  Role="CaseFileOfficer"			
						  Operational="#operational#" 
						  EntityTableName="CaseFile.dbo.CaseAction"					  
						  EntityKeyField4="ActionId"
						  EntityAcronym="CACT">					  
		
	</cfloop>	
	
</cfif>

<!--- -------------------- --->
<!--- -----ACCOUNTING----- --->
<!--- -------------------- --->
	  
<cf_verifyOperational module="Accounting" Warning="No">

<cfif Operational eq "1">		
			 
	<cf_insertRoles  Role="Accountant"        	Area="Accounting"  
					 SystemModule="Accounting" 	SystemFunction="Accounting"
					 OrgUnitLevel="Parent"  	Description="Accountant"  
					 Parameter="Journal">
	
	<cf_insertRoles  Role="AccountManager"    	Area="Accounting"  
					 SystemModule="Accounting" 	SystemFunction="Accounting"
					 OrgUnitLevel="Parent"  	Description="Account Manager"  
					 Parameter="Entity" 		Memo="Role geared for transaction workflow approval and inquiry functions">
	
	<cf_insertRoles  Role="AdminFinancials"  	Area="Accounting"  
					 SystemModule="Accounting" 	SystemFunction="Accounting"
					 OrgUnitLevel="Global"   	Description="Financials System Manager" 
					 Memo="Mantains reference information and settings">
					 
	<cf_insertEntity Code="GLEvent"
		Description="Financial Event" 
		Role="AccountManager"
		EntityTableName="Accounting.dbo.Event"
		EntityKeyField4="EventId"
		EntityAcronym="GLE">					 
	
	<cf_insertEntity Code="GLTransaction"
		Description="Journal Transaction" 
		Role="AccountManager"
		EntityTableName="Accounting.dbo.TransactionHeader"
		EntityKeyField4="TransactionId"
		EntityAcronym="GLT">	
		
	 <cf_insertEntity  Code="PayBank"   
	    Description="Employee Bank account" 
		Role="AccountManager"
		PersonClass="Employee"
		PersonReference="Requester"
		EntityTableName="Payroll.dbo.PersonAccount"
		EntityKeyField1="PersonNo"
		EntityKeyField4="AccountId"
		EntityAcronym="PAC">				  							  	
		
	<cf_insertEntity Code="BankAccount"
		Description="Bank Account" 
		Role="AccountManager"
		EntityTableName="Organization.dbo.OrganizationBankAccount"
		EntityKeyField4="AccountId"
		EntityAcronym="BKA">		
		
	<cf_insertEntityDocument
	          Code="GLTransaction"   
			  DocumentType="script" 
			  DocumentCode="S001"
			  DocumentDescription="Generate and Send Payslip"
			  DocumentTemplate="Payroll/Application/Payroll/SalarySlipPrintBatch.cfm"
			  DocumentMode="Embed">			
			  
	<cf_insertEntityDocument
	          Code="GLTransaction"   
			  DocumentType="script" 
			  DocumentCode="S009"
			  DocumentDescription="Obtain Tax invoiceNo"
			  DocumentTemplate="Gledger/Workflow/Tax/ObtainInvoiceNo.cfm"
			  DocumentMode="Embed">					  
			  
	<cf_insertEntityDocument
	          Code="GLTransaction"   
			  DocumentType="dialog" 
			  DocumentCode="PS1"
			  DocumentDescription="Generate and Send Payslip"
			  DocumentTemplate="Payroll/Application/Payroll/SalarySlipPreparation.cfm"
			  DocumentMode="Embed">		
			  
	<cf_insertEntityDocument
		      Code="GLTransaction"   
	          DocumentType="dialog" 
			  DocumentCode="ACU"
			  DocumentDescription="Update customer information"
			  DocumentTemplate="GLedger/Workflow/Customer/Document.cfm"
			  DocumentStringList=""
			  DocumentMode="Embed">		
			  		  	  		    

</cfif>

<!--- ------------------------- --->
<!--- ------ SYSTEM - report -- --->
<!--- ------------------------- --->

<cf_insertEntity  Code="SysReport" 
                  Description="Report issuance" 
				  Role="ReportManager"
				  EntityTableName="System.dbo.Ref_ReportControl"
				  EntityKeyField4="ControlId"
				  EntityAcronym="RPT"
				  StandardFlow="No">	
				  				  
	<cfquery name="Module" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_SystemModule
	WHERE  Operational = 1
	AND    EnableReportDefault = 1
	AND    MenuOrder != '99'	
	</cfquery>				  	
	
	<cfloop query="Module">
	
			<cf_insertEntityClass  
			      Code="SysReport"   
                  Class="#SystemModule#" 
     			  Description="#Description#">			
					
	</cfloop>				  
			  
<cfquery name="Group" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM Ref_AuthorizationRoleOwner
	</cfquery>				  	
	
	<cfloop query="Group">
	
			<cf_insertEntityGroup  
			      EntityCode="SysReport"   
	              EntityGroup="#Code#"
                  EntityGroupName="#Description#">	
					
	</cfloop>	
		
<cfquery name="Entity" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM Ref_Entity
</cfquery>	
	
<cfloop query="Entity">

	<cf_insertEntityDocument
	      Code="#EntityCode#"   
          DocumentType="function" 
		  DocumentCode="fact"
		  DocumentDescription="Actor decision"
		  DocumentTemplate="actor"
		  DocumentMode="Embed">		
		
	<cf_insertEntityDocument
	      Code="#EntityCode#"   
          DocumentType="function" 
		  DocumentCode="ftme"
		  DocumentDescription="Time recording"
		  DocumentTemplate="work"
		  DocumentMode="Embed">		
		  
	<cf_insertEntityDocument
	      Code="#EntityCode#"   
          DocumentType="function" 
		  DocumentCode="fexp"
		  DocumentDescription="Expenditures"
		  DocumentTemplate="cost"
		  DocumentMode="Embed">		
		  
	<cf_insertEntityDocument
	      Code="#EntityCode#"   
          DocumentType="function" 
		  DocumentCode="fmes"
		  DocumentDescription="Messenger"
		  DocumentTemplate="mess"
		  DocumentMode="Embed">			  
		  	  
	<cf_insertEntityDocument
	      Code="#EntityCode#"   
          DocumentType="function" 
		  DocumentCode="fnts"
		  DocumentDescription="Notes"
		  DocumentTemplate="note"
		  DocumentMode="Embed">		
		  
	<cf_insertEntityDocument
	      Code="#EntityCode#"   
          DocumentType="function" 
		  DocumentCode="ftpl"
		  DocumentDescription="Templates"
		  DocumentTemplate="template"
		  DocumentMode="Embed">		
		  
	<cf_insertEntityDocument
	      Code="#EntityCode#"   
          DocumentType="function" 
		  DocumentCode="fled"
		  DocumentDescription="Ledger Transaction"
		  DocumentTemplate="ledger"
		  DocumentMode="Embed">			  	  		  
		  
</cfloop>			  

<!---- Inserting role access added by Armin on 12/26/2014 ---->
<cfquery name="qRole" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT R.SystemFunctionId, R.Role, Organization.dbo.Ref_AuthorizationRole.AccessLevels
		FROM Ref_ModuleControlRole AS R INNER JOIN
			Organization.dbo.Ref_AuthorizationRole ON R.Role = Organization.dbo.Ref_AuthorizationRole.Role
		WHERE NOT EXISTS
				(
					SELECT SystemFunctionId, Role, AccessLevel, Created
					FROM Ref_ModuleControlRoleLevel
					WHERE SystemFunctionId = R.SystemFunctionId
					AND Role = R.Role
				)
</cfquery> 

<cftransaction>
	<cfloop query="qRole">
		<cfif qRole.AccessLevels eq 2>
				<cfloop index = "i" from = "1" to = "2"> 
					<cfquery name="qRoleInsert" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Ref_ModuleControlRoleLevel(SystemFunctionId, Role, AccessLevel)
						VALUES ('#qRole.SystemFunctionId#','#qRole.Role#','#i#')
					</cfquery> 
				</cfloop> 
		<cfelseif qRole.AccessLevels eq 3>
				<cfloop index = "i" from = "0" to = "2"> 
					<cfquery name="qRoleInsert" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Ref_ModuleControlRoleLevel(SystemFunctionId, Role, AccessLevel)
						VALUES ('#qRole.SystemFunctionId#','#qRole.Role#','#i#')
					</cfquery> 
				</cfloop> 
		<cfelseif qRole.AccessLevels gte 4>
				<cfloop index = "i" from = "0" to = "3"> 
					<cfquery name="qRoleInsert" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Ref_ModuleControlRoleLevel(SystemFunctionId, Role, AccessLevel)
						VALUES ('#qRole.SystemFunctionId#','#qRole.Role#','#i#')
					</cfquery> 
				</cfloop> 
		</cfif>
	</cfloop>
</cftransaction>
<!---- Ending routine for access roles on 2020 ---->