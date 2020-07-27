
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_ParameterMission
		WHERE Mission = '#URL.Mission#' 
</cfquery>

<!--- End Prosis template framework --->

<cfparam name="url.message" default="">

<table width="100%" height="100%">	

<tr><td height="35">

	    <!--- ---------------------------------- --->
		<!--- ---------- TOP MENU -------------- --->
		<!--- ---------------------------------- --->
				
		<cfoutput>
		
		<table width="98%" border="0" align="center" cellspacing="0" cellpadding="0">		  		
						
			<cfset ht = "48">			
			<cfset wd = "48">
			
			<cfset add = 1>
					
				<tr>									
					
					<cf_tl id="Pending for" var="vPending">
					<cf_tl id="Assignment" var="vAssignment">
					<cf_tl id="Assigned Requests" var="vAssignedRequests">
					
					<cf_menutab item       = "1" 
					            iconsrc    = "Logos/Procurement/Submit.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								class      = "highlight"
								name       = "#vPending# #Parameter.BuyerDescription# #vAssignment#">			
				
					<cf_menutab item       = "2" 
					            iconsrc    = "Logos/Staffing/Log.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "#vAssignedRequests# #Parameter.BuyerDescription#"
								source     = "RequisitionBuyerDetail.cfm?mission=#url.mission#">		
								
					<cf_tl id="Extended Inquiry" var="1">
					<cfset tInquiry = "#Lt_text#">
						
					<cfinvoke component="Service.Analysis.CrossTab"  
						  method      = "ShowInquiry"
						  buttonName  = "Analysis"
						  buttonClass = "variable"		  
						  buttonIcon  = "Logos/Procurement/Inquiry.png"
						  buttonText  = "#tInquiry#"
						  buttonStyle = "height:29px;width:120px;"
						  reportPath  = "Procurement\Application\Requisition\Portal\"
						  SQLtemplate = "RequisitionFactTable.cfm"
						  queryString = "mission=#URL.Mission#&period={periodsel}"
						  dataSource  = "appsQuery" 
						  module      = "Procurement"
						  reportName  = "Facttable: Requisition"
						  olap        = "1"
						  target      = "analysisbox"
						  table1Name  = "Requisitions"							
						  filter      = "1"
						  returnvariable = "script"> 	
						  
				  	<cf_menutab item       = "3" 
			            iconsrc    = "Logos/Procurement/Inquiry.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						name       = "#tInquiry#"
						source     = "javascript:#script#">						
								
					
																										 		
				</tr>
		</table>
					
		</cfoutput>			

	 </td>
 </tr>
 
<tr class="line"><td width="99%" align="center"></td></tr>

<tr><td height="100%">

	<!--- ------------------------------------ --->
	<!--- ---------- CONTAINERS -------------- --->
	<!--- ------------------------------------ --->
	
	<table width="100%" 	     
		  height="100%">	  
	 		
			<tr class="hide"><td valign="top" height="1" id="result"></td></tr>
					
			<!--- container 1 for processing advanced --->	
			
			<!--- container 2 --->			
			<cf_menucontainer item="1" class="regular">	
						   			   
				   <table width="100%" height="100%" class="formpadding">		
						
						<tr>
						  <td height="100%" colspan="2" valign="top" id="contentbox1" name="contentbox1">						  
								  <cfset url.ajax = 0>	
								  <cfinclude template="RequisitionBuyerPending.cfm">						
						  
						  </td>
						</tr>
					
					</table>
					
			</cf_menucontainer>
				
			<!--- container 2 --->			
			<cf_menucontainer item="2" class="hide">	
							
			<cf_menucontainer item="3" class="hide" iframe="analysisbox">
						
	</table>
		
</td>
</tr>
</table>	

