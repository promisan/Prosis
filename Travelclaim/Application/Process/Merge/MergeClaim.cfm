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

<cfquery name="Parameter" 
 datasource="AppsTravelClaim">
 	SELECT *
	 FROM Parameter
</cfquery>

<!--- cross reference claim with IMIS claimNo --->

<cfquery name="CrossReference"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   UPDATE Claim
   SET    Reference = I.f_dorf_id_code, 
          ReferenceNo = I.doc_id,
          ReferenceStatus = I.doc_stat_code
   FROM   IMP_CLAIM I, Claim 
   WHERE  I.ext_ref_num = 'TCP' + Claim.DocumentNo
   AND    I.ext_ref_num is not NULL
</cfquery>   

<cfquery name="InsertStatus"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   INSERT INTO Ref_Status
   (StatusClass,Status,Description)
   SELECT DISTINCT 'TVCV',ReferenceStatus,'Undefined'
   FROM Claim
   WHERE ReferenceStatus NOT IN (SELECT Status
                                 FROM Ref_Status
								 WHERE StatusClass = 'TVCV') 
    AND ReferenceStatus is not NULL								   
</cfquery> 

<cftransaction>

	<!--- set claim status based on mapping table --->
	
	<!--- made correction to update the log file before it is updated --->
	
	<cfquery name="updateLog"
	   datasource="appsTravelClaim"
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    INSERT INTO ClaimActionLog
		(ClaimId,ActionStatus,OfficerUserid,OfficerLastName,OfficerFirstName)
		SELECT C.ClaimId, R.PointerStatus,'#SESSION.acc#','#SESSION.last#','#SESSION.first#'
		FROM   Claim C INNER JOIN
		       Ref_Status R ON C.ReferenceStatus = R.Status
		WHERE  R.StatusClass = 'TVCV' 
		AND    C.Reference IS NOT NULL
		AND    C.ActionStatus <> R.PointerStatus
		AND    C.ActionStatus <> '6'
	</cfquery>
	
	<cfquery name="updatestatus"
	   datasource="appsTravelClaim"
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    UPDATE Claim
		SET    ActionStatus = R.PointerStatus,  
		       ReferenceStatusDate = getDate(), 
			   PointerChange = '1'
		FROM   Claim C INNER JOIN
		       Ref_Status R ON C.ReferenceStatus = R.Status
		WHERE  R.StatusClass = 'TVCV' 
		AND    C.Reference IS NOT NULL
		AND    C.ActionStatus <> R.PointerStatus
		AND    C.ActionStatus <> '6'
	</cfquery>
		
	<!--- JUST A safeguard only as these claims or not portal related --->
	
	<cfquery name="correction"
	   datasource="appsTravelClaim"
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		UPDATE Claim
		SET   ActionStatus = '6' , 
		      ReferenceStatusDate = getDate(),
			  PointerChange = '0'
		WHERE (
		      (ActionStatus IN ('4','4c','5') AND (DocumentNo = '0' or documentNo is NULL or documentNo = ''))
				OR PointerUpload = 1
			   )
		AND   ActionStatus <> '6'		
	</cfquery>	

</cftransaction>

<!--- based on DW data from IMIS
      1. update workflow, 
      2. trigger email, 
      3. complete last action for that claim --->
 

<cfquery name="Entity" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  		 SELECT  *  
		 FROM    Ref_Entity
		 WHERE   EntityCode = 'EntClaim' 
</cfquery>	
 
<cfif Entity.MailFrom eq "">
  <cfset mailfrom = "hvanpelt@promisan.com">
<cfelse>
  <cfset mailfrom = Entity.MailFrom>  
</cfif>  

<!--- select approved claims in this session --->
	  
<cfquery name="result"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT * 
	FROM   Claim
	WHERE  PointerChange = '1'
	AND    ActionStatus  = '5' <!--- approved --->
	</cfquery>

