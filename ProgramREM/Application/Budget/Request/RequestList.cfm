

<!--- ------------------------------------------------------------- --->
<!--- important template to determine if access to edit is possible --->
<!--- --------- allotment entry detail screen --------------------- --->


<cfparam name="url.cell"          default="">
<cfparam name="url.scope"         default="regular">
<cfparam name="url.programcode"   default="">
<cfparam name="url.period"        default="">
<cfparam name="url.editionid"     default="">
<cfparam name="url.objectcode"    default="">
<cfparam name="url.activityid"    default="">
<cfparam name="url.requirementid" default="">
<cfparam name="url.itemmaster"    default="all">
	
<cfquery name="get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      ProgramAllotmentRequest
	<cfif url.requirementid neq "">
	WHERE     RequirementId = '#url.requirementid#'	
	<cfelse>
	WHERE     1=0
	</cfif>
</cfquery>	

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Program P
	WHERE     P.ProgramCode = '#url.programcode#' 	 	
</cfquery>

<cfquery name="Param" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ParameterMission
	WHERE     Mission = '#Program.Mission#' 	 	
</cfquery>

<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_AllotmentEdition E INNER JOIN Ref_Period P ON E.Period = P.Period
	WHERE     Editionid     = '#url.editionid#' 	
</cfquery>

<cfquery name="Object" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_Object
	WHERE     Code     = '#url.ObjectCode#' 
</cfquery>

<cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_Period
	WHERE 	Period = '#url.Period#'
</cfquery> 

<cfif Edition.status eq "1">

	<!--- edition is open --->

	<cfinvoke component="Service.Access"  
		Method         = "budget"
		ProgramCode    = "#URL.ProgramCode#"
		Period         = "#URL.Period#"	
		EditionId      = "#URL.editionId#"  
		Role           = "'BudgetManager','BudgetOfficer'"
		ReturnVariable = "BudgetAccess">	

<cfelse>

	<!--- edition is locked = 3 --->

	<cfinvoke component="Service.Access"  
		Method         = "budget"
		ProgramCode    = "#URL.ProgramCode#"
		Period         = "#URL.Period#"	
		EditionId      = "#URL.editionId#"  
		Role           = "'BudgetManager'"
		ReturnVariable = "BudgetAccess">	

</cfif>

<!--- --------------- --->
<!--- added 12/6/2014 --->
<!--- --------------- --->

<cfif BudgetAccess eq "EDIT" or BudgetAccess eq "ALL">

		<!--- now we check if the project itself is closed or not 
		so possibly we lock the requirement in the below cfc --->
		
		<cfinvoke component="Service.Process.Program.ProgramAllotment"  <!--- get access levels based on top Program--->
			Method         = "RequirementStatus"
			ProgramCode    = "#URL.ProgramCode#"
			Period         = "#URL.Period#"	
			EditionId      = "#URL.editionID#" 
			ReturnVariable = "RequirementLock">			
			
<cfelse>

	<!--- WE LOCK THE REQUIREMENT --->
	<cfset RequirementLock = "1">			
			
</cfif>		

