
<cfajaximport tags="cfmenu,cfdiv,cfwindow">
<cf_ActionListingScript>
<cf_FileLibraryScript>
	
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   	SELECT 	  Mission, 
	          ServiceItem, 
			  MIN(SelectionDateExpiration) as SelectionDate
	FROM 	  ServiceItemMissionPosting
	WHERE	  ActionStatus = '0' --closed
	GROUP BY  Mission, ServiceItem
	ORDER BY  Mission, ServiceItem
</cfquery>

<cfset add = 0>

<cfinclude template = "../HeaderMaintain.cfm"> 

<cf_divscroll>

<table width="90%" border="0" align="center">  	

<cfset columns = 8>
<tr><td>

	<table width="100%" border="0" cellspacing="1" cellpadding="1" align="center" class="navigation_table">
	<tr><td height="10"></td></tr>
	<cfoutput>
	<tr><td height="50" colspan="#columns#" class="labellarge">Billing for services</td></tr>
	<tr><td height="5"></td></tr>
	<tr class="labelmedium line">
	    <td width="5%"></td> 
		<td>Enabled Services</td>
		<td>Start</td>
		<td>End</td>	
		<td align="center" width="100">Enabled</td>	
		<td align="center">Batch Process Date</td>
		<td align="center" width="100">Closing Status</td>
		<td align="center" width="100">Execute</td>
	</TR>
	
	</cfoutput>
	
	<cfoutput query="SearchResult" group="mission">
	
			<tr><td height="5" colspan="#columns#"></td></tr>
			<tr class="line labelmedium"><td height="33" colspan="#columns#"><b>#mission#</td></tr>
					
			<cfoutput>
	
				<cfinvoke component = "Service.Access"  
				   method           = "WorkorderProcessor" 
				   mission          = "#SearchResult.Mission#" 
				   serviceitem      = "#SearchResult.serviceitem#"	  
				   returnvariable   = "accessProcess">	
				
				<cfif accessProcess neq "NONE">	
	
					<cfquery name="getData"
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   	SELECT 	P.*,
						
								(SELECT Description 
								 FROM   ServiceItem 
								 WHERE  Code = P.ServiceItem) as ServiceItemDescription,
								 
								(SELECT DatePostingCalculate 
								 FROM   ServiceItemMission 
								 WHERE  ServiceItem = P.ServiceItem 
								 AND    Mission = P.Mission) as DatePostingCalculate,
								 
								(SELECT EnableInLinePosting 
								 FROM   ServiceItemMission 
								 WHERE  ServiceItem = P.ServiceItem 
								 AND    Mission = P.Mission) as EnableInLinePosting							 
								 
						FROM 	ServiceItemMissionPosting P
						WHERE 	P.ServiceItem	= '#serviceItem#'
						AND		P.Mission = '#mission#'
						AND		P.SelectionDateExpiration = '#selectionDate#'
					</cfquery>
					
					<cfquery name="getPreviousPeriod"
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   	SELECT 	 Mission, ServiceItem, MAX(SelectionDateExpiration) as SelectionDate
						FROM 	 ServiceItemMissionPosting
						WHERE 	 ServiceItem	= '#serviceItem#'
						AND		 Mission = '#mission#'
						AND		 SelectionDateExpiration < '#getData.SelectionDateExpiration#'
						GROUP BY Mission, ServiceItem
						ORDER BY Mission, ServiceItem
					</cfquery>
					
					<cfif getPreviousPeriod.recordCount gt 0>
					
						<cfset initialPeriod = dateAdd("d", 1, getPreviousPeriod.selectionDate)>
						
					<cfelse>
					
						<cfif getData.DatePostingCalculate neq "">
							
							<cfset initialPeriod = getData.DatePostingCalculate>
							
						<cfelse>
						
							<cfquery name="getParameterPosting"
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							   	SELECT 	DatePostingCalculate
								FROM 	Ref_ParameterMission
								WHERE	Mission = '#mission#'
							</cfquery>
							
							<cfset initialPeriod = getParameterPosting.DatePostingCalculate>
							
						</cfif>		
						
					</cfif>
					
				    <TR class="line labelmedium navigation_row"> 
					<td></td>
					<td>#getData.ServiceItemDescription# [#ServiceItem#]</td>
					<td>#dateformat(initialPeriod,'#CLIENT.DateFormatShow#')#</td>
					<td style="padding-left:5px"><!--- <cfdiv id="detailMissionPosting_#mission#_#serviceItem#" bind="url:Detail_MissionPosting.cfm?id1=#serviceItem#&id2=#mission#&id3=#dateformat(selectionDate,'yyyy-mm-dd')#"> --->
						#dateformat(selectionDate,'#CLIENT.DateFormatShow#')#
					</td>
					<td align="center" width="100">
						<cfdiv id="enableBatchProcessingMissionPosting_#mission#_#serviceItem#" bind="url:batchEnable.cfm?id1=#serviceItem#&id2=#mission#&id3=#dateformat(selectionDate,'yyyy-mm-dd')#&batch=#getData.EnableBatchProcessing#">
					</td>	
					<td align="center">
						<cfif getData.batchProcessDate eq "">
							<font color="808080">Not processed yet</font>
						<cfelse>
							#dateformat(getData.batchProcessDate,'#CLIENT.DateFormatShow#')#
						</cfif>		
					</td>		
					<td align="center" width="100">
						<cfif getData.batchProcessDate neq "">
							<cfdiv id="ActionStatusMissionPosting_#mission#_#serviceItem#" 
							     bind="url:batchStatus.cfm?id1=#serviceItem#&id2=#mission#&id3=#dateformat(selectionDate,'yyyy-mm-dd')#&actionStatus=#getData.actionStatus#">
						</cfif>
					</td>
					<td align="center" width="100">
						<cfif getData.EnableBatchProcessing eq "1" and getData.EnableInLinePosting eq "1">					
							<cfdiv id="runBatch_#mission#_#serviceItem#" 
							   bind="url:batchRun.cfm?id1=#serviceItem#&id2=#mission#&batch=#getData.EnableBatchProcessing#">
						</cfif>
					</td>					
				    </TR>
					
					<!--- future usage 
					
					<tr><td colspan="7">
					
					 <cfset wflnk = "batchWorkflow.cfm">
	   
					    <input type="hidden" 
					          id="workflowlink_#getData.postingid#" 
					          value="#wflnk#"> 
					 
					     <cfdiv id="#getData.postingid#"  bind="url:#wflnk#?ajaxid=#getData.postingid#"/>
					
					</td></tr>
					
					--->
					
				</cfif>
		</cfoutput>
		
	</cfoutput>
	
	</TABLE>

</td>
</tr>

</TABLE>

</cf_divscroll>