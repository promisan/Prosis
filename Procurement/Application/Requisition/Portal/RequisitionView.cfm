<head>
<cfoutput>
<script type="text/javascript">
  // Change cf's AJAX "loading" HTML
  _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy5.gif'/>";
</script>
</cfoutput>
</head>

<cfparam name="url.Mission"        default="">
<cfparam name="url.Period"         default="">
<cfparam name="url.context"        default="Manual">
<cfparam name="url.ItemMaster"     default="">
<cfparam name="url.requirementId"  default="">
<cfparam name="url.personno"       default="">
<cfparam name="url.orgunit"        default="">
<cfparam name="url.ID"             default="">
<cfparam name="url.menu"           default="1">

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#url.Mission#'
</cfquery>

<cfif url.personno neq "">

	<!--- obtain orgunit for the requisition --->

	<cfquery name="getAssignment" 
		datasource="AppsEmployee"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			SELECT PositionParentId 
			FROM   vwAssignment
			WHERE  PersonNo          = '#url.PersonNo#'
			AND    Mission           = '#url.mission#'
			AND    DateEffective    <= getDate()
			AND    DateExpiration   >= getDate()
			AND    AssignmentStatus IN ('0','1')
	</cfquery>	
		
	<cfquery name="getBudget" 
		datasource="AppsEmployee"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT     TOP (1) Pe.Period, Pe.OrgUnit, R.DateEffective, R.DateExpiration
		FROM       PositionParentFunding AS PPF INNER JOIN
	               Program.dbo.ProgramPeriod AS Pe ON PPF.ProgramCode = Pe.ProgramCode INNER JOIN
	               Program.dbo.Ref_Period AS R ON Pe.Period = R.Period
		WHERE      PPF.PositionParentId = '#getAssignment.positionparentid#' 
		AND        R.DateEffective <= GETDATE()
		ORDER BY   R.DateEffective DESC
	</cfquery>	

	<cfset url.orgunit = getBudget.OrgUnit>
	
			
</cfif>

<cf_tl id="REQ028" var="1">
<cfset vReq028=lt_text>
	
<cfif Parameter.recordcount eq "0">
	<cf_message message = "#vReq028#"
     return = "">
	 <cfabort>
</cfif>

<cfif URL.Period eq "">	
	<cfset URL.Period = "#Parameter.DefaultPeriod#">
</cfif>

<!--- now define the scripts, do not put these above the period --->

<cfparam name="url.role" default="ProcReqEntry">

<cfajaximport tags="cfwindow,cfform,cfdiv">

<cfif url.menu eq "1">
	
	<cf_screentop height="100%" 
		   scroll="no" 
		   html="No" 
		   band="No" 		   
		   jquery="Yes"
		   banner="gradient" 
		   label="Requester Requistion Control">
   
<cfelse>
		
	<cf_screentop height="100%" 
		   scroll="no" 
		   html="Yes" 
		   band="No"
		   layout="webapp" 
		   jQuery="Yes"
		   banner="gradient" 
		   label="Requester Requistion Control"
		   option="Process and view requisition lines">

</cfif>   

<cfinclude template="RequisitionViewScript.cfm">
<cf_DialogREMProgram>
<cf_DialogProcurement>
<cf_dialogWorkOrder>
<cf_AnnotationScript>
<cf_DialogStaffing>
<cf_FileLibraryScript>
<cf_MenuScript>

<table width="100%" height="100%">
 
<cfoutput>

