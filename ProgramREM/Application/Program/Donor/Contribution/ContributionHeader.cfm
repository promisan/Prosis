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
<cfparam name="URL.action" default="View">

<!--- tuned  by Hanno 8/7/2012 --->

<cfquery name="get"
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT  C.*, 
	        R.Description as Classdescription, 
			M.Description as EarMarkDescription,
			R.Execution
	FROM    Contribution C, Ref_ContributionClass R, Ref_EarMark M
	WHERE   C.ContributionClass = R.Code
	AND     ContributionId = '#URL.ContributionId#'
	AND     C.EarMark = M.EarMark
</cfquery>

<cfif URL.Mission eq "">
	<cfset URL.Mission = Get.Mission>
</cfif>

<cfquery name="Parameter"
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#url.mission#'		
</cfquery>

<cfquery name="Object"
    datasource="AppsOrganization" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    OrganizationObject
	WHERE   ObjectKeyValue4 = '#URL.ContributionId#'
	AND     Operational = 1
</cfquery>

<cfif URL.action eq "new">
	<cfset vOrg = URL.ID1>
<cfelse>
	<cfset vOrg = get.OrgUnitDonor>
</cfif>	

<cfquery name="org"
    datasource="AppsOrganization" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Organization
	WHERE   OrgUnit = '#vOrg#'		
</cfquery>

<cfquery name="isUsed" 
	 datasource="AppsProgram" 
	 username="#SESSION.login#"
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   ProgramAllotmentDetailContribution
	 WHERE  ContributionLineId IN (SELECT ContributionLineId 
		                           FROM   ContributionLine 
								   WHERE  ContributionId = '#URL.ContributionId#')										  	   
</cfquery>	

<cfquery name="isParent" 
	 datasource="AppsProgram" 
	 username="#SESSION.login#"
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   ContributionLine C
	 WHERE  ContributionId = '#URL.ContributionId#'
	 AND    EXISTS (SELECT 'X' 
		            FROM   ContributionLine 
					WHERE  ParentContributionLineId = C.ContributionLineId)										  	   
</cfquery>	

<cfoutput>

<cfif get.ActionStatus eq "3">
   <cfset url.action = "View">
</cfif>

