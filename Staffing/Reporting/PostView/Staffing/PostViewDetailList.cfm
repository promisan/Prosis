
<!--- presentation order

	1.	Post and incumbent
	2.  Parent position effective period
	3.  Remarks
	4.  Position title and period
	5.  Assignment title / loan
	6.  Borrow
	7. ePas
	8. recruitment

--->

<cfparam name="source" default="">

<cfquery name="Parameter" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission   = '#URL.Mission#'
</cfquery>	


<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table formpadding">
  	   
	   <tr><td>
	 	  	  	      							   
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" id="box">
		
		<cfif SearchResult.recordcount eq "0">
		
		<tr><td height="46" align="center" class="labelmedium"><cf_tl id="There are no records to show in this view">.</td></tr>
		
		<script>
			 Prosis.busy('no')
		</script>
						
		<cfelse>
		
			<!--- ---------------------------------------------------------- --->
			<!--- -----------Line 1 of 12 : TOP record ---------------------- --->
			<!--- ---------------------------------------------------------- --->
		
			<tr><td height="26"  style="border-top:1px solid silver">
			
				<table border="0" width="100%" align="center">
					
					<cfoutput>
					
					<tr>
					
						<TD width="35" align="left" style="padding-left:5px">
						
							<img src   = "#client.VirtualDir#/Images/close3.gif" 
							alt="Hide" border="0" 
							align  = "right" class="regular" style="cursor: pointer;" 
							onClick= "detaillisting('#url.org#','hide','only','','','','','','#URL.DATE#')">
							
						</TD>
					
						<td align="left" colspan="2" width="70%">
				 						
						<cfif URL.Search eq "0">
											
						  <table class="formspacing">
						    <tr class="labelmedium" style="height:40px;font-size:20px">
								<td style="padding-left:4px;cursor: pointer;">						
							    <input type="radio" id="#url.org#_sort1" name="#url.org#_sort" value="grade" <cfif URL.Sort eq "grade" or URL.sort eq "undefined">checked</cfif> onclick="detaillisting('#URL.org#','show','#URL.Mode#','#URL.Filter#','#URL.Level#','#URL.Line#','#URL.Cell#','grade','#URL.date#')">
								</td>
								<td style="padding-left:4px">
								<cf_tl id="Grade">/<cf_tl id="Level">
								</td>
								<td style="cursor: pointer;padding-left:3px">
								<input type="radio" id="#url.org#_sort2" name="#url.org#_sort" value="postclass" <cfif URL.Sort eq "postclass">checked</cfif> onclick="detaillisting('#URL.org#','show','#URL.Mode#','#URL.Filter#','#URL.Level#','#URL.Line#','#URL.Cell#','postclass','#URL.date#')">
								</td>
								<td style="padding-left:4px">
								<cf_tl id="Post class">
								</td>
								<td style="cursor: pointer;padding-left:3px">
								<input type="radio" id="#url.org#_sort3" name="#url.org#_sort" value="posttype" <cfif URL.Sort eq "posttype">checked</cfif> onclick="detaillisting('#URL.org#','show','#URL.Mode#','#URL.Filter#','#URL.Level#','#URL.Line#','#URL.Cell#','posttype','#URL.date#')">
								</td>
								<td style="padding-left:4px">
								<cf_tl id="Post Type">
								</td>
								<td style="cursor: pointer;padding-left:3px">
								<input type="radio" id="#url.org#_sort4" name="#url.org#_sort" value="location" <cfif URL.Sort eq "location">checked</cfif> onclick="detaillisting('#URL.org#','show','#URL.Mode#','#URL.Filter#','#URL.Level#','#URL.Line#','#URL.Cell#','location','#URL.date#')">
								</td>
								<td style="padding-left:4px">
								<cf_tl id="Location">
								</td>	
								<td style="cursor: pointer;padding-left:3px">
								<input type="radio" id="#url.org#_sort5" name="#url.org#_sort" value="workschedule" <cfif URL.Sort eq "workschedule">checked</cfif> onclick="detaillisting('#URL.org#','show','#URL.Mode#','#URL.Filter#','#URL.Level#','#URL.Line#','#URL.Cell#','workschedule','#URL.date#')">
								</td>
								<td style="padding-left:4px">
								<cf_tl id="Workschedule">
								</td>	
								
								<td style="padding-left:20px">						
								<input type="button" name="toggle" class="button10g" value="Collapse/Expand" onclick="javascript:$('.optional_#url.org#').toggle();">						
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
						
						
				 	</tr>
											
					</cfoutput>
									
				</table>   	
			
			</td>
			</tr>
					
			<tr><td class="line" colspan="3"></td></tr>	
		
					
		<tr><td>
		
							
			<table width="100%" align="center">
			
			<!--- ---------------------------------------------------------- --->
			<!--- -----------Line 2 of 12 : Header record ------------------ --->
			<!--- ---------------------------------------------------------- --->	
		
		    <tr class="labelmedium line">
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
				<td width="7%"><cf_tl id="Level"></td>
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
			
				<!--- ---------------------------------------------------------- --->
				<!--- -----------Line 3 of 12 : Group record ------------------- --->
				<!--- ---------------------------------------------------------- --->	
																
				<cfset col = "13">
					  
			   <cfswitch expression = "#URL.Sort#">
			  		  				   
				 <cfcase value = "PostClass">
				 <tr bgcolor="f8f8f8" class="line">
			     <td class="labellarge" style="font-size:20px;padding-left:6px;height:35px" colspan="#col#">#PostClass#</td></tr>				 
				
			     </cfcase>
				 
				 <cfcase value = "Location">
				 
				     <tr bgcolor="f4f4f4" class="line">
				     <td class="labellarge" style="font-size:20px;padding-left:6px;height:35px" colspan="#col#">#LocationCode# <cfif LocationName eq "">Undefined<cfelse>#LocationName#</cfif></td></tr>								 
										 
				 </cfcase>
				 
				  <cfcase value = "WorkSchedule">
				  
				  	<cfquery name="count" dbtype="query"> 
				    	SELECT count(*) as Total
						FROM   SearchResult 
						WHERE  WorkSchedule = '#workschedule#'						
					</cfquery>
					
					 <cfif workschedule eq "0">
					 
					 <tr bgcolor="f8f8f8" class="line">
				     <td  class="labelmedium" style="height:40;padding-left:6px" colspan="#col#"><font color="FF0000">Not scheduled for #dateformat(sel,client.dateformatshow)# [#count.total#]</td></tr>									 
					 					 
					 <cfelse>
				 
				     <tr bgcolor="f8f8f8" class="line">
				     <td  class="labellarge" style="height:40;padding-left:6px" colspan="#col#">#WorkSchedule# [#count.total#]</td></tr>									 
										 
					 </cfif>
					 
				 </cfcase>
				 
				 <cfcase value = "Grade">
				 
				     <tr bgcolor="f8f8f8" class="line">
				     <td  style="font-size:20px;padding-left:6px;height:35px" colspan="#col#">#PostGrade#</td></tr>									 
										 
				 </cfcase>
				 
				 <cfcase value = "Posttype">
				     <tr bgcolor="f4f4f4" class="line">
				     <td  class="labelmedium" style="padding-left:6px" colspan="#col#">#Posttype#</td></tr>						 
					 					 
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
														
					<tr class="line">
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
								
				<cfif cl eq "white" or cl eq "">
					<cfset cl = "f1f1f1">
				</cfif>
				
				<cfif dbl eq "1">
					  <cfset cl = "FFCEB7">					  
					  <tr class="line"><td bgcolor="Yellow" colspan="13" align="center" class="labelmedium">Attention : Position has more than one overlapping assignment</td></tr>						
				</cfif>
				
				<cfif sme eq "0">	  				
					  <cfset rw = rw + 1>  
				</cfif>			
				
				<cfset cutoff = dateAdd("d",param.AssignmentExpiration,now())>	
				
				<!--- ---------------------------------------------------------- --->
				<!--- -----------Line 4 of 12 : Positionrecord ----------------- --->
				<!--- ---------------------------------------------------------- --->			
																					
				<tr bgcolor="#cl#" class="navigation_row line">
							
				<td style="height:30px;border-top:1px solid silver;padding-left:10px;padding-right:3px" class="cellcontent"><cfif sme neq "1">#rw#.</cfif></td>
								
				<td width="20" style="padding-left:4px;border-top:1px solid silver;">
				
				<cf_assignId>
				
				<cfif AccessRecruit eq "EDIT" or AccessRecruit eq "ALL" 
				   or AccessStaffing eq "EDIT" or AccessStaffing eq "ALL">	
				 			 				   				   			
					<img src="#SESSION.root#/Images/memo.png" height="18" alt="Enter remarks" 
						id="#rowguid#Exp" border="0" class="regular" 						
						align="middle" style="cursor: pointer;" 
						onClick="memoshow('#rowguid#','show')">
					
					<img src="#SESSION.root#/Images/arrowdown.gif" height="18"
						id="#rowguid#Min" alt="Hide remarks" border="0" 
						align="middle" class="hide" style="cursor: pointer;" 
						onClick="memoshow('#rowguid#','hide')">
					
					</cfif>
				
	     		</td>
				
				<td class="cellcontent" style="width:80px;padding-left:4px;padding-right:7px;border-top:1px solid silver">
							
					 <cfif url.sort eq "WorkSchedule" and currentrow eq "1">					 
						 <cf_space spaces="25">					 
					 </cfif>
				
				   <a class="navigation_action" href="javascript:EditPosition('#URL.Mission#','#URL.Mandate#','#PositionNo#','i#URL.Org#')"  
				      title="Edit position"><font color="0080C0">				   			   	   

					   <cfif SourcePostNumber neq "">				   
					  	#SourcePostNumber# 						   
					   <cfelse>
					    #PositionParentId#
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
				
				<td class="cellcontent" style="padding-right:3px;border-top:1px solid silver;"><cfif PostClass neq "Valid">#PostClass#</cfif></td>
				<td class="cellcontent" style="border-top:1px solid silver;">#PostGrade#</td>
				<td class="cellcontent" style="border-top:1px solid silver;">
				
				   <cfif URL.Mode eq "Only">
				       #FunctionDescription# <cfset des = FunctionDescription>
				   <cfelse>
					   <cfif #Len(OrgUnitName)# gt 43>#left(OrgUnitName,37)#...<cfelse>#OrgUnitName#</cfif>
					   <cfset des = OrgUnitName>
				   </cfif>				
												
				</td>
				<td class="cellcontent" style="border-top:1px solid silver;">#LocationName#</td>
				<cfif Incumbency eq "0">
				<td class="cellcontent" style="border-top:1px solid silver;padding-right:4px">
					<table width="100%" bgcolor="FF80FF" style="border-left:1px solid silver;border-right:1px solid silver">
					<tr>
						<td align="center" style="padding-left:2px;padding-right:2px">#Incumbency#</td>
						<td align="center" style="padding-top:1px"><cf_img icon="open" onClick="javascript:positionchain('#personno#')"></td>
					</tr>
					</table>				
				</td>
				<cfelse>
				<td class="cellcontent" style="border-top:1px solid silver;;padding-right:4px">#Incumbency#</td>
				</cfif>
								
				<cfif PersonNo eq "">
				 											
					<td colspan="5" align="left" align="center" style="border-top:1px solid silver;">
					
					 <table width="100%" cellspacing="0" cellpadding="0">
					 <tr>
					 <td class="cellcontent" align="center"><font color="FF0000"><b>--- #tVacant# ---</b></font></td>
									 
					 <cfif AccessStaffing eq "EDIT" or AccessStaffing eq "ALL">
					 
					     <td class="cellcontent">
						 
						 <table>
						 <tr>
						 
						 <cfif Param.AssignmentEntryDirect eq "1">
						 	
						 <td class="cellcontent">						 
							 <A Title="Register recruitment request" 
							    href ="javascript:AddAssignment('#PositionNo#','i#URL.Org#')"><font color="0080C0">#tIncumbent#</a>
						 </td>	
														
						 </cfif>	
								
						 <td class="cellcontent" style="padding-left:5px">						
							 <A Title="Register recruitment request" 
							    href ="javascript:AddVacancy('#PositionNo#','i#URL.Org#')"><font color="0080C0">#tInitiateRecruitment#</a>
						 </td>
						 </tr>
						 </table>
						
						 </td>
						 
					 <cfelse>
					 					  
					  	  <cfif AccessRecruit eq "EDIT" or AccessRecruit eq "ALL">			   
						  <td class="cellcontent">						 	 
						   	 <a title="Register recruitment request" HREF ="javascript:AddVacancy('#PositionNo#','i#URL.Org#')"><font color="0080C0"><cf_tl id="Initiate Recruitment"></a>							 
						   </td>
						  </cfif> 
										 				 	 
					 </cfif>
					 
					 <td style="width:25%" style="width:25%;border-top:1px solid silver;border-right:1px solid silver">
					 
					 	<cfif EnableAssignmentReview eq 1>
					 
							<cfif AccessStaffing eq "EDIT" or AccessStaffing eq "ALL" 
							    or AccessRecruit eq "EDIT" or AccessRecruit eq "ALL">
														
								     <img src="#SESSION.root#/Images/Logos/Staffing/Track.png"
									     title="Assignment review prior to creation of a recruitment track"
									     border="0"
										 height="17" width="17"
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
				
					<td class="cellcontent" style="border-top:1px solid silver;"><a href="javascript:EditAssignment('#PersonNo#','#AssignmentNo#','#positionno#','i#URL.Org#')"><font color="0080C0">#FullName#</a></td>
					<td class="cellcontent" style="border-top:1px solid silver;"><a href="javascript:EditPerson('#PersonNo#','i#URL.Org#')"><font color="0080C0"><cfif IndexNo eq ""><cfif Reference neq "">#Reference#<cfelse>No Index</cfif><cfelse>#IndexNo#</cfif></a></td>
					<td class="cellcontent" style="padding-left:4px;border-top:1px solid silver;">#Nationality#</td>
					<td class="cellcontent" style="border-top:1px solid silver;padding-right:4px"><cfif ContractLevel neq "">#ContractLevel#/#ContractStep#<cfif ContractTime neq "100">:#ContractTime#%</cfif></cfif></td>
					<td style="width:140;padding-right:4px;border-top:1px solid silver;">
											
					<table width="100%" cellspacing="0" cellpadding="0">
					
					<tr bgcolor="white">
															
						<td style="border:1px solid silver;padding:1px;min-width:24" align="center">
						<cfif Extension neq "">							
						    <img src="#SESSION.root#/Images/Logos/Staffing/Extension-Request.png"  height="18" width="21" alt="Extension requested" border="0">							
						</cfif>
						</td>
						
						<td style="border:1px solid silver;padding:1px;min-width:24" align="center">
						
						<!--- newly added event --->
						
						<cfif (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL") and PersonNo neq "">
													
						     <img src="#SESSION.root#/Images/Logos/Staffing/Event-Action.png"
							     title="Record a Personnel Event"
							     border="0"
								 height="18" width="21"
							     align="absmiddle"
							     style="cursor: pointer;"
							     onClick="eventaddperson('#PersonNo#','#PositionNo#')">
														  
						</cfif>		
						
						</td>
												
						<td style="border:1px solid silver;padding:1px;min-width:24" align="center">

						<cfif EnableAssignmentReview eq 1>
						
							<cfif AccessStaffing eq "EDIT" or AccessStaffing eq "ALL" 
							    or AccessRecruit eq "EDIT" or AccessRecruit eq "ALL">

							     <img src="#SESSION.root#/Images/Logos/Staffing/Review.png"
								     title="Initiate an Assignment review prior to creation of a Recruitment Request"
								     border="0"
									 height="18" width="21"
								     align="absmiddle"
								     style="cursor: pointer;"
								     onClick="AddReview('#PositionNo#','i#url.org#')">
															  
							</cfif>		
							
						</cfif>
						</td>
												
						<td style="border:1px solid silver;padding:1px;min-width:24" align="center">
						
						<cfif AccessStaffing eq "EDIT" or AccessStaffing eq "ALL" 
						    or AccessRecruit eq "EDIT" or AccessRecruit eq "ALL">
													
						     <img src="#SESSION.root#/Images/Logos/Staffing/Recruit-Request.png"
							     title="Register a Recruitment Request"
							     border="0"
								 height="18" width="21"
							     align="absmiddle"
							     style="cursor: pointer;"
							     onClick="AddVacancy('#PositionNo#','i#url.org#')">
														  
						</cfif>		
						</td>
						
						<td style="border:1px solid silver;padding:1px;min-width:24" align="center">
						
						
						<cfif ePASOperational eq "1" and EnablePAS eq "1">
												
							<cfif AccessStaffing eq "EDIT" or
							      AccessStaffing eq "ALL" or 
								  AccessRecruit eq "EDIT" or 
								  AccessRecruit eq "ALL">								  
														   
						         <img src="#SESSION.root#/Images/Logos/Staffing/ePAS.png"
								     Title="Register a Performance Report"
								     border="0"
									 height="18" width="21"
								     align="absmiddle"
								     style="cursor: pointer;"
								     onClick="AddPAS('#AssignmentNo#','i#url.org#')">									 
							 
							</cfif>	
						
						</cfif>	
						</td>
					</tr>
					</table>  
					
					</td>
			    </cfif>	
				</tr>
				
				<!--- ---------------------------------------------------------- --->
				<!--- -----------Line 5 of 12 : Varying Post dara--------------- --->
				<!--- ---------------------------------------------------------- --->			
					
				<cfif showpdte eq 1 and Mission.MissionStatus eq "0">
				<tr bgcolor="#cl#"  class="line optional_#url.org#">
				    <td colspan="2"></td>
					<td colspan="2" style="min-width:200px;border-right:1px solid silver"><cf_tl id="Budget position">:</td>
					<TD colspan="8" style="padding-left:5px" class="labelit"><font color="808000">#DateFormat(ParentEffective, CLIENT.DateFormatShow)# - #DateFormat(ParentExpiration, CLIENT.DateFormatShow)#</font></TD>
					<TD></TD>
				</tr>
				</cfif>
				
				<!--- ---------------------------------------------------------- --->
				<!--- -----------Line 6 of 12 : Remarks ------------------------ --->
				<!--- ---------------------------------------------------------- --->	
																											
				<tr id="memo#rowguid#hdr" style="border-bottom:1px solid silver" class="<cfif Remarks eq "">hide<cfelse>regular</cfif>">
					<td></td>
					<td></td>
					<td style="height:26px" class="labelit" id= "memo#rowguid#" colspan="12">#Remarks#</td>
				</tr>
											
				<cfif sourceid neq "0">
				
					<cfset trackid = "">
				
				    <cfquery name="Track" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">									
							SELECT    D.*, RC.EntityClassName 
							FROM      Vacancy.dbo.Document D INNER JOIN
									  Organization.dbo.Ref_EntityClass RC ON RC.EntityClass = D.EntityClass AND RC.EntityCode = 'VacDocument'		
							WHERE     D.DocumentNo = '#SourceId#' 
					</cfquery>	
															
					<cfif track.recordcount eq "0">
																
						<cfquery name="Prior" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">				
								SELECT  *
								FROM    PersonAssignment
								WHERE   PersonNo     = '#PersonNo#'
								AND     AssignmentNo = '#sourceId#'
						</cfquery>
					
					    <cfif Prior.Source eq "vac">
						
							<cfset trackid = prior.sourceid>
							
							<cfquery name="Track" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">									
							SELECT    D.*, RC.EntityClassName 
							FROM      Vacancy.dbo.Document D INNER JOIN
									  Organization.dbo.Ref_EntityClass RC ON RC.EntityClass = D.EntityClass AND RC.EntityCode = 'VacDocument'		
							WHERE     D.DocumentNo = '#trackId#' 
							</cfquery>	
												
						</cfif>
											
					<cfelse>
					
						<cfset trackid = sourceid>
					
					</cfif>
					
					<cfif trackid neq "">
				
						<tr id="source#rowguid#hdr" style="background-color:yellow;border-bottom:1px solid silver">
							<td></td>
							<td></td>				
											
							<cfquery name="FO" 
								datasource="AppsSelection" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">												
								SELECT    D.*
								FROM      Functionorganization D 		
								WHERE     DocumentNo = '#trackid#' 												
							</cfquery>			
												
						    <td style="height:26px" class="labelit" id= "source#rowguid#" colspan="12">
						
						    <cf_tl id="Recruited under">&nbsp;<a href="javascript:showdocument('#TrackId#')" title="TrackNo">#Track.entityclassName#&nbsp;:&nbsp;<cfif fo.recordcount eq "1">#FO.ReferenceNo#<cfelse>#TrackId#</cfif><cf_tl id="on"> #dateFormat(dateEffective,client.dateformatshow)#</td>
					
						</tr>
					
					</cfif>
				
				</cfif>
				
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
								<tr><td align="center" style="padding-top:3px;padding-bottom:4px"> 
																
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
				
				<!--- ---------------------------------------------------------- --->
				<!--- -----------Line 7 of 12 : Post title reference ----------- --->
				<!--- ---------------------------------------------------------- --->	
										
				<cfif URL.Mode neq "Only" and url.sort neq "Workschedule">
				
				    <tr class="line labelmedium optional_#url.org#" style="height:10px">
						<td colspan="2"></td>
						<td colspan="2" style="min-width:130px;padding-left:4px;background-color:f1f1f1;border-right:1px solid silver"><cf_tl id="Position title"></td>
						<td colspan="2" style="padding-left:4px;font-size:14px;border-right:1px solid silver">
							<cfif FunctionDescription eq "undefined">
								A function description is not on file
							<cfelse>
								<a href="javascript:gjp('#functionNo#','#postgrade#')">#FunctionDescription#</a>
							</cfif>
						</td>
						<td colspan="1" style="min-width:100px;background-color:f1f1f1;padding-left:4px;border-right:1px solid silver"><cf_tl id="Position effective"></td>
						<td colspan="2" style="padding-left:4px;font-size:12px;border-right:1px solid silver">	
							#DateFormat(PostEffective, CLIENT.DateFormatShow)# - #DateFormat(PostExpiration, CLIENT.DateFormatShow)#
						</td>	
						<cfif DateEffective neq "">
						<td colspan="4" style="background-color:ffffaf;padding-left:4px;border-right:0px solid silver"><cf_tl id="Incumbency">
							&nbsp;#DateFormat(DateEffective, CLIENT.DateFormatShow)# - #DateFormat(DateExpiration, CLIENT.DateFormatShow)#
						</td>	
						<cfelse>
						<td colspan="4"></td>			
						</cfif>
									
					</tr>
										
				</cfif>	
				
				<!--- ---------------------------------------------------------- --->
				<!--- -----------Line 8 of 12 : Assignment title --------------- --->
				<!--- ---------------------------------------------------------- --->	
				
				<cfif Parameter.AssignmentFunction eq "1">
				
					<cfif (FunctionNoActual neq FunctionNo and FunctionDescriptionActual neq "") or 
					      (class eq "Loaned" and FunctionDescriptionActual neq "") or
						  (Orgunit neq OrgUnitParent and Class eq "Used")>
														
						<tr class="labelit optional_#url.org# line">
							<td colspan="2"></td>
							<td colspan="2" style="border-right:1px solid silver">#tAssigned#:</td>
							<td colspan="10" style="padding-left:4px;font-size:14px">#FunctionDescriptionActual#</td>
						</tr>
					
					</cfif>
				
				</cfif>
				
				<!--- ---------------------------------------------------------- --->
				<!--- -----------Line 9 of 12 : Assignment review action ------- --->
				<!--- ---------------------------------------------------------- --->	
								
				<cfif PositionReview neq "">
				
					<!--- Active workflow --->					
					
					<input type="hidden" 
					   name="workflowlink_#positionreview#" 
					   id="workflowlink_#positionreview#" 		   
					   value="#SESSION.root#/staffing/reporting/postview/staffing/PostViewDetailWorkflow.cfm">	
					
					<tr class="optional_#url.org#">
					    <td colspan="2"></td>
						
					    <cf_wfactive entityCode="PositionReview" ObjectKeyValue1="#positionno#">
						
						<td onclick="workflowdrill('#positionreview#','position')"  style="height:28px;cursor:pointer;padding-left:4px;min-width:150px">
							<font color="DD6F00"><cf_tl id="Incumbency Review"></td>							
									
						<cfif wfstatus neq "closed">
							
							 <td colspan="1" class="labelit"
							    align="right" 
								style="width:20px;cursor:pointer;padding-right:5px;border-right:1px solid silver" 
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
							
								<td align="right" height="20" class="labelit" style="width:20px;padding-right:5px;border-right:1px solid silver" onclick="workflowdrill('#positionreview#','position')">	
								
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
							
							<td colspan="9"></td>								
						
					</tr>										
					
					<tr class="optional_#url.org#">
						<td colspan="1"></td>
						<td align="center" colspan="12">						
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
					
					<tr class="labelmedium optional_#url.org# line">
					    
					    <td height="22" colspan="13" align="center" bgcolor="FEBBAF" style="padding-left:5px">
						
							<font color="black">
							Assignment of #FullName# will end on <b><u>#dateformat(DateExpiration,client.dateformatshow)#
							<cfset diff = dateDiff("d",now(),DateExpiration)> <cfif diff gte "2">in #diff# days </cfif>
							</b>
							
					   </td>
					</tr>
					
					</cfif>		
				
				</cfif>			
				
				<!--- ---------------------------------------------------------- --->
				<!--- -----------Line 10 of 12 : Borrowed position -------------- --->
				<!--- ---------------------------------------------------------- --->		
				
				<cfif Orgunit neq OrgUnitParent and Class eq "Used">
				
				 <cfquery name="LaterPosition" 
		    	   datasource="AppsEmployee" 
			       username="#SESSION.login#" 
		    	   password="#SESSION.dbpw#">
					 SELECT *
					 FROM   Position
					 WHERE  PositionNo      != '#PositionNo#'
					 AND    PositionParentId = '#PositionParentid#'
					 AND    DateEffective  > '#DateFormat(DateExpiration,client.dateSQL)#'
				   </cfquery>	
			
					<cfif LaterPosition.recordcount eq "0">				
				
						<cfquery name="Org" 
					    datasource="AppsOrganization" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						    SELECT *	
							FROM   Organization
							WHERE  OrgUnit = '#OrgUnitParent#'
						</cfquery>   
										
						<tr class="labelmedium line optional_#url.org#">
							
							<td colspan="2"></td> 
							<td bgcolor="FAA0AE" colspan="2" style="min-width:120px;padding-left:5px;border-right:1px solid silver"><cf_tl id="Borrowed from">:</td>
							<td  bgcolor="FAA0AE" colspan="9" style="padding-left:4px;">
							
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
							&nbsp;&nbsp; #dateformat(PostEffective,CLIENT.DateFormatShow)# - #dateformat(PostExpiration,CLIENT.DateFormatShow)#
							</td>
							
							<td></td>
						</tr>
						
					</cfif>	
				
				</cfif>
								
				<!--- ---------------------------------------------------------- --->
				<!--- -----------Line 11 of 12 : EPAS view  ---- --------------- --->
				<!--- ---------------------------------------------------------- --->	
								
				<cfif ContractNo gt "0">
				
					 <!--- Hanno 8/10/2017 to be adjusted as this is linked to an assignment and some assignments will be overwritted if matter like the
					 title changes and so we miss history to be shown --->
				
					  <cfquery name="ePasList" 
						datasource="AppsEPAS" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
						SELECT      C.ContractId,
						            C.ContractNo, 
									C.DateEffective, 
									C.DateExpiration, 
									C.FunctionDescription, 									
									C.ContractClass,
									C.ActionStatus,
									V.Description as ContractClassDescription,
									CA.RoleFunction, 
									P.LastName, 
									P.FirstName, 
									P.IndexNo, 
									P.PersonNo, 
		                   			R.Description AS StatusDescription
						FROM        Ref_Status AS R 
									INNER JOIN Contract AS C ON R.Status = C.ActionStatus 
									INNER JOIN Ref_ContractClass V ON C.ContractClass = V.Code 
									LEFT OUTER JOIN ContractActor AS CA 
									LEFT OUTER JOIN Employee.dbo.Person AS P ON CA.PersonNo = P.PersonNo ON C.ContractId = CA.ContractId AND CA.RoleFunction = 'FirstOfficer' AND CA.ActionStatus = '1'
						 WHERE      C.PersonNo = '#PersonNo#' 
						 -- AND        C.ActionStatus < '8' 
						 AND        C.DateEffective  <= '#Dateformat(DateExpiration, CLIENT.DateSQL)#' 
						 AND        C.DateExpiration >= '#Dateformat(DateEffective, CLIENT.DateSQL)#' 	
						 AND        C.Mission     = '#url.Mission#' 
						 AND        R.ClassStatus = 'Contract'
													
					  </cfquery>	
							  
					<tr class="optional_#url.org#">
						<td colspan="2"></td>
						<td colspan="2" bgcolor="E1F8FF" valign="top" style="padding-top:4px;padding-left:4px;border-right:1px solid silver"><cf_tl id="Appraisal">:</td>
						<td colspan="9" bgcolor="E1F8FF" style="padding-left:4px">
						
							<table width="100%" cellspacing="0" cellpadding="0">
										  
							<cfloop query="ePasList">		  					
												
								<tr class="labelmedium <cfif currentrow neq recordcount>line</cfif>">								
									<td width="60"><a href="javascript:pasdialog('#contractId#')">#ContractNo#</a></td>
									<td width="60">#ContractClass#</td>
									<td width="160">
									#dateformat(dateeffective,CLIENT.DateFormatShow)# -
									#dateformat(dateexpiration,CLIENT.DateFormatShow)#
									</td>
									<td width="80"><cfif ActionStatus gte "8"><font color="FF0000"></cfif>#StatusDescription#</td>
									<td width="200">#FunctionDescription#</td>
									<td width="260">
									<cf_tl id="#RoleFunction#">: <a href="javascript:EditPerson('#PersonNo#')">#FirstName# #LastName#</a>
									</td>						
								</tr>							
						
							</cfloop>
							
							</table>
							
						</td>
						</tr>
																		
				</cfif>
				
				<!--- ---------------------------------------------------------- --->
				<!--- -----------Line 12 of 12 : Recruitment title ------------- --->
				<!--- ---------------------------------------------------------- --->	
									
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
					
						<tr bgcolor="C0F1C1" class="labelmedium optional_#url.org#" style="border-top:1px solid silver;height:22px">
					
						 <td colspan="2"></td>					
						 <td colspan="2" style="border-right:1px solid silver">#tRecruitment#</td>					
						 <td colspan="5" style="padding-left:4px;font-size:12px;">#EntityClassName#:
							
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
									<a title="Vacancy No" href="javascript:showdocument('#DocumentNo#')">
									#Reference.ReferenceNo#</a>
								<cfelse>
									<a href="javascript:showdocument('#DocumentNo#')" title="TrackNo">
									#DocumentNo#</a>
								</cfif>
								
							<cfelse>
							
								<a href="javascript:showdocument('#DocumentNo#')" title="TrackNo">
									#DocumentNo#</a>
							
							</cfif>	
											
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
							<td colspan="6" bgcolor="e1e1e1" style="min-width:200px;padding-left:3px;border-left:1px solid gray">
							<cfloop query = "Candidate">
							<a href="javascript:ShowCandidate('#Candidate.PersonNo#')" title="selected candidate">#Candidate.FirstName# #Candidate.LastName#<cfif currentrow neq recordcount>;</cfif></a>&nbsp;
							</cfloop>
							- #cpl#
							</td>
						<cfelse>
							<td style="min-width:200px;padding-left:3px;border-left:0px solid gray" colspan="6">#tNoCandidateInfo#</td>
						</cfif>
						
						</tr>
						
					</cfloop>									
	 		 	
				</cfif>		
				
				<!--- ---------------------------------------------------------- --->
				<!--- -----------Line 13 of 13 : Assignment title --------------- --->
				<!--- ---------------------------------------------------------- --->	
				
				<cfif Class eq "Loaned"> 
								     					
					 <tr class="labelmedium line optional_#url.org#" style="height:20px">
					 
					    <td colspan="2"></td>
					    <td colspan="2" bgcolor="C6F2E2" style="padding-left:4px;border-right:1px solid silver"><cf_tl id="Loaned to">:</td>
						<td bgcolor="C6F2E2" colspan="10" style="font-size:14px;padding-left:4px;background-color:##C6F2E280">
											
						    <cfquery name="Loaned" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
								FROM   Organization
								WHERE  OrgUnit     = #OrgUnitOperational#
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
							#Loaned.Mission# - 
							<cfif ParentP.recordcount eq "1">#ParentP.OrgUnitName#/</cfif>#Loaned.OrgUnitName#</b></A>
							
						</td>
						
						<td></td>
												
					 </tr>	
											
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
					<tr class="labelit optional_#url.org# line">
					    <td colspan="2"></td>
						<td colspan="2" style="border-right:1px solid silver"><cf_tl id="Assigned to">:</td>
						<td colspan="10" style="font-size:14px;padding-left:4px">#Org.OrgUnitName#</td>						
					</tr>
					</cfif>
				
				</cfif>
			
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

