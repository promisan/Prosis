
<!--- Compatibility with CaseFile --->
<cfparam name="attributes.scope" default="">
<cfset scope = attributes.scope>

<!--- revised code --->

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Parameter
</cfquery>

<cfquery name="Applicant" 			<!--- determine if PHP exists on file --->
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  		SELECT R.Scope
  		FROM   Applicant A, Ref_ApplicantClass R
		WHERE  A.ApplicantClass = R.ApplicantClassId  	
		AND    PersonNo = '#URL.ID#'	
</cfquery>

<cfquery name="PHP" 			<!--- determine if PHP exists on file --->
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  		SELECT PersonNo
  		FROM   ApplicantSubmission
  		WHERE  PersonNo = '#URL.ID#'
		AND    Source in (Select PHPSource from Parameter)
</cfquery>
   
<cfoutput>

<cf_tl id="Personal information" var="per">

<cf_UItree
	id="root"
	title="<span style='font-size:16px;padding-bottom:3px'>#per#</span>"	
	expand="Yes">

	<cfparam name="URL.ID" default="0"> 
	
	<cf_tl id= "Contact" var = "1">
		
	    <cf_UItreeitem value="Contact"
	        display="<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:17px;font-weight:bold'>#lt_text#</span>"
			parent="Root"									
	        expand="Yes">	
			
	<cf_tl id= "Address" var = "1">
			
		<cf_UItreeitem value="Address"
	        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
			parent="Contact"
			target="right"			
			href="General.cfm?ID=#URL.ID#&section=contact&topic=address">	
	
	<cfif applicant.scope eq "applicant">
		
		<cf_tl id= "Reference" var="1">
		
		<cf_UItreeitem value="#lt_text#"
	        display="<span class='labelit' style='font-size:14px'>References</span>"
			parent="Contact"
			target="right"			
			href="General.cfm?ID=#URL.ID#&section=contact&topic=references">	
			
	</cfif>	
				
<cfif applicant.scope eq "patient">	

	    <cf_tl id= "Medical Profile" var = "1">
				
		<cf_UItreeitem value="Medical"
		        display="<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:17px;font-weight:bold'>#lt_text#</span>"
				parent="Root"	
				href="General.cfm?ID=#URL.ID#&section=general&topic=customer"
				target="right"														
		        expand="Yes">				
						
			<cfquery name="getSource" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   DISTINCT Source
					FROM     ApplicantSubmission
					WHERE    PersonNo = '#URL.ID#'											
					AND      Source IN (SELECT Source 
					                    FROM   Ref_Source 
										WHERE  Operational = 1)
			</cfquery>	
						
		<cfloop query="getSource">
		
			<cf_tl id="obtained" var="1">
		
			<cf_UItreeitem value="medical#Source#"
		        display="<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:15px'>#Source# #lt_text#</span>"
				parent="Medical"
				target="right"			
				href="General.cfm?ID=#URL.ID#&section=general&topic=recapitulation&Source=#Source#&edit=view&area=Medical">	
		
		</cfloop>					
											
		<cfquery name="Customer" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   CustomerId, Mission
				FROM     Customer
				WHERE    PersonNo = '#URL.ID#'																
		</cfquery>				
		
		<cfloop query="Customer">
		
		<cf_UItreeitem value="#mission#"
	        display="<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:15px'>#Mission#</span>"
			parent="Medical">	
		
		<cf_tl id= "Insurance" var = "1">		
		
		<cf_UItreeitem value="#mission#Insurance"
		        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
				parent="#mission#"
				target="right"			
				href="General.cfm?ID=#URL.ID#&section=general&topic=payer&mission=#mission#&customerid=#customerid#">		

		<cf_tl id= "Complaints" var = "1">		
		<cf_UItreeitem value="#mission#Complaint"
		        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
				parent="#mission#"
				target="right"			
				href="General.cfm?ID=#URL.ID#&section=general&topic=complaint&mission=#mission#&customerid=#customerid#">
		
		<cf_tl id= "Medical Encounters" var = "1">		
				
		<cf_UItreeitem value="#mission#MedicalLine"
	        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
			parent="#mission#"
			target="right"			
			href="General.cfm?ID=#URL.ID#&section=general&topic=medical&mission=#mission#&customerid=#customerid#">								
			
		<cf_tl id= "Medical Actions" var = "1">		
				
		<cf_UItreeitem value="#mission#MedicalActions"
	        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
			parent="#mission#"
			target="right"			
			href="General.cfm?ID=#URL.ID#&section=general&topic=medicalaction&mission=#mission#&customerid=#customerid#">		
										
		</cfloop>					

		<cf_tl id= "Diagnoses" var = "1">			
				
		<cf_UItreeitem value="Diagnoses"
		        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
				parent="Medical"
				target="right"			
				href="General.cfm?ID=#URL.ID#&section=general&topic=diagnoses">		
				
