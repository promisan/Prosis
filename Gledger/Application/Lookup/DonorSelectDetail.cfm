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

<!--- provision to select only mission --->

<cfquery name="getTransaction" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     TransactionHeader
	WHERE    Journal         = '#url.journal#'
	AND      JournalSerialNo = '#url.journalserialno#'		 	
</cfquery>

<cfquery name="getDonorLines"
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
	 
     SELECT   C.ContributionId,
	          C.Mission, 
			  C.OrgUnitDonor,
                        (SELECT  OrgUnitName
                         FROM    Organization.dbo.Organization
                         WHERE   OrgUnit = C.OrgUnitDonor) AS Donor, 
			  C.Reference as DonorReference,	
			  C.DateSubmitted,   
			  C.Description,
  			  CL.ContributionLineId, 
			  CL.Reference as ContributionReference,
			  CL.DateEffective, 
			  CL.DateExpiration, 					  
			  CL.Fund, 
			  CL.Reference,
              CL.AmountBase,			 		  
			  			   
			  (SELECT IsNull(SUM(AmountBaseDebit-AmountBaseCredit),0) as Consumed
	           FROM   Accounting.dbo.TransactionLine
			   WHERE  ContributionLineId = CL.ContributionLineId
			  <!--- AND    TransactionLineId <> '#getLine.TransactionLineid#' --->) as AmountUsed
			   			 			  
	 FROM     Contribution AS C INNER JOIN
                    ContributionLine AS CL ON C.ContributionId = CL.ContributionId
		
	 <!--- show contributions used for this project --->
	 		  
	 WHERE   CL.Fund       = '#url.Fund#' 	 
	 	 	 
	 AND     CL.ContributionLineId IN
                        (SELECT    ADC.ContributionLineId
                          FROM     ProgramAllotmentDetailContribution AS ADC INNER JOIN
                                   ProgramAllotmentDetail AS AD ON ADC.TransactionId = AD.TransactionId
                          WHERE    AD.ProgramCode = '#url.ProgramCode#') 
											
	 AND      (CL.DateExpiration IS NULL 
	          OR CL.DateExpiration >= '#dateformat(getTransaction.TransactionDate, client.dateSQL)#') 
	 
	  
	 <cfif url.crit neq "">
	 AND      (CL.Reference LIKE ('%#url.crit#%') OR C.Reference LIKE ('%#url.crit#%'))
	 </cfif>
	 
	 <!--- contribution line not already fully disbursed excluding the current line 
	 
	 AND      CL.AmountBase > (SELECT IsNull(SUM(AmountBaseDebit-AmountBaseCredit),0) as Consumed
	                           FROM   Accounting.dbo.TransactionLine
							   WHERE  ContributionLineId = CL.ContributionLineId
							   AND    TransactionLineId <> '#getLine.TransactionLineid#') 		
							   
	 --->						   

	 <!--- better to exclude here the current selected donor as well --->						   									   	 
	 
	 ORDER BY C.OrgUnitDonor, C.Reference, C.ContributionId, CL.DateEffective 
	 
   </cfquery>		
		
	<cf_divscroll style="height:100%;">	
	
	<table width="100%" class="navigation_table">			
								
				<tr>				
				<td width="96%" style="padding-top:5px" valign="top">
				
				<table width="92%" cellspacing="0" cellpadding="0" align="center">
				
				<tr class="linedotted labelmedium">
					<td><cf_tl id="Donor"></td>
					<td align="center"><cf_tl id="Effective"></td>
					<td align="center"><cf_tl id="Expiration"></td>
					<td align="right" width="60"><cf_tl id="Amount"></td>		
					<td align="right" width="60" style="padding-right:4px">Used</td>				
				</tr>
							
				<cfoutput>
				
				<tr class="navigation_row linedotted">					   
				   <td colspan="5" style="height:30" align="center" class="labelmedium2">
				   <a href="javascript:setvalue('undefined')">Click here to set as undefined</a></td>
				</tr> 
								
				</cfoutput>	  
								
				<cfoutput query="getDonorLines" group="OrgUnitDonor">
				
				    <cfif donor neq "">
					<tr class="linedotted">
					<td style="height:50px" class="labellarge" colspan="2"><font color="0080C0">#donor# #OrgUnitDonor#</font></td>							
					</tr>
					</cfif>

					<cfoutput group="DonorReference">
						
						<cfoutput group="ContributionId">
						
							<tr class="linedotted labelmedium">
							    <td style="padding-left:7px" class="labelmedium" colspan="5">
								#DonorReference# #Description# (#dateformat(DateSubmitted,client.dateformatshow)#)</td>							
							</tr>
				
							<cfoutput>
												
								<cfif url.selected eq contributionlineid>				
								<tr bgcolor="ffffaf" class="labelit navigation_row">
								<cfelse>
								<tr class="labelit navigation_row">
								</cfif>
								    <td align="right" style="padding-left:20px;padding-top:3px">
									<cf_img icon="select" navigation="Yes" onclick="setvalue('#contributionlineid#')">
									</td>
									<td align="center">#dateformat(DateEffective,CLIENT.DateFormatShow)#</td>
									<td align="center">#dateformat(DateExpiration,CLIENT.DateFormatShow)#</td>
									<td align="right">#numberformat(AmountBase,',')#</td>		
									<td align="right" style="padding-right:4px">#numberformat(AmountUsed,',')#</td>			
								</tr>			
						
							</cfoutput>
						
						</cfoutput>
						
					</cfoutput>
				
				</cfoutput>
								
				</table>				
				
				</td>
				</tr>
				<tr><td height="4"></td></tr>
				
				</table>
	
	<!---
  
     <table width="97%" border="0" style="padding-top:1px;padding-bottom:1px" cellspacing="0" cellpadding="0" align="center" rules="rows">
	
	 <TR>        	   
	   <td width="40" height="19"></td>
       <TD width="15%">Code</TD>	   
       <TD width="60%">Name</TD>
	   <td width="80">Type</td>	  
	   <td></td>
	 </TR>	
	 
	 <cfinvoke component="Service.Presentation.Presentation" 
	           method="highlight" 
			   returnvariable="stylescroll"/>
			   	 
	 <cfset prior = "">
	 		 	  	 		 
	 <cfoutput query="Program" group="HierarchyCode">	 	 
	 
	 <cfoutput group="ProgramHierarchy">
	 
	 	 <cfif orgunitname neq prior>
		
		 	 <tr><td height="1" colspan="6" style="padding-left:3px">
			 
			  <font face="Calibri" size="4"><b>
			  
			    <cfif orgunitname neq prior>
				
				 <cfif parent neq orgunitName>
					#parent#/#orgunitName#	 
				 <cfelse>
					 #orgunitname#
				 </cfif>
				 
				</cfif>
				
			 </font>	
			 
			 </td></tr>		
			 
			 <tr><td colspan="6" class="linedotted"></td></tr>
		 
		 </cfif>
	 	 
		 <cfset nm = replace(ProgramName,"'","","ALL")> 
		 
		 <TR #stylescroll# class="regular">		 
				 
		 <td height="18" align="center" style="padding-left:10px;padding-top:3px" onclick="selected('#nm#','#ProgramCode#')">		  
			  <cf_img icon="open">		 				      		 
		 </TD>
		 	 
		 <TD onclick="selected('#nm#','#ProgramCode#')">
		 
		 <cfif ReferenceBudget1 eq "" and Reference neq "">		 
		 	#Reference#
		 <cfelseif ReferenceBudget1 eq "" and Reference eq "">
		    #ProgramCode#
		 <cfelse>
		 	#ReferenceBudget1#-#ReferenceBudget2#-#ReferenceBudget3#-#ReferenceBudget4#-#ReferenceBudget5#-#ReferenceBudget6#
		 </cfif>
		 
		 </TD>
		
	  	 <TD onclick="selected('#nm#','#ProgramCode#')">#ProgramName#</TD>
		 
		 <td onclick="selected('#nm#','#ProgramCode#')">#ProgramClass#</td>
		 
		 <td align="right" style="padding-top:3px;padding-right:6px">
		 
		     <cf_img icon="edit" onClick="ViewProgram('#ProgramCode#','#Period#','#ProgramClass#')">
			
		 </td>		
		 </tr>	
		 
		 <!---
		 <cfif url.period eq "">
		 <cfoutput>
		 <tr>
			 <td></td>
			 <td></td>
			 <td></td>
			 <td>#Period#</td>
		 </tr>
		 </cfoutput>
		 </cfif>
		 --->
		 		 
		 <tr></tr>		 
						 
		 <cfset prior = orgunitname>
		 
	 </cfoutput>
	 
	 </cfoutput>
	 	
	 </table>
	 
	 --->
	 
	</cf_divscroll>
	
  <cfset ajaxonload("doHighlight")>
  