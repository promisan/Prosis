
<cfoutput>

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   UserDashboard
WHERE  Account = '#SESSION.acc#'
AND    DashBoardFrame = '#URL.frm#'
</cfquery>

<cfif Get.ReportType eq "Topic" and Get.ReportId neq "">

	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   * 
	FROM     Ref_ModuleControl 
	WHERE    SystemFunctionId = '#Get.ReportId#'
	</cfquery>
	
	<cfset id   = "#SearchResult.SystemFunctionId#">
	<cfset name = "#SearchResult.FunctionName#">
	<cfset cl   = "topic">
	
	
<cfelseif Get.ReportId neq "">

	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     UserReport U
	WHERE    ReportId = '#Get.ReportId#'
	</cfquery>
	
	<cfset id     = "#SearchResult.ReportId#">
	<cfset name   = "#SearchResult.DistributionName#">
	<cfset cl     = "report">
    	
<cfelse>	

	<cfset name = "undefined">
    <cfset id     = "">
	<cfset cl     = "">
	
</cfif>

<cfset ban = "ffffff">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

<tr><td height="25">

	<table width="100%"
	   border="0"
       cellspacing="0"
       cellpadding="0"
       align="center">
	   	   
	   <tr>
	   
	   <td height="25" style="padding-left:10px" class="labelmedium"><i>#name#</td>	   
	   <td align="right" style="padding-right:4px">
	   
		   <table cellspacing="0" cellpadding="0" class="formpadding">
		   
			   <tr>
							
				<td height="25" align="center" style="background-color: #ban#;">
				   
				    <!--- select other --->			
					<button type="button" class="button1" onclick="item('#url.frm#','#url.loc#','#id#')" style="width:45;height:22">
						<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/select2.gif"
						onMouseOver="window.status='Select dashboard content'"
						onMouseOut=""
						alt="Select dashboard content"
						align="absmiddle">
					</button>
					
				</td>
				
				<td style="background-color: #ban#;" align="center">
				    <!--- edit --->
				    <cfif cl eq "report" and id neq "">
					    <button type="button" class="button1" onclick="schedule('#id#')" style="width:45;height:22">
							<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/edit.gif" alt="Topic parameter settings" border="0" 
							onMouseOver="window.status='Variant parameter definition'"
							align="absmiddle"
							onMouseOut="">
						</button>
					</cfif>
					
				</td>
							
				<td style="background-color: #ban#;" align="center">
				    <!--- edit --->
				    <cfif cl eq "topic" and id neq "">
					    <button type="button" class="button1" onclick="edit('#url.frm#','#url.loc#','#id#')" style="width:45;height:22">
							<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/edit.gif" alt="Topic parameter settings" border="0" 
							onMouseOver="window.status='Topic parameter definition'"
							align="absmiddle" onMouseOut="">
						</button>
					</cfif>
					
				</td>
					
				<td style="background-color: #ban#;" align="center">
				    <!--- full screen --->
					<cfif cl eq "topic" and id neq "">
					<button type="button" class="button1" onclick="zoom('#id#')" style="width:45;height:22">
						<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/locate3.gif" height="15" width="17" alt="Zoom-in to topic details" border="0"
						align="absmiddle">
					</button>
					</cfif>
					
				</td>	
				
				<td style="background-color: #ban#;" align="center">
				    <!--- full screen --->
					<cfif cl eq "report" and id neq "">
					<button type="button" class="button1" onclick="report('#id#')" style="width:45;height:22">
						<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/pdf_small.gif" alt="Open report" border="0"
						align="absmiddle">
					</button>
					</cfif>
					
				</td>	
					
				<td style="background-color: #ban#;">
				
					<cfif id neq "">	
							
						<button class="button1" type="button" 
						       onclick="ColdFusion.navigate('DashboardGadgetItem.cfm?frm=#url.frm#&loc=#url.loc#','#url.loc#')" 
							   style="width:45;height:22">
						 	<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/refresh.gif"
							    alt="Refresh" 
								border="0" 
								height="15" width="17"
								align="absmiddle" 
								style="cursor: pointer;" 				
								onMouseOver="window.status='Refresh'">
						</button>	
							
					</cfif>	
					
				</td>
											   
			   </table>
			   
		   </td>
		   		   
		   <tr><td height="1" colspan="8" class="linedotted"></td></tr>		  		  
				
		</tr>
		
		<tr><td height="1" colspan="8" class="linedotted"></td></tr>
	
	</table>
	
</td></tr>

<tr><td valign="top" height="100%" id="box_#url.loc#">

    <cfset url.mode     = "dashboard">
    <cfset url.category = "dashboard">
	<cfset url.userid   = SESSION.acc>

	<cfif Get.ReportType eq "Topic" and id neq "">

	   <cfparam name="URL.edit" default="0">
	   
	   <cfif url.edit eq "0">
		   	<cfset ed = "">
	   <cfelse>
		    <cfset ed = "edit">
	   </cfif>	
			  
	   <cfset url.id       = id>
	   <cfset systemfunctionid = id>
	   
	   <iframe src="Topic.cfm?id=#id#&mode=dashboard"
        width="100%"
        height="100%"
        frameborder="0"/>
	  				
	<cfelseif id neq "">
	
		<cfset url.reportid  = id>
		
		<iframe src="../../Tools/cfreport/ReportSQL8.cfm?reportid=#id#&mode=dashboard&category=Dashboard&userid=#SESSION.acc#"
        width="100%"
        height="100%"
        frameborder="0"/>		
									
	<cfelse>
		
	</cfif>
	
</td></tr>

</table>

</cfoutput>