<cfelseif applicant.scope eq "customer">	

	<cf_tl id= "Customer Profile" var = "1">
				
		<cf_UItreeitem value="Customer"
		        display="<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:17px;font-weight:bold'>#lt_text#</span>"
				parent="Root"	
				href="General.cfm?ID=#URL.ID#&section=general&topic=customer"
				target="right"														
		        expand="Yes">	
						
		<cfquery name="getSource" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   DISTINCT Source
				FROM     ApplicantSubmission
				WHERE    PersonNo = '#URL.ID#'											
				AND      Source IN (SELECT Source FROM Ref_Source WHERE Operational = 1)
		</cfquery>	
						
		<cfloop query="getSource">
		
			<cf_tl id="obtained" var="1">
		
			<cf_UItreeitem value="customer#Source#"
		        display="<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:15px'>#Source# #lt_text#</span>"
				parent="Customer"
				target="right"			
				href="General.cfm?ID=#URL.ID#&section=general&topic=recapitulation&Source=#Source#&edit=view&area=Medical">	
		
		</cfloop>					
											
		<cfquery name="Customer" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   CustomerId, Mission
				FROM     Customer
				WHERE    PersonNo = '#URL.ID#'	
				AND      Operational = 1															
		</cfquery>				
		
		<cfloop query="Customer">
		
		<cf_UItreeitem value="customer#mission#"
	        display="<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:15px'>#Mission#</span>"
			parent="Customer">	
				
		<cf_tl id= "Sales" var = "1">		
		<cf_UItreeitem value="#mission#Sales"
		        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
				parent="customer#mission#"
				target="right">
					
		<cf_tl id= "Actions" var = "1">		
				
		<cf_UItreeitem value="#mission#Actions"
	        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
			parent="customer#mission#"
			target="right">		
										
		</cfloop>					
			
