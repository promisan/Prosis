
<cfparam name="URL.PDF"      default="0">
<cfparam name="orow"         default="0">
<cfparam name="recruitmenttrack" default="0">
<cfparam name="funding"      default="">
<cfparam name="prior"        default="">

<cf_tl id="Vacant" var="1">
<cfset tVacant = lt_text>

<!--- attention this screen is also embedded as line so the table is on the line level --->

<cfoutput>
   
   <cfset descp = FunctionDescription>
   <cfset orgcp = OrgUnitOperational>
    
   <table width="100%" class="navigation_table">     
       
	<cfparam name="Occurence" default="1">	
	
	<cfset cl = PresentationColor>
			
	<cf_assignid>	
	
	<cfset menufile = "#SESSION.root#/staffing/application/position/mandateview/MandateViewOrganizationPositionMenu.cfm?class=#class#&positionno=#positionno#&AjaxId=posmenu">		
	 
	<cfif prior neq PositionNo>  
		<cfset orow = orow+1>
	</cfif>	
	 
	<tr bgcolor="#cl#" class="navigation_row labelmedium" style="height:22px;border-top:1px solid silver">
	
		<cfif prior eq PositionNo>
		
		<td colspan="5" style="min-width:610px"></td>
		
		<cfelse>
					
		<td align="center" style="min-width:60px;height:19px">#orow#.</td>     
	    <td style="min-width:40px">
			
			<table>
			<TR>		
					    				
			   <td width="3"></td>
			   	 			
			   <cfif url.header eq "requisition">
			   
				 <td align="center" style="padding-left:4px" 
			      onclick="parent.document.getElementById('positionparentselect').value=#positionparentid#;parent.document.getElementById('positionparentselect').click()">			  
				     <cf_img icon="open" tooltip="Select Position for funding">				 			    				  
				 </td> 
						  
			   <cfelse>
			   		   
			      <td align="center" style="padding-left:4px" onclick="cmexpand('posmenu','#rowguid#','#menufile#')">			
				  	
					   <img src="#SESSION.root#/images/menu.gif" 
					      style="cursor:pointer" 
						  alt="Optionsl" 
						  border="0" 
						  height="10" width="10">
	  			  </td>	  
				  
			   </cfif> 	  
				
				<td id="posmenu" name="posmenu" class="hide">
					<table cellspacing="0" cellpadding="0"><tr><td id="posmenu#rowguid#"></td></tr></table>
				</td>	
				
			</tr>
			</table>
					
	    </td>		    
               
	    <td style="min-width:70px">#PostGrade#<td>
	   
	    <td style="min-width:280px">		 
		 
		   <cfset fun = rtrim(ltrim(FunctionDescription))>		  	   
		   <cfif len(fun) gte "27">
			   <cfset fun = "#left(fun,27)#..">	   
		   </cfif>#fun#
		 		   
	   </td>
	  
	  <td style="min-width:90px;padding-left:2px">   
		  		  
		   <table>
			<tr>			
				<cfif Occurence gte "2">			   
			   		<td style="height:15px;min-width:8;background-color:yellow;border:1px solid black"></td>									   
			    </cfif>  	
				
				<cfif class eq "Used">
					<cfset cla = "transparent">
				<cfelseif class eq "Loaned">
					<cfset cla = "e1e1e1">
				<cfelse>		
				    <cfset cla = "yellow">			
				</cfif>		
				
				<td style="padding-left:5px;background-color:#cla#">		
											       
				   <a title="#class# : #OrgUnitOwnerNameShort#" 
				   href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#','i#PositionNo#')"> 
				   
				      				   				   
			   	   <cfif SourcePostNumber neq "">
				    #SourcePostNumber#
				   <cfelse>
				   	#PositionParentId#
				   </cfif>
				   </a>					   
			   </td>		   		 		   
			</tr>
		   </table>
		 		    
	   </td>	
	   
	   <td style="min-width:70px;padding-left:4px">
		<!---- rfuetnes to show the name instead of the code ----->
		   <cfif TRIM(LocationName) neq "">#LocationName#<cfelse>#LocationCode#</cfif> 
	   </td>	
	   
	    </cfif>    
	   
	   <td style="padding-left:10px;min-width:45px">
	   
	   		<cfif positiongroup gte "1">
	   
			    <cfquery name="grouplist" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					 SELECT     R.ShowInColor, R.ShowInView
					 FROM       PositionGroup AS P INNER JOIN
		                        Ref_Group AS R ON P.PositionGroup = R.GroupCode
					 WHERE      P.PositionNo = '#PositionNo#'  AND Status != '9'
					 ORDER BY   R.ShowInColor
				</cfquery>	 
				
				<table>
				<tr>
				<cfloop query="grouplist">
					<cfif grouplist.ShowInView eq "1">
						<td style="height:15px;min-width:8;background-color:#ShowInColor#;border:1px solid black"></td>			
					</cfif>
				</cfloop>
				</tr>
				</table>

			</cfif>	
	   
	   </td>
	   	   	   
	   <cfif LastName eq ""> 
		   
		   <td colspan="7" align="center" style="background-color:##e3e3e380;width:100%;border-left:1px solid silver;border-right:1px solid silver">	  
	   	   	      	   
		  	   <font color="gray">#tVacant#</font>		   
		       <cfif ParamMission.AssignmentEntryDirect eq "0" and getAdministrator("*") eq "0">			   
		       	<cfif (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL") AND URL.PDF eq 0>	   
		    	   <A HREF ="javascript:AddAssignment('#PositionNo#','i#PositionNo#')">[<cf_tl id="assign">]</a>
				</cfif>  				
			   </cfif>		
			   
			</td>    
		   
	   <cfelse>
		   				   
			   <TD style="background-color:###cl#80;width:100%;min-width:160px;padding-left:3px">
									
				<cfif Extension neq "">				
														
				    <cfif Dateformat(DateExpirationAssignment, CLIENT.DateFormatShow) eq Dateformat(Mandate.DateExpiration, CLIENT.DateFormatShow)>
								
						<img src="#SESSION.root#/Images/reminder.png" height="13" alt="Extension requested" border="0">
						
					<cfelse>
						
						 <cfquery name="clean" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							DELETE FROM PersonExtension
							WHERE  PersonNo  = '#PersonNo#'
							AND    Mission   = '#Mission#'
							AND    MandateNo = '#MandateNo#'
							AND    PersonNo NOT IN (SELECT PersonNo 
							                        FROM   PersonAssignment
													WHERE  DateExpiration = '#Dateformat(Mandate.DateExpiration, CLIENT.DateSQL)#'
													AND    AssignmentStatus IN ('0','1'))	
						 </cfquery>										
					</cfif>
						
				</cfif>	
					
				<cfif (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL") AND URL.PDF eq 0>
					<a href="javascript:EditAssignment('#PersonNo#','#AssignmentNo#','#PositionNo#','i#PositionNo#')">
					</cfif>
					#FirstName# #LastName#
					</a>	
								
				</TD>
					
				<td style="background-color:###cl#80;min-width:80px">		    
					<cfif contractlevel neq "">#Contractlevel#/#ContractStep#<cfif contractTime neq "100">:#contractTime#%</cfif></cfif>			
				</td>	
				
				<td  style="background-color:###cl#80;min-width:80px">		
				    <cfif PostAdjustmentlevel neq "">#PostAdjustmentlevel#/#PostAdjustmentStep#</cfif>			
		    	</td>
				
		        <td style="background-color:###cl#80;min-width:100px">		
				    
					<cfif (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL") AND URL.PDF eq 0>
					<a href="javascript:EditPerson('#PersonNo#','#AssignmentNo#','#PositionNo#','i#PositionNo#')">
					</cfif>			
					<cfif IndexNo neq "">#IndexNo#<cfelse>#Reference#</cfif>			
				</td>
				
			    <td style="background-color:###cl#80;min-width:40px">#Gender#</td>
			    <td style="background-color:###cl#80;min-width:40px">#Nationality#</td>
				<cfif Incumbency eq "0">
				<td align="center" bgcolor="red"  style="min-width:60px"><b><font color="white">#Incumbency#</td>
				<cfelse>
				<td align="center" style="background-color:###cl#80;min-width:60px">#Incumbency#</td>
				</cfif>
		   
	   </cfif>			
	   
	   <cfif url.header eq "Yes">
  
		  <TD style="padding-left:4px;padding-right:4px;min-width:30px">  		  		  
		  
		        <cfif ( Mandate.MandateDefault eq 1 or Mandate.MandateStatus eq "0" )
		         and ((AccessPosition eq "EDIT" or AccessPosition eq "ALL") or (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL"))>
		          <cfset batch = "1">    
				       <cfif Mandate.MandateStatus eq "0">   <!--- draft mandate --->
		              	 <input style="height:17px;width:17px" class="radiol" type="checkbox" name="position" value="#PositionParentId#">   
					   <cfelse>
					     <input style="height:17px;width:17px" class="radiol" type="checkbox" name="position" value="#PositionNo#">   
					   </cfif>
		        </cfif>              
		  
		  </TD>
		  
	  </cfif>	  	
	 
  </tr>
      
  <cfif Lastname neq "" and OrgUnit neq orgcp and Class eq "Used">
  
	   <tr bgcolor="#cl#" class="labelmedium">
	      <td></td>
	      <TD colspan="12" bgcolor="E6E6E6"><cfif OrgUnit neq orgcp>#OrgUnitName#</cfif></TD>
	   </tr>
	   
  </cfif>	 
    
  <cfif recruitmenttrack gt "0">
			
	    <cfquery name="Doc" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
		
			<!--- select track occurence --->												  
							
			SELECT    D.* 
			<!----- show the inspira trackNo ------>
						,(SELECT TOP 1 ReferenceNo
							FROM   Applicant.dbo.FunctionOrganization
							WHERE  FunctionId =  D.FunctionId
							) as InspiraTrack
						,(SELECT TOP 1 ISNULL(Ref.EntityClassNameShort, Ref.EntityClass) 
							FROM Organization.dbo.Ref_EntityClass as Ref 
							WHERE Ref.EntityCode='VacDocument' AND Ref.EntityClass = D.EntityClass) as EntityClassNameShort
			FROM      Vacancy.dbo.DocumentPost as Track INNER JOIN
    			              Position PM ON Track.PositionNo = PM.PositionNo INNER JOIN
                      Position SP ON PM.PositionParentId = SP.PositionParentId INNER JOIN
                      Vacancy.dbo.Document D ON Track.DocumentNo = D.DocumentNo
			WHERE     SP.PositionNo = '#PositionNo#' 
			AND       D.EntityClass IS NOT NULL 
			AND       D.Status = '0'
			
			<!--- current mandate track linked through source --->
			
			UNION 
															
			<!--- first position in the next mandate --->			
			
			SELECT     D.*
			<!----- show the inspira trackNo ------>
						,(SELECT TOP 1 ReferenceNo
							FROM   Applicant.dbo.FunctionOrganization
							WHERE  FunctionId =  D.FunctionId
							) as InspiraTrack
						,(SELECT TOP 1 ISNULL(Ref.EntityClassNameShort, Ref.EntityClass) 
							FROM Organization.dbo.Ref_EntityClass as Ref 
							WHERE Ref.EntityCode='VacDocument' AND Ref.EntityClass = D.EntityClass) as EntityClassNameShort
			FROM       Vacancy.dbo.DocumentPost as Track INNER JOIN
                       Position PM ON Track.PositionNo = PM.PositionNo INNER JOIN
	                   Position SP ON PM.PositionParentId = SP.PositionParentId INNER JOIN
	                   Vacancy.dbo.Document D ON Track.DocumentNo = D.DocumentNo INNER JOIN
                       Position PN ON SP.PositionNo = PN.SourcePositionNo
			WHERE      D.EntityClass IS NOT NULL 
			AND        D.Status = '0' 
			AND        PN.PositionNo = '#PositionNo#'						
				
		</cfquery>	
								
		<cfloop query="doc">	
						
			<tr bgcolor="yellow" class="labelmedium" style="height:22px;border-top:1px solid silver">
			
				<td align="center">
					<img src="#SESSION.root#/Images/join.gif" alt="Recruitment action" border="0" align="middle" style="cursor: pointer;" onClick="showdocument('#DocumentNo#')">
				</td>			
				
				<td colspan="15">
				    <table cellspacing="0" cellpadding="0">
					<tr class="labelmedium" style="height:22px">
					
						<td height="16">
						<cfif URL.PDF eq 0><a href="javascript:showdocument('#DocumentNo#')"></cfif>
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
							  AND   Status = '2s'
						</cfquery>	
						
						<cfset cpl = DateFormat(Candidate.StatusDate, CLIENT.DateFormatShow)>
																				
						<cfif Candidate.recordcount gte "1">
							<td>
							<cfloop query = "Candidate">
								&nbsp;
								<cfif URL.PDF eq 0>
									<a href="javascript:ShowCandidate('#Candidate.PersonNo#')">
								</cfif>
								#Candidate.FirstName# #Candidate.LastName# - #cpl#</a>
							</cfloop>
							</td>
						<cfelse>
							<td style="padding-left:10px"> - #tNoCandidateInfo# -</a></td>
						</cfif>
					</tr>						
					</table>
				</td>
				
			</tr>		
			
		</cfloop>								
	 	
	</cfif> 
	    
  <cfif funding neq "">
    
	<cfquery name="FundingSel" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   TOP 20 
		         F.DateEffective,
		         F.DateExpiration, 
				 R.Reference, 
				 R.RequisitionNo, 
				 R.RequestDescription, 
				 R.OfficerLastName, 
				 R.OfficerFirstName, 
				 R.RequestAmountBase,   
				 R.Created 		    
	    FROM     PositionParentFunding F, Purchase.dbo.RequisitionLine R
		WHERE    PositionParentId = '#PositionParentId#'	
		AND      F.RequisitionNo = R.RequisitionNo
		AND      R.ActionStatus NOT IN ('0','0z','9')			
		ORDER BY DateExpiration DESC, R.Created DESC
	</cfquery>
	
		 
	<cfif fundingsel.recordcount gte "1">
	
		<tr>
			<td valign="top" align="center"><img src="#SESSION.root#/Images/join.gif" border="0" align="absmiddle"></td>						
		    <td colspan="14">
		   
				<table align="center" width="100%">
					    
					  <tr>
					  		    	    
					    <td>
						
							  <table width="100%" border="0" cellspacing="0" cellpadding="0"> <!--- class="navigation_table" --->
									
								<tr class="labelmedium line" bgcolor="DFEFFF">
															
									<td width="80"><cf_tl id="Expiration"></td>
									<td width="70">Reference</td>
									<td width="45%">Description</td>
									<td width="20%">Requester</td></td>			
									<td width="10%" align="right">Amount</td></td>				
																				
								</tr>
																											
								<cfloop query="FundingSel">
																			
									<TR class="labelmedium" height="20">  <!--- class="labelit navigation_row" --->
									   <td style="padding-left:4px">#Dateformat(dateexpiration,CLIENT.DateFormatShow)#</td>	
									   <td><a href="javascript:ProcReqEdit('#RequisitionNo#','dialog')"><font color="0080C0"><u>#Reference#</u></font></a></td>								   
									   <td>#RequestDescription# </td>
									   <td>#OfficerFirstName# #OfficerLastName# (#Dateformat(created,CLIENT.DateFormatShow)#)</td>	
									   <td align="right">#Numberformat(requestAmountBase,",.__")#</td>				  							   							 				   							   
								    </TR>											
									
								</cfloop>
							
							</table>	
								
						</td>
						
					</tr>	
										
				</table>	
		
		</td></tr>
	
	</cfif>	 
	
  </cfif>	
  
  <!--- this was just a wiggle for ruy to show the red line under the 2nd row of the position assignments --->
	 
  <cfif ParentOrgUnit neq OrgUnitOperational and Class eq "Used" and (occurence eq "1" or prior eq PositionNo)>
  
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
				SELECT *
				FROM   Organization.dbo.Organization Org
				WHERE  Org.OrgUnit = #ParentOrgUnit#
			</cfquery>	
			
			<cfquery name="ParentP" 
			datasource="AppsOrganization" 
			maxrows=1 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT OrgUnitName
				FROM   Organization
				WHERE  Mission     = '#Parent.Mission#'
				AND    MandateNo   = '#Parent.MandateNo#'
				AND    OrgUnitCode IN (SELECT ParentOrgUnit  
				                       FROM   Organization 
									   WHERE  OrgUnit = '#Parent.OrgUnit#')
			</cfquery>
			
			<tr>
			   
				<td colspan="16" height="100%" style="height:21px;border-left:1px solid silver;border-right:1px solid silver">
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
					<tr bgcolor="FFBBBB" class="labelmedium" style="height:100%">
					<td style="min-width:140px;padding-left:10px"><cf_tl id="Borrowed from">:</TD>	
					<TD width="100%">
					<cfif URL.PDF eq 0>
						<A HREF ="javascript:EditPost('#PositionNo#')">
					</cfif>
					#Parent.Mission# - 
					<cfif ParentP.recordcount eq "1">#ParentP.OrgUnitName#/</cfif>#Parent.OrgUnitName#</b></A>
					<cfparam name="ParentFunctionDescription" default="">
					<b>#ParentFunctionDescription#</b>
					</td>
					</TR>	
				</table>
				</td>
			</tr> 
			
		</cfif>	
    
	</cfif>
							 
	 <cfif Class eq "Loaned" and ParentOrgUnit neq OrgUnitOperational and incumbency neq "0">	 
	 
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
		 
			 <tr style="height:30px" bgcolor="EAF4FF">
			 
				 <td colspan="16" style="height:100%">
				 
					 <table height="100%" width="100%">
					 
					    <cfquery name="Loaned" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   Organization.dbo.Organization Org
							WHERE  Org.OrgUnit = #OrgUnitOperational#
						</cfquery>	
					 
					   <cfquery name="ParentP" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT OrgUnitName
							FROM   Organization
							WHERE  Mission     = '#Loaned.Mission#'
							AND    MandateNo   = '#Loaned.MandateNo#'
							AND    OrgUnitCode IN (SELECT ParentOrgUnit FROM Organization WHERE OrgUnit = '#Loaned.OrgUnit#')
						</cfquery>
											 
						<tr class="labelmedium">
							<td height="30" style="min-width:140px;padding-left:10px">Loaned to:</TD>	
							<TD width="100%">
							<cfif URL.PDF eq 0><A HREF ="javascript:EditPost('#PositionNo#')"></cfif><b>
							#Loaned.Mission# - 
							<cfif ParentP.recordcount eq "1">#ParentP.OrgUnitName#/</cfif>#Loaned.OrgUnitName#</A></TD>
						</tr>	
						 
					 </table>
					 
				 </td>
				 
			 </tr>	
			 
			</cfif>  
	 	 		 
	 </cfif>	
	 
		 	 
	 </table>
	 	 
</cfoutput>   

<cfset ajaxonload("doHighlight")>


