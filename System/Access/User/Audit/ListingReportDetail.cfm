
<cfquery name="Report" 
	datasource="AppsSystem"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM UserReportDistribution
	WHERE  DistributionId = '#URL.drillid#'	
</cfquery>

<cf_screentop height="100%" scroll="No" band="Yes" label="My Archived Report #Report.FunctionName#" banner="gray" jquery="yes" layout="webapp">

<cf_layoutScript>

<cfoutput>

	<cf_layout id="mainReportDetail" type="border">
	
		<cf_layoutArea 
			name="left" 
			position="left" 
			collapsible="true"
			size="350px">
			
				<table width="97%" border="0" align="center" cellspacing="0" cellpadding="0">
				
					<tr class="line labelmedium">
						<td colspan="2" style="font-size:20px;font-weight:200;height:40px">About this report</td>
					</tr>
					
					<tr><td height="5"></td></tr>
				   				
					<tr class="labelmedium line">
					    <td width="130">Module:</td>
					    <td>#Report.SystemModule#</td>
					</tr>
					
					<tr class="labelmedium line">	
						<td>Preparation:&nbsp;</td>
					    <td>#dateformat(Report.PreparationEnd,CLIENT.DateFormatShow)# #timeformat(Report.PreparationEnd,"HH:MM:SS")#</td>
					</tr>									
					
					<tr class="labelmedium line">	
						<td>Name:</td>
					    <td>#Report.FunctionName#</td>
					</tr>
					<tr class="labelmedium line">	
						<td>Start Extraction:</td>
					    <td>#dateformat(Report.PreparationStart,CLIENT.DateFormatShow)# #timeformat(Report.PreparationStart,"HH:MM:SS")#</td></tr>					
					</tr>
					
					<tr class="labelmedium line">
					    <td>Layout:</td>
					    <td>#Report.LayoutName#</td>
					</tr>
					<tr class="labelmedium line">	
						<cfif Report.PreparationEnd neq "">
							<td>Duration:</td>
						    <td>
							<cfif DateDiff("s", Report.PreparationStart, Report.PreparationEnd) lte "1">
							less than 1 second
							<cfelse>
							#DateDiff("s", Report.PreparationStart, Report.PreparationEnd)# seconds
							</cfif>
						</td>	
						</cfif>	
					</tr>
					<tr class="labelmedium line">
						<td>Output Format:</td>
					    <td>#Report.FileFormat#</td>
					</tr>
					<tr class="labelmedium line">	
						<td>Category:</td>
					    <td>#Report.DistributionCategory#</td>		
					</tr>
					<tr class="labelmedium line">	
					    <td>Status:</td>
					    <td><cfif report.distributionstatus eq "9"><font color="FF0000">Failed</font><cfelse><font color="green">Successfull</cfif></td>
					</tr>
											
						<cfif Report.BatchId neq "">
						
						  <cfquery name="Batch" 
							datasource="AppsSystem"
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT * 
							FROM   ReportBatchLog
							WHERE  BatchId = '#Report.BatchId#'	
						  </cfquery>
							
							<tr><td height="4"></td></tr>	
							<tr class="labelmedium line">
							<td style="font-weight:200;height:40px;font-size:20px" colspan="2">Report batch</td></tr>	
							
							<tr class="labelmedium line">
							  <td>Report Name:</td>
							  <td>#Report.DistributionName#</td>
							</tr>
							<tr class="labelmedium line">							  
							  <td>Mail to:</td>
							  <td>#Report.DistributionEMail#</td>
				 		    </tr>
							<tr class="labelmedium line">
							  <td>Batch Date:</td>
							  <td>#dateformat(Batch.ProcessStart,CLIENT.DateFormatShow)#</td>
							 </tr>
							 <tr class="labelmedium line"> 
							  <td>Batch Run on Host:</td><td>#Batch.OfficerUserId#</td>
							</tr>
							<tr class="labelmedium line"><td>Status:</td><td>#Batch.ProcessStatus#</td></tr>
							
						<cfelse>
						
						  <tr class="labelmedium line"><td>Run on Host:</td><td>#Report.HostName#</td></tr>		
						  <tr <tr class="labelmedium line"><td>Requester IP:</td><td>#Report.NodeIP#</td></tr>		
							
						</cfif>
						
							
				</table>
			
		</cf_layoutArea>
		
		
		<cf_layoutArea 
			name="center" 
			position="center" 
			collapsible="true"
			size="300px">
			
				<table width="100%"
					height="99%"
					border="0"
					cellspacing="0"
					cellpadding="0"
					class="formpadding"
					align="center"
					bordercolor="C0C0C0">
					
					<cfif report.fileFormat eq "Excel">
					
						<cfset suf = "XLS">
					
					<cfelse>
					
						<cfset suf = "#report.fileFormat#">
					
					</cfif>
					
					<cfif fileexists("#SESSION.rootdocumentpath#/CFReports/#report.account#/#report.distributionId#.#suf#")>
					
						<tr><td height="100%" width="100%">
						
						<cfoutput>
						
							<iframe name="reportembed"
							width="100%"
							height="100%"
							marginwidth="1"
							marginheight="1"
							frameborder="0">
							</iframe>		
							
							<cf_loadpanel id="reportembed" template="#SESSION.rootdocument#/CFReports/#report.account#/#report.distributionId#.#suf#">				
						
						</cfoutput>
						
						</td></tr>
					
					<cfelse>	
					
						<cfif report.layoutclass eq "Report">
							<tr><td height="500" width="100%" align="center">
								<font face="Verdana" size="3" color="0080FF">Sorry, a copy of this report is not available anymore</font>
							</td></tr>
						<cfelse>
							<tr><td height="500" width="100%" align="center">
								<font face="Verdana" size="3" color="0080FF">Sorry, a copy of this view is not captured at this point</font>
							</td></tr>
						</cfif>
					
					</cfif>
				
				</table>
			
		</cf_layoutArea>
		
	</cf_layout>
	
</cfoutput>