<!--- Create Criteria string for query from data entered thru search form --->

<cfparam name="URL.Header" default="1">
<cfparam name="URL.mode"   default="standard">
<cfparam name="URL.ID1"    default="">

<cfinvoke component = "Service.Process.System.Client" method= "getBrowser" returnvariable = "thisbrowser">	

<cf_actionListingScript>
<cf_FileLibraryScript>	

<cfoutput>

	<script>
	
	function workflowdrill(key,box,mode) {
			
		    se = document.getElementById(box)
			ex = document.getElementById("exp"+key)
			co = document.getElementById("col"+key)
				
			if (se.className == "hide") {		
			   se.className = "regular" 		   
			   co.className = "regular"
			   ex.className = "hide"	
			   
			   ptoken.navigate('#SESSION.root#/Staffing/Application/Assignment/AssignmentWorkflow.cfm?ajaxid='+key,key)		   		 
			} else {  se.className = "hide"
			          ex.className = "regular"
			   	      co.className = "hide" 
		    } 		
		}	
		
	function setpas(ass) {
	    ptoken.navigate('#SESSION.root#/Staffing/Application/Assignment/AssignmentPAS.cfm?assignmentno='+ass,'process')
	}	
		
	</script>
</cfoutput>

<cfset standardCSS = "standard.css">
<cfif thisbrowser.name eq "Explorer" and thisbrowser.Release eq "7">
	<cfset standardCSS = "standardIE7.css">
</cfif>

<cfoutput>
<link rel="stylesheet" type="text/css" href="#SESSION.root#/images/css/#standardCSS#">
</cfoutput>
 			
<cfif header eq "9">

	<table cellpadding="0" cellspacing="0" width="99%" align="center">			
		
			<tr><td height="10" style="padding-top:3px;padding-left:7px">	
				  <cfset ctr      = "1">		
				  <cfset ass      = "1">
				  
				  <cfset client.stafftoggle = "close">
			      <cfset openmode = "close"> 
				  <cfinclude template="../Employee/PersonViewHeaderToggle.cfm">		  
				 </td>
			</tr>	
			
			<cf_dialogposition>
			
		</table>

<cfelseif header eq "1">

	<cf_screentop html="No" jquery="Yes" height="100%" scroll="Yes" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">

	<table cellpadding="0" cellspacing="0" width="99%" align="center">			
		
			<tr><td height="10" style="padding-top:3px;padding-left:7px">	
				  <cfset ctr      = "1">		
				  <cfset ass      = "1">
				  
			      <cfset openmode = "close"> 
				  <cfinclude template="../Employee/PersonViewHeaderToggle.cfm">		  
				 </td>
			</tr>	
			
			<cf_dialogposition>
			
		</table>
		

<cfelse>

	<cf_screentop html="No" jquery="Yes">
	<cfajaximport>
		
</cfif>

