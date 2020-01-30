<!--- Email Parser for Mantinsa
by Armin Mazariegos 
Guatemala, November 20th 2012
Promisan b.v.
In this case we apply the concept of thread as image files might be so big (>1.5k) that processing of the files are an issue 
--->

<cfparam name="schedulelogid" default="">	

<cfset CFPopAttributes = {
	server = "172.16.7.53",
	username = "foto",
	password = "mantinsa12/"} />
  
<cflock name="mantinsa_lock"
	type="exclusive"
	timeout="40">
		
	<cfpop action="GETALL" name="qHeader" attributecollection="#CFPopAttributes#"/>	 
	
	<cfquery name="qEmail" dbtype="query">
		SELECT   [from], subject, uid, [date], textbody
		FROM     qHeader 
		ORDER BY [date] ASC
	</cfquery>

	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Getting emails #qEmail.recordcount#"
		StepStatus     = "0">	
	
</cflock>
 
		
 
<cfloop query="qEmail">

	<cfset dateValue = DateFormat(Date,CLIENT.DateSQL)> 
	<cfset timeValue = TimeFormat(Date,"HH:MM")> 

	<cfthread action="run"
			name="get#qEmail.uid#"
			uid="#qEmail.uid#"
			from="#qEmail.from#"
			subject="#qEmail.subject#"
			textbody="#qEmail.textbody#"
			datevalue="#dateValue#"
			timevalue="#timeValue#">
	
		<cflock	name="mantinsa_lock"
				type="exclusive"
				timeout="300">	
		
				<cfquery name="WorkOrderLineAction" 
					 datasource="NovaWorkOrder" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT TOP 1 *
					 FROM   WorkOrderLineAction A
					 INNER  JOIN 
								 (
									 SELECT WorkActionId, MIN(DateTimePlanning) AS DateTimePlanning 
									 FROM   WorkOrderLineAction
								     WHERE  WorkOrderid = (
									 	 SELECT TOP 1 WorkOrderId
									 	 FROM   WorkOrderLine
									 	 WHERE  DateEffective <= '#ATTRIBUTES.dateValue#'
									 	 AND    ( DateExpiration >= '#ATTRIBUTES.dateValue#' OR DateExpiration IS NULL)
									 	 AND    Reference = '#ATTRIBUTES.Subject#'
									 ) 
									AND ActionStatus = '1'
									GROUP BY WorkActionId
								) A2
								ON A.WorkActionId = A2.WorkActionId AND A.DateTimePlanning = A2.DateTimePlanning
					
					INNER JOIN WorkOrderLine WL ON WL.WorkOrderId = A.WorkOrderId and WL.WorkOrderLine=A.WorkOrderLine
					WHERE 	 WL.Reference = '#ATTRIBUTES.Subject#'					
											
					AND      A.DateTimePlanning>='#ATTRIBUTES.dateValue#'
					ORDER BY A.DateTimePlanning ASC					
				</cfquery>				
				
<!---Armin the following condition was removed 
	AND      A.DateTimePlanning <='#ATTRIBUTES.dateValue# #ATTRIBUTES.timeValue#'
	
	Also, the following was changed from
						ORDER BY A.DateTimePlanning ASC
				to
						ORDER BY A.DateTimePlanning DESC		    
---->
				
				<cf_ScheduleLogInsert
   					ScheduleRunId  = "#schedulelogid#"
					Description    = "Query for the email - returned #WorkOrderLineAction.recordcount#"
					StepStatus     = "0">
				
				
				<cfif WorkOrderLineAction.RecordCount gt 0>

					<cfset newDir = SESSION.rootDocumentPath & "/Workorder/#WorkOrderLineAction.WorkActionId#">			
			
					<cfif not DirectoryExists (newDir)>
						<cfdirectory  action= "create" directory= "#newDir#"  type= "dir">
					</cfif>
			
					<cfpop	action="getall"
							name="qMail"
							uid="#ATTRIBUTES.uid#"
							attachmentpath="#ExpandPath( '../../../../../../../../Shared/Apps/CFRStage/WorkOrder/' )#"
							generateuniquefilenames="no"
							attributecollection="#CFPopAttributes#"/>							


					<cf_ScheduleLogInsert
					   	ScheduleRunId  = "#schedulelogid#"
						Description    = "Files in mail #qMail.attachmentfiles#"
						StepStatus     = "0">	
					
					<cfloop index="strFilePath" list="#qMail.attachmentfiles#" delimiters="#Chr(9)#">
					
						<!---
						<cf_AssignId>							
						<cfset eId = rowguid>		
					
						<cfset vName = "#eId#_#GetFileFromPath(strFilePath)#">
						---->
						
						<cfset vName = "#GetFileFromPath(strFilePath)#">
						
						<cf_ScheduleLogInsert
						   	ScheduleRunId  = "#schedulelogid#"
							Description    = "Reading file #vName#"
							StepStatus     = "0">		

						<cfquery name="qCheck" 
						 datasource="NovaSystem" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 	 SELECT *
							  FROM Attachment
							  WHERE ServerPath = 'WorkOrder/#WorkOrderLineAction.WorkActionId#/'
							  AND FileName     = '#vName#'
						</cfquery>	 

						<cfif qCheck.recordcount eq 0>
					
					    <cfif right(vName,4) neq ".txt">  <!--- suppress .txt file of iPhone --->
												
							
							<cffile action="move" source="#strFilePath#" destination="#newDir#/#vName#"> 
				
							<cfset vFrom = reReplaceNoCase(ATTRIBUTES.from, "^([^<]*<)|(>[^>]*)$", "", "all")>
				
							<cfquery name="GetUser" 
							 datasource="NovaSystem" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							 	SELECT TOP 1 Account,FirstName,LastName 
								 FROM
								 UserNames 
								 WHERE emailAddress = '#vFrom#'
							 </cfquery>
							 
							<cfif GetUser.recordcount neq 0>
									<cfset vFirst 	= GetUser.FirstName>
									<cfset vLast 	= GetUser.LastName>
									<cfset vUserId 	= GetUser.Account> 
							<cfelse>
									<cfset vFirst 	= "Prosis">
									<cfset vLast 	= "Prosis">
									<cfset vUserId 	= "Prosis"> 
							</cfif>		 
 
				
				
							<cfquery name="Attachment" 
							 datasource="NovaSystem" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							 	INSERT INTO Attachment
									    (Server, 
										 ServerPath, 
										 FileName, 
										 FileStatus, 
										 Reference, 
										 AttachmentMemo,
										 OfficerUserId, 
										 OfficerLastName, 
										 OfficerFirstName, 
										 Created)
								VALUES ('document',
								        'WorkOrder/#WorkOrderLineAction.WorkActionId#/',
										'#vName#',
										'1',
										'#WorkOrderLineAction.WorkActionId#',
										'#left(Attributes.textBody,400)# (#ATTRIBUTES.from#)',
										'#vUserId#',
										'#vLast#',
										'#vFirst#',
										getdate())
							</cfquery>
							
						</cfif>
							
						</cfif>
 
					</cfloop>					
				</cfif>		
				
				<!---			
				<cfpop action="delete" uid="#ATTRIBUTES.uid#" attributecollection="#CFPopAttributes#"/>
				--->

	 	</cflock>

	</cfthread>

</cfloop>

