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

<cfparam name="URL.SubmissionEdition" default="">
<cfparam name="URL.ActionId" default="00000000-0000-0000-0000-000000000000">

<cfset Session.Status = 0>

<!----- Getting default values ----->
<cfquery name="qEdition"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ExerciseClass EX INNER JOIN Ref_SubmissionEdition S ON EX.ExcerciseClass = S.ExerciseClass
	WHERE   S.SubmissionEdition = '#url.submissionedition#'
</cfquery>

 <!--- Not a single email has been sent, it is ok to remove all previous---->
<cfquery name="qCheckingDraft" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	    DELETE  FROM    Ref_SubmissionEditionPublish
		WHERE 	SubmissionEdition = '#URL.SubmissionEdition#'	
		AND     ActionStatus = '0'	
</cfquery>
	
<cf_assignid>

<cfset vBroadcastId = rowguid>

<cfquery name="Broadcast" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  INSERT INTO System.dbo.Broadcast
		  (BroadcastId,
		   BroadcastClass,
		   BroadcastReference, 
		   BroadCastRecipient,
		   BroadCastSubject,
		   BroadcastFrom,
		   BroadcastReplyTo,
		   BroadcastPriority,
		   BroadcastFailTo,
		   BroadCastMailerId,
		   OfficerUserId,
		   OfficerLastName,
		   OfficerFirstName)
	  VALUES ('#vBroadcastId#',
		  'Mail', 
		  '#URL.SubmissionEdition#',
		  <cfif qEdition.actionStatus eq "1">
		  'Edition',
		  <cfelse>
		  'EditionPost',
		  </cfif>
		  '#qEdition.EditionDescription#',
		  '#client.eMail#',
		  '#client.eMail#',
		  '3',
		  '#client.eMail#',
		  '#SESSION.acc#',
		  '#SESSION.acc#',
		  '#SESSION.last#',
		  '#SESSION.first#')
</cfquery>

