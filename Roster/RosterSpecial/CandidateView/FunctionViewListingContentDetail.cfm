
<cfif Searchresult.recordcount eq "0">
	
	 <table width="99%" class="navigation_table" >	
		<tr><td height="30" colspan="<cfoutput>#col#</cfoutput>" class="labelit" align="center"><font color="gray"><cf_tl id="There are no candidates to show in this view">.</td></tr>
	 </table>	
	
<cfelse>
	
	<cfparam name="URL.page" default="1">
		
		<cfset counted = SearchResult.recordcount>
		<cfif url.print eq "1">
			<cf_PageCountN count="#Searchresult.recordcount#" show="3000">
		<cfelse>
			<cf_PageCountN count="#Searchresult.recordcount#" show="250">
		</cfif>
		<cfset per = URL.Page*250-250>
		<cfset perT = "">

    <table width="97.5%" class="navigation_table">	
					
	<tr class="fixrow"><td colspan="14" colspan="#col#"><cfinclude template="Navigation.cfm"></td></tr>
	
	<TR class="labelmedium2 fixrow2 line fixlengthlist">
	    <td style="max-width:50px" colspan="4"></td>	   		
		<TD><cf_tl id="Name"></TD>
		<TD><cfoutput>#client.IndexNoName#</cfoutput></TD>
		<td></td>
		<TD></TD>
		<TD style="padding-right:20px"><cf_tl id="Grade"></TD>		
		<TD title="Gender" align="center"><cf_tl id="G"></TD>
		<TD><cf_tl id="Birth date"></TD>	
	    <TD><cf_tl id="Nat"></TD>
		<td><cf_tl id="Profile"></td>
		<TD></TD>				
	</tr>
      	
	<tr><td>
	
	<cfinclude template="FunctionStatusRefresh.cfm">
	
	</td></tr>		
		
	<cfoutput Query="SearchResult" group="Status">
	
		<cfif url.source eq "Manual">
		
			<cfset access = 1>
			
		<cfelse>	
		
			<!--- define if the user has access for the combination from / to --->
			
			<cfif status eq "9">
	
			<cfinvoke component="Service.Access.Roster"  
				 method         = "RosterStep" 
			 	 returnvariable = "Access"			 
			     Status         = "#Level#"
				 StatusTo       = "#status#"
				 Process        = "Process"  <!--- was: search --->
			   	 Owner          = "#URL.Owner#"
				 FunctionId     = "#URL.IDFunction#">	
							 
			<cfelse>			
						
			<cfinvoke component="Service.Access.Roster"  
				 method         = "RosterStep" 
			 	 returnvariable = "Access"			 
			     Status         = "#status#"			
				 Process        = "Search"  
			   	 Owner          = "#URL.Owner#"
				 FunctionId     = "#URL.IDFunction#">	
						
			</cfif>	 
			 
		</cfif>	 
					 
		<cfif Access eq "1">	 
				
			<cfif URL.search eq "1" or URL.Source eq "Manual">
					
			<tr class="line"><td colspan="#col#" cstyle="height:30px" class="labellarge">#Meaning# [#Status#]</td></tr>
			
			</cfif>		
			
			<cfswitch expression="#URL.View#">
					
				<cfcase value="CreatedD">
				    <cfset grp = "Created">
				</cfcase> 
				<cfcase value="CreatedA">
				    <cfset grp = "Created">
				</cfcase> 
				<cfcase value="Gender">
				    <cfset grp = "Gender">
				</cfcase> 
				<cfcase value="Nationality">
				    <cfset grp = "Nationality">
				</cfcase> 
				<cfdefaultcase>
					<cfset grp = "LastName">
				</cfdefaultcase>
				
			</cfswitch>
			
			<cfoutput group="#grp#">
			
				<cfif (currrow gte first and currrow lte last) or currrow eq "0">
			
					<cfif grp eq "Created">
					
					  <tr class="fixrow3 line"><td colspan="#col#" align="left" class="labelit" style="padding-left:4px;font-size:16px;height:25;width:99%;"><font size="1">
				    	  <cf_tl id="Received on">:</font><b>&nbsp;#DateFormat(Created,CLIENT.DateFormatShow)#				
					   </td></tr>
					  
					  
					</cfif>  
					
					<cfif grp eq "Gender">
					
					 <tr class="fixrow3 line"><td colspan="#col#" align="left" class="labelmedium" style="font-size:16px;padding-left:4px;height:25;width:99%;">
				    	  <cfif gender eq "M"><cf_tl id="Male"><cfelse><cf_tl id="Female"></cfif>			
					   </td></tr>
					 					  
					</cfif>  
					
					<cfif grp eq "Nationality">
					
					<cfquery name="Nation" 
						 datasource="AppsSystem" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT *
						 FROM   Ref_Nation
						 WHERE  Code = '#Nationality#'			
						</cfquery>
										
					 <tr class="fixrow3 line">
					   <td colspan="#col#" align="left" class="labelmedium" style="height:24;width:99%;">#Nation.Name#</td>
					 </tr>
										
					</cfif> 
				
				</cfif>
				
				<cfoutput>
				
				<cfif Status eq "9" and (URL.search eq "1" or URL.Source eq "Manual")>
									
				   <cfquery name="Denied" 
				   datasource="AppsSelection" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
						SELECT     MAX(Status) as Status
				        FROM       ApplicantFunctionAction
						WHERE      FunctionId = '#FunctionId#'
						AND        ApplicantNo = #ApplicantNo# 
						AND        Status < '5'
				   </cfquery>			  
				 				
				   <cfinvoke component="Service.Access.Roster"  
					 method="RosterStep" 
				 	 returnvariable="Access"
				     Status="#Denied.Status#"
					 Process="Search"
				   	 Owner="#URL.Owner#"
					 FunctionId="#URL.IDFunction#">	
					 				 				 
					 <cfif Access eq "1">
					
						<cfset show = "1">
						
					<cfelse>
								
						<cfset show = "0">
					
					</cfif>	
							
				<cfelse>
				
					<cfset show = "1">	
			
				</cfif>
				
				<cfif show eq "1">
				
					<cfset currrow = currrow + 1>
												
					<cfif currrow gte first and currrow lte last>
											 
						<tr id="#ApplicantNo#" class="line labelmedium2 navigation_row fixlengthlist">
						    
							<cfif mission eq "">
						    <td align="center">
							<cfelse>
							<td align="center">
							</cfif>						
							
							<cfif PerT neq PersonNo>
							    <cfset per  = per + 1>
							    <cfset perT = PersonNo>
								#per#
							</cfif>
							</td>
								
							<!---							
							<td align="center"  style="width:1px;padding-right:1px;border:1px solid d4d4d4;padding-top:1px">									
								<cf_img icon="print" tooltip="submission" onClick="SubmissionPHP('#applicantno#','#functionid#')">											   
							</td>							
							--->
													
							<td align="center" style="border-right:0px solid silver;border-left:1px solid silver">					
							
								<i class="fas fa-user-edit" title="Maintain submission profile" style="color: ##c83702;font-size: 14px;position: relative;top:-1px;"
                                   onclick="ShowFunction('#ApplicantNo#','#FunctionId#','#URL.tab#','#url.box#','#url.owner#','#url.process#','#day#','#status#','#url.level#','#url.processmeaning#','#meaning#','#url.total#','#url.page#','php')">
                                </i>
								   
							</td>
							
							<!---						
							
							<td align="center" style="padding-top:1px;width:20px;border-left:1px solid d4d4d4">
							
								<cfif url.source neq "Manual">
																		
								    <cfif Access eq "1">
																			
								        <cfif FunctionJustification eq "">
																							
											<cf_img icon="edit" onclick="ShowFunction('#ApplicantNo#','#FunctionId#','#URL.tab#','#url.box#','#url.owner#','#url.process#','#day#','#status#','#url.level#','#url.processmeaning#','#meaning#','#url.total#','#url.page#','process')">
																					
										<cfelse>	
										
											<cf_img icon="edit" onclick="ShowFunction('#ApplicantNo#','#FunctionId#','#URL.tab#','#url.box#','#url.owner#','#url.process#','#day#','#status#','#url.level#','#url.processmeaning#','#meaning#','#url.total#','#url.page#','process')">
																								
										</cfif>
									
									</cfif>
								
								</cfif>
									
							</td>	
							
							--->	
							
							<td align="center">							
								<cfif eMailAddress is not ''>
								    <i class="fas fa-envelope" title="Send mail" style="color: ##c83702;font-size: 14px;" onClick="email('#eMailAddress#','','','','Applicant','#PersonNo#')"></i>								 
								</cfif>							
							</td>		
							
							<td align="center">
							
							    <cfif url.print eq "0">
												
									<cfif Access1 eq "EDIT" or Access2 eq "EDIT">										
									    <i class="fas fa-comment-alt-lines" title="Maintain comment" style="color: ##c83702;font-size: 14px;position: relative;top: 1px;" onClick="memoshow('memo#url.tab##CurrentRow#','show','#ApplicantNo#','#FunctionId#','#url.filter##CurrentRow#')">
                                        </i>
									</cfif>	
								
								</cfif>
									
							</td>																	
							
							<!--- background-color:<cfif (currentRow MOD 2 EQ 0)>e9e9e9<cfelse>ffffff</cfif> --->
							<td>
								<a href="javascript:ShowFunction('#ApplicantNo#','#FunctionId#','#URL.tab#','#url.box#','#url.owner#','#url.process#','#day#','#status#','#url.level#','#url.processmeaning#','#meaning#','#url.total#','#url.page#','process')">
								#LastName#, #FirstName#</a>
							</td>
							
							<td><A href="javascript:ShowCandidate('#PersonNo#')"><cfif IndexNo neq "">#IndexNo#<cfelse><font color="FF5E5E"></cfif></A></TD>
													
							<td><cfif PersonStatus neq 0>
									<cfif PersonStatus neq 2 >
										<font color="##993300">#PersonStatusDescription#</font>
									<cfelse>
										<strong><font color="##006699">#PersonStatusDescription#</font></strong>
									</cfif>
								<cfelse>
								</cfif>
							</td>
														
						    <TD><cfif ContractLevel neq "">#ContractLevel#/#ContractStep# <!--- [#DateFormat(DateExpiration, CLIENT.DateFormatShow)#] ---></cfif></TD>	
						   	<TD>#Mission#-				<cfif len(organizationunit) gt "20">
							   #left(organizationunit,20)#..
							<cfelse>					
							   #OrganizationUnit#
							</cfif>
							</TD>
							
						    <TD align="center">#Gender#</TD>							
						    <TD>#DateFormat(DOB, CLIENT.DateFormatShow)#</TD>								
						    <TD><cfif Nationality eq ""><font color="FF0000">N/A</font><cfelse>#Nationality#</cfif></TD>							
							<td style="border-right:1px solid d4d4d4">
							
								<table class="formspacing">
								
									<tr>							
									
									<td title="Has one or more education records" style="padding:0 5px;border-right:1px solid ##efefef;" align="center">
									    <cfif University gt 0><i class="fas fa-user-graduate" style="font-size: 15px;color: ##gray;"></cfif>
									</td>														
												
									<td title="Has one or more employment records" style="padding:0 5px;border-right:1px solid ##efefef;" align="center">
										<cfif Employment gt 0><i class="fas fa-briefcase" style="font-size: 16px;color: ##gray;"></cfif>
									</td>						
									<td style="padding:0 5px;" align="center">
										<cfif Language gt 0><span style="font-weight: 800;color: ##gray;">ENG</span></cfif>
									</td>
									</tr>
								</table>
								
							</td>
							
							<td>#dateformat(LastRosterAction,client.dateformatshow)#</td>							
							<td align="center"></td>						
											
						</TR>
						
						<cfif url.source eq "Manual">
						
							<tr>
							<td></td>
							<td></td>
							<td></td>
							<td colspan="3" class="labelit"><b>by:</b> #OfficerFirstName# #OfficerLastName# <b>on:</b> #dateformat(Created,CLIENT.DateFormatShow)#</td>				
							</tr>
						
						</cfif>
						
						<tr id="memo#url.tab##CurrentRow#" class="hide">
						    <td></td> 
							<td colspan="15" style="padding:4px" id="imemo#url.tab##currentRow#"></td>	
						</TR>		
																
						<!--- check if candidate was selected recently --->
							
						<cfif DocumentNo neq "">
						 				   					 
							 <cfset col = 14>					 
							 <cfset own = owner>
							 					 
							 <!--- ---------------------------------------- --->
							 <!--- check if candidate was selected recently --->
							 <!--- ---------------------------------------- --->
							 
							 <tr class="line">
							     <td></td>
								 <td style="border-left:1px solid silver;border-right:1px solid silver" colspan="15">
								 <table width="100%" align="center">								 					
								     <cfinclude template="../../Candidate/Details/Functions/ApplicantFunctionSelection.cfm">
								 </table>
							 </td>
							 </tr>
																					
						</cfif>							 				   
							  
					<cfelseif currrow gt last>										
											
					</cfif>	 
					
				</cfif>  
			
				</cfoutput>
		
			</cfoutput>
		
		</cfif>
		
		</cfoutput>
				
</table>

</cfif>

<!--- is throwing an error on refresh --->
<cfset AjaxOnLoad("doHighlight")>
					
<script>
	Prosis.busy('no');
</script>