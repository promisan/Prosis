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

<cfparam name="url.mode" default="fly">

<cfif url.mode eq "fly">
  
    <!--- generate data on the fly and fresh data --->
	
    <cf_OrgTreeAssignmentData	   
	   presentation  = "detail"
	   mode          = "query"
	   tree          = "#url.tree#"
	   selectiondate = "#url.selectiondate#"
	   orgunit       = "#URL.Unit#"
	   postclass     = "#url.postclass#"
	   fund          = "#url.fund#">
	
<cfelse>

	<!--- pregenerated table --->
	
	<cfquery name="qDetails" 
	 dataSource="appsquery">
	
	  SELECT * 
	  FROM   dbo.#SESSION.acc#_MissionAssignment
	  WHERE  1=1
	  
	  <cfif url.unit neq "">
		  <cfif url.tree eq "Operational">
			 AND  OrgUnitOperational   = '#URL.Unit#'		
		  <cfelse>
		    AND  OrgUnitAdministrative = '#URL.Unit#'		
		 </cfif>  
	<cfelse>
		AND 1=0	
	 </cfif>
	</cfquery>
	
</cfif>

<cfoutput>
<cfif url.tree eq "operational">
   <cfset link = "details('e#url.Unit#','#url.Unit#','show')">
<cfelse>
   <cfset link = "">
</cfif>
</cfoutput>