<cfquery name="Details" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
		SELECT     D.*, 
		           D.Fund as FundCode,
				   R.Description AS ItemMasterDescription,
				   R.CodeDisplay as ItemMasterCode,
				   
				   (SELECT count(*)
				    FROM   ProgramAllotmentRequestMove
					WHERE  RequirementId = D.RequirementId
					) as Moved,
				  
				   <!--- ----------------------- IMPORANT QUERY ------------------------- --->
				   <!--- determine if the requested line was (partially) cleared for allotments for
				   any of its clustered transactions under the same FUND/Object --------- --->			  
				   <!--- ----------------------  important query ------------------------ --->
				  
				  (SELECT  count(*) 
				   FROM    ProgramAllotmentRequest PAR, 
				           ProgramAllotmentDetailRequest PADR, 
						   ProgramAllotmentDetail S
				   WHERE   D.RequirementIdParent   =  PAR.RequirementIdParent <!--- alert : adjusted to consider the full transaction includes ripples and travel complex --->				   
				   AND     D.Fund                  = PAR.Fund                 <!--- alert : 14/9 I adjusted this to limit within the same OE !!! ripples are now considered ---> 
				   AND     D.ObjectCode            = PAR.ObjectCode
				   AND     S.Period                = '#url.period#'  <!--- added 19/8/2016 to prevent carry over to be set --->
				   AND     PAR.RequirementId       =  PADR.RequirementId
				   AND     PADR.TransactionId      =  S.TransactionId				      
				   AND     PADR.Amount <> '0' <!--- indeed used in allotment --->
				   AND     S.Status IN ('1','9')) as Cleared,
				   
				   <!--- ---------------------- end important query --------------------- --->
				   				   		
				  (SELECT  TOP 1 S.OfficerLastName 
				   FROM    ProgramAllotmentDetailRequest R, ProgramAllotmentDetail S
				   WHERE   R.TransactionId =  S.TransactionId
				   AND     R.RequirementId =  D.RequirementId 
				   AND     R.Amount <> '0'
				   AND     S.Status = '1'
				   ORDER BY S.Created DESC) as Clearer,		
				   
				  (SELECT  TOP 1 S.Created 
				   FROM    ProgramAllotmentDetailRequest R, ProgramAllotmentDetail S
				   WHERE   R.TransactionId =  S.TransactionId
				   AND     R.RequirementId =  D.RequirementId 
				   AND     R.Amount <> '0'
				   AND     S.Status = '1'
				   ORDER BY S.Created DESC) as ClearerDate,	
				   
				  (SELECT Operational
				   FROM   Ref_AllotmentEditionPosition
				   WHERE  Editionid = D.EditionId
				   AND    PositionNo = D.PositionNo) as PositionOperational,				   
			 
				   
				  CASE WHEN 

				  (SELECT SourcePostNumber
				   FROM   Ref_AllotmentEditionPosition
				   WHERE  Editionid = D.EditionId
				   AND    PositionNo = D.PositionNo) IS NOT NULL THEN (SELECT SourcePostNumber
																	   FROM   Employee.dbo.Position
																	   WHERE  Editionid = D.EditionId
																	   AND    PositionNo = D.PositionNo) ELSE CONVERT(varchar(20),PositionNo) END as SourcePostNumber,				
																	   
											   
				   
				   ( SELECT TOP 1 PersonNo 
			    	 FROM   Employee.dbo.PersonAssignment
				     WHERE  PositionNo = D.PositionNo
				     AND    AssignmentStatus IN ('0','1')
				     AND    Incumbency      > 0
				     AND    AssignmentType  = 'Actual'
					 AND    DateEffective  <= '#edition.dateEffective#'
					 AND    DateExpiration >= getDate()
				  	 ORDER BY DateEffective DESC				    
				  ) as PersonNo 						   
					  
		FROM      ProgramAllotmentRequest D 
		          LEFT OUTER JOIN  Purchase.dbo.ItemMaster R ON D.ItemMaster = R.Code
				  LEFT OUTER JOIN  Purchase.dbo.ItemMasterList L ON D.ItemMaster = L.ItemMaster AND D.TopicValueCode = L.TopicValueCode
				  
		WHERE     ProgramCode   = '#url.programcode#' 
		AND       Period        = '#url.period#' 
		AND       editionid     = '#url.editionid#' 
		AND       D.objectcode  = '#url.objectcode#'
		-- AND       D.RequestAmountBase <> '0' 
		<!---
		<cfif url.itemmaster neq "all">		
			AND   D.ItemMaster = '#URL.ItemMaster#'
		</cfif>
		--->
		AND      ActionStatus != '9'
		
		ORDER BY D.RequestDue,		 
				 CAST(RequestRemarks AS char(10)),        <!--- added by muserref, not 100% sure --->       
		         RequirementIdParent,  <!--- this is a cluster in selected from one screen --->
				 D.RequestType DESC, 
		         R.Description,  
				 L.Listorder,				
				 D.RequestDescription
		
</cfquery>

<cfif Details.recordcount eq "0">

	<table align="center">
		<tr><td height="30" class="labelmedium"><font color="gray"><cf_tl id="There are no requirements to show in this view">.</font></td></tr>
	</table>
	
