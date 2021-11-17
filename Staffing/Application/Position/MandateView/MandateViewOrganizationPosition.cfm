
<cfoutput>

	
<cfif DateFormat(Mandate.DateEffective, CLIENT.DateFormatShow) eq DateFormat(DateEffective, CLIENT.DateFormatShow)
  AND DateFormat(Mandate.DateExpiration, CLIENT.DateFormatShow) eq DateFormat(DateExpiration, CLIENT.DateFormatShow)>
 
   <cfset showpdte = 0>
	   
<cfelse>
	
   <cfset showpdte = 1>
		
</cfif>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
					
		<cfif PostAuthorised eq "0">
		  <cfset cl = "fffaaa">		  
		<cfelseif recruitmenttrack gt "0">			
		  <cfset cl = "E1F8FF">    
		<cfelse>	  
		  <cfset cl = PresentationColor>
		</cfif> 		
		
		<cf_assignid>	
		
		<cfset menufile = "#SESSION.root#/staffing/application/position/mandateview/MandateViewOrganizationPositionMenu.cfm?class=#class#&positionno=#positionno#&ajaxid=posmenu">		
		
		<cfif ParamMission.EnableStaffingMenu eq "1" AND URL.PDF eq 0>
			<TR bgcolor="#cl#" class="line"
			    onContextMenu="cmexpand('posmenu','#rowguid#','#menufile#')">
		<cfelse>
			<TR bgcolor="#cl#" class="line">		
		</cfif>
		
	 	<td height="20" width="20">
								
			<table width="100%">
				<tr>								  				   
				   <cfif url.pdf eq 0>				   
				   		<td width="3"></td>				   
						<td align="center" style="padding-left:4px" onclick="cmexpand('posmenu','#rowguid#','#menufile#')">
						   <img src="#SESSION.root#/images/menu.gif" style="cursor:pointer" alt="Optionsl" border="0" height="10" width="10">
						</td>
						<td id="posmenu" name="posmenu" class="hide">
							<table cellspacing="0" cellpadding="0">
								<tr><td name="posmenu#rowguid#" id="posmenu#rowguid#"></td></tr>
							</table>
						</td>				
				   <cfelse>				
						<td class="regular"></td>		  					
				   </cfif>	  				
				   <td width="10%"></td>					
				</tr>
			</table>
		</td>		
	
		<td width="30%" style="padding-left:6px" class="labelit">
			<cfif URL.PDF eq 0>
			   <a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#')"> 
			 </cfif>  
			 #FunctionDescription#
			 </a>
		</td>
		
		<td width="7%" class="labelit">#PostGrade#</td>
		<td class="labelit" width="8%">#PostClass#</td>
		
		<cfif URL.ID eq "ORG" or URL.Sort eq "OrgUnit">
		    
			<td class="labelit" width="19%">#PostType#</td>
			<td class="labelit" width="18%">
			
				<table width="100%" cellspacing="0" cellpadding="0">
				
				<tr>
				
					<td class="labelit"><cfif PostAuthorised eq "1">Auth</cfif></td>
					
					<cfif showpdte eq 1>
					 					    
						<TD class="labelit">: #DateFormat(DateEffective, CLIENT.DateFormatShow)#</TD>
						<td style="padding-left:2;padding-right:2px">-</td>
						<TD class="labelit">#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</TD>
																			
					</cfif>
										
				</tr>
				
				</table>
			
			</td>	
		<cfelse>
			<td class="labelit" width="37%" colspan="2"><cf_space spaces="80">#OrgUnitName#</td>
		</cfif>
		
		<td width="8%" class="labelit">
	
			<cfif URL.PDF eq 0>
			 	<a title="Edit Position" href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#','i#PositionNo#')"> <font color="0080C0"> 	   
			</cfif>
	     	<cfif SourcePostNumber neq "">#SourcePostNumber#<cfelse>#PositionNo#</cfif>
			<cfif URL.PDF eq 0>
			</a>	  
			</cfif>
				
		</td>
		
		<td class="labelit" width="15%" align="right" style="padding-right:3px"><cfif LocationName eq "">..<cfelse>#LocationName#</cfif></TD>
		<td class="labelit" align="right" style="padding-right:3px;padding-left:3px">
		
		<cfif url.pdf eq "0">
		
			<cfif Mission eq "#MissionOperational#">
					
				<cfif Mandate.MandateStatus eq "0">
				 			
					<cfif (AccessPosition eq "EDIT" or AccessPosition eq "ALL") 
						  or (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL")>
						  <cfset batch = "1">						 
						  <cfif Mandate.MandateStatus eq "0"> 
						    <!--- draft mandate --->
    		              	 <input type="checkbox" style="height:13px;width:13px" name="position" value="#PositionParentId#">   
	   				      <cfelse>
					         <input type="checkbox" style="height:13px;width:13px" name="position" value="#PositionNo#">   
					      </cfif>
						  
					</cfif>
							
				</cfif>
		
			</cfif>	
		
		</cfif>
		
		</td>
		</tr>	
		 				
		<cfif recruitmenttrack gt "0">
		
			 <cfinvoke component = "Service.Process.Vactrack.Vactrack"  
			   method           = "getTrackPosition" 
			   positionNo       = "#PositionNo#"
			   returnvariable   = "doc">					
			  
								
				<cfloop query="doc">	
				
								
					<tr bgcolor="<cfif class eq 'future'>DFBFFF<cfelse>yellow</cfif>">
					
						<td align="center"><img src="#SESSION.root#/Images/pointer.gif" alt="Recruitment action" width="9" height="9" border="0" align="middle" style="cursor: pointer;" onClick="javascript:showdocument('#DocumentNo#')">
						
						</td>
						<td colspan="9">
						
						    <table cellspacing="0" cellpadding="0">
							<tr>
							<td class="linedotted labelit" style="padding-left:3px">
							
							<cfif URL.PDF eq 0>
								<a href="javascript:showdocument('#DocumentNo#')">
							</cfif>							
							#tRecruitment#: [#EntityClassNameShort#] 
							<cfif trim(InspiraTrack) neq "">
								#InspiraTrack#
							<cfelse>
								#DocumentNo# 
							</cfif>
								(Officer - #LEFT(officerUserFirstName,1)#. #OfficerUserLastName# - Created on: #dateformat(created,CLIENT.DateFormatShow)#)</a>
							</td>
								 <cfquery name="Candidate" 
									datasource="AppsVacancy" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT  PersonNo, LastName, FirstName, StatusDate
									FROM    DocumentCandidate P
									WHERE   DocumentNo = '#DocumentNo#' 
									AND     Status IN ('2s','3')
								</cfquery>	
								
								<cfset cpl = DateFormat(Candidate.StatusDate, CLIENT.DateFormatShow)>
																						
								<cfif Candidate.recordcount gte "1">
									<td bgcolor="D6FED9" class="labelit" style="padding-left:4px">
									<cfloop query = "Candidate">
										
										<cfif URL.PDF eq 0>
											<a href="javascript:ShowCandidate('#Candidate.PersonNo#')">
										</cfif>
										#Candidate.FirstName# #Candidate.LastName# - #cpl#</a>
									</cfloop>
									</td>
								<cfelse>
								
									<td class="labelit" style="padding-left:4px"> - #tNoCandidateInfo# -</td>
									
								</cfif>
							</tr>
							</table>
						</td>
					</tr>		
					
				</cfloop>								
			 	
			</cfif>				
	
			<cfif ParentOrgUnit neq OrgUnitOperational and Class eq "Used">
			
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
				
					<cfquery name="Parent" 
					datasource="AppsOrganization" 
				    username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT TOP 1 *
						FROM   Organization.dbo.Organization Org
						WHERE  Org.OrgUnit = #ParentOrgUnit#
					</cfquery>	
					
					<cfquery name="ParentP" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT TOP 1 OrgUnitName
						FROM    Organization
						WHERE   Mission     = '#Parent.Mission#'
						AND     MandateNo   = '#Parent.MandateNo#'
						AND     OrgUnitCode IN (SELECT ParentOrgUnit 
						                        FROM Organization 
									   		    WHERE OrgUnit = '#Parent.OrgUnit#')
					</cfquery>
					
					<tr>
					<td colspan="9">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" >
							<tr bgcolor="EAF4FF">
								<td width="100" style="padding-left:4px" class="labelit"><cf_tl id="Borrowed from">:</TD>	
								<td class="labelit">
									<cfif URL.PDF eq 0>
										<A HREF ="javascript:EditPost('#PositionNo#')">
									</cfif><b>#Parent.Mission# - 
								<cfif ParentP.recordcount eq "1">#ParentP.OrgUnitName#/</cfif>#Parent.OrgUnitName#</b></A></TD>
								<td class="labelit"><b>#ParentFunctionDescription#</b></td>
							</tr>	
						</table>
					</td>
					</tr> 
			    
				</cfif>
			
			</cfif>
			
		 <cfif Class eq "Loaned" and ParentOrgUnit neq OrgUnitOperational>
		 
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
			
			 <tr>
			 <td colspan="9">
				 <table width="100%" border="0" cellspacing="0" cellpadding="0">
				 
				    <cfquery name="Loaned" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT TOP 1 *
						FROM   Organization
						WHERE  OrgUnit = #OrgUnitOperational#
					</cfquery>	
				 
				   <cfquery name="ParentP" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT TOP 1 OrgUnitName
					FROM    Organization
					WHERE   Mission     = '#Loaned.Mission#'
					AND     MandateNo   = '#Loaned.MandateNo#'
					AND     OrgUnitCode IN (SELECT ParentOrgUnit 
					                        FROM   Organization 
											WHERE  OrgUnit = '#Loaned.OrgUnit#')
					</cfquery>
										 
					<tr bgcolor="EAF4FF">
					
						<td colspan="1" class="labelmedium" style="padding-left:10px" width="100"><cf_tl id="Loaned to">:</TD>	
						<TD colspan="1" class="labelit">
						<cfif URL.PDF eq 0>
							<A HREF ="javascript:EditPost('#PositionNo#')">
						</cfif><b>
						#Loaned.Mission# - 
						<cfif ParentP.recordcount eq "1">#ParentP.OrgUnitName#/</cfif>#Loaned.OrgUnitName#</b></A>
						</TD>
					</TR>	 
				 
				 </table>
			  </td>
			  </tr>
			  
			  </cfif>
			 
		</cfif>
	 	 	
</table>

</cfoutput>

<script>
	Prosis.busy('false')
</script>

	