<cfloop query="result">

      <!--- last step --->
	  
      <cfquery name="Action" 
		datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
         SELECT  TOP 1 
		         M.PersonMailAction, 
		         OA.ActionCode, 
				 M.ActionTrigger,
				 OA.ActionFlowOrder
         FROM    OrganizationObjectAction OA INNER JOIN
                 Ref_EntityActionPublish M ON OA.ActionPublishNo = M.ActionPublishNo 
					AND OA.ActionCode = M.ActionCode
		 WHERE   ObjectId IN
	                 (SELECT  ObjectId
	                  FROM    OrganizationObject
					  WHERE   ObjectKeyValue4 = '#ClaimId#'
					  AND     Operational = 1) 
	     ORDER BY ActionFlowOrder DESC
	</cfquery>		
	
	<cfquery name="Object" 
		datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	  	 SELECT  *
	     FROM    OrganizationObject
	     WHERE   ObjectKeyValue4 = '#ClaimId#'
		 AND     Operational = 1
	</cfquery>	 
		 
	<!--- get attachment --->
				  		  	
	<cfif FileExists("#Parameter.DocumentLibrary#\Claim\TCP#documentNo#.txt")>
	
		<cffile action="READ" 
	       	file="#Parameter.DocumentLibrary#\Claim\TCP#DocumentNo#.txt" 
			variable="claimtext">
			
			<cfset l = Len(claimtext)>
			<cfset t = "">
			
			<cfif l gt 50>
			
				<cfset t = right(claimtext,l-50)>	
			
			
				<!--- PDF --->
	
			    <cfdocument 
			      filename          = "#Parameter.DocumentLibrary#\Claim\TCP#documentNo#.pdf"
		   	      format            = "PDF"
		       	  pagetype          = "letter"
		   	      orientation       = "portrait"
		          unit              = "in"
		   	      encryption        = "none"
		    	  fontembed         = "No"
		       	  backgroundvisible = "No"
		          overwrite         = "Yes">
										
					<cfoutput>#HTMLCodeFormat(t)#</cfoutput> 
		
				</cfdocument>
			
				<!--- HTML --->
				
				<cffile action="WRITE" 
				file="#Parameter.DocumentLibrary#\Claim\TCP#DocumentNo#.htm" 
				output="#HTMLCodeFormat(t)#" 
				addnewline="Yes" 
				fixnewline="No">
			
			</cfif>
	
			<cfset att = "#Parameter.DocumentLibrary#\Claim\TCP#documentNo#.pdf">
			<cfset htm = "#Parameter.DocumentLibrary#\Claim\TCP#documentNo#.htm">
			
	<cfelse>	
			
		    <cfset att = "">
			<cfset htm = "">
			<cfset t   = "No details were provided">		
			
	</cfif>		
	
	<!--- send eMail but only if the action is an External action --->		
		   	
	<cfif Action.PersonMailAction neq "" and Action.ActionTrigger eq "External">
	
			<cfquery name="Mail" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
		   	  SELECT    *
			  FROM      Ref_EntityDocument
			  WHERE     EntityCode = '#Object.EntityCode#' 
			   AND      DocumentCode IN ('#Action.PersonMailAction#') 
			</cfquery>
			
			<cfif mail.recordcount gte "1">
			
			   <cfparam name="mailsubject" default="">
			   <cfparam name="mailtext"    default="">
			   
			   <cfif FileExists("#SESSION.rootPath#\#Mail.DocumentTemplate#")>			   						    
			   	   <cfinclude template="../../../../#Mail.DocumentTemplate#">			   	
			   </cfif>	
					
				<!--- process mail template --->
					
				<cfparam name="mailSubject" default="">
				<cfparam name="mailText"    default="">
				<cfparam name="mailto"    default="oppba@un.org">
				<cfquery name="Entity" 
					datasource="AppsOrganization"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				  		 SELECT  *  
						 FROM    Ref_Entity
						 WHERE   EntityCode = 'EntClaim' 
				</cfquery>	
	 
				<!--- ----------------------------------- --->
				<!--- OVERRULE EMAIL ADDRESS WITH DEFAULT --->
				<!--- ----------------------------------- --->
				 
				<cfif entity.MailRecipient neq "">
				 
				     <cfset mailto = entity.MailRecipient>
					 
				<cfelse>
				      <cfif emailAddress NEQ ""> 
				 	 <cfset mailto =emailAddress >
					 </cfif>
					 
				</cfif>
									
				<cfmail TO          = "#mailto#"
				    	FROM        = "#mailFrom#"
						SUBJECT     = "#mailsubject#"
						FAILTO      = "NoReply"
						mailerID    = "#SESSION.welcome# Mail Engine"
						TYPE        = "html"
						spoolEnable = "Yes"
						wraptext    = "100">
						#mailtext#
						
						<cfif att neq "">
							<cfmailparam file = "#att#">
						</cfif>			
																						
				</cfmail>	
				   	
		   </cfif>
			   
    </cfif> 	
	
	<cfif Action.ActionTrigger eq "External">	
						  	  
		<cfquery name="UpdateWorkflow"
		   datasource="appsOrganization"
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">	  
		   UPDATE    OrganizationObjectAction
		   SET       ActionStatus     = '2', 
		             OfficerUserId    = '#SESSION.acc#',
					 OfficerLastName  = '#SESSION.last#',
					 OfficerFirstName = '#SESSION.first#', 
					 ActionMemo       = '#HTMLCodeFormat(t)#',
					 OfficerDate      = getDate()
		   WHERE     ObjectId IN
		                 (SELECT  ObjectId
		                  FROM    OrganizationObject
		                  WHERE   ObjectKeyValue4 = '#ClaimId#'
						  AND     Operational = 1) 
		   AND       ActionFlowOrder = '#Action.ActionFlowOrder#'	 
		</cfquery> 
				
	</cfif>	
	
</cfloop>	
	  
<cfquery name="reset"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	UPDATE Claim
	SET   PointerChange = '0'
	WHERE PointerChange = '1'
</cfquery>	

<cfquery name="setUpload"
   datasource="appsTravelClaim"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	UPDATE stExportFile
	SET   ActionStatus = '2'
	WHERE ExportNO IN (SELECT ExportNo 
	                   FROM Claim C 
					   WHERE ActionStatus > '3')
</cfquery>	