<cfelse>					
		
	<!--- ------------------------------------------- --->		
	<!--- ------------------------------------------- --->	
	<!--- ------------------------------------------- --->		
		
	<cf_verifyOperational 	        
	         module    = "Roster" 
			 Warning   = "No">
			 
	<cfif operational eq "1">
					
		<cf_tl id= "Professional Profile" var = "1">
				
		<cf_UItreeitem value="Profile"
		        display="<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:17px;font-weight:bold'>#lt_text#</span>"
				parent="Root"	
				target="right"			
				href="General.cfm?ID=#URL.ID#&section=profile&topic=all"									
		        expand="Yes">				
						
		<cfinvoke component="Service.Access"  
			method="roster" 
			role="'AdminRoster','CandidateProfile','RosterClear'"
			returnvariable="Access">			   
			   
		<cfif Access eq "EDIT">	   
		
			<cfquery name="getSource" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     Ref_Source R 
					WHERE    Source IN (SELECT Source
										FROM   ApplicantSubmission
					                    WHERE  Source = R.Source
					                    AND    PersonNo = '#URL.ID#' )
					AND     Operational = 1 
					--	AND AllowEdit = 1		
			</cfquery>
					
			<cfloop query="getSource">
		     	
				<cf_tl id="Source" var="1">
				<cf_UItreeitem value="#source#"
			        display="<span class='labelit' style='color:gray;padding-bottom:2px;padding-top:6px;font-size:11px'>#lt_text# :&nbsp;</span><span class='labelit' style='padding-bottom:2px;padding-top:2px;font-size:15px'>#Source#</span>"
					parent="Profile"							
					Expand="No">	
					
				<!--- define if there are more than one submission --->		
					
				 <cfset src = source> 	
					
				 <cf_tl id= "Miscellaneous" var = "1">			
		
			     <cf_UItreeitem value="Questions_#src#"
			        display  = "<span class='labelit' style='font-size:14px'>#lt_text#</span>"
					parent   = "#source#"
					target   = "right"				
					href     = "General.cfm?ID=#URL.ID#&section=general&topic=recapitulation&Source=#Source#&edit=view&area=Miscellaneous">
					
					<cfquery name="getSubmission" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	 	
					
					SELECT    ApplicantNo, SubmissionDate
					FROM      ApplicantSubmission
					WHERE     PersonNo = '#url.ID#' AND Source = '#src#'					
				</cfquery>	
				
				<cfquery name="PHP"
			         datasource="AppsSelection"
			         username="#SESSION.login#"
			         password="#SESSION.dbpw#">
			         SELECT   *
			         FROM     Ref_ParameterSkill
					 WHERE    CandidateHide = 0
					 ORDER BY ListingOrder
			    </cfquery>
				
				<cfif getSubmission.recordcount eq "1">												
							
					<cfloop query="PHP">		
					
						<cf_tl id="#Description#" var="1">
				
						<cf_UItreeitem value="#description#_#src#"
					        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
							parent="#src#"
							target="right"				
							href="General.cfm?source=#src#&ID=#URL.ID#&section=profile&id2=#code#&topic=#code#">		
					
					</cfloop>
					
				<cfelse>
				
				     <cfloop query="getSubmission">
					 
						 	<cfset appNo = applicantNo>
						 
						 	<cf_UItreeitem value="#appNo#"
						        display="<span class='labelit' style='font-size:14px'>#dateformat(submissiondate,client.dateformatshow)#&nbsp;</span>&nbsp;<span style='padding-top:3px' class='labelit' style='font-size:12px'></span>"
								parent="#src#" 							
								Expand="No">	
						 				
						    <cfloop query="PHP">		
							
								<cf_tl id="#Description#" var="1">
						
								<cf_UItreeitem value="#description#_#src#"
							        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
									parent="#appno#"
									target="right"				
									href="General.cfm?source=#src#&ID=#URL.ID#&section=profile&id2=#code#&topic=#code#&applicantno=#appno#">		
							
							</cfloop>
						
					 </cfloop>
				
				</cfif>
									
			</cfloop>	
			
		</cfif>
		
		<cfif SESSION.isAdministrator eq "Yes">
		
			<cfquery name="Own" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT Owner
			   FROM   Ref_ParameterOwner
			   WHERE  Owner IN (SELECT Owner FROM Ref_Assessment)
			</cfquery>
			
		<cfelse>
		
			<cfquery name="Own" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    DISTINCT ClassParameter as Owner
				FROM      OrganizationAuthorization
				WHERE     UserAccount = '#SESSION.acc#' 
				AND       Role IN ('AdminRoster', 'RosterClear')
				AND       ClassParameter IN (SELECT Owner FROM Applicant.dbo.Ref_Assessment)
			</cfquery>
		
		</cfif>		
				
		<cfif Own.recordcount gt "0">
					
			<cf_tl id= "Job Assessment" var = "1">
				
			<cfif Own.recordcount eq "1">
			
				<cf_UItreeitem value="Assessment"
		        display="<span class='labelit' style='font-size:15px'>#lt_text#</span>"
				parent="Profile"
				target="right"			
				href="General.cfm?Owner=#Own.Owner#&ID=#URL.ID#&section=general&topic=assessment">				
			
			<cfelse>
			
				<cf_UItreeitem value="Assessment"
		        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
				parent="Profile"		
				expand="No"
				img="#SESSION.root#/Images/select.png">						
												
					<cfloop query="own">
					
						<cf_UItreeitem value="Assessment_#Owner#"
				        display="<span class='labelit' style='font-size:14px'>#Owner#</span>"
						parent="Assessment"
						target="right"					
						href="General.cfm?Owner=#Owner#&ID=#URL.ID#&section=general&topic=assessment">		
							
					</cfloop>
											
			</cfif>
				
		</cfif>			
		
		<cfquery name="Class" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ReviewClass
			WHERE  Operational = '1'
		</cfquery>
		
		<cfif SESSION.isAdministrator eq "Yes">
		
			<cfquery name="Own" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT Code as Owner
			   FROM   Ref_AuthorizationRoleOwner
			   WHERE  Code IN (SELECT Owner 
			                   FROM   Applicant.dbo.Ref_ParameterOwner 
							   WHERE  Operational = 1)
			</cfquery>
			
		<cfelse>
		
			<cfquery name="Own" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    DISTINCT ClassParameter as Owner
				FROM      OrganizationAuthorization
				WHERE     UserAccount = '#SESSION.acc#' 
				AND       Role IN ('AdminRoster','RosterClear','CandidateProfile')
				AND       ClassParameter IN (SELECT Owner 
				                             FROM   Applicant.dbo.Ref_ParameterOwner 
											 WHERE  Operational = 1)
			</cfquery>
		
		</cfif>
		
		<cfif Own.recordcount gt "0" and applicant.scope eq "applicant">
	
				<cf_tl id= "Profile Verification" var = "1">
		
				<cf_UItreeitem value="Review"
		        display="<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:17px;font-weight:bold'>#lt_text#</span>"
				parent="Root"
				<!---
				img="#SESSION.root#/images/folder_collapse.JPG"
				imgopen="#SESSION.root#/images/folder_expand.JPG"					
				--->
		        expand="Yes">			
													
			<cfloop query="class">
			
			<cfif Own.recordcount eq "1">
			
				<cf_UItreeitem value="rev_#description#"
			        display="<span class='labelit' style='font-size:14px'>#description#</span>"
					parent="Review"
					target="right"				
					href="General.cfm?Owner=#Own.Owner#&ID=#URL.ID#&section=general&topic=review&ID1=#code#">		
				
			<cfelse>
			
				<cfset cde = Code>
			
				<cf_UItreeitem value="rev_#cde#"
		        	display="<span class='labelit' style='font-size:15px'>#description#</span>"
					parent="Review"
					expand="No">		
				
					<cfloop query="own">
					
						<cf_UItreeitem value="rev_#cde#_#owner#"
				        display="<span class='labelit' style='font-size:15px'>#Owner#</span>"
						parent="rev_#cde#"
						target="right"
						href="General.cfm?Owner=#Owner#&ID=#URL.ID#&section=general&topic=review&ID1=#Cde#">		
											
					</cfloop>
										
			</cfif>
					
			</cfloop>
			
		</cfif>
	
	</cfif>
		
