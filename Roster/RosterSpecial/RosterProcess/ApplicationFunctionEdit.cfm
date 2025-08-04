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

<cfparam name="url.box" default="">

<cf_calendarscript>

<cf_divscroll style="height:98%">

<!--- Entry form --->
<CFFORM name="edit" style="height:98%"
  action="ApplicationFunctionDecision.cfm?box=#URL.box#&Owner=#Get.Owner#&Mode=#URL.Mode#&IDFunction=#URL.IDFunction#" 
  method="post">

<cf_printcontent>

<cfoutput>
	<input type="hidden" id="ApplicantNo"  name="ApplicantNo"  value="#URL.ID#">
	<input type="hidden" id="FunctionId"   name="FunctionId"   value="#URL.ID1#">
	<input type="hidden" id="FunctionNo"   name="FunctionNo"   value="#Get.FunctionNo#">
	<input type="hidden" id="clCount"      name="clCount"      value="0">	
</cfoutput>

<table width="100%" style="min-width:700px">
    
  <tr><td style="padding-top:3px" valign="top">
    
  <table width="98%" align="center" height="100%">
  
  <tr>
  
   <td width="100%" colspan="2" height="20">
	
   <table width="100%">
		
   <tr><td colspan="4" style="padding-top:5px;padding:5px;border-top:0px solid silver">

	   <table width="99%" align="center">
	     		
	    <TR>
			   
	    <TD width="89%" colspan="2">
		
		    <table style="width:100%">
			    <tr class="labelmedium fixlengthlist" style="height:40px">
			    <td style="padding-left:5px;font-size:20px">
			    <cfoutput query="Get" maxrows=1><a href="javascript:gjp('#FunctionNo#','#GradeDeployment#')" title="Access Function detailed description">#FunctionDescription# <font size="1">[#FunctionNo#]</font></a></cfoutput>		
				</td>		
				<td style="padding-left:20px;padding-right:5px"><cf_tl id="Level"></td>
				<TD style="font-size:20px;padding-left:10px;padding-right:5px">
					<cfoutput query="Get" maxrows=1><a href="javascript:gjp('#FunctionNo#','#GradeDeployment#')">#GradeDeployment#</a></cfoutput>
					<cfoutput query="Get" maxrows=1>#OrganizationDescription#</cfoutput>
				</TD>		
				<cfif Get.ReferenceNo neq "">				
			    	<td height="20" style="padding-left:10px"><cf_tl id="JO No"></td>
				    <td style="padding-left:5px;font-size:20px"><cfoutput query="Get" maxrows=1>#ReferenceNo#</cfoutput></td>			
				</cfif>					
				</tr>		
			</table>
			
		 </TD>
		</TR>		
			
		<cfif URL.Mode neq "0" and URL.print eq "0">
				   
			<cfif Access1 eq "EDIT" or Access2 eq "EDIT">	
								
				<TR>
					<td style="padding-left:6px" colspan="2" style="width:100%">
					
					<table style="width:100%">
					<tr>
										
						<TD style="padding-top:2px">
					    <cfoutput query="Get" maxrows=1>
					    	<textarea class="regular" name="Remarks" style="border:0px;background-color:f1f1f1;font-size:13px;height:40px;padding:2px;min-height:15;padding:4px;width:99%" type="text">#RosterGroupMemo#</textarea>
					    </cfoutput>				
					    </TD>
						<td align="right" style="width:100;padding-top:2px;padding-right:3px">				
					    <input type="button" name="Memo" value="Save" onclick="saveremarks()" style="border:1px solid silver;height:40px;width:100px" class="button10g"></td>
						<td class="hide" id="saveremarks"></td>
					</tr>
					</table>
					
					</td>				
					
					
			   </tr>	   	  
			 			 		   
		   <cfelse>	 
		  	 
	   			<cfset mode = "0"> 
	 		    	
				<tr>
				    <td height="25" style="padding-left:20px"><cf_tl id="Candidate Remarks">:</b></td>
					<td>
				    <cfoutput query="Get" maxrows=1>
				        <cfif RosterGroupMemo eq "">N/A<cfelse>#RosterGroupMemo#</cfif>
				    </cfoutput>
					</td>
			   </tr>
		   
		   </cfif>   
		   
	   <cfelseif URL.print eq "1">
	   		   
			<tr>
			    <td height="25" style="padding-left:20px"><cf_tl id="Candidate Remarks">:</b></td>
				<td>
			    <cfoutput query="Get" maxrows=1>#RosterGroupMemo#</cfoutput>
				</td>
		   </tr>
		      
	   </cfif>
	   
	   </table>
   
   </td>
   </tr>
   </table>
   </td>
   
   </tr>  
  
   <tr><td colspan="2" style="padding:3px;-moz-border-radius:3px;border-radius:3px;padding-top:7px;padding-left:15px;padding-right:10px;padding-bottom:6px">  	 
		<cfinclude template="ApplicationFunctionEditCandidate.cfm">	
       <td>  
   </tr>
   
   <tr>   
     <td colspan="2" style="padding-top:4px;padding-left:4px"><cf_DocumentCandidateReview PersonNo="#get.PersonNo#" Owner="#get.Owner#"></td>
   </tr> 
   
      
   <cf_menuscript>
                 
   <cfinvoke component="Service.Access"  
	      method="roster" 
	      role="'AdminRoster'" 
		  returnvariable="FullAccess"
		  Parameter="#Get.Owner#">
	  
		
	<cfset url.owner  = get.Owner>
	<cfset url.status = get.Status>
					
	  <TR>
	  <td colspan="2" style="padding-top:5px">
	    <table width="100%">
			<tr>
		    <td id="currentbox" class="labelmedium" style="height:45px;font-size:28px;padding-left:10px">		
			    <cfinclude template="ApplicationFunctionEditCurrent.cfm">						
			</td>
			<td align="right" style="padding-right:4px">			
				<cf_print mode="hyperlink" wrap="yes" class="labelmedium" paddingleft="5px">																			
			</td>	
			</tr>
		</table>
	   </td>	
	</tr>		
		  
	<tr><td colspan="2">
		
		<table width="99%" align="center">
	     	
		<tr>		
		<td>
		
		<table width="99%" align="center">
		
			<tr class="line">
		 									
					<cfset ht = "40">
					<cfset wd = "40">					
					
						<cfparam name="url.mycl" default="0">
					
						<cfset itm = 1>
					
						<cfif url.mycl eq "0">						
							
							<cf_menutab item  = "#itm#" 					   				
								iconsrc    = "Logos/Roster/Candidacy/Status_gray.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								padding    = "2"						
								class      = "highlight1"
								name       = "Status of Candidacy">		
								
							<cfset itm = itm+1>											
							
							<cf_menutab item       = "#itm#" 					   				
								iconsrc    = "Logos/Roster/Candidacy/Submission_gray.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								padding    = "2"	
								source     = "ApplicationFunctionSubmission.cfm?applicantno=#url.id#&functionid=#url.id1#&owner=#get.owner#"																
								name       = "Submitted Profile">					
										
							
							<cfquery name="Cover" 
								datasource="AppsSelection" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT * 
									FROM  ApplicantFunctionDocument
									WHERE ApplicantNo         = '#URL.ID#' 
									AND   FunctionId          = '#URL.ID1#'
							</cfquery>
		
							<cfif cover.recordcount gt 0 and len(cover.documenttext) gte "5">
														
									<cfset itm = itm+1>
									
									<cf_menutab item       = "#itm#" 					  				
									iconsrc    = "Logos/Roster/Candidacy/Submission_gray.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									targetitem = "3"
									padding    = "2"												
									name       = "Cover letter"
									source     = "ApplicationFunctionCover.cfm?id=#url.id#&id1=#url.id1#&owner=#get.owner#">	
																	
							</cfif>
															
							<cfset itm = itm+1>
														
							<cf_menutab item       = "#itm#" 					   				
								iconsrc    = "Logos/Roster/Candidacy/ProcessLog_gray.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "3"
								padding    = "2"												
								name       = "Candidacy Log"
								source     = "ApplicationFunctionHistory.cfm?id=#url.id#&id1=#url.id1#&owner=#get.owner#">		
															
						<cfelse>
						
							<!--- called from workflow --->
																		
							<cf_menutab item       = "#itm#" 					   				
								iconsrc    = "Logos/Roster/Candidacy/Status_gray.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								padding    = "2"									
								name       = "Candidacy Status">		
							
														
							<cfset itm = itm+1>											
							<cf_menutab item       = "#itm#" 					   				
								iconsrc    = "Logos/Roster/Candidacy/Submission_gray.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								padding    = "2"		
								source     = "ApplicationFunctionSubmission.cfm?applicantno=#url.id#&functionid=#url.id1#&owner=#get.owner#"								
								name       = "Submitted Profile">									
														
							<cfquery name="Cover" 
								datasource="AppsSelection" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT * 
									FROM  ApplicantFunctionDocument
									WHERE ApplicantNo         = '#URL.ID#' 
									AND   FunctionId          = '#URL.ID1#'
							</cfquery>
		
							<cfif cover.recordcount gt 0 and len(cover.documenttext) gte "5">
							
									<cfset itm = itm+1>
																		
									<cf_menutab item       = "#itm#" 					  				
									iconsrc    = "Logos/Roster/Candidacy/Submission_gray.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									targetitem = "3"
									padding    = "2"												
									name       = "Cover Letter"
									source     = "ApplicationFunctionCover.cfm?id=#url.id#&id1=#url.id1#&owner=#get.owner#">	
																		
							</cfif>
															
							<cfset itm = itm+1>
							
							<cf_menutab item       = "#itm#" 					   				
								iconsrc    = "Logos/Roster/Candidacy/ProcessLog_gray.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "3"
								padding    = "2"		
								class      = "highlight1"										
								name       = "Candidacy Log"
								source     = "ApplicationFunctionHistory.cfm?id=#url.id#&id1=#url.id1#&owner=#get.owner#">						
													
						</cfif>		
							
						<cfif access1 eq "EDIT">
							
						<cfset itm = itm+1>
														
						<cf_menutab item  = "#itm#" 					  				
								iconsrc       = "Logos/Roster/Candidacy/Competencies_gray.png" 
								iconwidth     = "#wd#" 
								iconheight    = "#ht#" 
								targetitem    = "2"
								padding       = "2"												
								name          = "Set competencies">		
						
						</cfif>		
					
					</tr>
					
				</table>		
							
		</tr>
						
		<tr>
		
		<td colspan="1" height="99%" valign="top">
			
			<table border="0" align="center" width="100%">	
		
		    <cfif url.mycl eq "0">
			
				<cf_menucontainer item="1" class="regular">		
					<cfif url.mycl eq "0">
						<cfinclude template="ApplicationFunctionEditStatus.cfm">						   			   	
					<cfelse>
					    <cfset url.owner = get.Owner>
					    <cfinclude template="ApplicationFunctionHistory.cfm">		
					</cfif>	
				</cf_menucontainer>		
							
				<cf_menucontainer item="3" class="hide"/>
			
			<cfelse>
			
				<cf_menucontainer item="1" class="hide">				
						<cfinclude template="ApplicationFunctionEditStatus.cfm">						   			   				
				</cf_menucontainer>				
				
				<cf_menucontainer item="3" class="regular">
					 <cfset url.owner = get.Owner>
				     <cfinclude template="ApplicationFunctionHistory.cfm">	
				</cf_menucontainer>
					
			</cfif>
			
			<cf_menucontainer item="2" class="hide">
				<cfinclude template="../../Candidate/Details/Competence/CompetenceEntryLimited.cfm">
			</cf_menucontainer>
			
			</table>		
												
		</td></tr>
		
		</table>
		</td>
	</tr>	  
				
</table>

</td></tr>

</table>

</cf_printcontent>

</CFFORM>

</cf_divscroll>
