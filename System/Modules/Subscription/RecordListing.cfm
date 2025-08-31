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
<cfparam name="url.portal" default="0">
<cfparam name="url.systemfunctionid" default="">
<cfparam name="url.module" default="">

<cfif Portal eq "0">
    <cfinclude template="RecordScript.cfm">	
	<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">
</cfif>

<table width="94%" height="100%" align="center" class="formpadding">

<tr><td height="10"></td></tr>
<tr><td valign="top">

	<form action="RecordPurge.cfm?<cfoutput>module=#url.module#&portal=#url.portal#&systemfunctionid=#url.systemfunctionid#</cfoutput>" method="post" name="result" id="result">
	
		<table width="100%" class="formpadding">
		   
		  <tr class="noprint">
		    <td>
			
			<table width="100%" bgcolor="white">	
			 			
				<tr><td colspan="2" class="labellarge" style="font-size:29px">
		
			<cfoutput>
			My <cfif URL.View eq "1">&nbsp;<img src="#SESSION.root#/Images/favorite.gif" alt="" width="40" height="40" border="0">&nbsp;<font color="FF8040">popular</font>&nbsp;</cfif>report variants</b>
			</cfoutput>
			
			<font size="3">&nbsp;
			<cfif URL.View eq "1">
			    <a href="javascript:reloadForm('0')">[Show All variants]</a>
			<cfelse>
			    <a href="javascript:reloadForm('1')">[Show Favorite variants only]</a>	  
			</cfif>	
					</td></tr>
				</table>
		    </td>
			<td align="right">
		   
			</td>
		  </tr> 	
		    
		<cfset FileNo = round(Rand()*100)>  
		    
		<cfquery name="SearchResult" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT U.*, 
			       R.*, 
				   L.TemplateReport, 
				   L.LayoutName, 
				   S.Description, 
				   (SELECT Max(Created) as LastDate 
				    FROM UserReportDistribution 
					WHERE  BatchId is NULL
					AND    Account = '#SESSION.acc#' 
					AND    ReportId = U.ReportId) as LastDate
			FROM   UserReport U,
			       Ref_ReportControlLayout L,
			       Ref_ReportControl R, 
			       Ref_SystemModule S
			WHERE  U.LayoutId    = L.LayoutId
			AND    L.ControlId   = R.ControlId
			AND    R.SystemModule = S.SystemModule
			AND    U.Account = '#SESSION.acc#'	
			AND    L.Operational = '1'
			AND    S.Operational = '1'
			AND    U.Status NOT IN ('5','6')
			<cfif URL.View eq "1">
			AND    U.ShowPopular = '1'
			</cfif>
			ORDER BY R.SystemModule, R.MenuClass, R.FunctionName, U.DateExpiration
		</cfquery>
		
		<tr><td colspan="2">
		
		<table width="100%" align="center" class="formpadding navigation_table">
		
		<cfif SearchResult.recordcount eq "0">
		
		    <tr><td height="5"></td></tr>
		    <tr><td height="1" class="line" colspan="13"></td></tr>	
			<tr><td colspan="13" style="height:60px" align="center" class="labellarge"><font color="808080">No subscribed reports were found.</td></tr>
			<tr><td height="1" class="line" colspan="13"></td></tr>
			
		<cfelse>
		
				<cfoutput query="SearchResult" group="SystemModule">
				
				<TR>
				    <td colspan="13">
					
						<table width="100%">
						<tr>
						    <td width="165" colspan="2" class="labellarge" style=";font-weight:200;height:40;font-size:24px;padding-top:5px;padding-left:5px">#Description#</td>
						   
							<td align="right">
							<button type="button" style="height:30px;width:30px" class="button3" onClick="purge()" onmouseover="javascript:tooltip('Remove selected reports')" onmouseout="javascript:tooltip('')">
								<img src="#SESSION.root#/Images/trash2.gif" alt="Remove selected reports" border="0" style="height:30px;width:20px;bordercolor: f6f6f6; cursor: pointer;" >
							</button>	
							</td>			
						</tr>
						</table>
					
					</td>
				</tr>
						
				<cfoutput group="MenuClass">		
					
				<cfoutput group="FunctionName">
				
				<tr class="line labelmedium2 fixlengthlist" style="height:30px">
				<td colspan="7" style="font-size:17px"><font color="gray">#FunctionName#</font></td>
				<td colspan="6" align="right"><cfif FunctionAbout neq "">
				<button type="button" class="button3" onClick="javascript:reportabout('#ControlId#')"
				onmouseover="javascript:tooltip('About this report')" onmouseout="javascript:tooltip('')">
				<img src="#SESSION.root#/Images/question.gif" alt="About this report" border="0" style="cursor: pointer;" >
				</button>
				</cfif></td>
				  
				</tr>
						
				<cfoutput>
				
				
				     <cfif Operational eq "1">
							
						<cfinvoke component="Service.AccessReport"  
					          method="report"  
							  ControlId="#ControlId#" 
							  returnvariable="access">
						  
						<cfif access is "GRANTED">
							<cfset color = "ffffff">
							<cfset color1 = "f9f9f9">
						<cfelse>
						    <cfset color = "FAD5CB">
							<cfset color1 = "FAD5CB">
						</cfif>	 				
					
					<cfelse>
					
						 <cfset access = "DIS">
						 <cfset color  = "ffffff">
						 <cfset color1 = "ffffdf">
							
					</cfif>
							
					<TR id="#currentrow#1" class="navigation_row labelmedium2 line fixlengthlist">
								
					<td align="center" style="padding-left:5px"
					    onClick="more('#reportId#','show','#Currentrow#','prior')">
				
						<img src="#SESSION.root#/Images/arrowright.gif" alt="View criteria" 
							id="#currentrow#Exp" border="0" class="show"
							align="middle" style="cursor: pointer;" 					
							onMouseOver="tooltip('View criteria')"
							onMouseOut="tooltip('')">
								
						<img src="#SESSION.root#/Images/arrowdown.gif" 
							id="#currentrow#Min" alt="Hide criteria" border="0" 
							align="middle" class="hide" style="cursor: pointer;" 					
							onMouseOver="tooltip('Hide criteria')"
							onMouseOut="tooltip('')"> 
										
					</td>
					
					<td align="center">
						  
					<CFIF access is "GRANTED"> 
					
					     <cfif TemplateReport neq "Excel">
						 
		   					   <img src="#SESSION.root#/Images/print_small3.gif" alt="Open report" name="img1_#currentrow#" 				    
								  style="cursor: pointer;" alt="View report" height="16" border="0" align="absmiddle" onClick="report('#ReportId#')">
							  
						  <cfelse>
						  
							   <img src="#SESSION.root#/Images/dataset.png" alt="Open report" name="img1_#currentrow#" 				    
								  style="cursor: pointer;" alt="View report" height="16" border="0" align="absmiddle" onClick="report('#ReportId#')">		
						  
						  </cfif>
		  
					<cfelse>
					      <img src="#SESSION.root#/Images/caution.gif" border="0">
					</cfif>	
					</td>					
					
					<CFIF access is "GRANTED"> 
					
						<td id="mail#reportid#" align="center">
						
						<cfset l = len(reportPath)>
									
						<cfif right(reportPath,1) eq "\">				
							 <cfset path = left(reportpath,l-1)>
						<cfelse>				
							 <cfset path = reportpath> 
						</cfif>
						
						<cfif TemplateReport neq "Excel">
										
							<cfif DistributioneMail neq "">
		
								<img src="#SESSION.root#/Images/mail.png"  onClick="mail('#ReportId#','#path#','#TemplateSQL#')"
								  name="img3_#currentrow#" alt="send this report to myself" height="28" width="23" style="cursor:pointer" alt="eMail report" border="0" align="absmiddle" >
		
							</cfif>
						
						</cfif>
						
						</td>
						
						<td align="center" style="padding-top:3px">
										
						<cf_img icon="open" tooltip="open report variant" onClick="schedule('#ReportId#')">				
									  
						</td>
							
						<td align="center">
						
						<cfif ShowPopular eq "0">
						
							<img onClick="javascript: popular('1','#ReportId#')" height="12" src="#SESSION.root#/Images/favorite.gif" alt="List as favorite report" border="0" align="absmiddle"
							onMouseOver="tooltip('List as favorite report')" onMouseOut="tooltip('')" style="cursor:pointer">
						
						<cfelse>
						
							<img onClick="javascript: popular('0','#ReportId#')" height="12" src="#SESSION.root#/Images/down2.gif" alt="Disable as favorite report" border="0" align="absmiddle"
							onMouseOver="tooltip('Disable as favorite report')" onMouseOut="tooltip('')" style="cursor:pointer">
						
						</cfif>
						</td>
				
					<cfelse>
														
						<td colspan="3" align="center"><font color="FF0000"><cfif Access eq "DIS">Disabled<cfelse>Revoked</cfif></td>
						
					</cfif>
					
					<td><a href="javascript:more('#reportId#','show','#Currentrow#')"><cfif TemplateReport eq "Excel">Excel data<cfelse>#LayoutName#</cfif></a></td>
					<TD>#DistributionSubject#</TD>
					<TD><cfif DistributionPeriod neq "Manual">#DistributionPeriod# <cfif #DistributionPeriod# eq "Weekly">[#DistributionDOW#]</cfif></cfif></TD>
					<TD><cfif TemplateReport neq "Excel">#FileFormat#<cfelse>Analysis ROLAP</cfif></TD>
					<TD><!--- #Dateformat(DateEffective, CLIENT.DateFormatShow)# - ---> #Dateformat(DateExpiration, CLIENT.DateFormatShow)#</TD>					 
					<TD>
					<cfif LastDate lt now() - 30 >
					<img src="#SESSION.root#/Images/caution.gif" alt="Report was never launched" border="0"> 
					<b>Never</b><cfelse>last:#Dateformat(LastDate, CLIENT.DateFormatShow)#</cfif></TD>								
					<td align="center">
						<input type="checkbox" class="radiol" name="selected" id="selected" value="'#ReportId#'">
					</td>	
					
					<td align="center">
						
						 <cfinvoke component="Service.AccessReport"  
					          method="editreport"  
							  ControlId="#ControlId#" 
							  returnvariable="accessedit">
							  
							  <CFIF accessedit is "EDIT" or accessedit is "ALL"> 
							  
						 		 	<img src="#SESSION.root#/Images/configure.gif" height="20" alt="Edit report definition" name="img0_#currentrow#" 
									  style="cursor: pointer;" border="0" align="absmiddle" onClick="recordedit('#ControlId#')">
									  
							  </cfif>
						
						</td>									
											
				    </TR>	
					
					<cfif AccountSubscriber neq "">
								
					<cfquery name="User" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						  SELECT *
						  FROM   UserNames U
						  WHERE  Account = '#AccountSubscriber#' 				
					</cfquery>
					
					<cfif user.recordcount eq "1">
					
					<tr>
					  <td align="center" colspan="1" valign="top"></td>
					  <td colspan="12" class="labelmedium2">
						  <font color="gray">This report variant was made available to you by:</font></i>&nbsp;&nbsp;<font color="0080FF">#User.FirstName# #User.LastName# 
					  </td>
					</tr>
					
					</cfif>
								
					</cfif>
								
					<cfif DateExpiration lt now() and DistributionPeriod neq "Manual">
					
						<tr>
						 <td align="center" colspan="13" valign="top" class="labelmedium">
						    <font color="red"><b>Attention:</b>&nbsp;&nbsp;the delivery schedule of this report expired.</font>
						 </td>
						</tr>
					
					</cfif>
																			 
						<tr id="#currentrow#" class="hide">				  
						  <td colspan="13" style="padding-left:10px" id="i#currentrow#"></td>
						</tr>
								
						<tr id="#currentrow#3" class="hide">
						  <td height="1" bgcolor="f3f3f3" colspan="13"></td>
					    </tr>
																			
				</CFOUTPUT>	
				</CFOUTPUT>	
				</CFOUTPUT>	
				</CFOUTPUT>
						
		</cfif>		
		
		</TABLE>
		
		</td>
		
		</tr>
		
		</TABLE>
	
	</form>

</td>

</tr>

</TABLE>