</cfif>

<!--- ------------------------------------------- --->		
    <!--- ------------------------------------------- --->	
	<!--- ------------------------------------------- --->			

	<cf_tl id= "Miscellaneous" var = "1">
	
	<cf_UItreeitem value="Miscellaneous"
	        display="<span class='labelit' style='font-weight:bold;padding-bottom:4px;padding-top:4px;font-size:17px'>#lt_text#</span>"
			parent="Root"							
	        expand="Yes">		
		
	 <cfif getAdministrator("*") eq "1">
	
		<cfquery name="Own" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT Owner
		   FROM   Ref_ParameterOwner
		   WHERE  Owner IN (SELECT Owner 
		                    FROM   Ref_Assessment)
		   AND    Operational = 1
		</cfquery>
		
	<cfelse>
	
		<cfquery name="Own" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    DISTINCT ClassParameter as Owner
			FROM      OrganizationAuthorization
			WHERE     UserAccount = '#SESSION.acc#' 
			AND       Role IN ('AdminRoster','RosterClear')
			AND       ClassParameter IN (SELECT Owner 
			                             FROM   Applicant.dbo.Ref_ParameterOwner 
										 WHERE  Operational = 1)
		</cfquery>
	
	</cfif>
	
	<cfif Own.recordcount gt "0">
				
		<cf_tl id= "Interviews" var = "1">
		
		<cfif Own.recordcount eq "1">
		
			<cf_UItreeitem value="Interviews"
		        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
				parent="Miscellaneous"
				target="right"				
				href="General.cfm?Owner=#Own.Owner#&ID=#URL.ID#&section=general&topic=interview">				
		
		<cfelse>
		
			<cf_UItreeitem value="Interviews"
		        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
				parent="Miscellaneous"		
				expand="No"
				img="#SESSION.root#/Images/select.png">						
											
				<cfloop query="own">
				
					<cf_UItreeitem value="Interview_#Owner#"
			        display="<span class='labelit' style='font-size:14px'>#Owner#</span>"
					parent="Interviews"
					target="right"					
					href="General.cfm?Owner=#Owner#&ID=#URL.ID#&section=general&topic=interview">		
						
				</cfloop>
										
		</cfif>
			
	</cfif>
	
	<cfif scope neq "casefile">
	
		<cf_tl id= "Official documents" var = "1">
		
		<cf_UItreeitem value="Document"
	        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
			parent="Miscellaneous"			
			target="right"			
			href="General.cfm?ID=#URL.ID#&section=general&topic=issueddocument">		
	
		<cf_tl id= "Official messages" var = "1">
		
		<cf_UItreeitem value="EMail"
	        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
			parent="Miscellaneous"
			target="right"					
			href="General.cfm?ID=#URL.ID#&section=general&topic=email">		
			
	</cfif>	
	
	<cfif getAdministrator("*") eq "1">
		
			<cfquery name="Own" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT Owner
			   FROM   Ref_ParameterOwner
			   WHERE  Operational = 1
			</cfquery>
			
		<cfelse>
		
			<cfquery name="Own" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    DISTINCT ClassParameter as Owner
				FROM      OrganizationAuthorization
				WHERE     UserAccount = '#SESSION.acc#' 
				AND       Role IN ('AdminRoster', 'RosterClear')
				AND       ClassParameter IN (SELECT Owner 
				                             FROM   Applicant.dbo.Ref_ParameterOwner 
											 WHERE  Operational = 1)
			</cfquery>
		
		</cfif>
		
		<cfif Own.recordcount gt "0">
		
			<cf_tl id= "Annotations and Archive" var = "1">
					
			<cfif Own.recordcount eq "1">
			
				<cf_UItreeitem value="Attachments"
		        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
				parent="Miscellaneous"
				target="right"		
				expand="No"				
				href="General.cfm?Owner=#Own.Owner#&ID=#URL.ID#&section=general&topic=document">		
					
			<cfelse>
			
				<cf_UItreeitem value="Attachments"
		        display="<span class='labelit' style='font-size:13px'>#lt_text#</span>"				
				expand="No"
				parent="Miscellaneous">	
														
					<cfloop query="own">
					
						<cf_UItreeitem value="Attachments_#Owner#"
					        display="<span class='labelit' style='font-size:13px'>#Owner#</span>"
							parent="Attachments"
							target="right"							
							href="General.cfm?Owner=#Owner#&ID=#URL.ID#&section=general&topic=document">	
							
					</cfloop>
											
			</cfif>
				
		</cfif>		
	