<cfform name="form_contribution" onsubmit="return false;">
	
	<table width="100%" class="formspacing formpadding" border="0" style="height:100%" cellspacing="0" cellpadding="0">
		
	<tr class="line">
		
		<td align="left" colspan="3">
		<cfif url.action eq "View" and get.ActionStatus neq "3">
			<table cellspacing="0" cellpadding="0" class="formpadding formspacing">
			<tr>
				<td>
					<input type="button" 
						  onclick="ColdFusion.navigate('ContributionHeader.cfm?mission=#URL.mission#&Id1=#vOrg#&contributionid=#url.contributionid#&action=edit','result')"
						  id="btnEdit" 
						  name="btnEdit" 
						  class="button10g"
						  style="width:130;height:25px" 
						  value="Edit">
				</td>
				
				<cfif isUsed.recordcount eq "0" and isParent.recordcount eq "0">
				<td style="padding-left:3px">
					<input type="button" class="button10g" onclick="javascript:delete_contribution('#url.contributionid#')" id="btnDelete" name="btnDelete" style="width:120" value="Delete">
				</td>				
				</cfif>
			</tr>
			</table>
		<cfelse>
			<input type="button" 
			     onclick="dosave('#URL.mission#','#vOrg#','#url.contributionid#','#url.action#')" 
				 class="button10g" 
				 id="btnEdit" 
				 name="btnEdit" 
				 style="width:120" 
				 value="Save">
		</cfif>
		</td>
				
		<cfif get.recordcount gte "1">
		<td align="right" style="padding-right:10px;">
			<cf_tl id="Print Pledge" var="1">
			<cfset vTemplate = "ProgramREM/Inquiry/Printout/Contribution/Contribution.cfr">
			<img height="20" src="#session.root#/images/print.png" style="cursor:pointer;" title="#lt_text#" onclick="printPledge('#url.contributionid#','#vTemplate#');">
		</td>
		</cfif>
	</tr>	
				
	<tr>
		<td width="15%" class="labelmedium" style="padding-left:5px"><cf_tl id="Donor">:</td>
		<td width="35%" class="labelmedium">
		
		<table cellspacing="0" cellpadding="0">
			<tr>
				<td id="orgUnitDisplay" class="labelmedium">
					<cfif url.action eq "view">
						<cf_verifyOperational module="Staffing" mission="#org.mission#">
						<cfif operational eq "1" and org.orgunitclass neq parameter.DonorPersonalOrgUnitClass>
							<cf_tl id="Staffing View" var="1">
							<a href="javascript:maintainStaffing('#org.orgunitcode#','#url.mission#','#org.mandateno#')" title="#lt_text#" style="color:##0080C0">
								#Org.OrgUnitName#
							</a>
						<cfelse>
							#Org.OrgUnitName#
						</cfif>
					<cfelse>
						<input type="Text"   name="orgunitname"   id="orgunitname" 	value="#org.OrgUnitName#" class="regularxl" size="34" maxlength="80" readonly>		
						<input type="hidden" name="orgunit"       id="orgunit" 		value="#org.OrgUnit#">
						<input type="hidden" name="mission"       id="mission" 		value="#url.Mission#">
						<input type="hidden" name="orgunitcode"   id="orgunitcode" 	value="#org.OrgUnitCode#">
						<input type="hidden" name="orgunitclass"  id="orgunitclass" value="#org.OrgUnitClass#">
					</cfif>
				</td>
				<td style="padding-left:3px;">
				
					<cfif url.action neq "view">
					
						<cf_tl id="Change Organization" var="1">
						
						<img 
							src="#SESSION.root#/Images/search.png" 
							onMouseOver="this.src='#SESSION.root#/Images/contract.gif'" 
						  	onMouseOut="this.src='#SESSION.root#/Images/search.png'"
							height="25"
							width="26"
							style="cursor:pointer;border-radius:3px" 
							title="#lt_text#" 
							onclick="selectorgN('#parameter.TreeDonor#','','orgunit','applyorgunit','','1','modal')">
							
							
					</cfif>
				</td>
				<td id="process"></td>
			</tr>
		</table>
			
		
		</td>
		<td width="15%" class="labelmedium" style="padding-left:5px"><cf_tl id="Reference">:<cf_space spaces="32"></td>
		<td width="35%" class="labelmedium">
		<cfif url.action eq "view">	
		
			#get.reference#
		
		<cfelse>
		
			<input type="text"
			       name="reference"
			       id="reference"
			       value="#get.reference#"
			       maxlength="20"
			       class="regularxl enterastab">
	
		</cfif>	
		
		</td>
	</tr>
	
	<cfif org.orgunitclass eq parameter.DonorPersonalOrgUnitClass>
	
	<tr>
	<td class="labelmedium" style="padding-left:5px"><cf_space spaces="32"><cf_tl id="Person">:</td>
	<td width="85%" colspan="3" class="labelmedium">
		  
		<cfoutput>
			
		    <cfquery name="Person" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Person
					WHERE PersonNo = '#get.PersonNo#'	
			</cfquery>
			
			 <table cellspacing="0" cellpadding="0">
			 <tr>
										
			 <cfif url.action eq "View">
				 
				 <td colspan="3" class="labelmedium">
					 <cfoutput>
					 <a href="javascript:EditPerson('#Person.PersonNo#')"><font color="0080C0">
					 #Person.FirstName# #Person.LastName# (#Person.IndexNo#)</a>
					 </cfoutput>
				 </td>
			 
			 <cfelse>
			 				
				<td class="labelmedium">
				
					<input type="Text"
					       name="personname"
		                   id="personname"
					       value="#Person.FirstName# #Person.LastName#"			     
					       required="Yes"
					       visible="Yes"
					       enabled="Yes"		     
					       size="38"
					       maxlength="60"
					       class="regularxl enterastab"
					       readonly  
						   style="text-align: left;">
				   
				</td>
				
				<td style="padding-left:5px">   
			   
				<input type="text"    name="indexno"   id="indexno"   class="regularxl" readonly value="#Person.IndexNo#" size="12" maxlength="20" style="text-align: center;">
				<input type="hidden"  name="personno"  id="personno"  size="8" readonly value="#Person.PersonNo#">
			  				
				</td>	
				
				<td id="member"></td>							
				
				 <td style="padding-left:3px">				 
				 
				 <cfset link = "#SESSION.root#/ProgramREM/Application/Program/Donor/Contribution/setEmployee.cfm?insert=yes">	
							
				 <cf_selectlookup
				    class      = "Employee"
				    box        = "member"
					button     = "yes"
					icon       = "search.png"
					iconwidth  = "25"
					iconheight = "25"
					title      = "#lt_text#"
					link       = "#link#"						
					close      = "Yes"
					des1       = "PersonNo">
				
				  <!---						
				  <img src="#SESSION.root#/Images/search.png" alt="Select Employee" name="img9" 
					  onMouseOver="document.img9.src='#SESSION.root#/Images/contract.gif'" 
					  onMouseOut="document.img9.src='#SESSION.root#/Images/search.png'"
					  style="cursor: pointer;border-radius:3px" alt="" width="26" height="25" border="0" align="absmiddle" 
					  onClick="selectperson('webdialog','personno','indexno','lastname','firstname','personname','','')">			
					  
					  --->
				
				</td>
				
			</cfif>	
			
			</tr>
			</table>
				
		</cfoutput>	
							
	 </td>  

	</tr>
	
	<cfelse>
	
		<input type="hidden"  name="personno"  id="personno"  size="8" readonly value="">
	
	</cfif>
			
	<tr>
		<td class="labelmedium" style="padding-left:5px"><cf_tl id="Additional information">:<cf_space spaces="70"></td>
		<td colspan="3" class="labelmedium"><cfif url.action eq "view">
		    
			 	<cfif get.Contact eq "">
				---
				<cfelse>
				#get.Contact#
				</cfif>
			<cfelse>
			<input type="text" name="contact" id="contact" class="regularxl enterastab" value="#get.contact#" size="80" maxlength="80">
			</cfif>
			</td>	
					
			
	</tr>	
	
	<tr>
			<td class="labelmedium" style="padding-left:5px"><cf_tl id="Pledge Amount">:</td>
			<td class="labelmedium">
			
				<cfif url.action eq "view">
					#get.currency#				
				<cfelse>
						<cfquery name="qCurrency" 
						   datasource="AppsLedger" 
						   username="#SESSION.login#"
						   password="#SESSION.dbpw#">
							SELECT *
							FROM   Currency
							WHERE  Currency IN (
										SELECT Currency
										FROM   CurrencyMission
										WHERE  Mission = '#URL.Mission#'
									    )
						</cfquery>
						
						<cfif qCurrency.recordcount eq "0">
						
						<cfquery name="qCurrency" 
						   datasource="AppsLedger" 
						   username="#SESSION.login#"
						   password="#SESSION.dbpw#">
							SELECT *
							FROM   Currency					
						</cfquery>
						
						</cfif>
						
						<cfif get.Currency eq "">
							<cfset cur = parameter.budgetCurrency>
						<cfelse>
							<cfset cur = get.Currency>
						</cfif>
						
						<select id="currency" name="currency" class="regularxl enterastab">
						<cfloop query="qCurrency">
							<option value="#Currency#" <cfif currency eq cur>selected</cfif>>#Currency#</option>
						</cfloop>
						</select>
						
				</cfif>
								
				<cfif url.action eq "view">
				
				    <cfif get.Amount eq "">
					---
					<cfelse>
					#Numberformat(get.Amount,"__,___.__")#
					</cfif>
					
				<cfelse>
				
					<input type="text" name="Amount" id="Amount" value="<cfif get.Amount eq "">0<cfelse>#get.Amount#</cfif>" style="height:24px;text-align:right;padding-right:4px" class="regularxl enterastab" size="7" maxlength="10">
					
				</cfif>	
								
			</td>
			
			<td height="18" class="labelmedium" style="padding-left:5px"><cf_tl id="Received">:</td>
		<td class="labelmedium">
		<cfif url.action eq "view">
	
			#dateformat(get.DateSubmitted,CLIENT.DateFormatShow)#
	
		<cfelse>
		
			<cfif get.recordcount eq "1">
			
				<cfset ajaxonload("doCalendar")>
			
			<cfelse>
			
				<cf_calendarscript>
			
			</cfif>
		
			
				
			<cf_intelliCalendarDate9
		       FieldName="dateSubmitted"
		       Default="#Dateformat(get.DateSubmitted, CLIENT.DateFormatShow)#"
			   class="regularxl enterastab"
		       AllowBlank="Yes"> 
			   
		</cfif>	   
	           		
		</td>
	</tr>
					
	<tr>
	
		<td height="18" class="labelmedium" style="padding-left:5px"><cf_tl id="Descriptive">:</td>
		<td class="labelmedium">
		<cfif url.action eq "view">	
		
			<cfif get.Description eq "">
			---
			<cfelse>
			#get.Description#
			</cfif>	
		
		<cfelse>
		<input type="text" maxlength="50" style="width:95%" class="regularxl enterastab" name="description" id="description" value="#get.description#"/>
		</cfif>
		</td>
		<td class="labelmedium" style="padding-left:5px"><cf_tl id="Earmark">:</td>
		<td class="labelmedium">
		
		<cfquery name="getEarmark"
		    datasource="AppsProgram" 
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_Earmark
		</cfquery>

		<cfif url.action eq "view">
			#get.EarMarkDescription#
		<cfelse>
			<select id="earmark" name="earmark" class="regularxl enterastab" onchange="setearmark(this.value)">
				<cfloop query="getEarmark">
					<option value="#EarMark#" <cfif get.EarMark eq Earmark>selected</cfif>>#getEarmark.Description#</option>
				</cfloop>
			</select>
		</cfif>
		
		<cf_space spaces="60">
		
		</td>
	</tr>
	
	<cfif get.Earmark eq "0">
		<cfset cl = "hide">	
	<cfelse>
		<cfset cl = "regular">
	</cfif>
	
    <cfif url.ContributionId neq "" and url.action neq "new">
	
		<tr class="#cl#" id="earmarkbox">
			<td height="18" valign="top" class="labelmedium" style="padding-top:5px;padding-left:5px"><cf_tl id="Earmarked for">:</td>
			<td colspan="3" class="labelmedium" id="r_#url.contributionid#">
			
			<cfif url.action eq "view">
			
				<cfquery name="qProgram" 
					datasource="AppsProgram"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
						SELECT P.*
						FROM   Program P INNER JOIN ContributionProgram PP ON P.ProgramCode = PP.ProgramCode				
						WHERE  P.Mission   = '#get.Mission#'	
						AND    PP.ContributionId = '#URL.ContributionId#'				
				</cfquery>
				
				<cfif qProgram.recordcount eq "0">
					<font color="808080"><cf_tl id="No earmarked programs"></font>
				<cfelse>
				<table>
				<cfloop query="qProgram">
					<tr class="labelmedium"><td>#ProgramName#</td></tr>		
				</cfloop>
				</table>
				</cfif>
					
			<cfelse>
					
			<cfinclude template="ContributionProgram.cfm">
			
			</cfif>
			
			</td>	
		</tr>
	
	</cfif>
		
	<tr>
		<td class="labelmedium" style="padding-left:5px">
		
		<font color="0080C0"><u>
		 
		 <cfif get.Execution eq "0">
		 
		 	<cf_tl id="Income contribution">
		 
		 <cfelseif get.Execution eq "1">
		 
		 	<cf_tl id="Execution grant">
		 
		 <cfelse>
		 
		 	<cf_tl id="Standard Contribution">
		 
		 </cfif>
				
		:</td>
		<td class="labelmedium">
		
		
		<cfif url.action eq "view">
							
		 #get.ClassDescription#
		 	 
		
		<cfelse>
				
			<cfquery name="qClass" datasource="AppsProgram"  
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_ContributionClass
				WHERE    Mission = '#url.mission#'
			</cfquery>
			
			<select id="ContributionClass" name="ContributionClass" class="regularxl enterastab">
			<cfloop query="qClass">
				<option value="#code#" <cfif code eq get.ContributionClass>selected</cfif>>#qClass.Description#</option>
			</cfloop>
			</select>
			
		</cfif>
		
		</td>
		
	</tr>
	
	<cfif url.action eq "new">
		
		<tr>
	
			<td class="labelmedium" style="padding-left:5px;height:18px"><cf_tl id="Classification">:</td>
			<td class="labelmedium">
				<cfquery name="qEntityClass" datasource="AppsOrganization">
					SELECT * 
					FROM Ref_EntityClass
					WHERE EntityCode = 'EntDonor'
				</cfquery>
					
				<select id="EntityClass" name="EntityClass" class="regularxl enterastab">
					<cfloop query="qEntityClass">
						<option value="#EntityClass#" <cfif Object.EntityClass eq EntityClass>selected</cfif>>#EntityClassName#</option>
					</cfloop>
				</select>
			</td>
				
		</tr>
	
	</cfif>		
	
		
	<cfinclude template="ContributionCustomFields.cfm">	

	<cfif url.action eq "view">
	
		<cfif get.ContributionMemo neq "">		
		<tr>
			<td class="labelmedium" valign="top" style="height:18px;padding-top:3px;padding-left:5px;"><cf_tl id="Memo">:</td>
			<td colspan="3" style="height:18px" class="labelmedium">#get.ContributionMemo#</td>
		</tr>
		</cfif>
		
	<cfelse>
	
	    <cfif url.action eq "New">
		
		<tr>
		<td class="labelmedium" valign="top" style="padding-top:3px;;height:18px;padding-left:5px;"><cf_tl id="Memo">:</td>
		<td colspan="3" style="height:100%">
			<textarea name="ContributionMemo"
			          style="width:100%;height:70;padding:3px;border:1px solid silver; background: fafafa;">#get.ContributionMemo#</textarea>
		</td>
		</tr>
		
		<cfelse>
					
		<tr><td class="labelmedium" valign="top" style="padding-top:3px;height:18px;padding-left:5px;height:100%">Memo:</td><td colspan="3" class="labelmedium">
			<textarea style="width:100%;height:37;padding:3px;font-size:13px" class="regular" name="ContributionMemo">#get.ContributionMemo#</textarea>
		</td></tr>
		
		</cfif>
	
	</cfif>	
		
	<tr><td class="labelmedium" valign="top" style="height:18px;padding-top:3px;padding-left:5px"><cf_tl id="Attachment">:</td>
	
	<td colspan="3">
			
		<cfif url.action eq "Edit" or url.action eq "New">
			
				<cf_filelibraryN
					DocumentPath="Donor"
					SubDirectory="#URL.ContributionId#" 
					Filter=""
					Presentation="all"
					Insert="yes"
					Remove="yes"
					width="100%"	
					Loadscript="no"				
					border="1">	
					
		<cfelse>
		
				<cf_filelibraryN
					DocumentPath="Donor"
					SubDirectory="#URL.ContributionId#" 
					Filter=""			
					Insert="no"
					Remove="no"			
					Loadscript="no"
					width="100%"			
					border="1">	
		
		</cfif>		
	
	</td>
	
	</tr>	
	
	</table>

</cfform>

</cfoutput>