<cfelse>

	<cfif url.itemmaster eq "all">
 	
	<table width="100%" class="navigation_table"> 
		
	<cfelse>
	
	<table width="98%" align="center" class="navigation_table"> 
		
	</cfif>
	
	<tr class="labelmedium line" style="height:15px">
	    <td height="15"></td>
	    <td></td>		
		<td></td>
		<td width="40"><cf_tl id="Loc"></td>		
		<td><cf_tl id="Item"></td>
		<td><cf_tl id="Requirement"></td> 		
		<td><cf_tl id="Person"></td>
		<td><cf_tl id="Allotment"></td>  		
		<td style="padding-left:2px" width="60"><cf_tl id="Fund"></td>		
		<td style="padding-left:5px" align="center" colspan="2"><cf_tl id="Quantity"></td>
		<td align="right"><cf_tl id="Price"></td>
		<td align="right"><cf_tl id="Total"><cfoutput>#Param.BudgetCurrency#</cfoutput><cf_space spaces="23"></td>	
		<td style="width:20"></td>	 
	</TR>	
			
	   <cfoutput query="details" group="RequestDue">
	   
	    <cfif RequestDue eq "">
	    <tr class="line"><td colspan="14" style="padding-top:3px;padding-left:3px" class="labelmedium"> <cf_tl id="Not dated"> </td></tr>
		<cfelse>
		<tr class="line"><td colspan="12" style="padding-top:3px;padding-left:3px" class="labelmedium">#dateformat(RequestDue,client.dateformatshow)#</td>
				
		<cfquery name="getDate" dbtype="query">
			SELECT 	sum(RequestAmountBase) as Total
			FROM 	details
			WHERE 	RequestDue = '#dateformat(requestdue,client.dateSQL)#'
		</cfquery> 

		<td class="labelit" align="right" style="padding-left:4px"><b>#numberformat(getDate.Total,",_")#</td>
		<td></td>		
		</tr>
		</cfif>
				
		<cfoutput group="RequestRemarks">
		
			<cfif requestremarks neq "">
			<tr bgcolor="FDFEDE" class="labelmedium line"><td colspan="14" style="padding-left:10px">#requestremarks#</td></tr>
			</cfif>
		  	   
		   <cfoutput group="ItemMasterDescription">
		   		   		   								   		  		 		   
			    <cfoutput group="RequirementIdParent">	
				
				   <cfset priormaster = "">	
																								
				   <cfset cnt = "0">	 
											   				
				   <cfoutput>	
				   
				   		<cfif RequirementIdParent neq "">
						    <cfset cnt = cnt+1>
						<cfelse>
							<cfset cnt = "1">
						</cfif>		
						
						<cfset linemode = "">
						   				   						
				        <cfif actionStatus eq "9">
							<tr bgcolor="FFD5D5" style="height:22px" class="navigation_row line labelmedium">
						<cfelseif requirementid eq url.requirementid or requirementidparent eq get.RequirementIdParent>
							<tr bgcolor="e6e6e6" style="height:22px" class="navigation_row line labelmedium">
							<cfset linemode = "edit">
						<cfelseif requesttype eq "Ripple">
							<tr bgcolor="f4f4f4" style="height:22px" class="navigation_row line labelmedium">					
						<cfelse>
							<tr style="height:22px" class="navigation_row line labelmedium">
						</cfif>
									
						<td width="40" height="20" 
						   valign="center" style="padding-top:5px;padding-left:6px;padding-right:2px" onClick="more('#requirementid#')">								   		
						   <cf_img icon="expand" toggle="yes">			 			 											   
						</td>										
						
						<td width="20" style="padding-left:2px;padding-right:2px">#currentrow#.</td>
						
						<td align="center" style="padding-left:5px;padding-right:2px;padding-top:1px">
						
							<table cellspacing="0" cellpadding="0">
							
							<tr>
							
								<td style="width:20" align="center">
								
									<cfif Object.RequirementMode eq "2">
									
										<!--- does not make sense to copy here --->
									
									<cfelse>
																							
										<cfif RequirementLock eq "0" and ActionStatus neq "9">		
										
											<cfif linemode eq "" and requesttype eq "standard">
											
											    <cfif cnt eq "1">
		
												<cf_img icon="copy" 
												tooltip="This will clone all associated requirements"
												onclick="alldetinsert('#url.editionid#_#url.objectcode#','#url.editionid#','#url.objectcode#','#requirementid#','add','#url.scope#')">
												
												</cfif>
												
											</cfif>			
														
										</cfif>
										
									</cfif>	
																
								</td>		
							
								<td style="width:20;padding-left:6px" align="center" valign="center">
								
								<!--- ----------------------------------------------------------- --->
								<!--- important, do not change unless you know what you are doing --->
								<!--- ---------------------------------------------------------- --->		
								
								<cfif Cleared eq "0" or (Object.RequirementMode lt "3" and getAdministrator("*") eq "1")> <!--- wildcard added 13/9/2013 for administrator --->
								
									<cfif RequirementLock eq "0" and ActionStatus neq "9">		
																	
									    <!--- line mode, just in order to show the edit on just one line of the listing, it is optional --->
										
										<cfif linemode eq "" and requesttype eq "standard">
										
										    <cfif cnt eq "1">
											
												<table><tr><td style="padding-top:3px">
																					
												<cf_img icon="edit" navigation="Yes"
												tooltip="This will edit the requirement"
												onclick="alldetinsert('#url.editionid#_#url.objectcode#','#url.editionid#','#url.objectcode#','#requirementid#','edit','#url.scope#')">
												
												</td></tr></table>
												
											<cfelse>
											
												<img src="#session.root#/images/joinbottom.gif" alt="" border="0">											
											 	
											</cfif>
											
										</cfif>			
													
									</cfif>
								
								</cfif>		
								
								</td>	
								
							</tr>	
																	
							</table>
						
						</td>		
						
						<td style="padding-left:4px;padding-right:3px">#RequestLocationCode#</td>			
						
						<td width="15%" style="min-width:260px;padding-left:1px;padding-right:3px">
						<cfif priormaster neq "#itemmastercode#">
						#ItemMasterCode# #ItemMasterDescription#
						<cfset priormaster = ItemMasterCode>
						<cfelse>
						
						</cfif>
						</td>
							
							<cfif requesttype eq "Standard">
								
								<cfif Cleared eq "0">	
									<cfif BudgetAccess eq "EDIT" or BudgetAccess eq "ALL">			
									<td  style="min-width:200px">
									</cfif>
								<cfelse>				
									<td style="min-width:200px">
								</cfif>
								
							<cfelse>
							
								<td width="30%" tyle="min-width:200px"><b><cf_tl id="Ripple">:</b></font>
							
							</cfif>
																		
							<cfif url.itemmaster eq "all">	
								#RequestDescription# (<font size="1">#details.ItemMaster#</font>)
							<cfelse>
							
							    <table>
								<tr class="labelmedium" style="height:10px">								
							    <cfif PositionNo neq "">	
								<td style="min-width:50px">
								<a href="javascript:EditPosition('#Program.mission#','','#PositionNo#')">							
								<cfif PositionOperational eq "0"><font color="FF0000"><span style="text-decoration: line-through;">#SourcePostNumber#</span></font><cfelse>#SourcePostNumber#</cfif>&nbsp;:&nbsp;
								</a>	
								</td>													
								</cfif>
								
								<td>#RequestDescription#</td>
								
								</tr>
								</table>
							</cfif>
												
						</td>	
						
						<td style="padding-left:4px;min-width:150px">
						
							<cfif PersonNo neq "">
		 
								 <cfquery name="getPerson" 
										datasource="AppsEmployee" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT * 
										FROM   Person 
										WHERE  PersonNo = '#PersonNo#'
								  </cfquery>	
								  	
				 				  <a href="javascript:EditPerson('#personno#')" class="navigation_action">#getPerson.FirstName# #getPerson.LastName#</a>
		 
						    </cfif>		
						
						</td> 
																
						<td width="10%" style="padding-right:3px">
							
							<cfif actionstatus eq "0">
							    <font color="FF8040"> <cf_tl id="Disabled"></font>
							<cfelseif clearer eq "">
							    <font color="FF8040"> <cf_tl id="Pending"> </font>
							<cfelse>
								<font color="green">#Clearer#:&nbsp;#dateformat(ClearerDate,"DD/MM/YY")#</font>
							</cfif>	
						
						</td>			
						
						<td width="70">#FundCode#</td>
						<td width="85" align="right">#numberformat(RequestQuantity,"_._")# </td>
						<td width="85" align="right"><cfif ResourceQuantity gte "2" and ResourceDays gte "2">(#ResourceQuantity#|#ResourceDays#)</cfif></td>
						<td width="85" align="right" style="padding-left:4px">#numberformat(RequestPrice,"_,_")#</td>
						<td width="85" align="right" style="padding-left:4px">#numberformat(RequestAmountBase,"_,_")#</td>
						<td width="40" align="center">
						
						<!--- condition for delete if detailed line is open and not cleared or denied --->
						
						<cfif requirementid eq url.requirementid or requirementidparent eq get.RequirementIdParent> 
						
							<!--- it is in edit mode, we hide it --->
						
						<cfelseif RequestType eq "standard">																		
						
							<cfif Cleared eq "0" <!---14/7 removed wildcard or getAdministrator("*") eq "1" --->>	
																	
								<cfif RequirementLock eq "0" and ActionStatus neq "9">
								
									 <table><tr><td style="padding-top:4px;padding-left:4px;padding-right:3px">
									 
									    <cfset mes = "Do you want to remove this requirement only? \n\nThis will not remove any associated ripples!">
									    <cfif url.scope eq "Dialog">																		
											<cf_img icon="delete"  onclick = "if (confirm('#mes#?')) { Prosis.busy('yes');ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDelete.cfm?scope=dialog&requirementid=#requirementid#&cell=#url.editionid#_#url.objectcode#&itemmaster=#url.itemmaster#&line=1','details') }">																		 
										<cfelse>																				
											<cf_img icon="delete"  onclick = "if (confirm('#mes#?')) { Prosis.busy('yes');ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDelete.cfm?scope=listing&requirementid=#requirementid#&cell=#url.editionid#_#url.objectcode#&itemmaster=#url.itemmaster#&line=1','box#url.editionid#_#url.objectcode#') }">																			 
										</cfif>	 
									 
									 </td>
									 
									 <cfif cnt eq "1">
									 									 
									 	<cfset mes = "Do you want to remove the complete requirement ?\n\nThis includes associated ripples.\n\nDo you want to proceed">	
										<cfif url.scope eq "Dialog">	
										    <td style="padding-left:2px;min-width:50px" onclick = "if (confirm('#mes#?')) { Prosis.busy('yes');ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDelete.cfm?scope=dialog&requirementid=#requirementid#&cell=#url.editionid#_#url.objectcode#&itemmaster=#url.itemmaster#&line=0','details') }"><a><font color="FF0000"><cf_tl id="clear all"></font></a></td>																												
										<cfelse>	
											<td style="padding-left:2px;min-width:50px" onclick = "if (confirm('#mes#?')) { Prosis.busy('yes');ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDelete.cfm?scope=dialog&requirementid=#requirementid#&cell=#url.editionid#_#url.objectcode#&itemmaster=#url.itemmaster#&line=0','box#url.editionid#_#url.objectcode#') }"><a><font color="FF0000"><cf_tl id="clear all"></font></a></td>																												
										</cfif>	 
									 									 
									 </cfif>
									 
									 </tr>
									 </table>
																	
								</cfif>	
							
							</cfif>
							
						<cfelseif RequestType eq "ripple">																		
						
							<cfif Cleared eq "0" <!---14/7 removed wildcard or getAdministrator("*") eq "1" --->>	
																	
								<cfif RequirementLock eq "0" and ActionStatus neq "9">
								
									<cfset line = "1">
									<cfset mes = "Do you want to remove this rippled line">
																				
									<cfif url.scope eq "Dialog">																		
										<cf_img icon="delete"  onclick = "if (confirm('#mes#?')) { Prosis.busy('yes');ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDelete.cfm?scope=dialog&requirementid=#requirementid#&cell=#url.editionid#_#url.objectcode#&itemmaster=#url.itemmaster#&line=#line#','details') }">																			 
									<cfelse>																				
										<cf_img icon="delete"  onclick = "if (confirm('#mes#?')) { Prosis.busy('yes');ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDelete.cfm?scope=listing&requirementid=#requirementid#&cell=#url.editionid#_#url.objectcode#&itemmaster=#url.itemmaster#&line=#line#','box#url.editionid#_#url.objectcode#') }">																			 
									</cfif>	 
										 	
								</cfif>	
							
							</cfif>	
						
						</cfif>
						
						</td>
						
						</tr>
									
						<cfif Moved gte "1">
						
							<cfquery name="Move" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								 SELECT   R.*, P.ProgramName
								 FROM     ProgramAllotmentRequestMove R, Program P
								 WHERE    P.ProgramCode    = R.ProgramCode
								 AND      R.RequirementId  = '#requirementid#'
								 AND      R.ProgramCode != '#url.programcode#'
								 ORDER BY R.Created DESC
						 </cfquery>
						 
							 <cfif move.recordcount gte "1">						 					 	 
							
								<cfloop query="Move" endrow="#move.recordcount-1#">
									<tr class="navigation_row_child labelmedium">
										<td></td>			
										<td colspan="3"></td>
										<td colspan="2"><font color="808080"><cf_tl id="Moved from">:</font>&nbsp;#ProgramName#</td>
										<td colspan="2">#OfficerFirstName# #OfficerLastName# (#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#)</td>
										<td><cfif Fund eq ""><cf_tl id="same">same<cfelse>#Fund#</cfif></td>
										<td colspan="5"></td>
									</tr>	
								</cfloop>	
								
							</cfif>		
						
						</cfif>
													
						<tr id="detail#requirementid#" class="hide">
							   <td></td>
							   <td></td>
							   <td></td>
						   	   <td colspan="11" bgcolor="FDFEDE">
							   <table width="100%" cellspacing="0" cellpadding="0">
							   		<tr class="line">
									<td class="labelit" style="padding-left:40px;min-width:200">#dateformat(Created,"DD/MM/YY")#:&nbsp;#OfficerLastName#</td>								
								    
									<!--- not needed
									<cfif RequestRemarks neq ""> 							  
									  <td class="labelit">:</td>
									  <td class="labelit">#RequestRemarks#</td>								
									</cfif>
									--->
									</tr>
									<cfset url.mode = "view">
									<cfset id = requirementid>
									<cfinclude template="CustomFields.cfm">													
							   </table>
							   </td>				   				   
						</tr>
						
						<cfquery name="Contrib" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT    O.OrgUnitName, C.Reference, CL.Reference AS Tranche, CL.DateReceived, CL.DateEffective, CL.DateExpiration, CL.AmountBase
							FROM      ProgramAllotmentRequestContribution AS PARC INNER JOIN
				                      ContributionLine AS CL ON PARC.ContributionLineId = CL.ContributionLineId AND PARC.ContributionLineId = CL.ContributionLineId INNER JOIN
	            			          Contribution AS C ON CL.ContributionId = C.ContributionId INNER JOIN
				                      Organization.dbo.Organization AS O ON C.OrgUnitDonor = O.OrgUnit
							WHERE     PARC.RequirementId = '#Requirementid#'
						 </cfquery>
						 
						 <cfloop query="Contrib">
						 
						 <tr id="contrib#requirementid#" class="regular">
							   <td></td>
							   <td></td>
							   <td></td>
						   	   <td colspan="11">
							   <table width="100%" cellspacing="0" cellpadding="0" bgcolor="FBFCDA">
								    
									<tr class="labelit" style="padding-left:3px">
										<td>#OrgUnitName# #Reference# #Tranche#</td>
									</tr>
														
							   </table>
							   </td>				   				   
						</tr>
						 
						 </cfloop>	
						
				   <cfif RequestType eq "standard">	
				   
				       <!--- show ripled lines for this standard line --->
						
					   <cfquery name="Rippled" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
					   
						      SELECT   A.RequirementId,
							  		   I.Code AS ItemMaster, 
							           I.Description AS ItemMasterDescription, 
									   R.Code, 
									   R.Description, 
									   A.RequestDescription,
									   A.RequestAmountBase as RippleAmount,
									  (SELECT count(*) 
									   FROM  ProgramAllotmentDetailRequest R, ProgramAllotmentDetail S
									   WHERE R.TransactionId =  S.TransactionId
									   AND   R.RequirementId =  A.RequirementId 
									   AND   Status IN ('1','9')) as Cleared							   
									   <!----- , SUM(A.RequestAmountBase) AS RippleAmount --->
							  FROM     ProgramAllotmentRequest A INNER JOIN
							           Purchase.dbo.ItemMaster I ON A.ItemMaster = I.Code INNER JOIN
							           Ref_Object R ON A.ObjectCode = R.Code
							  WHERE    A.RequirementIdParent = '#RequirementIdParent#' 
							  AND      A.RequestType     = 'Ripple'
							  AND      A.ObjectCode     != '#url.objectCode#'
							  AND      A.TopicValueCode  = '#TopicValueCode#'
							  AND	   A.ActionStatus   != '9'
							  AND      A.Period          = '#URL.Period#'
								<!---- GROUP BY R.Code, R.Description, I.Description, I.Code, A.RequestDescription --->
					   </cfquery>	
					   					 
					   <cfif rippled.recordcount gte "1">
					   
						    <tr>
								   <td></td>
								   <td></td>
								   <td></td>
								   						   
							   	   <td colspan="11" bgcolor="E6F2FF">
								   
									   <table width="100%" cellspacing="0" cellpadding="0">								   
									   					   
									   <cfloop query="rippled">
									   			   
										   	<tr class="labelmedium line">
											  <td style="padding-left:40px"><cf_tl id="ripple">:</td>
											  <td>#Rippled.RequestDescription#</td>
											  <td>#Rippled.Code# #Rippled.Description#</td>										 
											  <td>#Rippled.ItemMaster# #Rippled.ItemMasterDescription#</td>
											  <td align="right">#numberformat(Rippled.RippleAmount,",")#</td>
											  <td style="padding-left:4px;padding-top:4px;padding-right:4px">			
											  
											  <!--- rippled lines will only be removed for the ripple line itself --->								  									  											
												
												<cfif Rippled.Cleared eq "0" <!--- removed the wildcar or getAdministrator("*") eq "1" --->>	
												
													<cfif RequirementLock eq "0">
																
														<cfif url.scope eq "Dialog">														
															<cf_img icon="delete"  onclick = "_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDelete.cfm?scope=dialog&requirementid=#rippled.requirementid#&objectcode=#url.objectcode#&cell=#url.editionid#_#url.objectcode#&itemmaster=#rippled.itemmaster#&line=1','details')">																													 
														<cfelse>															
															<cf_img icon="delete"  onclick = "_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDelete.cfm?scope=listing&requirementid=#rippled.requirementid#&objectcode=#url.objectcode#&cell=#url.editionid#_#url.objectcode#&itemmaster=#rippled.itemmaster#&line=1','box#url.editionid#_#url.objectcode#')">																													 
														</cfif>	 
															 	
													</cfif>	
													
												<cfelse>
												
													&nbsp;<font color="green">A</font>	
												
												</cfif>
													
											  </td>
											  
											</tr>																		
									   
									   </cfloop>  
									   					   						
									   </table>
											   
								   </td>			
								   <td></td>	
								   <td></td>   				   
							</tr>
				   
					   </cfif>
					   
				   </cfif>	   				
						
				   </cfoutput>	
				  	  		   
			   </cfoutput>		
		   
		   </cfoutput>
	   
	    </cfoutput>
	   
	   </cfoutput>
	   
	</table>
	
</cfif>	
	   
<cfset ajaxonload("doHighlight")>   