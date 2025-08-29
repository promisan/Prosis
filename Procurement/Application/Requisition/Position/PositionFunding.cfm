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
<cfparam name="url.action" default="">
<cfparam name="url.access" default="edit">
<cfparam name="url.PositionParentId" default="">

<cfif url.action eq "Insert" 
     and URL.PositionParentId neq "" 
	 and URL.PositionParentId neq "undefined">

    <!--- allow to select only one position to be funded by this line --->
	
	<cfquery name="GetMandate" 
	 datasource="AppsEmployee"
  	 username="#SESSION.login#" 
 	 password="#SESSION.dbpw#">
		SELECT M.*
		FROM   PositionParent PP, Organization.dbo.Ref_Mandate M
		WHERE  PP.PositionParentId='#url.PositionParentId#'
		AND    PP.MandateNo  = M.MandateNo
		AND    PP.Mission    = M.Mission
	</cfquery>
	
	<cfquery name="CleanPrior" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM PositionParentFunding
	  WHERE  RequisitionNo = '#URL.ReqId#'	  
	</cfquery>
	
	<cfquery name="Member" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   PositionParentFunding
	  WHERE  PositionParentId  =  '#url.PositionParentId#'
	  AND    RequisitionNo = '#URL.ReqId#'	  
	</cfquery>
	
	<cfif Member.recordcount eq "0">
	
	   <!--- define effective date --->
	   
	   <cfquery name="Pos" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT DateEffective, DateExpiration,
		         (SELECT MAX(DateExpiration) 
				  FROM  PositionParentFunding 
				  WHERE PositionParentId = P.PositionParentId
				  ) as Expiration
		  FROM   PositionParent P
		  WHERE  P.PositionParentId  =  '#url.PositionParentId#'	 
	   </cfquery>
	   
	   <cfif Pos.Expiration gt Pos.DateEffective>
		    <cfset dte = Pos.Expiration>
	   <cfelse>
		   	<cfset dte = Pos.DateEffective>
	   </cfif> 
	   
	   <cfif Pos.DateExpiration lt dte>
	        <cfset dte = Pos.DateExpiration>
	   </cfif>
	   
	   <cftry>
			<cfset dateValue = "">
			<CF_DateConvert Value="#url.DateExpiration#">
			<cfcatch>
				<cfset url.DateExpiration="">
			</cfcatch>
	   </cftry>	    		
	
	    <CF_DateConvert Value="#url.DateExpiration#">
		
		<cfset EXP = dateValue>
		
		<cfif isDate(Exp)>

			<cfquery name="Employee" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO PositionParentFunding
				    (PositionParentId,
					 RequisitionNo,
					 ProgramCode,
					 <!---
					 DateEffective,		
					 --->
					 DateExpiration,	 
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
				VALUES(	
					'#URL.PositionParentId#',
					'#URL.ReqId#',	
					'',	
					<!--- '#dateformat(dte+1,client.dateSQL)#',	--->
					<cfif GetMandate.DateExpiration gte dateValue and url.DateExpiration neq "">
	   				#datevalue#,
	                <cfelse>
	   				'#GetMandate.DateExpiration#',
				    </cfif>					
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#') 
			</cfquery>
		
		</cfif>
		
		<!--- ----------------------------------------------------- --->
		<!--- Determine and Update the personno in requisition line --->
		<!--- ----------------------------------------------------- --->
		
		<cfquery name="Inc" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 PA.*
			FROM     Position P INNER JOIN
	                 PersonAssignment PA ON P.PositionNo = PA.PositionNo 
			WHERE    P.PositionParentId = '#url.positionparentid#'			
			AND      PA.AssignmentStatus IN ('0', '1') 
			<!--- AND     PA.AssignmentClass  = 'Regular' --->
		    AND      PA.AssignmentType   = 'Actual'
			AND      PA.DateEffective <= GETDATE() 
			ORDER BY PA.DateExpiration DESC			
		</cfquery>	
		
		<cfif Inc.recordcount eq "1">
		
			<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   UPDATE  RequisitionLine
			   SET     PersonNo = '#Inc.PersonNo#'
			   WHERE   RequisitionNo = '#URL.ReqId#'	 
			</cfquery>
		
		</cfif>
	
	</cfif>
	
<cfelseif url.action eq "delete">	

	<cfquery name="Employee" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM PositionParentFunding
	  WHERE  PositionParentId = '#url.positionparentid#'
	  AND    RequisitionNo = '#URL.ReqId#'	 
	</cfquery>
	
	<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   UPDATE  RequisitionLine
	   SET     PersonNo = ''
	   WHERE   RequisitionNo = '#URL.ReqId#'	 
	</cfquery>
	
</cfif>

<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT   P.*, 
	            O.OrgUnitName, 
			    F.RequisitionNo, 
			    F.DateExpiration as FundedUntil,
			    F.FundingId
	   FROM     PositionParent P, 
	            PositionParentFunding F,
			    Organization.dbo.Organization O
	   WHERE    P.PositionParentid = F.PositionParentId
	   AND      F.RequisitionNo = '#URL.ReqId#'
	   AND      P.OrgUnitOperational = O.OrgUnit 	
	   ORDER BY F.DateExpiration DESC  
</cfquery>
	
<cfquery name="FundingCheck" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  max(PF.DateExpiration) as Last
		FROM    PositionParentFunding PF INNER JOIN
	            Purchase.dbo.RequisitionLine R ON PF.RequisitionNo = R.RequisitionNo INNER JOIN
	            Organization.dbo.Organization O ON R.OrgUnit = O.OrgUnit
		WHERE   PF.PositionParentId = '#Position.positionparentid#'		
		AND     PF.RequisitionNo <> '#URL.ReqId#'		
		AND     R.Created < (SELECT Created 
		                     FROM    Purchase.dbo.RequisitionLine 
							 WHERE   RequisitionNo = '#URL.ReqId#')
		AND     R.ActionStatus NOT IN ('0','9')	
</cfquery>
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">			
    <tr class="labelmedium linedotted">
	   <td width="2" height="20"></td>
       <td width="35%"><cf_tl id="Unit"></td>
	   <TD width="60"><cf_tl id="Grade"></TD>
	   <TD width="25%"><cf_tl id="Function"></TD>
	   <TD width="10%"><!--- Position valid ---></TD>	  
	   <TD width="10%" colspan="2"><cf_tl id="Funded through"></TD>	  
	   <td width="23"></td>	     
   </TR>

   <cfoutput>  
   <tr><td id="refresh_#url.reqid#" onclick="javascript:_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/procurement/application/requisition/Position/PositionFunding.cfm?PositionParentId=#PositionParentId#&ReqId=#url.reqid#','pos#url.reqid#')"></td></tr>
   </cfoutput>     
   
   <tr><td height="2"></td></tr>
   
   <cfif position.recordcount eq "0">
   
     <tr>
      <td colspan="8" height="16" class="labelmedium"><font color="FF0000">There are no positions to show in this view.</td>
    </tr>
	
	<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   UPDATE  RequisitionLine
	   SET     PersonNo = ''
	   WHERE   RequisitionNo = '#URL.ReqId#'	 
	</cfquery>
	
   </cfif>
      			   
   <cfoutput query="Position">
     
	   <cfif FundingCheck.Last neq "">
	     	   
		   <cfif FundingCheck.last gt FundedUntil>
		   
		   <tr><td colspan="8" align="center" class="labelmedium" bgcolor="red" style="height:35px"><font color="FFFFFF">You selected an expiration date that lies before the existing funding records.</font></td></tr>
		   
		   <cfelseif FundingCheck.last eq FundedUntil>
		   
		    <tr><td colspan="8" align="center" class="labelmedium" bgcolor="yellow" style="height:35px"><font color="black">Attention : You selected an expiration date equal to the last funding.</font></td></tr>
		  	   
		   </cfif>
	   
	   </cfif>
	   
	   <tr class="navigation_row">
	      
	   	  <td><!--- #currentrow#.&nbsp;---></td>
	      <td class="labelmedium">#left(OrgUnitName,50)#</td>
		  <td class="labelmedium">#PostGrade#</td>
		  <td class="labelmedium">#FunctionDescription#</td>
		  <td class="labelmedium"><!--- #dateformat(DateEffective,CLIENT.DateFormatShow)# - #dateformat(DateExpiration,CLIENT.DateFormatShow)#---></td>
		  <td class="labelmedium" colspan="2" align="center" bgcolor="yellow" style="padding-left:7px;padding-right:7px;border:1px solid b1b1b1"><font color="002350">#dateformat(FundedUntil,CLIENT.DateFormatShow)#</b></font></td>	  
		 
		  <td style="padding-left:4px">
		  
		     <table cellspacing="0" cellpadding="0">
			 
			 <tr>
			 			  
		     <td align="center">	 	  
				
				    <!--- pick the last position for that parent, usually just one per parent --->
					
					<cfquery name="PositionCurrent" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						  SELECT *
						  FROM   Position
						  WHERE  PositionParentId = '#Position.PositionParentId#'						  
						  ORDER BY DateEffective DESC				  
					</cfquery>
					
					<cfif PositionCurrent.recordcount gte "1">
					
						<cfinvoke component="Service.Access"  
					     method="position" 
					     orgunit="#position.orgunitoperational#" 
						 posttype="#position.PostType#"
					     returnvariable="accessPosition">	
						 
						 <!--- only of the user has position manage rights --->
				 				 			 
						<cfif AccessPosition eq "EDIT" or AccessPosition eq "ALL">
														
						     <img src="#SESSION.root#/Images/hr_positionadd.gif"
							     alt="Recruitment Request"
							     border="0"
								 height="13" width="12"
							     align="absmiddle"
							     style="cursor: pointer;"
							     onClick="AddVacancy('#PositionCurrent.PositionNo#','#url.reqid#','i#position.orgunitoperational#')">
															  
						</cfif>		
					
					</cfif>
					
				</td>
				
				 <td align="center" width="30">
					 <cfif url.access eq "Edit">
				     	  <A href="javascript:ColdFusion.navigate('#SESSION.root#/procurement/application/requisition/Position/PositionFunding.cfm?action=delete&PositionParentId=#PositionParentId#&ReqId=#RequisitionNo#','pos#RequisitionNo#')">
						   <img src="#SESSION.root#/images/delete5.gif" height="11" width="11" alt="delete" border="0" align="absmiddle">
						  </a>
					 </cfif>
		    	 </td>
			</tr>
			
			</table>
			
			</td>
		  
	   </tr> 		   
	   
	   <!--- show recruitment track info  --->
	   					
	    <cfquery name="Doc" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		<!--- current mandate --->
		SELECT   D.*			
		FROM     Document D INNER JOIN
				 DocumentPost DP ON D.DocumentNo = DP.DocumentNo INNER JOIN
				 Employee.dbo.Position P ON DP.PositionNo = P.PositionNo
		WHERE    D.Status = '0'
			AND  P.PositionNo = '#PositionCurrent.PositionNo#'
			AND  D.EntityClass is not NULL					
		UNION
		<!--- next mandate --->
		SELECT   D.*
		FROM     Document D INNER JOIN
                 DocumentPost DP ON D.DocumentNo = DP.DocumentNo INNER JOIN
                 Employee.dbo.Position P ON DP.PositionNo = P.SourcePositionNo
		WHERE    D.Status = '0'		 
			AND  P.PositionNo = '#PositionCurrent.PositionNo#'			
			AND  D.EntityClass is not NULL									
		</cfquery>	
								
		<cfloop query="doc">	
								
		<tr class="navigation_row_child">
			<td height="30" align="center"><img src="#SESSION.root#/Images/pointer.gif" alt="Recruitment action" width="9" height="9" border="0" align="middle" style="cursor: pointer;" onClick="javascript:showdocument('#DocumentNo#')"></td>
			<td colspan="7">
			    <table cellspacing="0" cellpadding="0">
				<tr>
				<td class="labelit" style="padding-right:5px">
								
				<cf_tl id="Recruitment" var="1">
				<cfset tRecruitment=lt_text>
								
				<cf_tl id="No candidate information available" var="1" class="message">
				<cfset tNoCandidateInfo=lt_text>
				
				<a href="javascript:showdocument('#DocumentNo#')">
				<font color="0080C0">
				#tRecruitment#: #DocumentNo# (#officerUserFirstName# #OfficerUserLastName# : #dateformat(created,CLIENT.DateFormatShow)#)
				</font>
				</a></td>
									 
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
						<td bgcolor="D6FED9" class="labelit" style="padding-left:6px;padding-right:6px;border-radius:4px;border:1px solid silver">
						<cfloop query = "Candidate">													
							<a href="javascript:ShowCandidate('#Candidate.PersonNo#')">							
							#Candidate.FirstName# #Candidate.LastName# - #cpl#</a>
						</cfloop>
						</td>
					<cfelse>
						<td class="labelit" style="padding-left:4px"> <font color="FF0000">#tNoCandidateInfo#</td>
					</cfif>
					</tr>
					</table>
			 </td>
		 </tr>		
			
	   </cfloop>									 	       
	   
	   <cfquery name="Inc" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  TOP 1 PA.*, Pers.*
			FROM    Position P INNER JOIN
	                PersonAssignment PA ON P.PositionNo = PA.PositionNo INNER JOIN
	                Person Pers ON PA.PersonNo = Pers.PersonNo
			WHERE   (P.PositionParentId = '#positionparentid#') 
			AND     PA.AssignmentStatus IN ('0', '1') 
			AND     PA.AssignmentClass  = 'Regular'
		    AND     PA.AssignmentType   = 'Actual'
			ORDER BY PA.DateExpiration DESC
			<!---
			AND     PA.DateEffective <= GETDATE() 
			AND     PA.DateExpiration > GETDATE()
			--->
		</cfquery>
		
		<cfloop query="inc">
		
		<tr><td></td></tr>
		<tr class="navigation_row">
			<td height="18"></td>
			<td class="labelit" style="padding-left:10px"><a href="javascript:EditPerson('#PersonNo#')"><font color="0080FF">#FirstName# #LastName#</font></a></td>
			<td class="labelit">#Gender#</td>
			<td class="labelit">#IndexNo#</td>
			<td class="labelit">#dateformat(DateEffective,CLIENT.DateFormatShow)#</td>
			<td class="labelit">#dateformat(DateExpiration,CLIENT.DateFormatShow)#</td>
			<td bgcolor="ffffef"></td>
		</tr>
		</cfloop>
		
		<cfquery name="Funding" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    PF.DateExpiration, 
			          R.*, 
					  O.OrgUnitName,
					  S.StatusDescription
			FROM      PositionParentFunding PF INNER JOIN
	                  Purchase.dbo.RequisitionLine R ON PF.RequisitionNo = R.RequisitionNo INNER JOIN
	                  Organization.dbo.Organization O ON R.OrgUnit = O.OrgUnit INNER JOIN
					  Purchase.dbo.Status S ON S.Status = R.ActionStatus AND StatusClass = 'Requisition'
			WHERE     PF.PositionParentId = '#positionparentid#'		
			AND       PF.Requisitionno != '#URL.ReqId#'
			AND       R.ActionStatus NOT IN ('0','9')
			
			ORDER BY PF.DateExpiration DESC
		</cfquery>
		
		<cfif funding.recordcount gte "1">
		
			<tr><td></td><td colspan="7" height="18" class="labelmedium"><font color="808080">Other request(s) funding this Position:</td></tr>
			
			<cfloop query="funding">
			
			   	<cfset col = "transparent">			
								
				<tr class="navigation_row labelit" bgcolor="#col#">
					<td></td>
					<td style="padding-left:10px" bgcolor="#col#" height="18"><cfif requisitionno eq URL.ReqId>
					#Reference# (#RequisitionNo#)<cfelse>
					<a href="javascript:ProcReqEdit('#RequisitionNo#','dialog')"><font color="0080FF">#Reference# (#RequisitionNo#)</font></a>
					</cfif>
					</td>
					<td bgcolor="#col#">#dateformat(RequestDate,CLIENT.DateFormatShow)#</td>
					<td colspan="2" bgcolor="#col#">#RequestQuantity# #QuantityUoM# @ #numberformat(RequestCostPrice,"__,__.__")# = <b>#numberformat(RequestAmountBase,"__,__.__")#</b></td>								
					<td bgcolor="#col#">#dateformat(DateExpiration,CLIENT.DateFormatShow)#</td>
					<td bgcolor="#col#" colspan="2"></td>
				</tr>
				
				<tr class="labelit navigation_row_child linedotted"><td bgcolor="#col#"></td>
				    <td style="padding-left:10px"><b>#StatusDescription#</b></td>
					<td style="padding-left:10px" bgcolor="#col#" colspan="6">#RequestDescription#</td>	
				</tr>
							
			</cfloop>		
		
		</cfif>
		
	  </CFOUTPUT>  	
				
   	</table>
     
<cfset ajaxonload("doHighlight")>	     
   