<table width="97%" align="center" border="0">

	<cfif url.mode eq "Portal">
	
		<cfparam name="url.contractid" default="">	
				
		<cfquery name="PersonAssignment" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT     TOP 4 A.*, 
			           P.SourcePostNumber, 
					   P.PositionParentId,
					   P.PostGrade,
					   P.MandateNo,
					   O.Mission, 
					   O.OrgUnitName, 
					   M.MissionOwner, 
					   
					   (SELECT TOP 1 ObjectKeyValue1 
						  FROM     Organization.dbo.OrganizationObject 
						  WHERE    ObjectKeyValue1 = A.AssignmentNo
						  AND      EntityCode      = 'Assignment' 
						  AND      Operational = 1) as Workflow,	
					   				   
					   C.Description as AssignmentDescription,
					   P.FunctionDescription as PositionDescription
					   
		    FROM       PersonAssignment A, 
			           Position P,
			           Organization.dbo.Organization O, 
				       Organization.dbo.Ref_Mission M,
					   Ref_AssignmentClass C
			WHERE      A.OrgUnit   = O.OrgUnit
			  AND      A.PersonNo  = '#URL.ID#'
			  AND      M.Mission   = O.Mission
			  AND      C.AssignmentClass = A.AssignmentClass 
			  AND      A.PositionNo = P.PositionNo
			  AND      A.AssignmentStatus IN ('0','1')	
			  
			  <cfif url.contractid neq "">
			  
			  	AND      A.DateExpiration >= (  SELECT DateEffective 
			    	                            FROM   EPAS.dbo.Contract
												WHERE  ContractId = '#url.contractid#')
											
				AND      A.DateEffective  <= (  SELECT DateExpiration 
			                         	        FROM   EPAS.dbo.Contract
											    WHERE  ContractId = '#url.contractid#')							
			  
			  </cfif>
			 			  
			  ORDER BY M.MissionOwner, 		          
					   A.DateEffective,
					   A.Incumbency DESC 
					   
		</cfquery>			   
	
	<cfelse>	
	
		<cfquery name="PersonAssignment" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT     A.*, 
			           P.SourcePostNumber, 
					   P.PostGrade,
					   P.PositionParentId,
					   P.MandateNo,
					   O.Mission, 
					   O.OrgUnitName, 
					   M.MissionOwner, 
					   
					   (SELECT  Description
					    FROM    Organization.dbo.Ref_AuthorizationRoleOwner
						WHERE Code = M.MissionOwner) as MissionOwnerName,
					   
					   (SELECT TOP 1 ObjectKeyValue1 
						  FROM     Organization.dbo.OrganizationObject 
						  WHERE    ObjectKeyValue1 = A.AssignmentNo
						  AND      EntityCode = 'Assignment' 
						  AND      Operational = 1) as Workflow,	
					   				   
					   C.Description as AssignmentDescription,
					   P.FunctionDescription as PositionDescription
					   
		    FROM       PersonAssignment A, 
			           Position P,
			           Organization.dbo.Organization O, 
				       Organization.dbo.Ref_Mission M,
					   Ref_AssignmentClass C
			WHERE      A.OrgUnit   = O.OrgUnit
			  AND      A.PersonNo  = '#URL.ID#'
			  AND      M.Mission   = O.Mission
			  AND      C.AssignmentClass = A.AssignmentClass 
			  AND      A.PositionNo = P.PositionNo
			  AND      A.AssignmentStatus IN ('0','1')			  
			  
			  ORDER BY M.MissionOwner, 		          
					   A.DateEffective,
					   A.Incumbency DESC 										   
					   
	     </cfquery>
   
   </cfif>
   
    <tr><td id="process"></td></tr>
      
	<tr><td>  
	
	<table width="100%">
		  
		  <tr>
		  <td width="100%" colspan="2">
		  		  
		  <table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">
		  
		  <cfif PersonAssignment.recordcount neq "0">
		  						  
			   <TR class="line labelmedium fixrow" height="18">
				    <td width="2%" align="center"></td>
					<td width="2%" align="center"></td>
					<TD style="min-width:140px"><cf_tl id="Function"> </TD>
					<TD style="min-width:60px"><cf_tl id="Post"></TD>
					<TD style="min-width:60px"><cf_tl id="Grade"></TD>
					<td colspan="1" width="5%"><cf_tl id="Duty"></td>		
					<TD style="min-width:100px"><cf_tl id="Effective"></TD>	
					<TD style="min-width:100px"><cf_tl id="Expiration"></TD>	
					<cfif url.mode neq "Portal">				
				    <TD><cf_tl id="Class"></TD>														
					<td><cf_tl id="Status"></td>
					</cfif>
					<TD style="padding-right:10px">Inc.</TD>	
					<cfif url.mode neq "Portal">	
					<TD><cf_tl id="Officer"></TD>	
					<TD style="min-width:100px"><cf_tl id="Recorded"></TD>	
					<cfelse>
					<td></td>
					<td></td>
					</cfif>
					
			   </TR>
			  		   
		  </cfif> 
		  	 
		  <cfset last = "1">
		  <cfset assignlist = "">
	   
		  <cfoutput query="PersonAssignment" group="MissionOwner">   
		  
				<cfif url.mode eq "standard" or url.mode eq "staffing">
				<tr class="line"><td height="23"  style="font-size:20px;font-weight:200" class="labelmedium" colspan="13" align="left"><font size="2"><cf_tl id="Owner">:&nbsp;</font>#MissionOwnerName#</b></td></tr>					
				</cfif>
				
				<cfset prior    = "">	
				<cfset priororg = "">	
				
				<cfset dte = "01/01/1900">
				
				<!---  
				<cfoutput group="AssignmentClass">
				--->
				
					<!--- 						
						<tr class="line labelmedium"><td colspan="13" align="left" style="font-size: 16px; font-weight: 300; height: 26px; color: gray; padding-left: 4px;">#AssignmentDescription# <cf_tl id="Incumbency"></td></tr>							 						
					--->
					
					<cfoutput group="OrgUnit">
								
					<cfset validwork = "1">
														
					<cfoutput>
										
					<cfif DateEffective lte dte and incumbency eq "100">						
					<cfset validwork = "0">
					<tr class="line labelmedium" style="font-weight:200px"><td colspan="13" height="30" style="font-weight:200px" align="center" bgcolor="yellow"><font color="black">Attention: Assignment effective period overlaps with prior record</td></tr>					
					</cfif>
					
					<cfif DateEffective gt DateExpiration and Incumbency eq "100">						
					<cfset validwork = "0">
					<tr class="line labelmedium" style="font-weight:200px;border-top:1px solid gray"><td colspan="13" height="30"  align="center" bgcolor="FF0000"><font color="white">Attention: Incorrect assignment. Please contact administrator to remove record.</td></tr>					
					</cfif>
														
				    <cfinvoke component="Service.Access"  
					   method="owner" 
					   owner="#MissionOwner#" 
					   returnvariable="accessOwner">	
					   					  				     
					 <cfif AccessOwner neq "NONE" or url.mode eq "Portal">
					 					 					 					 				 
					     <cfif assignmentNo eq URL.ID1>			 
						     <cfset color = "ffffcf">	
						 <cfelseif AssignmentStatus eq "0">	 
						 	<cfset color = "ffffbf">						 		
						 <cfelseif Incumbency eq "0">	
						    <cfset validwork = "0">	 
						    <cfset color = "FFCAFF">													    					    
						 <cfelse>
						    <cfset color = "ffffff">						   		 
						 </cfif>							 										
						 
						 <cfif Mission neq Prior>
						 							 
						 	<tr><td colspan="13" height="30" class="labelmedium" style="padding-top:3px;font-size:21px;color:green;padding-left:4px"><b>#Mission#</td></tr>
							<cfset prior = mission>
						 
						 </cfif>		
						 
						 <cfif OrgUnit neq priorOrg>						 	
						 						 
							 <tr class="labelmedium fixrow2">
							 
							 <td></td>
							 
							 <td valign="bottom" colspan="12" style="font-size:15px;height:31px">
							 								 
							  <cfquery name="Parent" 
								    datasource="AppsOrganization" 
								    username="#SESSION.login#" 
								    password="#SESSION.dbpw#">
								    SELECT      *
									FROM        Organization
									WHERE       OrgUnit = '#OrgUnit#'
								</cfquery>
																
								<cfset struct = "">
								
								<cfset loopCount = 0>
								
								<cfloop condition="#Parent.ParentOrgUnit# neq '' and loopCount lt 10">
																																				
									 <cfquery name="getParent" 
									    datasource="AppsOrganization" 
									    username="#SESSION.login#" 
									    password="#SESSION.dbpw#">
									    SELECT    *
										FROM      Organization
										WHERE     OrgUnitCode  = '#Parent.ParentOrgUnit#'
										AND       Mission      = '#Parent.Mission#'
										AND       MandateNo    = '#Parent.MandateNo#'
									</cfquery>
								
									<cfif getRoot.OrgUnit neq getParent.OrgUnit>
									
										<cfif struct neq "">
											<cfset struct = "#struct# #getParent.OrgUnitName#">	
										<cfelse>
											<cfset struct = "#getParent.OrgUnitName#">		
										</cfif>		
									
									</cfif>
									
									 <cfquery name="Parent" 
									    datasource="AppsOrganization" 
									    username="#SESSION.login#" 
									    password="#SESSION.dbpw#">
									    SELECT    *
										FROM      Organization
										WHERE     OrgUnitCode  = '#getParent.ParentOrgUnit#'
										AND       Mission      = '#Parent.Mission#'
										AND       MandateNo    = '#Parent.MandateNo#'
									</cfquery>				
									
									<cfset loopCount = loopCount + 1>		
												
								</cfloop>		
								
								<b>#OrgUnitName#</b><cfif struct neq ""> <span style="font-size:12px">/ #struct#</span></cfif>  		
								
								<cfif Parent.HierarchyRootUnit neq "">
								
									 <cfquery name="getRoot" 
								    datasource="AppsOrganization" 
								    username="#SESSION.login#" 
								    password="#SESSION.dbpw#">
								    SELECT    *
									FROM      Organization
									WHERE     OrgUnitCode  = '#Parent.HierarchyRootUnit#'
									AND       Mission      = '#Parent.Mission#'
									AND       MandateNo    = '#Parent.MandateNo#'
									</cfquery>
								
									<font color="804000"><span style="font-size:12px">/ #getRoot.OrgUnitName#</span></font>  							
								
								</cfif>	 
															 
							 </td>																		 		 
							 
							 </tr>
						 
						 </cfif>
						 
						 <cfset priorOrg = OrgUnit>
						
						 <TR bgcolor="#color#" class="labelmedium line navigation_row" style="padding-top:3px;height:21px">
						 						 
						 <cfif workflow neq "" and url.mode neq "Portal">
					 
							 <td height="20"
								    align="center" 
									style="cursor:pointer;padding-left:4px" 
									onclick="workflowdrill('#workflow#','box_#workflow#')" >
									
								<cf_wfActive entitycode="Assignment" objectkeyvalue1="#AssignmentNo#">	
								 
									<cfif wfStatus eq "Open">
									
										  <img id="exp#Workflow#" 
									     class="hide" src="#SESSION.root#/Images/arrowright.gif" 
										 align="absmiddle" alt="Expand" height="9" width="7" border="0"> 	
														 
									   <img id="col#Workflow#" 
									     class="regular" src="#SESSION.root#/Images/arrowdown.gif" 
										 align="absmiddle" height="10" width="9" alt="Hide" border="0"> 
									
									<cfelse>
									
										   <img id="exp#Workflow#" 
									     class="regular" src="#SESSION.root#/Images/arrowright.gif" 
										 align="absmiddle" alt="Expand" height="9" width="7" border="0"> 	
														 
									   <img id="col#Workflow#" 
									     class="hide" src="#SESSION.root#/Images/arrowdown.gif" align="absmiddle" 
										 height="10" width="9" alt="Hide" border="0"> 
									
									</cfif>
									
							   </td>
								
						<cfelse>
							
							   <td height="20" align="center"></td>	
							  
						</cfif>	 						 
						 
						   <td width="24" align="center" style="padding-left:5px;padding-top:2px;padding-right:3px">
						  						  
						   <cfif url.mode eq "standard" or url.mode eq "staffing">
						  
						   	 <cfif assignmentNo neq URL.ID1>
							 							 
							   	<cfif accessOwner eq "EDIT" or accessOwner eq "ALL">								
								    <cf_img icon="open" navigation="Yes" onClick="EditAssignment('#PersonNo#','#AssignmentNo#')">																			 
								 </cfif>
							 
							</cfif> 
							
						   </cfif>	
						 
					       </td>	
					   	   <TD>#PositionDescription# <cfif PositionDescription neq FunctionDescription><font color="0080C0">(#FunctionDescription#)</cfif></TD>
						   <td style="padding-left:3px">
						    	<cfif accessOwner eq "EDIT" or accessOwner eq "ALL">
						        <a href="javascript:EditPosition('#Mission#','#Mandateno#','#PositionNo#')">
						    	<cfif SourcePostNumber neq "">#SourcePostNumber#<cfelse>#PositionParentId#</cfif>
								</a>
								<cfelse>
								<cfif SourcePostNumber neq "">#SourcePostNumber#<cfelse>#PositionParentId#</cfif>
								</cfif>
								
						   </td>
						   <TD style="padding-left:3px">#PostGrade#</TD>
						   <TD>#LocationCode#</TD>		
						   
						   <cfset compare = dateAdd("d","1",dte)>
						   <td style="padding-left:2px"><cfif compare neq dateeffective and currentrow neq "1"><font color="FF0000"></cfif>#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
					       <td>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>		
						   <cfif url.mode neq "Portal">					  			   
						   <TD style="padding-left:2px">#AssignmentClass#</TD>	
						   <td style="padding-left:5px;padding-right:15px"><cfif AssignmentStatus eq "0"><font color="FF0000"><cf_tl id="Pending"><cfelse><cf_tl id="Cleared"></cfif></td>
						   </cfif>					   
						   <TD style="padding-right:4px">#Incumbency#%</TD>	
						   <cfif url.mode neq "Portal">					   
						   <td style="padding-right:4px">#OfficerLastName#</td>
						   <td style="padding-right:4px">#Dateformat(Created, CLIENT.DateFormatShow)#</td>	
						   <cfelse>
						   <td></td>	
						   <td></td>
						   </cfif>   	  
						 </tr>
						 					 
						 <cfif len(Remarks) gte "20" and not find("FPMS",remarks) and (url.mode eq "standard" or url.mode eq "staffing")>
							 <TR bgcolor="#color#" style="height:15px" class="navigation_row_child labelmedium">
							 	<td colspan="2"></td>
								<td colspan="12">#Remarks#</td>
							 </tr>
						 </cfif>
						 
						 <cfif url.mode eq "standard" or url.mode eq "staffing">
						 
							 <!--- check on ePas --->
							<cf_verifyOperational module = "EPAS" Warning = "No">
							
							<cfif operational eq "1">
							
								<cfquery name="getPAS" 
									datasource="AppsEPAS" 
									username="#SESSION.login#" 
								    password="#SESSION.dbpw#">
									    SELECT    *
										FROM      Contract
										WHERE     PersonNo = '#PersonNo#'
										AND       DateEffective  <= '#Dateformat(DateExpiration, CLIENT.DateSQL)#' 
										AND       DateExpiration >= '#Dateformat(DateEffective, CLIENT.DateSQL)#' 										
										AND       ContractClass = 'standard'
										AND       Mission = '#Mission#'
									</cfquery>
								
								<cfif getPAS.recordcount gte "1">
								
									<TR bgcolor="#color#" style="height:15px" class="labelmedium line">
									 	<td colspan="2"></td>
										<td colspan="11">
										<table>
										<tr class="labelmedium" style="height:20px">
										<td><cf_tl id="Performance Appraisal">:</td>
										<cfloop query="getPAS">
																				
											<cfif actionstatus eq "8">
											    <cfset cl = "800080">
											<cfelseif actionstatus eq "9">
												<cfset cl = "red">
											<cfelse>
												<cfset cl = "">
											</cfif>
											
											<td style="padding-left:4px">
											<a style="color:#cl#" href="javascript:pasdialog('#ContractId#')">										
											#contractclass# : #ContractNo# (#Dateformat(DateEffective, CLIENT.DateFormatShow)# - #Dateformat(DateExpiration, CLIENT.DateFormatShow)# )
											</a>	
											</td>
																											
										</cfloop>																						
																							
										</table>
										</td>
									 </tr>	
									 
								</cfif>								
								
								<cfquery name="getPAS" 
									datasource="AppsEPAS" 
									username="#SESSION.login#" 
								    password="#SESSION.dbpw#">
									    SELECT    *
										FROM      Contract
										WHERE     PersonNo = '#PersonNo#'
										AND       DateEffective  <= '#Dateformat(DateExpiration, CLIENT.DateSQL)#' 
										AND       DateExpiration >= '#Dateformat(DateExpiration, CLIENT.DateSQL)#' 										
										AND       ContractClass = 'standard'
										AND       ActionStatus != '9'
										AND       Mission = '#Mission#'
									</cfquery>
																		
								<cfquery name="getPeriod" 
									datasource="AppsEPAS" 
									username="#SESSION.login#" 
								    password="#SESSION.dbpw#">
									    SELECT TOP 1 *
										FROM      Ref_ContractPeriod
										WHERE     Mission = '#Mission#'
										AND       PASPeriodStart  <= '#Dateformat(DateExpiration, CLIENT.DateSQL)#' 
										AND       PASPeriodEnd     >= '#Dateformat(DateEffective, CLIENT.DateSQL)#' 										
										AND       ContractClass = 'standard'	
										ORDER BY PASPeriodEnd ASC										
								</cfquery>								
																
								<cfif getPAS.recordcount eq "0" and getPeriod.recordcount eq "1" and DateExpiration gte now()>													
								
									<TR bgcolor="#color#" style="height:15px" class="labelmedium line">
									 	<td colspan="2"></td>
										<td colspan="11">
										<table>
										<tr class="labelmedium">																										
										<td style="padding-left:0px"><a href="javascript:setpas('#AssignmentNo#')"><cf_tl id="Initiate appraisal record"></a></td>																									
										</table>
										</td>
									 </tr>	
									 
								</cfif>	 
										
							</cfif>
						</cfif>
																			 
					 	<cfquery name="GroupAll" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
							SELECT F.GroupCode, F.Description
							FROM   PersonAssignmentGroup S, 
							       Ref_Group F 
							WHERE  S.AssignmentNo = '#AssignmentNo#'
							 AND   S.AssignmentGroup = F.GroupCode
							 AND   S.Status <> '9'
						</cfquery>
					
						<cfif GroupAll.recordcount gt 0>
					
							<tr class="line"><td></td>
							    <td></td>
								<td colspan="11" class="navigation_row_child labelit">
							   <cfloop query="GroupAll">
							    [#GroupAll.Description#]
							   </CFLOOP>
							</td></tr>
					
						</cfif>		
						
						<cfif workflow neq "" and url.mode neq "Portal">
		
							<input type="hidden" 
						       name="workflowlink_#workflow#" id="workflowlink_#workflow#" 		   
						       value="AssignmentWorkflow.cfm">						 
						 						   
							<tr id="box_#workflow#">
							
								    <td colspan="2"></td>
								 
								    <td colspan="11" id="#workflow#">
									
									<cfif wfstatus eq "open">
									
										<cfset url.ajaxid = workflow>					
										<cfinclude template="AssignmentWorkflow.cfm">
																		
									</cfif>
								
								</td>
							
							</tr>
						
						</cfif>				
							
						</cfif>
						
						<cfset dte = dateformat(DateExpiration,client.dateSQL)>		
						
						<cfif validwork eq "1">
						   <cfif assignlist eq "">
						    <cfset assignlist = "#assignmentno#">
						   <cfelse>
							<cfset assignlist = "#assignlist#,#assignmentno#">
						   </cfif>	
						</cfif>
														
					</cfoutput>		
					
					</cfoutput>	
				<!---     
					</cfoutput> 
					--->
			
			</cfoutput> 
						
	
			</TABLE>
			
		</td>
		
		</tr>
		
		
		<cfif url.mode neq "Portal">
				
			<cfif assignlist neq "">
			
			<cfquery name="Experience" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
	
				SELECT      Mission, PostGrade, PostOrder, SUM(Months) AS Months
				FROM        (
				             SELECT  P.Mission, 
							         R.PostGrade, 
									 R.PostOrder,
									 DATEDIFF(month, PA.DateEffective, PA.DateExpiration) AS Months
                		     FROM    PersonAssignment AS PA INNER JOIN
                                     Position AS P ON PA.PositionNo = P.PositionNo INNER JOIN Ref_PostGrade R ON P.PostGrade = R.PostGrade
                             WHERE   PA.AssignmentNo IN (#assignlist#) ) AS B
			    GROUP BY Mission, PostGrade, PostOrder
				ORDER BY Mission,PostOrder DESC
				
			</cfquery>	
						
			
			<tr><td style="padding-top:10px"></td></tr>
			<tr class="labelmedium"><td style="padding-left:5px;font-size:20px"><cf_tl id="Work assignment summary"></td></tr>
			<tr><td style="padding-left:30px;padding-top:6px">
			<table style="width:300px">
			<cfoutput query="Experience">
			<tr class="line">
			<td>#Mission#</td>
			<td>#PostGrade#</td>
			<cfset years = int(Months/12)>
			<cfif years gt "0">
				<cfset mnths = months - (years*12)>
			<cfelse>
				<cfset mnths = months> 	
			</cfif>
			<td style="width:140px">#years# year<cfif years gt "1">s</cfif> <cfif mnths gt"0">#mnths# month<cfif mnths gt "1">s</cfif></cfif></td>			
			
			</td>
			</tr>
			</cfoutput>
			</table>
			</td></tr>
				
			</cfif>
		
		</cfif>
				
	</table>

</td>

</tr>

</table>

<cfset ajaxonload("doHighlight")>

