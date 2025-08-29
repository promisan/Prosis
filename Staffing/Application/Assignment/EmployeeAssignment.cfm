<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="URL.Header" default="1">
<cfparam name="URL.mode"   default="standard">
<cfparam name="URL.ID1"    default="">
<cfparam name="getRoot.OrgUnit"    default="">

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
					   O.OrgUnitCode,
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
		  		  
		  <table width="100%" class="navigation_table">
		  
		  <cfif PersonAssignment.recordcount neq "0">
		  						  
			   <TR class="line labelmedium2 fixrow fixlengthlist">
				    <td align="center"></td>
					<td align="center"></td>
					<TD><cf_tl id="Function"> </TD>
					<TD><cf_tl id="Post"></TD>
					<TD><cf_tl id="Track"></TD>
					<TD><cf_tl id="Grade"></TD>
					<td><cf_tl id="Duty"></td>		
					<TD><cf_tl id="Effective"></TD>	
					<TD><cf_tl id="Expiration"></TD>	
					<cfif url.mode neq "Portal">				
				    <TD><cf_tl id="Class"></TD>														
					<td><cf_tl id="Status"></td>
					</cfif>
					<TD title="Encumbency">Enc.</TD>	
					<cfif url.mode neq "Portal">	
					<TD><cf_tl id="Officer"></TD>	
					<TD><cf_tl id="Recorded"></TD>	
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
				<tr class="line">
				<td style="height:30px;font-size:20px;" class="labelmedium" colspan="14" align="left"><font size="2"><cf_tl id="Owner">:&nbsp;</font>#MissionOwnerName#</td>
				</tr>					
				</cfif>
				
				<cfset prior    = "">	
				<cfset priorOrg = "">	
				<cfset priorMis = "">	
				
				<cfset dte = "01/01/1900">
				
				<!---  
				<cfoutput group="AssignmentClass">
				--->
				
					<!--- 						
						<tr class="line labelmedium"><td colspan="13" align="left" style="font-size: 16px; font-weight: 300; height: 26px; color: gray; padding-left: 4px;">#AssignmentDescription# <cf_tl id="Incumbency"></td></tr>							 						
					--->
					
					<cfoutput group="OrgUnit">
																					
					<cfoutput>
					
					<cfset validwork = "1">
										
					<cfif DateEffective lte dte and incumbency eq "100">						
					<cfset validwork = "0">
					<tr class="line labelmedium2"><td colspan="14" height="30" align="center" bgcolor="yellow"><font color="black">Attention: Assignment effective period overlaps with prior record</td></tr>					
					</cfif>
					
					<cfif DateEffective gt DateExpiration and Incumbency eq "100">						
					<cfset validwork = "0">
					<tr class="line labelmedium2" style="border-top:1px solid gray"><td colspan="14" height="30"  align="center" bgcolor="FF0000"><font color="white">Attention: Incorrect assignment. Please contact administrator to remove record.</td></tr>					
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
						 	
							<!---						 
						 	<tr><td colspan="13" height="30" class="labelmedium" style="font-size:21px;padding-left:4px"><b>#Mission#</td></tr>
							<cfset prior = mission>
							--->
						 
						 </cfif>		
						 
						 <cfif OrgUnitCode neq priorOrg or mission neq priorMis>						 	
						 						 
							 <tr class="labelmedium2 fixrow2 line" style="height:22px">
							
														 
							 <td colspan="14" style="padding-left:14px;background-color:f1f1f1">
							 
							  <cfif mission neq priorMis>	
							  <span style="font-weight:bold;padding-left:1px;border-right:1px solid silver;font-size:17px">#Mission#</span>
							  </cfif>
							 								 
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
								
								#OrgUnitName#<cfif struct neq ""> <span style="font-size:12px">/ #struct#</span></cfif>  		
								
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
						 
						 <cfset priorOrg = OrgUnitCode>
						 <cfset priorMis = Mission>
						
						 <TR bgcolor="#color#" class="labelmedium line navigation_row fixlengthlist" style="padding-top:3px;height:22px">
						 						 
						 <cfif workflow neq "" and url.mode neq "Portal">
					 
							 <td align="center" style="cursor:pointer;padding-left:4px" 
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
						 
						   <td align="center" style="padding-top:2px">
						  						  
						   <cfif url.mode eq "standard" or url.mode eq "staffing">
						   						  
						   	 <cfif assignmentNo neq URL.ID1>														
							 							 
							   	<cfif accessOwner eq "EDIT" or accessOwner eq "ALL">								
								    <cf_img icon="open" navigation="Yes" onClick="EditAssignment('#PersonNo#','#AssignmentNo#')">																			 
								 </cfif>
							 
							</cfif> 
							
						   </cfif>	
						 
					       </td>	
					   	   <TD>#PositionDescription# <cfif PositionDescription neq FunctionDescription><font color="0080C0">(#FunctionDescription#)</cfif></TD>
						   <td>
						    	<cfif accessOwner eq "EDIT" or accessOwner eq "ALL">
						        <a href="javascript:EditPosition('#Mission#','#Mandateno#','#PositionNo#')">
						    	<cfif SourcePostNumber neq "">#SourcePostNumber#<cfelse>#PositionParentId#</cfif>
								</a>
								<cfelse>
								<cfif SourcePostNumber neq "">#SourcePostNumber#<cfelse>#PositionParentId#</cfif>
								</cfif>
								
						   </td>
						   <td><cfif source eq "vac"><a href="javascript:showdocument('#sourceid#')">#sourceId#</a></cfif></td>
						   <TD>#PostGrade#</TD>
						   <TD>#LocationCode#</TD>		
						   
						   <cfset compare = dateAdd("d","1",dte)>
						   <td><cfif compare neq dateeffective and currentrow neq "1"><font color="FF0000"></cfif>#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
					       <td>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>		
						   <cfif url.mode neq "Portal">					  			   
						   <TD>#AssignmentClass#</TD>	
						   <td><cfif AssignmentStatus eq "0"><font color="FF0000"><cf_tl id="Pending"><cfelse><cf_tl id="Cleared"></cfif></td>
						   </cfif>					   
						   <TD>#Incumbency#%</TD>	
						   <cfif url.mode neq "Portal">					   
						   <td>#OfficerLastName#</td>
						   <td>#Dateformat(Created, CLIENT.DateFormatShow)#</td>	
						   <cfelse>
						   <td></td>	
						   <td></td>
						   </cfif>   	  
						 </tr>
						 					 
						 <cfif len(Remarks) gte "20" and not find("FPMS",remarks) and (url.mode eq "standard" or url.mode eq "staffing")>
							 <TR bgcolor="#color#" style="height:15px" class="navigation_row_child labelmedium2">
							 	<td colspan="2"></td>
								<td colspan="12" style="padding-left:2px;height:15px">#Remarks#</td>
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
										<td colspan="12">
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
										<td colspan="12">
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
								<td colspan="12" class="navigation_row_child labelit">
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
								 
								    <td colspan="12" id="#workflow#">
									
									<cfif wfstatus eq "open">
									
										<cfset url.ajaxid = workflow>					
										<cfinclude template="AssignmentWorkflow.cfm">
																		
									</cfif>
								
								</td>
							
							</tr>
						
						</cfif>				
							
						</cfif>
						
						<cfif incumbency neq "0">
						     <cfset dte = dateformat(DateExpiration,client.dateSQL)>		
						</cfif>
						
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
				<tr class="labelmedium">
				     <!---
				     <td style="padding-left:5px;font-size:16px"><cf_tl id="Work assignment summary"></td>
					 --->
				     <td style="padding-top:6px;padding-right:5px;padding-left:4px">
				
					<table class="formpadding formpacing"> 	
						
					<cfset pr = "">	
						
					<cfoutput query="Experience">
					
					     <cfif mission neq pr>
							<tr class="line labelmedium2">	
							<td style="padding-right:9px">#Mission#</td>
							<cfset pr = mission>	
						</cfif>
							
							<td style="padding-right:9px">#PostGrade#&nbsp;:</td>
							<cfset years = int(Months/12)>
							<cfif years gt "0">
								<cfset mnths = months - (years*12)>
							<cfelse>
								<cfset mnths = months> 	
							</cfif>
							<td style="width:140px"><cfif years neq "0">#years# yr<cfif years gt "1">s</cfif></cfif> <cfif mnths gt"0">#mnths# mth<cfif mnths gt "1">s</cfif></cfif></td>											
										
					</cfoutput>				
					
					</table>
					
				</td></tr>
				
			</cfif>
		
		</cfif>
				
	</table>