<cfif ListLen(url.ShowColumns) neq 0>

	<table width="98%" class="navigation_table" align="center" cellspacing="0" cellpadding="0" bgcolor="ffffff" onClick="<cfoutput>#link#</cfoutput>">
	
		 <cfif url.unit neq "">
					
			<cfif qDetails.recordcount eq "0">
			
			   <cfoutput>
			   
				    <tr>				
					   <td class="labelmedium" colspan="5" align="center" style="padding:3px;cursor: pointer;">No positions set on this level.</td>					 
				    </tr>
					
			   </cfoutput>
			   
			</cfif>		
					
			<cfoutput query="qDetails">				
																					
				<tr class="labelmedium navigation_row" style="border-top:1px solid silver;">
					
					<cfif blocked eq 0 or blocked eq 1>
							<cfif listContainsNoCase(URL.ShowColumns, "ShowGrade", "|") neq 0>		
								<td style="min-width:35px;padding-left:2px;padding-right:3px;<cfif class eq 'Borrowed'>background-color:##00ff0080; <cfelseif class eq 'Loaned'>background-color:##CEECF580;</cfif>" class="listcontent">											
								<cfif url.tree neq "operational">
								<a href="javascript:EditPosition('','','#positionno#','close')">
								</cfif>
								<cfif ApprovalPostGrade neq PostGrade and ApprovalPostGrade neq "">
									#ApprovalPostGrade#
								<cfelse>
									#PostGrade#
								</cfif>
								</a>
								</td>
							</cfif>								
							
							<cfif listContainsNoCase(URL.ShowColumns, "ShowPosition", "|") neq 0>	
											
								<td class="listcontent" style="padding-right:3px">	
											
										<cfif url.tree neq "operational">			
											<cfif SourcePostNumber neq "">
												<a href="javascript:EditPosition('','','#positionno#','')">#SourcePostNumber#<b></a>
											<cfelse>	
												<a href="javascript:EditPosition('','','#positionno#','')">#PositionParentId#</a>
											</cfif>	
										<cfelse>
											<cfif SourcePostNumber neq ""><a href="javascript:EditPosition('','','#positionno#','')">#SourcePostNumber#</a>
											<cfelse>
											<a href="javascript:EditPosition('','','#positionno#','')">#PositionParentId#</a>
											</cfif>	
										</cfif>								
								</td>			
											
							</cfif>								
							
							<cfif listContainsNoCase(URL.ShowColumns, "ShowFund", "|") neq 0>							
								<td class="listcontent" style="padding-right:3px">#PositionParentFund#</td>									
							</cfif>	
							
					<cfelse>
						<td colspan="3" class="listcontent"><font color="A4A4A4"><cf_tl id="Blocked"></font></td>
					</cfif>
					
					<cfif listContainsNoCase(URL.ShowColumns, "ShowPersonGrade", "|") neq 0>	
							
						<td class="listcontent" style="min-width:40px">						
						<cfif PostAdjustmentLevel neq "">
							#PostAdjustmentLevel# 
						<cfelse>
							#ContractGrade# 
						</cfif>						
						</td>	
						
					</cfif>	
								
					<cfif PersonNo eq "">
					
						<td class="labelit listcontent" style="padding-right:3px" align="right">
							<cfif ListLen(URL.ShowColumns) neq 0>
							    <font color="FF0000"><cf_tl id="Vacant"></font>
							</cfif>	
						</td>	
						
					<cfelse>
					
						<td class="listcontent" style="padding-right:3px;min-width:80px" align="right" bgcolor="<cfif Incumbency neq "100">silver</cfif>">
							<cfif listContainsNoCase(URL.ShowColumns, "ShowFullName", "|") neq 0>				
								<cfset vPos=Find("x",LastName)>
								<a href="javascript:EditPerson('#PersonNo#')">								
								<cfif vPos neq "0">
									#Mid(LastName,1,vPos)#,#Mid(FirstName,1,1)#
								<cfelse>
									#Mid(LastName,1,16)#,#Mid(FirstName,1,1)#
								</cfif>								
								</a>	
							</cfif>	
						</td>					
					
					</cfif>	
					
				</tr>
				
				<cfif listContainsNoCase(URL.ShowColumns, "ShowTitle", "|") neq 0>	
				
					<tr style="height:14px">
						<td></td>							
						<td colspan="4" class="listcontent" style="min-width:200px;height:10px">#replace(FunctionDescription,'-','')#</td>							
					</tr>	
						
					</cfif>	
				
				<cfif (class eq "Borrowed" or class eq "Loaned") and blocked neq 1>
				<tr class="listcontent">
						<td><img src="#SESSION.root#/Images/join.gif" alt="Recruitment action" border="0" align="middle"></td>
						<cfif class eq "Borrowed">
							<td colspan="4" class="listcontent">
								<font color="800000"> <cf_tl id="Borrowed from"> <cfif url.tree eq "Administrative">#replace(OrgUnitAdmin,'-','')#<cfelse>#replace(OrgUnitOpera,'-','')#</cfif></font>
							</td>
						<cfelseif class eq "Loaned">
							<td colspan="4" class="listcontent">						
								<font color="800000"><cf_tl id="Loaned to"> <cfif url.tree eq "Administrative">#replace(OrgUnitAdmin,'-','')#<cfelse>#replace(OrgUnitOpera,'-','')#</cfif></font>
							</td>	
						</cfif>
							
				</tr>	
				</cfif>			
				
				<cfif (TrackCurrent gte "0" or TrackPrior gte "0") and ListLen(URL.ShowColumns) neq 0>
						
						    <cfquery name="Tracks" 
							datasource="AppsVacancy" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							<!--- current mandate --->
							SELECT   D.*			
							FROM     Document D INNER JOIN
									 DocumentPost DP ON D.DocumentNo = DP.DocumentNo INNER JOIN
									 Employee.dbo.Position P ON DP.PositionNo = P.PositionNo
							WHERE    D.Status = '0'
								AND  P.PositionNo = '#PositionNo#'
								AND  D.EntityClass is not NULL					
							UNION
							<!--- next mandate --->
							SELECT   D.*
							FROM     Document D INNER JOIN
					                 DocumentPost DP ON D.DocumentNo = DP.DocumentNo INNER JOIN
					                 Employee.dbo.Position P ON DP.PositionNo = P.SourcePositionNo
							WHERE    D.Status = '0'		 
								AND  P.PositionNo = '#PositionNo#'				
								AND  D.EntityClass is not NULL									
							</cfquery>	
																	
							<cfloop query="Tracks">	
							
							<tr class="labelit">
							
							<td><img src="#SESSION.root#/Images/join.gif" alt="Recruitment action" border="0" align="middle"></td>
							<td colspan="2">
							
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
									<a href="javascript:showdocument('#DocumentNo#')" title="TrackNo">#DocumentNo#</font></a>
								</cfif>
								
							<cfelse>
							
								<a href="javascript:showdocument('#DocumentNo#')" title="TrackNo">#DocumentNo#</font></a>
							
							</cfif>	
										
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
									<td colspan="3" bgcolor="D6FED9" style="padding-left:4px">
									<cfloop query = "Candidate">
									<a href="javascript:ShowCandidate('#Candidate.PersonNo#')" title="selected candidate">#Candidate.LastName#<cfif currentrow neq recordcount>;</cfif></a>
									</cfloop>							
									</td>
								<cfelse>
									<td colspan="3" align="center"><font color="800000"><cf_tl id="In Process"></td>
								</cfif>
								</tr>
								
							</cfloop>									
			 		 	
						</cfif>
						
						
							
				</cfoutput>
				
			</cfif>	
	
	</table>	
	
</cfif>

<cfset ajaxonLoad("doHighlight")>
