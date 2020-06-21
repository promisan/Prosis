
<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table formpadding">
  	   
	   <tr><td>
	 	  	  	      							   
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" id="box">
		
		<cfif SearchResult.recordcount eq "0">
		
		<tr><td height="46" align="center" class="labelmedium"><cf_tl id="There are no records to show in this view">.</td></tr>
		<script>
			 Prosis.busy('no')
		</script>
						
		<cfelse>
		
			<tr><td height="26"  style="border-top:1px solid silver">
			
				<table border="0" width="100%" align="center">
					
					<cfoutput>
					
					<tr class="line" style="height:40px">
					
						<td align="left" colspan="2" width="70%">
				 						
						<cfif URL.Search eq "0">
											
						  <table class="formspacing">
						    <tr>
								<td class="cellcontent" style="padding-left:4px;cursor: pointer;">						
							    <input type="radio" id="#url.org#_sort1" name="#url.org#_sort" value="grade" <cfif URL.Sort eq "grade" or URL.sort eq "undefined">checked</cfif> onclick="detaillisting('#URL.org#','show','#URL.Mode#','#URL.Filter#','#URL.Level#','#URL.Line#','#URL.Cell#','grade','#URL.date#')">
								</td>
								<td class="cellcontent" style="padding-left:4px">
								<cf_tl id="Grade">/<cf_tl id="Level">
								</td>
								<td class="cellcontent" style="cursor: pointer;padding-left:3px">
								<input type="radio" id="#url.org#_sort2" name="#url.org#_sort" value="postclass" <cfif URL.Sort eq "postclass">checked</cfif> onclick="detaillisting('#URL.org#','show','#URL.Mode#','#URL.Filter#','#URL.Level#','#URL.Line#','#URL.Cell#','postclass','#URL.date#')">
								</td>
								<td class="cellcontent" style="padding-left:4px">
								<cf_tl id="Post class">
								</td>
								<td class="cellcontent" style="cursor: pointer;padding-left:3px">
								<input type="radio" id="#url.org#_sort3" name="#url.org#_sort" value="posttype" <cfif URL.Sort eq "posttype">checked</cfif> onclick="detaillisting('#URL.org#','show','#URL.Mode#','#URL.Filter#','#URL.Level#','#URL.Line#','#URL.Cell#','posttype','#URL.date#')">
								</td>
								<td class="cellcontent" style="padding-left:4px">
								<cf_tl id="Post Type">
								</td>
								<td class="cellcontent" style="cursor: pointer;padding-left:3px">
								<input type="radio" id="#url.org#_sort4" name="#url.org#_sort" value="location" <cfif URL.Sort eq "location">checked</cfif> onclick="detaillisting('#URL.org#','show','#URL.Mode#','#URL.Filter#','#URL.Level#','#URL.Line#','#URL.Cell#','location','#URL.date#')">
								</td>
								<td class="cellcontent" style="padding-left:4px">
								<cf_tl id="Location">
								</td>	
								<td class="cellcontent" style="cursor: pointer;padding-left:3px">
								<input type="radio" id="#url.org#_sort5" name="#url.org#_sort" value="workschedule" <cfif URL.Sort eq "workschedule">checked</cfif> onclick="detaillisting('#URL.org#','show','#URL.Mode#','#URL.Filter#','#URL.Level#','#URL.Line#','#URL.Cell#','workschedule','#URL.date#')">
								</td>
								<td class="cellcontent" style="padding-left:4px">
								<cf_tl id="Workschedule">
								</td>						
							</tr>
						</table>
						
						</cfif>
						
						</td>
												
						<td width="5%" align="right" class="cellcontent">
											
						<cfinvoke component="Service.Analysis.CrossTab"  
							  method         = "ShowInquiry"
							  buttonName     = "Excel"
							  buttonText     = "Export to MS - Excel"
							  buttonClass    = "td"
							  buttonIcon     = "#SESSION.root#/Images/sqltable.gif"
							  scriptfunction = "facttabledetailxls"
							  reportPath     = "Staffing\Reporting\PostView\Staffing\"
							  SQLtemplate    = "PostViewDetailExcel.cfm"  <!--- generates the data --->
							  queryString    = "Mission=#URL.Mission#&Mandate=#URL.Mandate#&org=#url.org#"
							  dataSource     = "appsQuery" 
							  module         = "Staffing"
							  reportName     = "Facttable: Staffing Table"
							  table1Name     = "Export file"
							  data           = "1"
							  filter         = "#url.org#"
							  ajax           = "1"
							  olap           = "0" 
							  excel          = "1"> 
			  					
						</td>
																		
						<td width="6%" align="right" class="cellcontent">
												
						<cfif URL.Search eq "0">
												
							<img src="#SESSION.root#/Images/refresh.gif" 
							align="absmiddle" 
							alt="Refresh" 
							border="0" 
							id="refresh_i#URL.Org#" 
							align="absmiddle" 
							style="cursor: pointer;" 
							onClick="javascript:detaillisting('#URL.org#','show','#URL.Mode#','#URL.Filter#','#URL.Level#','#URL.Line#','#URL.Cell#','#URL.Sort#','#URL.date#')">
							
							<a href="javascript:detaillisting('#URL.org#','show','#URL.Mode#','#URL.Filter#','#URL.Level#','#URL.Line#','#URL.Cell#','#URL.Sort#','#URL.date#')">
							Reload
							</a>
				   		<cfelse>						
						    <img src="#SESSION.root#/Images/refresh.gif" align="absmiddle" alt="Refresh" border="0" id="refresh_i#URL.Org#" align="absmiddle" style="cursor: pointer;" onClick="javascript:searchnew('#URL.tpe#')">
							Reload
				     	</cfif>
						
						</td>
																		
						<TD width="35" align="right" style="padding-right:5px">
						
							<img src   = "#client.VirtualDir#/Images/close3.gif" 
							alt="Hide" border="0" 
							align  = "right" class="regular" style="cursor: pointer;" 
							onClick= "detaillisting('#url.org#','hide','only','','','','','','#URL.DATE#')">
							
						</TD>
						
				 	</tr>
											
					</cfoutput>
									
				</table>   	
			
			</td>
			</tr>
								
		<tr><td>
						
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		    <tr class="labelit line">
				<td height="19" colspan="2"></td>
				<td width="3%"><cf_tl id="PostNo"></td>
				<td width="3%"></td>
				<td width="5%"><cf_tl id="Grade"></td>
				<td width="24%"><cfif URL.Mode eq "Only"><cf_tl id="Function"><cfelse><cf_tl id="Unit"></cfif></td>
				<td width="12%"><cf_tl id="Location"></td>
				<td width="3%"><cf_tl id="Inc"></td>
				<td width="23%"><cf_tl id="Incumbent"></td>
				<td width="6%"><cf_tl id="#CLIENT.IndexNoName#"><cf_space spaces="20"></td>
				<td width="4%"><cf_tl id="Nat."></td>
				<td width="7%"><cf_tl id="Lvl"></td>
				<td width="3%"></td>
		    </tr>
						
			<cfset rw = 0>			
			<cfset ort = "">
									
			<cfinvoke component="Service.Access"  
				  method="recruit" 
				  orgunit="#SearchResult.OrgUnit#" 
				  posttype="#SearchResult.PostType#"
				  returnvariable="accessRecruit">
				  
			<cfinvoke component="Service.Access"  
				  method="staffing" 
				  orgunit="#SearchResult.OrgUnit#" 
				  posttype="#SearchResult.PostType#"
				  returnvariable="accessStaffing"> 
			   
			 <cfset pos = "">  
			 <cfset ass = "">
			 		 		 
			<cfswitch expression="#URL.sort#">
				 <cfcase value="grade">         <cfset grp = "PostOrder">    </cfcase>
				 <cfcase value="posttype">      <cfset grp = "PostType">     </cfcase>
				 <cfcase value="postclass">     <cfset grp = "PostClass">    </cfcase>
				 <cfcase value="location">      <cfset grp = "LocationCode"> </cfcase>	
				 <cfcase value="workschedule">  <cfset grp = "WorkSchedule"> </cfcase>	
				 <cfdefaultcase> <cfset grp = "PostOrder"> </cfdefaultcase>
			</cfswitch>
												 
		    <cfoutput query="SearchResult" group="#grp#">
													
				<cfset col = "13">
					  
			   <cfswitch expression = "#URL.Sort#">
			  		  				   
				 <cfcase value = "PostClass">
				 <tr bgcolor="f8f8f8" class="line">
			     <td class="labelmedium" style="padding-left:6px" colspan="#col#"><b>#PostClass#</b></font></td></tr>				 
				
			     </cfcase>
				 
				 <cfcase value = "Location">
				 
				     <tr bgcolor="f4f4f4" class="line">
				     <td class="labelmedium" style="padding-left:6px" colspan="#col#"><b>#LocationCode# <cfif LocationName eq "">Undefined<cfelse>#LocationName#</cfif></b></td></tr>								 
										 
				 </cfcase>
				 
				  <cfcase value = "WorkSchedule">
				  
				  	<cfquery name="count" dbtype="query"> 
				    	SELECT count(*) as Total
						FROM   SearchResult 
						WHERE  WorkSchedule = '#workschedule#'						
					</cfquery>
					
					 <cfif workschedule eq "0">
					 
					  <tr bgcolor="f8f8f8" style="border-bottom:1px solid B0B0B0;">
				     <td  class="labelmedium" style="height:40;padding-left:6px" colspan="#col#"><font color="FF0000">Not scheduled for #dateformat(sel,client.dateformatshow)# [#count.total#]</td></tr>									 
					 					 
					 <cfelse>
				 
				     <tr style="height:43px;border-bottom:1px solid B0B0B0" bgcolor="f8f8f8" class="line">
				     <td  class="labellarge" style="height:40;padding-left:6px" colspan="#col#">#WorkSchedule# [#count.total#]</td></tr>									 
										 
					 </cfif>
					 
				 </cfcase>
				 
				 <cfcase value = "Grade">
				 
				     <tr style="height:43px;border-bottom:1px solid B0B0B0" bgcolor="f8f8f8" class="line">
				     <td  class="labellarge" style="padding-left:6px" colspan="#col#">#PostGrade#</td></tr>									 
										 
				 </cfcase>
				 
				 <cfcase value = "Posttype">
				     <tr style="height:43px;border-bottom:1px solid B0B0B0" bgcolor="f4f4f4" class="line">
				     <td  class="labellarge" style="padding-left:6px" colspan="#col#">#Posttype#</td></tr>						 
					 					 
			     </cfcase>
				 
				 </cfswitch>
							  		   
			<cfoutput> 			
								
				<cfif find(PositionNo,Pos) and URL.Search eq "0">
				
					<!--- check if this position has indded more than one assignment in the table --->
					
					<cfquery name="checkDouble" dbtype="query"> 
				    	SELECT DISTINCT AssignmentNo 
						FROM   SearchResult 
						WHERE  PositionNo = #PositionNo#
						AND    Incumbency > 0
					</cfquery>
					
					<cfif checkdouble.recordcount gte "2">
					   <cfset dbl = 1>					  	  
					<cfelse>
					   <cfset dbl = 0>  
					</cfif>		  
					
					<cfquery name="checkSame" dbtype="query"> 
				    	SELECT DISTINCT AssignmentNo 
						FROM   SearchResult 
						WHERE  PositionNo = #PositionNo#					
					</cfquery>
								
					<cfif checksame.recordcount gte "2">
					   <cfset sme = 1>					  	  
					<cfelse>
					   <cfset sme = 0>  
					</cfif>		    
				 
				<cfelse>
				
				   <cfset dbl = 0>  
				   <cfset sme = 0> 
				    
				</cfif> 
			  				 
				<cfif pos neq "">
					<cfset pos = "#pos#-#PositionNo#">	
				<cfelse>
				    <cfset pos = "#PositionNo#">	
				</cfif>
								
				<cfif AssignmentNo neq "">
					<cfif ass neq "">
						<cfset ass = "#ass#-#AssignmentNo#">	
					<cfelse>
					    <cfset ass = "#AssignmentNo#">	
					</cfif>
				</cfif>		
				
				<cfif ort neq "#HierarchyCode#" and search eq "1">
																	
					<tr>
					  <td colspan="1" style="padding-left:8px">
					  
					   <cf_img icon="open" onClick="maintainQuick('#OrgUnitCode#')">
					  				
					  </td>
					  <td colspan="10" class="cellcontent"><b>							 	  
					  
					   <cfquery name="Parent" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
								SELECT  P.*
								FROM    Organization O, Organization P
								WHERE   O.OrgUnit       = '#OrgUnitOperational#' 
								AND     O.ParentOrgUnit = P.OrgUnitCode
								AND     P.Mission       = '#URL.Mission#'
								AND     P.MandateNo     = '#URL.Mandate#'
					   </cfquery>	
					   
					   <a href="javascript:maintainQuick('#OrgUnitCode#')">
					   #Parent.OrgUnitName# / #OrgUnitName# (#OrgUnitCode#)
					   </a>
					   </b></td>
					   <cfset ort = HierarchyCode>
				    </tr>
									
				</cfif>
										
			<cfif URL.ID eq "0" or (URL.ID eq "1" AND PersonNo eq "")>
												
				<cfset cl = presentationcolor>
												
			    <cfif PostAuthorised eq "0" and Mandate.MandateStatus eq "1">
			      <cfset cl = "E2FEE4">
			    </cfif>
																	
				<cfif Orgunit neq OrgUnitParent and Class eq "Used">
						<cfset showpdte = 0>									
				<cfelseif DateFormat(Mandate.DateExpiration, CLIENT.DateFormatShow) eq DateFormat(ParentExpiration, CLIENT.DateFormatShow)>					
					    <cfset showpdte = 0>					
				<cfelse>				
					    <cfset showpdte = 1>					
				</cfif>
				
				<cfif dbl eq "1">
					  <cfset cl = "FFCEB7">
					  <tr><td style="height:1px" class="line" colspan="13"></td></tr>
					  <tr><td bgcolor="Yellow" colspan="13" align="center" class="labelmedium"><b>Position has more than one assignment</td></tr>	
					  <tr><td style="height:1px" class="line" colspan="13"></td></tr>
				</cfif>
				
				<cfif sme eq "0">	  				
					  <cfset rw = rw + 1>  
				</cfif>			
				
				<cfset cutoff = dateAdd("d",param.AssignmentExpiration,now())>			
																					
				<tr bgcolor="#cl#" style="height:30px" class="navigation_row labelit">
							
				<td style="border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;padding-left:10px;padding-right:3px"><cfif sme neq "1">#rw#.</cfif></td>
								
				<td width="20" style="padding-left:4px;border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;">
				
				<cf_assignId>
				
				<cfif AccessRecruit eq "EDIT" or AccessRecruit eq "ALL" 
				   or AccessStaffing eq "EDIT" or AccessStaffing eq "ALL">	
				 			 				   				   			
					<img src="#SESSION.root#/Images/memo.png" height="16" alt="Enter remarks" 
						id="#rowguid#Exp" border="0" class="regular" 						
						align="middle" style="cursor: pointer;" 
						onClick="memoshow('#rowguid#','show')">
					
					<img src="#SESSION.root#/Images/arrowdown.gif" 
						id="#rowguid#Min" alt="Hide remarks" border="0" 
						align="middle" class="hide" style="cursor: pointer;" 
						onClick="memoshow('#rowguid#','hide')">
					
					</cfif>
				
	     		</td>
				
				<td style="width:80px;padding-left:4px;padding-right:7px;border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;">
							
					 <cfif url.sort eq "WorkSchedule" and currentrow eq "1">					 
						 <cf_space spaces="25">					 
					 </cfif>
				
				   <a href="javascript:EditPosition('#URL.Mission#','#URL.Mandate#','#PositionNo#','i#URL.Org#')" class="navigation_action"  
				      title="Edit position">
					  	   			   	   

					   <cfif SourcePostNumber neq "">				   
					  	#SourcePostNumber#								   
					   <cfelse>
					    #PositionNo#
					   </cfif>
					   
					   <cfif url.sort eq "WorkSchedule">
					   
						   	<cfquery name="count" dbtype="query"> 
						    	SELECT count(*) as Total
								FROM   SearchResult 
								WHERE  PositionNo = #PositionNo#						
							</cfquery>
							
							<cfif count.total gt "1">
								&nbsp;<font color="FF8000"><b>[#count.total#]</font>					
							</cfif>					   
					   
					   </cfif>
					   
				   </a>				   
				   
			    </td>
				
				<td style="padding-right:3px;border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;"><cfif PostClass neq "Valid">#PostClass#</cfif></td>
				<td align="center" style="border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;">#PostGrade#</td>
				<td style="border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;">
				
				   <cfif URL.Mode eq "Only">
				       #FunctionDescription# <cfset des = FunctionDescription>
				   <cfelse>
					   <cfif #Len(OrgUnitName)# gt 43>#left(OrgUnitName,37)#...<cfelse>#OrgUnitName#</cfif>
					   <cfset des = OrgUnitName>
				   </cfif>				
												
				</td>
				<td style="border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;">#LocationName#</td>
				<cfif Incumbency eq "0">
				<td style="border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;padding-right:2px"">				
				<table width="100%" bgcolor="FF80FF" style="border-left:1px solid silver;border-right:1px solid silver">
				<tr class="labelit">
					<td align="center" style="padding-left:2px;padding-right:2px">#Incumbency#</td>
					<td align="center" style="padding-top:1px"><cf_img icon="open" onClick="javascript:positionchain('#personno#')"></td>
				</tr>
				</table>				
				</td>
				<cfelse>
				<td style="border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;">#Incumbency#</td>
				</cfif>
								
				<cfif PersonNo eq "">
				 											
					<td colspan="5" align="left" align="center" style="border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;">
					
					 <table width="100%" cellspacing="0" cellpadding="0">
					 <tr class="labelit">
					 <td align="center" style="color:red">--- #tVacant# ---</font></td>
									 
					 <cfif AccessStaffing eq "EDIT" or AccessStaffing eq "ALL">
					 
					     <td>
						 
						 <table>
							 <tr class="labelit">
							 
							 <cfif Param.AssignmentEntryDirect eq "1">
							 	
							 <td>					 
								 <a title="Register recruitment request" href ="javascript:AddAssignment('#PositionNo#','i#URL.Org#')">#tIncumbent#</a>
							 </td>	
															
							 </cfif>	
									
							 <td style="padding-left:5px">						
								 <A title="Register recruitment request" 
								    href ="javascript:AddVacancy('#PositionNo#','i#URL.Org#')">#tInitiateRecruitment#</a>
							 </td>
							 
							 </tr>
						 </table>
						
						 </td>
						 
					 <cfelse>
					 					  
					  	  <cfif AccessRecruit eq "EDIT" or AccessRecruit eq "ALL">			   
						  <td>						 	 
						   	 <a title="Register recruitment request" HREF ="javascript:AddVacancy('#PositionNo#','i#URL.Org#')"><cf_tl id="Initiate Recruitment"></a>							 
						   </td>
						  </cfif> 
										 				 	 
					 </cfif>
					 
					 <td style="width:25%" style="width:25%;border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;border-right:1px solid silver">

					 
					 	<cfif EnableAssignmentReview eq 1>
					 
							<cfif AccessStaffing eq "EDIT" or AccessStaffing eq "ALL" 
							    or AccessRecruit eq "EDIT" or AccessRecruit eq "ALL">
														
								     <img src="#SESSION.root#/Images/HR_EmployeeOutgoing.png"
									     title="Assignment review prior to creation of a recruitment track"
									     border="0"
										 height="15" width="15"
									     align="absmiddle"
									     style="cursor: pointer;"
									     onClick="AddReview('#PositionNo#','i#url.org#')">
									 
								</cfif>		
			  
						</cfif>		
						
						</td>
						
						</tr>			
					 
					 </table>
					 
					 </td>
					 
				<cfelse>
				
					<td style="border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;"><a href="javascript:EditAssignment('#PersonNo#','#AssignmentNo#','#positionno#','i#URL.Org#')">#FullName#</a></td>
					<td style="border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;"><a href="javascript:EditPerson('#PersonNo#','i#URL.Org#')"><cfif IndexNo eq ""><cfif Reference neq "">#Reference#<cfelse>No Index</cfif><cfelse>#IndexNo#</cfif></a></td>
					<td style="padding-left:4px;border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;">#Nationality#</td>
					<td style="border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;"><cfif ContractLevel neq "">#ContractLevel#/#ContractStep#</cfif></td>
					<td style="width:140;padding-right:4px;border-top:1px solid B0B0B0;border-bottom:1px solid B0B0B0;">
																
					<table width="100%" cellspacing="0" cellpadding="0">
					
					<tr>
					
						<td style="padding-left:5px;width:25%" align="center">
						<cfif Extension neq "">												
						    <img src="#SESSION.root#/Images/reminder.png"  height="15" width="15" alt="Extension requested" border="0">							
						</cfif>
						</td>
												
						<td style="padding-left:5px;width:25%" align="center">
						
						<cfif EnableAssignmentReview eq 1>
						
							<cfif AccessStaffing eq "EDIT" or AccessStaffing eq "ALL" 
							    or AccessRecruit eq "EDIT" or AccessRecruit eq "ALL">

							     <img src="#SESSION.root#/Images/HR_EmployeeOutgoing.png"
								     title="Assignment review prior to creation of a Recruitment Request"
								     border="1"
									 height="17" width="15"
								     align="absmiddle"
								     style="cursor: pointer;"
								     onClick="AddReview('#PositionNo#','i#url.org#')">
															  
							</cfif>		
							
						</cfif>
						</td>
						
						<td style="padding-left:5px;width:25%" align="center">
						
						<cfif AccessStaffing eq "EDIT" or AccessStaffing eq "ALL" 
						    or AccessRecruit eq "EDIT" or AccessRecruit eq "ALL">
													
						     <img src="#SESSION.root#/Images/hr_positionadd.png"
							     title="Record a Recruitment Request"
							     border="1"
								 height="17" width="15"
							     align="absmiddle"
							     style="cursor: pointer;"
							     onClick="AddVacancy('#PositionNo#','i#url.org#')">
														  
						</cfif>		
						</td>
						
						<td style="padding-left:5px;width:25%" align="center">
						<cfif EnablePAS eq "1" and ePASOperational eq "1">
						
							<cfif AccessStaffing eq "READ" or AccessStaffing eq "EDIT" or AccessStaffing eq "ALL" or AccessRecruit eq "EDIT" or AccessRecruit eq "ALL">
							   <cfif ContractNo eq "0">
							   
						         <img src="#SESSION.root#/Images/Evaluate.png"
								     Title="Register Performance Approval request"
								     border="1"
									 height="17" width="15"
								     align="absmiddle"
								     style="cursor: pointer;"
								     onClick="AddPAS('#AssignmentNo#','i#url.org#')">
									 
							   </cfif>
							</cfif>	
						
						</cfif>	
						</td>
					</tr>
					</table>  
					
					</td>
			    </cfif>	
				</tr>
					
				<cfif showpdte eq 1 and Mission.MissionStatus eq "0">
				<tr  class="">
				    <td colspan="5"></td>
					<TD colspan="7" class="labelit"><font color="FF0000">#DateFormat(ParentEffective, CLIENT.DateFormatShow)# - #DateFormat(ParentExpiration, CLIENT.DateFormatShow)#</font></TD>
					<TD></TD>
				</tr>
				</cfif>
																											
				<tr id="memo#rowguid#hdr" class=" labelit <cfif #Remarks# eq "">hide<cfelse>regular</cfif>">
					<td colspan="3"></td>
					<td style="border:1px solid B0B0B0;padding-left:6px" id="memo#rowguid#" colspan="10">#Remarks#</td>
				</tr>
				
				<cfif AccessRecruit eq "EDIT" 
					  or AccessRecruit eq "ALL" 
					  or AccessStaffing eq "EDIT" 
	    			  or AccessStaffing eq "ALL">		
				
					<tr id="#rowguid#" class="hide">
					
						<td colspan="1"></td>
											
						<td colspan="14" style="padding-top:5px">
						
							<table width="100%"><tr><td>
							
							<textarea style = "width:99%;padding:3px;font-size:14px" 
							          rows  = "3" 
									  name  = "remarks#left(rowguid,8)#" 
									  id    = "remarks#left(rowguid,8)#" 
									  class = "regular" 
									  value = "#Remarks#">#remarks#</textarea> 
									  
								</td>
								</tr>
								<tr><td align="center" style="padding-top:2px"> 
																
								<input type = "button" 
							      class     = "button10g" 
								  style     = "width:130px" 
								  name      = "Save" 
								  value     = "Save" 
								  onClick   = "memo('#PositionNo#','#rowguid#')">	  
								  
								</td></tr>	 
							</table>		  
							
						</td>					
						
					</TR>
								
				</cfif>
										
				<cfif URL.Mode neq "Only" and url.sort neq "Workschedule">
				
				    <tr class=" labelit" style="height:10px">
						<td colspan="3"></td>
						<td style="border-left:1px solid B0B0B0;padding-left:6px" colspan="2"><cf_tl id="Title">:</td>
						<td colspan="8" style="padding-left:4px;border-right:1px solid B0B0B0;">
							<cfif FunctionDescription eq "undefined">
								A function description is not on file
							<cfelse>
								<a href="javascript:gjp('#functionNo#','#postgrade#')">#FunctionDescription#</a>
							</cfif>
						</td>						
					</tr>
					
				</cfif>	
				
				<!--- ------------------------------- --->
				<!--- we have an active workflow here --->
				<!--- ------------------------------- --->
				
				<cfif PositionReview neq "">
				
					<!--- Hanno 12/12 ajax embedded list instead --->					
					
					<input type="hidden" 
					   name="workflowlink_#positionreview#" 
					   id="workflowlink_#positionreview#" 		   
					   value="#SESSION.root#/staffing/reporting/postview/staffing/PostViewDetailWorkflow.cfm">	
					
					<tr class="">
					    <td colspan="3"></td>
					    <td style="border-left:1px solid B0B0B0;border-right:1px solid B0B0B0;;padding-left:6px" colspan="10" style="padding-top:5px">
						
						<table>
						<tr>
						
					    <cf_wfactive entityCode="PositionReview" ObjectKeyValue1="#positionno#">
								
						<cfif wfstatus neq "closed">
							
							 <td height="20"
							    align="center" 
								style="cursor:pointer;padding-top:2px" 
								onclick="workflowdrill('#positionreview#','position')">
							 
									<img id="exp#positionreview#" 
									     class="hide" 
										 src="#SESSION.root#/Images/arrowright.gif" 
										 align="absmiddle" 
										 alt="Expand" 
										 height="9"
										 width="7"			
										 border="0"> 	
													 
								   <img id="col#positionreview#" 
									     class="regular" 
										 src="#SESSION.root#/Images/arrowdown.gif" 
										 align="absmiddle" 
										 height="10"
										 width="9"
										 alt="Hide" 			
										 border="0"> 		
								  								
							<cfelse>
							
								<td height="20" style="padding-top:2px" align="center" onclick="workflowdrill('#positionreview#','position')">	
								
								 <img id="exp#positionreview#" 
									     class="regular" 
										 src="#SESSION.root#/Images/arrowright.gif" 
										 align="absmiddle" 
										 alt="Expand" 
										 height="9"
										 width="7"			
										 border="0"> 	
													 
								   <img id="col#positionreview#" 
									     class="hide" 
										 src="#SESSION.root#/Images/arrowdown.gif" 
										 align="absmiddle" 
										 height="10"
										 width="9"
										 alt="Hide" 			
										 border="0"> 
										 
								 </td>		 
							  
							</cfif>	 
							
							<td class="labelmedium" onclick="workflowdrill('#positionreview#','position')" 
							  style="cursor:pointer;padding-left:7px"><font color="DD6F00"><cf_tl id="Incumbency Review"></td>
												
						</tr>			
						
						</table>						
						
					</tr>										
					
					<tr class="">
						<td colspan="3"></td>
						<td style="border-left:1px solid B0B0B0;padding-left:6px;border-right:1px solid B0B0B0;" 
						  align="center" colspan="10">
						
						   <cfif wfstatus eq "closed">						   
						     <cfdiv class="hide" id="#positionreview#"/>						   
						   <cfelse>						   	
						     <cfdiv class="regular" bind="url:#SESSION.root#/Staffing/Reporting/Postview/Staffing/PostViewDetailWorkflow.cfm?ajaxid=#PositionReview#" 
						         id="#positionreview#"/>							  
						   </cfif>	  
						   
						</td>
						<td></td>
					</tr>
																			
					
				<cfelse>
				
					<!--- ---------------------------------------- --->
					<!--- we check if we need a review action here --->
					<!--- ---------------------------------------- --->
				
					<cfif DateExpiration lte cutoff and Dateexpiration gte now() and DateEffective lte now()>
					
					<tr class="">
					    <td colspan="3"></td>
						
												
					    <td height="22" colspan="9" align="center" bgcolor="FEBBAF" class="labelit" style="border-left:1px solid B0B0B0;padding-left:6px">
						
							<font color="black">
							Assignment of <b>#FullName#</b> will end on <b><u>#dateformat(DateExpiration,client.dateformatshow)#
							<cfset diff = dateDiff("d",now(),DateExpiration)> <cfif diff gte "2">in #diff# days </cfif>
							</b>
							
					   </td>
					</tr>
					
					</cfif>		
				
				</cfif>				
				
				<cfif Orgunit neq OrgUnitParent and Class eq "Used">
				
					<cfquery name="Org" 
				    datasource="AppsOrganization" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					    SELECT *	
						FROM   Organization
						WHERE  OrgUnit = '#OrgUnitParent#'
					</cfquery>   
									
					<tr class=" labelit">
						
						<td colspan="3"></td> 
						<td colspan="2" style="border-left:1px solid B0B0B0;padding-left:6px"><cf_tl id="Borrowed from">:</td>
						<td colspan="8" style="border-right:1px solid B0B0B0;">
						
						 <cfquery name="Parent" 
			 				datasource="AppsOrganization" 
							maxrows=1 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    	SELECT OrgUnitName
								FROM   Organization
								WHERE  Mission   = '#URL.Mission#'
								AND    MandateNo   = '#URL.Mandate#'
								AND    OrgUnitCode IN (SELECT ParentOrgUnit FROM Organization WHERE OrgUnit = '#Org.OrgUnit#')
						</cfquery>
						<cfif Org.Mission neq URL.Mission>#Org.Mission#&nbsp;</cfif>
						<cfif Parent.recordcount eq "1">#Parent.OrgUnitName#/</cfif>#Org.OrgUnitName# 												
						&nbsp;&nbsp;<font color="808080"><cf_tl id="Period">:</font> #dateformat(PostEffective,CLIENT.DateFormatShow)# - #dateformat(PostExpiration,CLIENT.DateFormatShow)#
						</td>
					</tr>
				
				</cfif>
				
				<cfif (FunctionNoActual neq FunctionNo and FunctionDescriptionActual neq "") or 
				      class eq "Loaned" or
					  (Orgunit neq OrgUnitParent and Class eq "Used")>
													
					<tr class=" labelit">
						<td colspan="3"></td>
						<td colspan="2" style="border-left:1px solid B0B0B0;padding-left:6px">#tAssigned#:</td>
						<td colspan="8" style="border-right:1px solid B0B0B0;">#FunctionDescriptionActual#</td>
					</tr>
				
				</cfif>
				
				<cfif ContractNo gte "1">
				
					  <cfquery name="ePasList" 
						datasource="AppsEPAS" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  C.ContractId,
							        C.ContractNo,
							        C.DateEffective, 
									C.DateExpiration,
									C.FunctionDescription, 
							        CA.RoleFunction as RoleFunction, 
									P.LastName as LastName, 
									P.FirstName as FirstName, 
									P.IndexNo as IndexNo, 
									P.PersonNo as PersonNo,
									R.Description as StatusDescription
							FROM    ContractActor CA INNER JOIN
					                Employee.dbo.Person P ON CA.PersonNo = P.PersonNo INNER JOIN
					                Contract C ON CA.ContractId = C.ContractId INNER JOIN
									Ref_Status R ON C.ActionStatus = R.Status
							WHERE   AssignmentNo = '#AssignmentNo#'
							AND     R.ClassStatus = 'Contract'
							AND     CA.RoleFunction = 'Supervisor'
					  </cfquery>						  
									  
					<cfloop query="ePasList">
					  					
					<tr bgcolor="E1F8FF" class="">
					<td colsoan="3"></td>
					<td colspan="10" style="border-left:1px solid B0B0B0;padding-left:6px;border-right:1px solid B0B0B0;">
						<table width="100%" cellspacing="0" cellpadding="0">
							<tr class="labelit">
							<td width="40"><b>PAS:</b></td>
							<td width="60"><a href="javascript:pasdialog('#contractId#')">#ContractNo#</a></td>
							<td width="160">#dateformat(dateeffective,CLIENT.DateFormatShow)# - #dateformat(dateexpiration,CLIENT.DateFormatShow)#
							</td>
							<td width="60">#StatusDescription#</td>
							<td width="200">#FunctionDescription#</td>
							<td width="260"><a href="javascript:EditPerson('#PersonNo#')"><b>#RoleFunction#</b>: #FirstName# #LastName#</a></td>						
							</tr>
						</table>
					</td>
					</tr>
					
					</cfloop>
													
				</cfif>
				
				<!--- show track information --->
									
				<cfif RecruitmentTrack gt "0">
				
					    <cfquery name="Tracks" 
					datasource="AppseMPLOYEE" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				
					<!--- select track occurence --->												  
							
					SELECT    D.*, RC.EntityClassName 
					FROM      Vacancy.dbo.DocumentPost as Track INNER JOIN
		    			              Position PM ON Track.PositionNo = PM.PositionNo INNER JOIN
		                      Position SP ON PM.PositionParentId = SP.PositionParentId INNER JOIN
		                      Vacancy.dbo.Document D ON Track.DocumentNo = D.DocumentNo INNER JOIN
							  Organization.dbo.Ref_EntityClass RC ON RC.EntityClass = D.EntityClass AND RC.EntityCode = 'VacDocument'		
					WHERE     SP.PositionNo = '#PositionNo#' 
					AND       D.EntityClass IS NOT NULL 
					AND       D.Status = '0'
					
					<!--- current mandate track linked through source --->
					
					UNION 
																	
					<!--- first position in the next mandate --->			
					
					SELECT     D.*, RC.EntityClassName
					FROM       Vacancy.dbo.DocumentPost as Track INNER JOIN
		                       Position PM ON Track.PositionNo = PM.PositionNo INNER JOIN
			                   Position SP ON PM.PositionParentId = SP.PositionParentId INNER JOIN
			                   Vacancy.dbo.Document D ON Track.DocumentNo = D.DocumentNo INNER JOIN
		                       Position PN ON SP.PositionNo = PN.SourcePositionNo INNER JOIN
							   Organization.dbo.Ref_EntityClass RC ON RC.EntityClass = D.EntityClass AND RC.EntityCode = 'VacDocument'		 
					WHERE      D.EntityClass IS NOT NULL 
					AND        D.Status = '0' 
					AND        PN.PositionNo = '#PositionNo#'			
					
					</cfquery>			
																			
					<cfloop query="Tracks">	
					
					<tr class="labelit  line" style="border-top:1px solid silver" bgcolor="#cl#">
					
					<td colspan="3"></td>
					
					<td colspan="2" style="border-left:1px solid B0B0B0;padding-left:6px;padding-top:4px;padding-right:4px">
					
					<cfif tracks.FunctionId neq "">
					
						<cfquery name="Reference" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   *			
							FROM     FunctionOrganization
							WHERE    FunctionId = '#functionId#'					
						</cfquery>
												
						<cfif Reference.ReferenceNo neq "">
							<a title="Vacancy No" href="javascript:showdocument('#DocumentNo#')">#Reference.ReferenceNo#</a>
						<cfelse>
							<a href="javascript:showdocument('#DocumentNo#')" title="TrackNo">No: #DocumentNo#</font></a>
						</cfif>
						
					<cfelse>
					
						<a href="javascript:showdocument('#DocumentNo#')" title="TrackNo">No: #DocumentNo#</a>
					
					</cfif>	
					
					</td>

					<td colspan="4" style="border-left:1px solid B0B0B0;border-right:1px solid B0B0B0;padding-left:6px;padding-top:4px;padding-right:4px">
										
					#EntityClassName#:
									
					&nbsp;#officerUserFirstName# #OfficerUserLastName# : #dateformat(created,CLIENT.DateFormatShow)#
					
					</td>
										 
						 <cfquery name="Candidate" 
							datasource="AppsVacancy" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT  PersonNo, LastName, FirstName, StatusDate
							FROM    DocumentCandidate P
							WHERE   DocumentNo = '#DocumentNo#' 
							  AND   Status = '2s'
						</cfquery>	
						
						<cfset cpl = DateFormat(Candidate.StatusDate, CLIENT.DateFormatShow)>
																				
						<cfif Candidate.recordcount gte "1">
							<td style="padding-left:3px;border-left:1px solid B0B0B0;border-right:1px solid B0B0B0;" colspan="4" bgcolor="yellow">
							<cfloop query = "Candidate">
							<a href="javascript:ShowCandidate('#Candidate.PersonNo#')" title="selected candidate">#Candidate.FirstName# #Candidate.LastName#<cfif currentrow neq recordcount>;</cfif></a>&nbsp;
							</cfloop>
							- #cpl#
							</td>
						<cfelse>
							<td style="padding-left:3px;border-left:1px solid B0B0B0;border-right:1px solid B0B0B0;" colspan="4"> - #tNoCandidateInfo# -</a></td>
						</cfif>
						
						</tr>
						
					</cfloop>									
	 		 	
				</cfif>		
				
				<cfif Class eq "Loaned">
				
				 <tr class=" labelit line">
				 
				 <td colspan="3"></td>
				 <td colspan="2" style="border-left:1px solid B0B0B0;padding-left:6px"><cf_tl id="Loaned to">:</td>
				 <td colspan="8">
				
				    <cfquery name="Loaned" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization
						WHERE  OrgUnit = #OrgUnitOperational#
					</cfquery>	
				 
				   <cfquery name="ParentP" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT OrgUnitName
						FROM   Organization
						WHERE  Mission     = '#Loaned.Mission#'
						AND    MandateNo   = '#Loaned.MandateNo#'
						AND    OrgUnitCode = '#Loaned.ParentOrgUnit#'						
					</cfquery>
										
					<A HREF ="javascript:maintainQuickLoan('#Loaned.Mission#','#Loaned.MandateNo#','#Loaned.OrgUnitCode#')" title="Review staffing">
					<b>
					#Loaned.Mission# - 
					<cfif ParentP.recordcount eq "1">#ParentP.OrgUnitName#/</cfif>#Loaned.OrgUnitName#</b></A></TD>
								 
			    </cfif>	 
												
				<cfif OrgunitActual neq OrgUnitOperational and OrgunitActual neq "" AND OrgunitOperational neq "">
				
					<cfquery name="Org" 
				    datasource="AppsOrganization" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    	SELECT *	
						FROM  Organization
						WHERE OrgUnit = '#OrgUnitActual#' 
					</cfquery>   
					
					<cfif Org.recordcount eq "1">
					<tr class=" labelit">
					    <td colspan="3"></td>
						<td colspan="2" style="border-left:1px solid B0B0B0;padding-left:6px"><cf_tl id="Assigned to">:</td>
						<td colspan="8">#Org.OrgUnitName#</td>						
					</tr>
					</cfif>
				
				</cfif>
			
			</cfif>
			
			<cfif showpdte eq 2>
				<tr class=" labelit line">
				    <td colspan="3"></td>
					<TD colspan="9" style="border-left:1px solid B0B0B0;padding-left:6px"><font color="FF0000">#DateFormat(DateEffective, CLIENT.DateFormatShow)# - #DateFormat(DateExpiration, CLIENT.DateFormatShow)#</font></TD>
					<TD></TD>
				</tr>
				</cfif>
			
								
		</cfoutput>
		
		</cfoutput>		
		
		<cfif searchresult.recordcount eq "0" and search eq "0">
		
			<tr>
			  <td colspan="13" align="center"><b><cf_tl id="No positions found in this unit" class="message"></b></td>
		    </tr>
		    
		</cfif>	
			
	</table>

	</td>
	</tr>
	
</cfif>

</table>
 
</td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>

<!--- keeps the link to the generated table for export, no longer needed as we keep the table generated for the box handy

<form name="form_<cfoutput>#url.org#</cfoutput>" id="form_<cfoutput>#url.org#</cfoutput>" method="post">

	<cfoutput>		
		<input type="hidden" name="position_#url.Org#"   value="#pos#">
		<input type="hidden" name="assignment_#url.Org#" value="#ass#">
		<input type="hidden" name="table_#url.Org#" value="#SESSION.acc#Staffing_#FileNo#">		
	</cfoutput>

</form>

--->