<cfif Session.Status lte 0> <!---- rfuentes because the ajax somehow it was calling it many times, June-17 2020 ------->
	
	<cftransaction>
		
		<cfset Session.Message = "Gathering addresses">
		<cfset Session.Status  = 0.1>
		
		<!--- eFaxNo review if still needed --->
		
		<cfquery name="qSelect" 
		   datasource="AppsSelection" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			SELECT    DISTINCT SEO.SubmissionEdition,SEO.OrgUnit, O.OrgUnitName, OA.eFaxNo as EmailAddress
			FROM      Ref_SubmissionEditionOrganization SEO 
					  INNER JOIN Organization.dbo.OrganizationAddress OA ON OA.OrgUnit = SEO.OrgUnit 
					  INNER JOIN Organization.dbo.Organization O ON O.OrgUnit = SEO.OrgUnit 
					  INNER JOIN Ref_SubmissionEditionAddressType SEAT ON SEO.SubmissionEdition = SEAT.SubmissionEdition AND SEAT.AddressType = OA.AddressType
			WHERE     SEO.SubmissionEdition	= '#URL.SubmissionEdition#'
			AND 	  SEO.Operational	   = '1'
			AND 	  SEAT.Operational 	   = '1'
			AND       OA.Operational       = 1
			AND 	  eFaxNo IS NOT NULL
			
			UNION 
			
			SELECT    DISTINCT  SEO.SubmissionEdition,SEO.OrgUnit, O.OrgUnitName, A.eMailAddress
			FROM      Ref_SubmissionEditionOrganization SEO 
					  INNER JOIN Organization.dbo.OrganizationAddress OA ON OA.OrgUnit = SEO.OrgUnit 
					  INNER JOIN Organization.dbo.Organization O ON O.OrgUnit = SEO.OrgUnit 
					  INNER JOIN Ref_SubmissionEditionAddressType SEAT ON SEO.SubmissionEdition = SEAT.SubmissionEdition AND SEAT.AddressType = OA.AddressType
					  INNER JOIN System.dbo.Ref_Address A ON A.AddressId = OA.AddressId
			WHERE     SEO.SubmissionEdition	= '#URL.SubmissionEdition#'
			AND 	  SEO.Operational 	    = '1'
			AND 	  SEAT.Operational 	    = '1'
			AND       OA.Operational        = 1
			AND 	  A.EmailAddress IS NOT NULL	
			ORDER BY  SEO.SubmissionEdition,SEO.OrgUnit
						
		</cfquery>	
		
		<cfoutput query="qSelect" group="OrgUnit">				   
			   
				<cfquery name="check" 
				   datasource="AppsSelection" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					SELECT * 
					FROM   Ref_SubmissionEditionPublish
					WHERE  SubmissionEdition = '#SubmissionEdition#'
					AND    OrgUnit           = '#orgunit#'		   
				</cfquery>				
				
				<cfif check.recordcount eq "0">
		
					<cfquery name="qHeader" 
					   datasource="AppsSelection" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						INSERT INTO Ref_SubmissionEditionPublish
						           (SubmissionEdition,
						            OrgUnit,
						            ActionStatus,
						            OfficerUserId,
						            OfficerLastName,
						            OfficerFirstName)
						VALUES ('#SubmissionEdition#',
								'#OrgUnit#',
								0,
						    	'#SESSION.acc#',
							    '#SESSION.last#',
							    '#SESSION.first#')
					</cfquery>		
				
				</cfif>		
										   
				<cfoutput>
	
					<!--- we prevent resending to the same address of the mail status = 1 --->
									
					<cfquery name="qCheck" 
					   datasource="AppsSelection" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						SELECT  *
						FROM   	Ref_SubmissionEditionPublishMail
						WHERE   SubmissionEdition  = '#SubmissionEdition#'
						AND 	OrgUnit 	       = '#OrgUnit#'
						AND 	eMailAddress       = '#eMailAddress#'    
						AND     ActionStatus       = '1' 						
					</cfquery>			
					
					<cfset address= LCase(eMailAddress)>
					
					<cfif qCheck.recordcount eq 0 and (isValid("eMail",address) or isValid('regex',address,'[a-z]+@[0-9]+@fax'))>
					
							<cf_assignid>
							
							<cfset vRecipientId = rowguid>
							
							<!--- we record the recipinent --->
		
							<cfquery name="qContact" 
							   datasource="AppsSelection" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
								SELECT  DISTINCT TOP 1 Contact 
								FROM    Organization.dbo.OrganizationAddress OA INNER JOIN 
									    System.dbo.Ref_Address A ON A.AddressId = OA.AddressId 
								WHERE   OrgUnit = '#OrgUnit#'
								AND     Contact IS NOT NULL
								AND 	(OA.eFaxNo = '#EmailAddress#' OR A.eMailAddress = '#EmailAddress#')
							</cfquery>				
							
							<cfquery name="BroadcastRecipients" 
							   datasource="AppsSelection" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
							   INSERT INTO System.dbo.BroadcastRecipient (
										RecipientId,
										BroadcastId, 
										RecipientCode, 
										RecipientName,
										eMailAddress, 										
										RecipientLastName,
										RecipientFirstName)								
							   VALUES ('#vRecipientId#',
							   		   '#vBroadcastId#',
							           '#orgunit#',
									   '#orgunitname#',
									   '#eMailAddress#',
							           '#LEFT(qContact.Contact,100)#',
									   '') 									   
							</cfquery>			
		
					</cfif>				
					
				</cfoutput>
				   
		</cfoutput>
					
			<!--- we retrieve the default  body from the edition --->
	
		<cfset Session.Message = "Parsing text">
		<cfset Session.Status  = 0.2>
			
			
			<!---
			This was needed when the Mail body was also a text area.
			
			<cfquery name="qBodyContent" 
			   datasource="AppsSelection" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				SELECT  TOP 1 EditionNotes
				FROM    Ref_SubmissionEditionProfile SEP INNER JOIN 
						Ref_TextArea T ON SEP.TextAreaCode = T.Code AND T.TextAreaSection = 'Mail' INNER JOIN
						System.dbo.Ref_SystemLanguage L ON L.LanguageCode = SEP.LanguageCode
				WHERE 	SEP.SubmissionEdition = '#URL.SubmissionEdition#'
				AND   	L.SystemDefault = '1'
				AND     ActionStatus = '1'
			</cfquery>
			
			<cfquery name="qUpdateBodyContent" 
			   datasource="AppsSelection" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				UPDATE   System.dbo.Broadcast   
				SET 	 BroadcastContent = '#qBodyContent.EditionNotes#'
				WHERE 	 BroadCastId 	 = '#vBroadcastId#'  
			</cfquery>   
			--->
					
			<!--- we generate and associate dynamic files from the recipient --->
			
			<cfif qEdition.PathPublishText neq "">							
							
					<cfif not DirectoryExists("#SESSION.rootDocumentPath#/Broadcast/#vBroadcastId#")>
					
						<cfdirectory action="CREATE" 
						   directory="#SESSION.rootDocumentPath#/Broadcast/#vBroadcastId#">
						   
					</cfif>  	
					
					<!--- -------------------------------------------------- ---> 
					<!--- ----Generating dynamic files per recipient-------- --->
					<!--- -------------------------------------------------- --->
					<cfset ActionStatus = 1>
					
					<!---generalised --->
					<cfinclude template="generateEditionDocs.cfm">				
													
					<cfinclude template="../../../../Custom#qEdition.PathPublishText#EditionVerification.cfm">
																			
					<cfif response neq "">
					    <cfoutput>
						<font color="FF0000">#response#</font>
						</cfoutput>
						<cfabort>
					</cfif>					
																	
					<!--- -------------------------------------------------- --->
					<!--- --- and move over static content files edition --- --->
					<!--- -------------------------------------------------- --->
					
					<cfset Session.Message = "Attaching Job Profiles">
					<cfset Session.Status = 1>
					
					<cfquery name="qAttachments" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   * 
						FROM     System.dbo.Attachment
						WHERE    Reference        = '#url.submissionedition#'
						AND      ServerPath       = 'RosterEdition/#url.submissionedition#/'
						AND      FileName         != 'Thumbs.db'
						AND      FileStatus       != '9'	
						ORDER BY CREATED DESC
					</cfquery>
					
					<cfloop query="qAttachments">
					
						<cfset Session.Message = "Attaching file: #FileName#">
					
						<cffile action = "copy" 
							source = "#SESSION.rootDocumentPath#/#ServerPath#/#FileName#" 
						    destination = "#SESSION.rootDocumentPath#/Broadcast/#vBroadcastId#/">				
									
					</cfloop>
								  
			</cfif>   
	
	</cftransaction>

