
<cf_screenTop height="100%" label="Reporter distribution batch" html="No" band="No" jQuery="Yes" scroll="no">
		
	<cfparam name="URL.dts"        default="#dateformat(now(),client.dateformatshow)#">	
	<cfparam name="URL.Mode"       default="schedule">
	<cfparam name="URL.FormSelect" default="Batch">	
	
	<!--- create an instance as we bypass from the backoffice or trial mode --->
			
	<cfif url.mode neq "schedule" and url.mode neq "manual">
		
		<cf_assignId>
	
		<cfset schedulelogid = rowguid>
		
		<cfquery name="Schedule"
		datasource="AppsSystem">	
		    SELECT * 
			FROM   Schedule
			WHERE  ScheduleName = 'ReportBatch'			
		</cfquery>
		
		<cfquery name="Insert"
		datasource="AppsSystem">
		    INSERT INTO ScheduleLog
			       (ScheduleId, 
				    ScheduleMode,
				    ScheduleRunId,
					OfficerUserId,
					OfficerFirstName,
					OfficerLastName)
			VALUES ('#Schedule.scheduleId#',
			        '#url.mode#',
			        '#schedulelogid#',
					'#SESSION.acc#',
					'#SESSION.first#',
					'#SESSION.last#') 
		</cfquery>
					
	</cfif>
	
	<cfif url.mode eq "Trial">
	   <cfset class = "Trial">
	   <cfset CLIENT.TrialMode = "1">
	<cfelse>
	   <cfset class = "Schedule">  
	   <cfset CLIENT.TrialMode = "0">
	</cfif> 
		
	<cfparam name="URL.Batch" default="1">
			
	<!--- set the dates	to work with --->
			 
	<CF_DateConvert Value="#URL.dts#">
	<cfset STR = dateValue>	
	<cfset PRI = dateadd("D","-1",STR)>
	<cfset END = dateadd("D","1",STR)>			
	
	<!--- external reports are not supported for batch eMail --->
	
	<cfquery name="Batch" 
	datasource="AppsSystem">
		SELECT DISTINCT U.*, 
		       L.LayoutId, 
			   L.LayoutClass, 
			   L.LayoutName, 
			   R.FunctionName, 
			   R.SystemModule,
		       R.ControlId, 
			   R.ReportRoot, 
			   R.ReportPath, 
			   R.TemplateSQL
		FROM  UserReport U,
		      Ref_ReportControlLayout L,
		      Ref_ReportControl R, 
		      Ref_SystemModule S,
			  UserNames Usr
		WHERE U.LayoutId           =  L.LayoutId
		AND   L.ControlId          =  R.ControlId
		AND   Usr.Account          =  U.Account
		AND   R.SystemModule       =  S.SystemModule
		AND   U.DateEffective      <= #STR# 
		AND   U.DateExpiration     >= #STR#
		AND   U.DistributionEMail  > ''
		AND   U.Status             != '5'
		AND   U.DistributionPeriod != 'Manual'
		AND   L.Operational         = '1'
		AND   Usr.Disabled          = '0'
		AND   R.Operational         = '1'
		AND   S.Operational         = '1' 
		AND   R.TemplateSQL        != 'External' 
				
		<cfif class neq "Trial">
		
		<!--- exclude reports that were created as part of a batch of the select date --->
		
		AND   U.ReportId NOT IN (
                         SELECT     D.ReportId
					     FROM       ReportBatchLog Log INNER JOIN
			                        UserReportDistribution D ON Log.BatchId = D.BatchId
					     WHERE      Log.Created = #STR# 
					     AND        Log.ProcessClass != 'Trial'
					     -- AND        D.Account != 'administrator'
					     ) 							
								 
		</cfif>		
		
		ORDER BY U.Account  
	</cfquery>
	
	<cfset row = 0>
	
	
	<table width="96%" border="0" align="center" class="navigation_table">
	   <tr><td>&nbsp;</td></tr>
	   <tr class="labelmedium line">
	      <td width="5%" height="20" style="padding-left:5px"><cf_tl id="No"></td>
	      <td width="10%"><cf_tl id="Account"></td>
		  <td width="20%"><cf_tl id="Name"></td>
		  <td width="10%"><cf_tl id="Mode"></td>
		  <td width="20%"><cf_tl id="eMail"></td>
		  <td width="20%"><cf_tl id="Report"></td>
		  <td width="15%"><cf_tl id="Stamp"></td>
	   </tr>
	  
	   <cfif Batch.recordcount eq "0">
	   <tr><td colspan="7" height="1" align="center"><font color="FF0000"><cf_tl id="No reports to be distributed"></font></td></tr>  
	   </cfif>
	      
	</table>
	
	<cfflush>
	
	<cf_assignId>   
	
	<cfquery name="Log" 
	datasource="AppsSystem">
		INSERT INTO ReportBatchLog 
				(BatchId,
				 ProcessClass, 
				 ProcessStart, 
				 OfficerUserId, 
				 ProcessStatus, 
				 Created)
		VALUES  ('#ROWGUID#',
		        '#class#', 
		        getDate(), 
				'#CGI.Remote_Addr#', 
				'In process', 
				#STR#) 
	</cfquery>
	
	<cfset batchid = rowguid>
	
	<cfset sent = 0>	
		
	<cfoutput query="Batch">	
		
		<!--- check current access to report --->

		<cfset access = "Granted">
		  
		<cfif access is "GRANTED">
		
			<cfset report = "No">
		
			<cfswitch expression="#DistributionPeriod#">
			
				<cfcase value="Daily">
				    <cfset report = "Yes">
				</cfcase>
				
				<cfcase value="Weekly">
				    <cfset day = DayOfWeek(STR)>
					<cfloop index="d" list="#DistributionDOW#" delimiters="|">
						<cfif d eq day>
						    <cfset report = "Yes">
						</cfif>
					</cfloop> 
				</cfcase>
				
				<cfcase value="Monthly">
				    <cfif DistributionDOM eq "0">
						<cfif Day(STR) eq Day(DateEffective)>
						    <cfset report = "Yes">
						</cfif>
					<cfelse>
						<cfif Day(STR) eq DistributionDOM>
						    <cfset report = "Yes">
						</cfif>
					</cfif>
				</cfcase>
		
			</cfswitch>	
							
			<cfif Report eq "Yes">
	
					<cfset row = row+1>
				   							
					<!--- log the report --->
					
					<cfif class neq "Trial">
										
						<cf_ScheduleLogInsert
						   	ScheduleRunId  = "#schedulelogid#"
							Description    = "#Account# - #FunctionName#">
						
					</cfif>
					
					<cfset prepS = now()>		
									
					<cfset URL.ReportId = "#reportId#">
					<cfset URL.Mode     = "Distribution">
													
					<cfset condition = "1">
					
					<!--- perform the report --->
					
					<cfparam name="URL.GUI"     	default="HTML">
					<cfparam name="URL.Status"     	default="1">
					<cfparam name="URL.Mode"     	default="distribution">
					<cfparam name="URL.ReportId" 	default="00000000-0000-0000-0000-000000000000">
					<cfparam name="URL.ControlId" 	default="00000000-0000-0000-0000-000000000000">
					
					<!--- define the criteria from the report --->
					<cfparam name="Form.LayoutId"   default="00000000-0000-0000-0000-000000000000">
					<cfparam name="Form.FileFormat" default = "FlashPaper">
						
					<cfset serial = row+99>   <!--- counting from 100 --->
					
					<table width="96%" border="0" align="center">				
				     <tr class="labelmedium line">
					    <td width="5%" style="padding-left:5px">#serial#</td>
					    <td width="10%">#Account#</td>
						<td width="20%">#DistributionName#</td>
						<td width="10%">#DistributionMode#</td>
						<td width="20%"><cfloop index="itm" list="#DistributioneMail#">#itm#<br></cfloop></td>
					    <td width="20%">#FunctionName#</td>		
						<td width="15%">#dateformat(now(),CLIENT.DateFormatShow)# #timeformat(now(),"HH:MM:SS")#</td>		
					 </tr>
					 </table>	
						
					<cfset answer1      = "t#Serial#Answer1">
					<cfset answer2      = "t#Serial#Answer2">
					<cfset answer3   	= "t#Serial#Answer3">
					<cfset answer4      = "t#Serial#Answer4">
					<cfset answer5      = "t#Serial#Answer5">
					<cfset answer6      = "t#Serial#Answer6">
					<cfset answer7      = "t#Serial#Answer7">
					<cfset answer8      = "t#Serial#Answer8">
					<cfset answer9      = "t#Serial#Answer9">
					<cfset answer10     = "t#Serial#Answer10">
					<cfset answer11     = "t#Serial#Answer11">
					<cfset answer12     = "t#Serial#Answer12">
					<cfset answer13  	= "t#Serial#Answer13">
					<cfset answer14  	= "t#Serial#Answer14">
					<cfset answer15  	= "t#Serial#Answer15">
					<cfset answer16  	= "t#Serial#Answer16">
					<cfset answer17  	= "t#Serial#Answer17">
					<cfset answer18  	= "t#Serial#Answer18">
					<cfset answer19  	= "t#Serial#Answer19">
					<cfset answer20  	= "t#Serial#Answer20">
					<cfset answer21  	= "t#Serial#Answer21">
					<cfset answer22  	= "t#Serial#Answer22">
					<cfset answer23  	= "t#Serial#Answer23">
					<cfset answer24  	= "t#Serial#Answer24">
					<cfset answer25  	= "t#Serial#Answer25">
					<cfset answer26  	= "t#Serial#Answer26">
					<cfset answer27  	= "t#Serial#Answer27">
					<cfset answer28  	= "t#Serial#Answer28">
					<cfset answer29  	= "t#Serial#Answer29">
					<cfset answer30  	= "t#Serial#Answer30">
					<cfset answer31  	= "t#Serial#Answer31">
					<cfset answer32  	= "t#Serial#Answer32">
					<cfset answer33  	= "t#Serial#Answer33">
					<cfset answer34  	= "t#Serial#Answer34">
					<cfset answer35  	= "t#Serial#Answer35">
					<cfset answerOrg 	= "t#Serial#Answer99">
					<cfset answerOrgAccess = "t#Serial#Answer99_Access">
											
					<!--- retrieve criteria for SQL.cfm --->
					
					<!--- clean all variables --->
					<cfset StructClear(Form)>
												
					<cfinclude template="ReportCriteria.cfm">
																	
					<cfset table1   	= "T#Serial##UserReport.LayOutCode#_qTable1">
					<cfset table2   	= "T#Serial##UserReport.LayOutCode#_qTable2">
					<cfset table3   	= "T#Serial##UserReport.LayOutCode#_qTable3">
					<cfset table4   	= "T#Serial##UserReport.LayOutCode#_qTable4">
					<cfset table5   	= "T#Serial##UserReport.LayOutCode#_qTable5">
					<cfset table6   	= "T#Serial##UserReport.LayOutCode#_qTable6">
					<cfset table7   	= "T#Serial##UserReport.LayOutCode#_qTable7">
					<cfset table8   	= "T#Serial##UserReport.LayOutCode#_qTable8">
					<cfset table9   	= "T#Serial##UserReport.LayOutCode#_qTable9">
					<cfset table10  	= "T#Serial##UserReport.LayOutCode#_qTable10">
					
					<cfinclude template="SQLDropTable.cfm"> 
					
					<cfset variable1    = "">
					<cfset variable2    = "">
					<cfset variable3    = "">
					<cfset variable4    = "">
					<cfset variable5    = "">
					<cfset variable6    = "">
					<cfset variable7    = "">
					<cfset variable8    = "">
					<cfset variable9    = "">
					<cfset variable10   = "">
					
					<cfset st = "1">							
						
					<!--- retrieve report definitions --->
					<cf_ReportLocation layoutid="#layoutid#">
					
					<cf_assignid>
					<cfset url.distribid  = rowguid>
					<cfset distributionid = rowguid>
					
					<cfquery name="Log" 
						datasource="AppsSystem">							
						 INSERT INTO UserReportDistribution 		
								 (DistributionId,
								  ReportId,
								  ControlId,
								  SystemModule,
								  FunctionName,  
								  LayoutClass,
								  LayoutName,
								  FileFormat, 
								  Account,
								  NodeIP,
								  PreparationStart,									 
								  DistributionPeriod, 
								  DistributionName, 
								  DistributionSubject, 
								  DistributionEMail, 
								  DistributionCategory, 
								  DistributionStatus,
								  OfficerUserid, 
								  OfficerLastName,
								  BatchId,
								  BatchSerialNo) 
						 VALUES ('#distributionid#',
							     '#ReportId#', 
							     '#ControlId#',
							     '#SystemModule#',
								 '#FunctionName#',
								 '#LayoutClass#',
								 '#LayoutName#',
								 '#FileFormat#',
								 '#Account#',
								 '#CGI.Remote_Addr#',  
								 #PrepS#,									 
								 '#DistributionPeriod#',
							     '#DistributionName#',
							     '#DistributionSubject#', 
								 '#DistributionEMail#',
								 '#DistributionMode#',
								 '#Condition#',
								 '#session.acc#',  
								 'Batch',
								 '#BatchId#',
								 '#serial#') 
				    	</cfquery>						
												
					<cfif class eq "Trial">											
					
					    <!--- REPORT IS RUN WITHOUT CFTRY CONDITION --->
					
						<cfif UserReport.TemplateSQL eq "Application" or 
						      UserReport.TemplateSQL eq "External" or 
							  UserReport.TemplateSQL eq "">
							 									 					
							<!--- data preparation was already finished --->
			
						<cfelse>
						
						<cfif UserReport.TemplateSQLIsolation eq "1">
				
								<cftransaction isolation="READ_UNCOMMITTED">
								
									<cfinclude template="#reportSQL#">
								
								</cftransaction>
							
							<cfelse>
						
								<cfinclude template="#reportSQL#">
								
							</cfif>													
									
						</cfif>
					
						<cfinclude template="ReportPrepareN.cfm">														
						
					<cfelse>
					
						<cftry>
						
							<cfif UserReport.TemplateSQL eq "Application" or 
						      UserReport.TemplateSQL eq "External" or 
							  UserReport.TemplateSQL eq "">
							 									 					
							<!--- data preparation was already finished --->
			
							<cfelse>
	
								<!--- <cfinclude template="#reportSQL#"> --->
																		
								<cfif UserReport.TemplateSQLIsolation eq "1">
				
									<cftransaction isolation="READ_UNCOMMITTED">
									
										<cfinclude template="#reportSQL#">
									
									</cftransaction>
							
								<cfelse>
						
									<cfinclude template="#reportSQL#">
								
								</cfif>													
									
							</cfif>
						
							<!--- generate report --->
							<cfinclude template="ReportPrepareN.cfm">
							
							<cf_ScheduleLogInsert
							   	ScheduleRunId  = "#schedulelogid#"
								Description    = "Report Preparation Finished"
								StepStatus     = "1">
						
							<cfcatch>
							
								<cfset condition = "9">
								
								<cf_ScheduleLogInsert
								   	ScheduleRunId  = "#schedulelogid#"
									Description    = "#Account# - #FunctionName#"
									StepStatus     = "9"
									StepException  = "Problem with report : #CFCATCH.Detail#">
							
								<table width="96%" border="0" align="center">
								      <tr>				
									  <td>
									  	<td class="labelmedium linedotted"><font color="FF0000">Problem with report. Report has been skipped</font></td>
									  </tr>
								<table>
							
							</cfcatch>
					
						</cftry>
						
					</cfif>	
									
					<cfset st = "1">
										
					<cf_waitEnd>
					
					<cfif condition eq "1">
					 	<cfset sent = sent+1>
					</cfif>										
					
					<cfset diff = datediff("s",  PrepS,  now())>
					<cfif diff eq "0">
						 <cfset diff = "800">							
					<cfelse>
						<cfset diff = (diff*1000)+600>
					</cfif>  
					
					<!--- ------------------------ --->
				    <!--- ----- audit logging ---- --->
					<!--- ------------------------ --->
		 
					<cfinvoke component = "Service.Audit.AuditReport"  
					  	method              = "EndReport"
						DistributionId      = "#distributionid#">																					
											
				<cfinclude template="SQLDropAnswer.cfm">							
				<cfinclude template="SQLDropTable.cfm"> 	
									
			</cfif>
					
		</cfif>	
	
	</cfoutput>
			
	<cfif batch.recordcount gte 1>
		<cfset Status = "Completed">
	<cfelse>
		<cfset Status = "Empty">
	</cfif>
	
	<cfquery name="Log" 
	datasource="AppsSystem">
		UPDATE ReportBatchLog
		SET    ProcessEnd    = getDate(),
		       eMailSent     = #sent#,
			   ProcessStatus = '#Status#' 
		WHERE  BatchId       = '#BatchId#'
	</cfquery>
	
	<cfif row gte 1 and sent gte "1">
	
		<cfquery name="Log" 
		datasource="AppsSystem">
			SELECT *
			FROM ReportBatchLog
			WHERE BatchId = '#BatchId#'
		</cfquery>
		
		<cfset sec = (Log.ProcessEnd-Log.ProcessStart)>
		<cfset sec = int(sec*24*60*60)>
		
		<cfquery name="Log" 
		datasource="AppsSystem">
			UPDATE ReportBatchLog
			SET    AvgTimeEmail = #sec#/eMailSent
			WHERE  BatchId = '#BatchId#'
		</cfquery>
	
	</cfif>
	
	<table>
	<tr><td style="padding-left:20px" height="30" class="labelmedium">	
	Completed <cfif class eq "Trial"><br>Test Mode : No eMails were sent except for administrator account</cfif>	
	</td></tr>
	</table>
	