<cfif applicant.scope eq "Applicant">

	<!--- ------------------------------------------- --->		
    <!--- ------------------------------------------- --->	
	<!--- ------------------------------------------- --->		
	
<cf_UItreeitem value   = "Candidacy"
	        display = "<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:17px;font-weight:bold'>Job candidacy</span>"
			parent  = "Root"
			expand  = "Yes">
				
		<!--- hanno disabled as we do not have pupose for it 			
			
		<cf_tl id= "Preference" var = "1">
	
		<cf_UItreeitem value="Preference"
	        display="<span class='labelit'>#lt_text#"
			parent="Candidacy"
			target="right"			
			href="Functions/ApplicantMission.cfm?ID=#URL.ID#">		
			
		--->	
		
		<!--- hanno added 9/3/2016 --->
		
		<cfif findNoCase("nucleus",session.root) or findNoCase("nova",session.root)>
		
			<cf_tl id= "Inspira/Galaxy" var = "1">
			
			<cf_UItreeitem value="Inspira"
		        display="<span class='labelit' style='font-size:14px'>>#lt_text#</span>"
				parent="Candidacy"
				target="right"			
				href="General.cfm?ID=#URL.ID#&section=vacancy&topic=inspira">	
			
		</cfif>	
		
		<cfinvoke component="Service.Access"  
		  method="roster" 
		  role="'AdminRoster'"
		  returnvariable="Access">		
			
	    <cfif access neq "NONE">
		
			<!--- only roster admin, the actual template will limit base on the owners the person has access to --->
		
			<cf_tl id= "Track Application" var = "1">
				
			<cf_UItreeitem value="Application"
		        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
				parent="Candidacy"
				target="right"				
				href="Functions/ApplicantFunction.cfm?ID=#URL.ID#">	
			
		</cfif>	

		<cf_tl id= "Track Shortlisted" var = "1">
		
		<cf_UItreeitem value="Short"
	        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
			parent="Candidacy"
			target="right"			
			href="General.cfm?ID=#URL.ID#&section=vacancy&topic=shortlist">	

		<cf_tl id= "Track Selected" var = "1">
					
		<cf_UItreeitem value="Selected"
	        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
			parent="Candidacy"
			target="right"			
			href="General.cfm?ID=#URL.ID#&section=vacancy&topic=selected">	

		<cf_tl id= "Offers" var = "1">
					
		<cf_UItreeitem value="Offer"
	        display="<span class='labelit' style='font-size:14px'>#lt_text#</span>"
			parent="Candidacy"
			target="right"			
			href="General.cfm?ID=#URL.ID#&section=vacancy&topic=offer">		
			  
		
	<cfquery name="Own" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM    Ref_ParameterOwner M, 
	          Organization.dbo.Ref_AuthorizationRoleOwner O
	  WHERE   Owner IN (SELECT Owner FROM Ref_SubmissionEdition)
	  AND     M.Owner = O.Code
	  AND     Operational = 1	
	  ORDER BY Description			  
	</cfquery>
	
	<!--- ------------------------------------------- --->		
    <!--- ------------------------------------------- --->	
	<!--- ------------------------------------------- --->		
	
	<cfif own.recordcount gte "1">
	
	<cf_UItreeitem value="Roster"
        display="<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:17px;font-weight:bold'>Rostered</span>"
		parent="Root"												
        expand="Yes">	
		
	</cfif>
	
	<cfloop query="own">
	
		<cfinvoke component="Service.Access"  
		   method="roster" 
		   owner="#Owner#" 
		   role="'AdminRoster','CandidateProfile'"
		   returnvariable="Access">	
		   
		 <cfinvoke component="Service.Access"  
			   method="roster" 
			   owner="#Owner#" 
			   role="'RosterClear'"
			   accesslevel="0"
			   returnvariable="AccessRead">	   
			 
			<cfif Access eq "EDIT" or Access eq "ALL" or accessread eq "READ">
			
				<cfset OwnerCode = "#Owner#">
				<cfset add       = "#DefaultRosterAdd#">					
					 
				<cfquery name="Edition" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				 SELECT    *
				  FROM     Ref_SubmissionEdition S, Ref_ExerciseClass C	
				  WHERE    C.ExcerciseClass = S.ExerciseClass		 
				  AND      Owner = '#OwnerCode#'
				  AND      S.Operational = '1'
				  AND      C.Roster = '1'		
				  ORDER BY EditionShort	
				</cfquery>
				
				<cfif edition.recordcount eq "0000">
				
				<cf_UItreeitem value="#Edition.EditionShort#"
			        display="<span class='labelit' style='font-size:14px'>#Edition.EditionDescription#</span>"
					parent="Roster"
					target="right"					
					href="../Details/Functions/ApplicantFunction.cfm?Owner=#Owner#&ID=#URL.ID#&ID1=#Edition.SubmissionEdition#"				
			        expand="No">	
								
				<cfelse>
				
					<cf_UItreeitem value="#OwnerCode#"
			        display="<span class='labelit' style='font-size:14px'>#Description#</span>"
					parent="Roster"
					target="right"					
					href="Functions/ApplicantFunction.cfm?ID=#URL.ID#&Owner=#Owner#"				
			        expand="No">	
											
				  <cfloop query="Edition">
					  
					  <cfset Edit  = SubmissionEdition>
					  				  
					  <cf_UItreeitem value="#EditionShort#"
					        display="<span class='labelit' style='font-size:13px'>#EditionShort#</span>"
							parent="#OwnerCode#"
							target="right"									
							href="../Details/Functions/ApplicantFunction.cfm?Owner=#Owner#&ID=#URL.ID#&ID1=#SubmissionEdition#"
							Expand="Yes">	
							
						<!---			
							
						<cfif EnableManualEntry eq "1">
					    
						   <cfinvoke component="Service.AccessGlobal"  
						      method="global" 
							  role="AdminRoster" 
							  parameter="#OwnerCode#"
							  returnvariable="Access">
						  
						  	<cfif Access eq "EDIT" or Access eq "ALL" and Add eq "1">
						  
								<cf_UItreeitem value="#EditionShort#_add"
						        	display="Add"
									parent="#EditionShort#"
									target="right"								
									href="../Details/Functions/ApplicantFunctionEntry.cfm?Owner=#OwnerCode#&ID=#URL.ID#&ID1=#SubmissionEdition#">			
						 	  
						 	 </cfif>	
							 
						</cfif> 	
						
						--->		
  	    
					</cfloop>	
					
				</cfif>							   
								
			</cfif>
		
	</cfloop>
	
	</cfif>
	
</cf_UItree>
	 
</cfoutput>