<tr class="line">

	<td style="padding-left:2px;padding-right:2px;min-width:150px;border-right:1px solid silver" valign="top">

		<!--- top menu --->
				
		<table width="100%" align="center">		
								
			<cfset ht = "52">
			<cfset wd = "52">
			
			<cfset add = 1>
			
			<input type="hidden" name="reqno" id="reqno" value="#url.id#">
		
		     <tr>
			        <cfif url.menu eq "1">
					
							<cf_tl id="Under Preparation" var ="vUnder">
							<cf_menutab item       = "1" 
						            iconsrc    = "Logos/Procurement/Pending.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 									
									class      = "highlight1"
									name       = "#vUnder#"
									source     = "../Requisition/RequisitionEntryListing.cfm?add=0&Mission=#URL.Mission#&Period=#URL.Period#&Mode=Entry&Source=#url.context#&ID={reqno}&ajax=1">			
									
					<cfelse>
					
							<cf_tl id="Submit Requests" var ="vSubmit">
							<cf_menutab item       = "1" 
						            iconsrc    = "Logos/Procurement/Submit.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									class      = "highlight1"
									name       = "#vSubmit#"
									source     = "../Process/RequisitionCreatePending.cfm?mission=#url.mission#&period={periodsel}">			
									
					</cfif>		
					
				</tr>						
				
				<tr>
					<cf_tl id="New Request" var ="vRequest">									
					<cf_menutab item       = "2" 
					            iconsrc    = "Logos/Procurement/Add.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "#vRequest#"
								source     = "javascript:add()">
				</tr>
				
				
				<tr>	
					 <cfif url.menu eq "3">
					 
							<cf_tl id="Requests under preparation" var ="vUnderPreparation">									
							<cf_menutab item = "3" 
					            iconsrc    = "Logos/Procurement/Pending.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 									
								name       = "#vUnderPreparation#"
								source     = "../Requisition/RequisitionEntryListing.cfm?add=0&Mission=#URL.Mission#&Period=#URL.Period#&Mode=Entry&ID={reqno}">			
								
					<cfelse>
					
							<cf_tl id="Submit Request" var= "vSubmit">
							<cf_menutab item = "3" 
					            iconsrc    = "Logos/Procurement/Submit.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "#vSubmit#"
								source     = "../Process/RequisitionCreatePending.cfm?mission=#url.mission#&period={periodsel}&Source=#url.context#">			
								
					</cfif>		
					
				 </tr>
				 
				 <tr>
				 					
					<cf_tl id="Recent History" var= "vRecent">
					<cf_menutab item       = "4" 
					            iconsrc    = "Logos/Procurement/Recent.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "#vRecent#"
								source     = "RequisitionLog.cfm?mission=#url.mission#&period={periodsel}">		
								
				 </tr>					
					
					<cf_verifyOperational module="WorkOrder" Warning="No">    
	    		    <cfif Operational eq "1">
																	
						<cf_tl id="Advanced Inquiry" var="1">
						<cfset tInquiry = "#Lt_text#">
							
						<!--- just to create the needed scripts here, button is hidden --->
								
								<cfinvoke component="Service.Analysis.CrossTab"  
								  method         = "ShowInquiry"
								  buttonName     = "Analysis"
								  buttonClass    = "variable"		<!--- pass the loading script --->  
								  buttonIcon     = "#SESSION.root#/Images/dataset.png"
								  buttonText     = "#tInquiry#"
								  buttonStyle    = "height:29px;width:120px;"
								  reportPath     = "Procurement\Application\Requisition\Portal\"
								  SQLtemplate    = "RequisitionFactTable.cfm"
								  queryString    = "Mission=#URL.Mission#"
								  dataSource     = "appsQuery" 
								  module         = "Procurement"
								  reportName     = "Facttable: Requisition"
								  olap           = "1"
								  target         = "analysisbox"
								  table1Name     = "Requisitions"											 
								  returnvariable = "script"> 	
					
					 <tr> 	  
				  	 <cf_menutab item       = "5" 
			         		     iconsrc    = "Logos/Procurement/Inquiry.png" 
								 iconwidth  = "#wd#" 
								 iconheight = "#ht#" 
								 name       = "#tInquiry#"
								 source     = "javascript:#script#">	
					 </tr>			 
								 		
					</cfif>
					
		</table>

	</td>
	
	<td height="100%" style="padding:4px;width:100%">

    <cf_divscroll>
	
	<table width="100%" 
	      border="0"
		  height="100%"	
		  align="center">
	 		
			<tr class="hide"><td valign="top" height="100" id="result" name="result"></td></tr>
			
			<cf_menucontainer item="1" class="regular">
			
			  <cfif url.menu eq "3">			  		  		
				 <cfinclude template="../Process/RequisitionCreatePending.cfm">						  
			  <cfelse>			  			  
				 <cfset url.add = "0">
				 <cfset url.mode = "entry">				 
				 <cfinclude template="../Requisition/RequisitionEntryListing.cfm">					 
			  </cfif>	 		
					  
			<cf_menucontainer>
			
			<cf_menucontainer item="2" class="hide"></cf_menucontainer>
		
			<!--- container for processing advanced --->	
			<tr class="hide" id="box3" name="box3">
			
			   <cfoutput>
			   <td height="100%" width="100%" valign="top">
			   			   
				   <table width="100%" height="100%">
				   			   		   
						<cfquery name="PeriodList" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   Ref_MissionPeriod
							WHERE  Mission = '#URL.Mission#'
							AND ( Period IN (SELECT Period
							               FROM Purchase.dbo.RequisitionLine
										   WHERE Mission = '#URL.Mission#')
							OR 	Period = '#url.Period#')		   
						</cfquery>
										
						<tr>
												   
						   <td width="95%" style="height:10px;padding-left:12px">
						   
							    <table class="formpadding">
								
								<tr>
								
									<cfoutput>
										<input type="hidden" name="periodsel" id="periodsel" value="#url.period#">
									</cfoutput>
									
								    <cfloop query="PeriodList">
									
									  <td style="padding-right:3px">
										  <input type="radio" 
										    onclick="document.getElementById('periodsel').value='#period#';reqsearch()" 
											name="Period" 
											id="box#Period#"
											value="#Period#" <cfif url.period eq period>checked</cfif>>		
									  </td>
									  
									  <td style="height:20px;cursor: pointer;padding-left:3px;padding-right:8px" class="labelmedium"
									      onclick="document.getElementById('box#Period#').click()">#Period#</td>
																												  
									</cfloop>  
									
									<td class="hide">
								    
									 <input type="button" 
									   id="refreshbutton" class="button10s"
									   name="refreshbutton"
									   onclick="reqsearch()">					      		
								  
									</td>	
													
								</tr>
								
								</table>
							
						   </td>
						</tr>
					
						<cfform name="req" method="post" style="height:100%">
							<tr>							
							  <td height="100%" colspan="2" valign="top" id="contentbox3" name="contentbox3"></td>
							</tr>
						</cfform>
					
					</table>
					</td></cfoutput>
			   			   
		    </tr>
						
			<cf_menucontainer item="4" class="hide">
			<cf_menucontainer item="5" class="hide" iframe="analysisbox">
						
	</table>
	
	</cf_divscroll>
	
	</td>
	
	
		
 </tr>
 </cfoutput>

</table>

<cf_screenbottom layout="webapp">