</cfif>

<cfoutput>

<input type="button" class="button10g" id="Send" name="Send" value="Broadcast Edition" style="height:28;width:210" onclick="doSend('#url.submissionedition#','#url.actionid#')">	

	<script language="JavaScript1.1">	  

	   function reloadDetail(){
	   		ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewDetail.cfm?submissionedition=#url.submissionedition#', 'recipients');
	   }

	   ColdFusion.ProgressBar.stop('pBar');
	   ColdFusion.ProgressBar.hide('pBar');	
	  
	     
	   ColdFusion.Window.create('BroadcastWindow', 'Broadcast edition', '',{x:100,y:100,height:800,width:1050,modal:true,center:true});
	   // ProsisUI.createWindow('BroadcastWindow', 'Broadcast edition', '',{x:100,y:100,height:800,width:1050,modal:true,center:true});
	   ColdFusion.Window.onHide( 'BroadcastWindow', reloadDetail );    
	  	
	   ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/prepareBroadcastView.cfm?id=#vBroadcastId#',"BroadcastWindow");	   
	  	 
   </script>
   
   <cfset Session.Status = 0>
										
	<cfprogressbar name="pBar" 
	    style="bgcolor:silver;progresscolor:black" 					
		height="20" 
		bind="cfc:service.Authorization.AuthorizationBatch.getstatus()"				
		interval="1000" 
		autoDisplay="false" 
		width="506"/> 
   
</cfoutput>

<script>
	Prosis.busy('no')	
</script>
