<cfset format = "_,_">

<table width="98%" align="center" class="navigation_table"> 

<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Program P, ProgramPeriod Pe
	WHERE     P.ProgramCode = Pe.ProgramCode
	AND       P.ProgramCode  = '#url.programcode#' 
	AND       Pe.Period      = '#url.period#' 	
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * 
	FROM   Ref_ParameterMission 
	WHERE  Mission = '#Program.Mission#'
</cfquery>		

<cfquery name="getDate" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * 
	FROM   Ref_Period 
	WHERE  Period = '#url.period#'
</cfquery>		

<cfparam name="url.editionid" default="">

<cfif url.editionid eq "">
	
	<cfquery name="Edition" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_AllotmentEdition
		WHERE     Mission = (SELECT Mission FROM Organization.dbo.Organization WHERE OrgUnit = '#Program.OrgUnit#')
		AND       (Period  = '#URL.Period#' or Period is NULL)
		
		AND       Status != '9'
			
		AND       EditionId IN (SELECT  EditionId 
		                        FROM    ProgramAllotmentRequest 
								WHERE   ProgramCode = '#url.programcode#' 
								AND     Period = '#url.period#'
								AND     ActionStatus != '9')							
								
	</cfquery>
	
	<cfset url.editionid = edition.editionid>

<cfelse>

	<cfquery name="Edition" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_AllotmentEdition
		WHERE     Editionid = '#url.editionid#'					
				
	</cfquery>

</cfif>

<cfif Edition.recordcount eq "0">
	<table align="center">
		<tr><td style="padding-top:10px" class="labelmedium"><cf_tl id="There are no records found for this period"></td></tr>
	</table>		
</cfif>

<cfloop query="Edition">
	
    <tr><td colspan="10" class="labelmedium">
	<cfoutput><cf_tl id="Financial Period">:&nbsp;#Description#</cfoutput>
	</td></tr>
	
	<cfif Edition.status eq "1">
	
		<!--- edition is open --->
	
		<cfinvoke component="Service.Access"  
			Method         = "budget"
			ProgramCode    = "#URL.ProgramCode#"
			Period         = "#URL.Period#"	
			EditionId      = "#editionId#"  
			Role           = "'BudgetManager','BudgetOfficer'"
			ReturnVariable = "BudgetAccess">	
	
	<cfelse>
	
		<!--- edition is locked = 3 --->
	
		<cfinvoke component="Service.Access"  
			Method         = "budget"
			ProgramCode    = "#URL.ProgramCode#"
			Period         = "#URL.Period#"	
			EditionId      = "#editionId#"  
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
				EditionId      = "#editionId#" 
				ReturnVariable = "RequirementLock">			
				
	<cfelse>
	
		<!--- WE LOCK THE REQUIREMENT --->
		<cfset RequirementLock = "1">			
				
	</cfif>				
		
	<!--- for rippled access only, can be tuned --->
	
	<cfinvoke component="Service.Access"  
			Method         = "budget"
			ProgramCode    = "#URL.ProgramCode#"
			Period         = "#URL.Period#"	
			EditionId      = "#editionId#"  
			Role           = "'BudgetManager'"
			ReturnVariable = "BudgetManagerAccess">	
	
	<!--- ----------------------- --->
	<!--- summary by year / month --->
	<!--- ----------------------- --->
				
	<tr>
	<td colspan="10" style="padding-left:2px;">
	
		<cf_RequirementSummary mode="Quarter" 
		     programcode="#url.programcode#" 
			 period="#url.period#" 
			 Support="No">
			 		
			 
	</td>
	</tr>	
			
<cfquery name="ProgramEdition"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    R.*
	FROM      ProgramAllotment A INNER JOIN Ref_AllotmentEdition R ON A.Editionid = R.EditionId
	WHERE     A.ProgramCode  = '#url.programcode#' 
	AND       A.Period      = '#url.period#' 	
</cfquery>
	
<tr><td height="15"></td></tr>
<tr class="labelmedium line">
		<td colspan="10" bgcolor="#EBEBEB">
		<table><tr>	
		<cfoutput query="ProgramEdition">
		<td style="width:300px;padding-left:5px;font-weight:bold;font-size:125%;" class="labellarge">
		    <cfif url.editionid neq editionid>
			  <a href="javascript:refreshview('#url.programcode#','#url.period#','#EditionId#','')">#description#</a>
	        <cfelse>#description#
			</cfif>
		</td>
		</cfoutput>		
		</tr>
		</table>			
</tr>		
	
<cfquery name="getDate" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * 
	FROM   Ref_Period 
	WHERE  Period = '#period#'
</cfquery>	
	
<cfquery name="getYear" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT  DISTINCT Year(RequestDue) as Year
	FROM    ProgramAllotmentRequest 
	WHERE   ProgramCode  = '#url.programcode#' 
	AND     Period       = '#url.period#'			  
	AND     EditionId    = '#editionid#'	
	ORDER BY Year(RequestDue) DESC	  
</cfquery>		
		
	<cfquery name="getratio" 
		datasource="AppsProgram">
		    SELECT *
			FROM   ProgramAllotment
			WHERE  ProgramCode = '#URL.ProgramCode#' 
			AND    Period      = '#URL.Period#'
			AND    EditionId   = '#URL.Edition#' 
	</cfquery>		
	
	<cfif getRatio.SupportPercentage eq "">
	
		<cfset ratio = 0>
	
	<cfelse>
	
		<cfset ratio = getratio.SupportPercentage/100>
	
	</cfif>
	
	<cfif getYear.Year eq "">
		
	<cfelse>
			
		<cfif getYear.Year lt year(getDate.DateExpiration)>
			<cfset yrto = getYear.Year>
		<cfelse>
			<cfset yrto = year(getDate.DateExpiration)>	
		</cfif>		
				
		<!--- last year first --->
					
		<cfloop index="yr" from="#yrto#" to="#year(getDate.DateEffective)#" step="-1">
			
			<cfsavecontent variable="data">
			
			  <cfoutput>		  
			  		
			  SELECT     PAR.RequirementId, 
	                     PAR.ProgramCode, 
						 PAR.Period, 
						 PAR.EditionId, 
						 PAR.ActivityId,
						 O.Resource, 
						 PAR.ObjectCode, 
						 PAR.Fund, 
						 PAR.ItemMaster, 
						 R.AuditId,
						 R.AuditDate AS RequestDue, 
	                     PARQ.RequestQuantity, 
						 
						 <!--- generate the adjusted quantity --->
						 
						 PARQ.RequestQuantity /
	                                           (SELECT  SUM(RequestQuantity) 
	                                            FROM    ProgramAllotmentRequestQuantity
	                                            WHERE   RequirementId = PAR.RequirementId) * PAR.RequestAmountBase AS RequestAmountBase, 
						
						 <!--- determine if the requirement has an issued budget allotment already recorded --->													  
						  (
						  	(  SELECT ISNULL(SUM(R.Amount),0)
					  		   FROM   ProgramAllotmentDetailRequest R, 
							          ProgramAllotmentDetail S
							   WHERE  R.TransactionId =  S.TransactionId
							   AND    R.RequirementId  = PAR.RequirementId 
							   AND    S.Period         = '#url.period#'  <!--- to prevent in case of carry over --->
							   AND    S.Status = '1') / 
							    (	SELECT count(*) 
								    FROM   ProgramAllotmentRequestQuantity 
									WHERE  RequirementId = PAR.RequirementId
									AND    RequestQuantity <> 0
								)
								)  as Allotment,						
											
						 PAR.RequirementIdParent,
						 RequestRemarks,
						 ActionStatus,
						 RequestType,
						 RequestDescription,
						 PAR.OfficerLastName,						
						 PAR.Created
						 
	           FROM      ProgramAllotmentRequestQuantity AS PARQ INNER JOIN
	                     Ref_Audit AS R ON PARQ.AuditId = R.AuditId INNER JOIN
	                     ProgramAllotmentRequest AS PAR ON PARQ.RequirementId = PAR.RequirementId INNER JOIN
	                     Ref_Object AS O ON PAR.ObjectCode = O.Code
						 
	           WHERE     PAR.ProgramCode  = '#url.programcode#' 
			   AND       PAR.Period       = '#url.period#'			  
			   AND       PAR.EditionId    = '#editionid#'		  
			   AND       PARQ.RequestQuantity <> 0
			   AND       PAR.ActionStatus IN ('0','1')
			   		   
	           UNION ALL		   
			   		   
	           SELECT    RequirementId, 
			             ProgramCode, 
						 Period, 
						 EditionId, 
						 PARQ.ActivityId,
						 O.Resource, 
						 ObjectCode, 
						 Fund, 
						 ItemMaster, 
						 NULL as AuditId,
						 ISNULL(RequestDue,'#dateformat(getDate.DateEffective,'YYYY-MM-DD')#') as RequestDue, 
						 RequestQuantity, 
						 RequestAmountBase, 
						 
						 <!--- determine if the requirement has an issued budget allotment already recorded --->	
						 
						 (  SELECT ISNULL(SUM(R.Amount),0)
					  	    FROM   ProgramAllotmentDetailRequest R, 
							       ProgramAllotmentDetail S
							WHERE  R.TransactionId =  S.TransactionId
							AND    R.RequirementId  = PARQ.RequirementId 
							AND    S.Period         = '#url.period#'  <!--- to prevent in case of carry over --->
							AND    S.Status = '1') as Allotment,			
							   
	                     RequirementIdParent,
						 RequestRemarks,
						 ActionStatus,
						 RequestType,
						 RequestDescription,
						 PARQ.OfficerLastName,						 
						 PARQ.Created
						 
	           FROM      ProgramAllotmentRequest AS PARQ INNER JOIN Ref_Object AS O ON PARQ.ObjectCode = O.Code
	           WHERE     NOT EXISTS (SELECT 'X' FROM ProgramAllotmentRequestQuantity WHERE RequirementId = PARQ.RequirementId) 		   
			   AND       ProgramCode  = '#url.programcode#'
			   AND       Period       = '#url.period#'			  
			   AND       EditionId    = '#editionid#'
			   AND       PARQ.ActionStatus IN ('0','1')
			  		 		   
			   </cfoutput>
				
		</cfsavecontent>		
						
		<cfquery name="Details" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT    R.Description  AS ItemMasterDescription, 
				          D.*, 
						  
						 (SELECT   MIN(RequestDue)
						  FROM     (#preservesingleQuotes(Data)#) X
						  WHERE    X.RequirementId = D.RequirementId
						  AND      Year(RequestDue) = '#yr#') as DateFrom,
						  
						 (SELECT   MAX(RequestDue)
						  FROM     (#preservesingleQuotes(Data)#) X
						  WHERE    X.RequirementId = D.RequirementId
						  AND       Year(RequestDue) = '#yr#') as DateTo,
											
						 (SELECT   count(*)
						  FROM     (#preservesingleQuotes(Data)#) as X
						  WHERE    X.RequirementIdParent = D.RequirementIdParent
						  AND      Year(RequestDue) = '#yr#') as Children,
						  					   									
						  O.Description  AS ObjectDescription, 
						  O.ListingOrder AS ObjectOrder, 
						  S.Description  AS ResourceDescription, 
		                  S.ListingOrder AS ResourceOrder						  
							   
				FROM      (#preservesingleQuotes(Data)#) D INNER JOIN
		                  Ref_Object O INNER JOIN
		                  Ref_Resource S ON O.Resource = S.Code ON D.ObjectCode = O.Code LEFT OUTER JOIN
		                  Purchase.dbo.ItemMaster R ON D.ItemMaster = R.Code
				WHERE     ActionStatus IN ('0','1') 
				AND       Year(RequestDue) = '#yr#' 			
				ORDER BY  S.Listingorder,S.Description,O.ListingOrder,D.ObjectCode,D.ActionStatus DESC,D.Created,D.RequirementIdParent,D.RequestDue,ItemMaster,RequestDescription
				
		</cfquery>		
		
		<cfquery name="CheckAllotment" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT     D.AmountBase, D.TransactionId, R.RequirementId, R.Amount
			FROM       ProgramAllotmentDetail AS D LEFT OUTER JOIN
	                   ProgramAllotmentDetailRequest AS R ON D.TransactionId = R.TransactionId
			WHERE      D.ProgramCode = '#url.programcode#'
			AND        D.Period = '#url.period#' 
			AND        D.Status = '1'
			GROUP BY   D.Amount, D.TransactionId, D.AmountBase, R.RequirementId, R.Amount
			HAVING     R.RequirementId IS NULL
		</cfquery>			
		
		<cfif checkAllotment.recordcount eq "0">
			<cfset showallotment = "1">
		<cfelse>
			<cfset showallotment = "0">
		</cfif>
		<!---	
		<cfoutput>-#cfquery.executiontime#-</cfoutput>
		--->
			
		<cfset cols = "7">
		<cfset row  = 0>
		
			<tr><td height="5"></td></tr>
		
			<tr>
			
			<cfoutput>
			<td colspan="<cfoutput>#cols#</cfoutput>" style="font-size:35" class="labellarge"><b><cfoutput>#yr#</cfoutput><font size="2">&nbsp;(#Parameter.BudgetCurrency#)</font> <b></td>
			
				     <cfquery name="Total" dbtype="query">
						   	SELECT SUM(RequestAmountBase) as Total, SUM(Allotment) as Allotment
						    FROM   Details		
							WHERE  ActionStatus IN ('0','1') 													   
					 </cfquery>		
					 
					 <cfquery name="Allotment" datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">					 
						SELECT   SUM(AmountBase) AS Total
						FROM      ProgramAllotmentDetail AS D
						WHERE     ProgramCode = '#url.programcode#' 
						AND       Period = '#url.period#' 
						AND       Status = '1' 
						AND       YEAR(TransactionDate) = '#yr#'
					 </cfquery>	
					 								
			<cfset vTotalRatio = 0>
			<cfif total.total neq "" and ratio neq "">
				<cfset vTotalRatio = Total.Total*ratio>
			</cfif>
			<cfset vTotalAllot = 0>
			<cfif Allotment.Total neq "" and ratio neq "">	
				<cfset vTotalAllot = Allotment.Total*ratio>
			</cfif>		   			   
		    <td align="right" bgcolor="FBFCDA" class="labellarge" style="border:1px solid silver;padding-right:3px;padding-left:4px"><b>#numberformat(Total.Total,"#format#")#<br></b>
			<font size="2">#numberformat(vTotalRatio,"#format#")#</font>
			</b></td>
			<td class="labellarge" bgcolor="FBFCDA" align="right" style="border:1px solid silver;padding-right:3px;padding-left:4px">
			
			#numberformat(Allotment.Total,"#format#")#<br>
			</b>
			<font size="2">#numberformat(vTotalAllot,"#format#")#</font>
			
			</td>
			
			</cfoutput>
			</tr>	
						
			<tr class="labelmedium line">
			    <td></td>
				<td colspan="3"></td>
				<td><cf_tl id="Period"></td>
				<td></td>
				<td></td>
				<td align="right"><cf_tl id="Requirement"><cf_space spaces="26"></td>
				<td align="right"><cf_tl id="Allotment"><cf_space spaces="26"></td>
			</tr>
						  		   
			<cfoutput query="details" group="ResourceDescription">
				   
				   <tr class="line fixrow labelmedium2">
				   <td colspan="#cols#" style="font-weight:bold;height:32px;font-size:18px;padding-left:5px;">#ResourceDescription#</td>
				   			  
				     <cfquery name="Resource" dbtype="query">
						   	SELECT SUM(RequestAmountBase) as Total, 
							       SUM(Allotment) as Allotment
						    FROM   Details		
							WHERE  ResourceDescription = '#ResourceDescription#'	
							AND    ActionStatus IN ('0','1') 							   
					 </cfquery>		
					 
					 <cfquery name="ObjectAll" datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">					 
							SELECT    SUM(AmountBase) AS Total
							FROM      ProgramAllotmentDetail AS D
							WHERE     ProgramCode = '#url.programcode#' 
							AND       Period = '#url.period#' 
							AND       Status = '1' 
							AND       ObjectCode IN (SELECT Code FROM Ref_Object WHERE Resource = '#Resource#')						
							AND       YEAR(TransactionDate) = '#yr#'
					 </cfquery>	  
				  
				   <td align="right" style="padding-left:4px;font-size:16px"><b>#numberformat(Resource.Total,"#format#")#</td>
				   <td align="right" style="padding-left:4px;font-size:16px"><b>#numberformat(Resource.Allotment,"#format#")#</td>		
				   <td></td>			   
				 	  
				   </tr>
				   		   
				   <cfoutput group="ObjectCode">
				   
				       <tr class="labelmedium2 line">
					   <td colspan="#cols#" style="padding-left:9px;height:32px">#ObjectCode# #ObjectDescription# </td>
					   
					    <cfquery name="Object" dbtype="query">
						   	SELECT    SUM(RequestAmountBase) as Total, 
							          SUM(Allotment) as Allotment
						    FROM      Details		
							WHERE     ResourceDescription = '#ResourceDescription#'	
							AND       ObjectCode = '#ObjectCode#'
							AND       ActionStatus IN ('0','1') 							   
					   </cfquery>	
					   
					   <cfquery name="ObjectAll" datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">					 
							SELECT    SUM(AmountBase) AS Total
							FROM      ProgramAllotmentDetail AS D
							WHERE     ProgramCode = '#url.programcode#' 
							AND       Period = '#url.period#' 
							AND       Status = '1' 
							AND       ObjectCode = '#ObjectCode#'						
							AND       YEAR(TransactionDate) = '#yr#'
					 </cfquery>	
					 
					   <td align="right"><b>#numberformat(Object.Total,"#format#")#</b></td>					   
					   <td align="right">#numberformat(ObjectAll.Total,"#format#")#</td>		
					   <td></td>					 	   
					   </tr>
					   
					   <cfoutput group="ActionStatus">
					   				
				   			<cfif actionstatus eq "0" AND
							      (BudgetAccess eq "EDIT" or BudgetAccess eq "ALL")>									  
								   <cfset bgcolor = "ffff00">								  
								   
							<cfelse>
							      <cfset bgcolor = "transparent">
							</cfif>	  	  						
																		   
					   <cfoutput group="RequirementIdParent">		
					   										 				   
					        <cfif Children gte "2" and (RequestRemarks neq "" or RequestType eq "Ripple")>
							
							   <cfset cl = "hide">
							   						   
							   <cfquery name="Parent" dbtype="query">
								   	SELECT MIN(DateFrom) as DateFrom,
									       MAX(DateTo) as DateTo,
										   SUM(RequestAmountBase) as Total,
										   SUM(Allotment) as Allotment
								    FROM   Details		
									WHERE  RequirementIdParent = '#RequirementIdParent#'	
									AND    ObjectCode          = '#objectCode#'		   
							   </cfquery>		
							   												
							   <cfset row = row+1>	
						   	   <tr bgcolor="#bgcolor#" class="navigation_row labelmedium2 navigation_action line">						   
								   <td style="padding-left:30px">#row#.</td>
								   <td style="padding-top:5px;padding-left:5px;width:20px">
								  							  						   							   
								   <img src="#SESSION.root#/Images/arrowright.gif"
									     alt="Expand" 
										 id="l#RequirementIdParent#_#ObjectCode#_#yr#_col" 
									     class="regular"
										 align="absmiddle"
									     style="cursor: pointer;height:11px"
									     onClick="togglecontent('#RequirementIdParent#_#ObjectCode#_#yr#')">
								 
									<img src="#SESSION.root#/Images/arrowdown.gif"
									     alt="Collapse"
									     id="l#RequirementIdParent#_#ObjectCode#_#yr#_exp"						    					    
									     class="hide"
										 align="absmiddle"
									     style="cursor: pointer;height:11px"
									     onClick="togglecontent('#RequirementIdParent#_#ObjectCode#_#yr#')">
									
								   </td>
								   <td colspan="#cols-4#" style="padding-left:2px;padding-right:4px"><cfif RequestType eq "Ripple">Rippled<cfelse>#RequestRemarks#</cfif></td>
								   <td style="padding-left:4px;min-width:140px;">
								   
								   <cfif Parent.DateFrom eq "">#dateformat(Parent.RequestDue,"YYYY:MMMM")#
								   <cfelse>
									<cfif dateformat(Parent.DateFrom,"YYYY") eq dateformat(Parent.DateTo,"YYYY") and dateformat(Parent.DateFrom,"MMM") eq dateformat(Parent.DateTo,"MMM")>							
								    #dateformat(Parent.DateTo,"YYYY : MMMM")#							
									<cfelseif dateformat(Parent.DateFrom,"YYYY") eq dateformat(Parent.DateTo,"YYYY")>
								    #dateformat(Parent.DateFrom,"YYYY : MMM")#&nbsp;-&nbsp;#dateformat(Parent.DateTo,"YYYY : MMM")#
									<cfelse>
									#dateformat(Parent.DateFrom,"YYYY : MMM")#&nbsp;-&nbsp;#dateformat(Parent.DateTo,"YYYY : MMM")#
									</cfif>
									</cfif>
								   
								   </td>
								   <td></td>
								   <td align="right" style="min-width:85px;padding-left:4px">#numberformat(Parent.Total,"#format#")#</td>								   
								   <td align="right" style="min-width:85px;padding-left:4px">#numberformat(Parent.Allotment,"#format#")#</td>
								  								   
								   <td align="right" style="padding-left:4px;padding-right:15px">		
								   								   
								   <cfif Parent.Allotment gte "1">
								   
									   <cf_img icon="log" onclick="toggleallotment('#RequirementIdParent#','#ObjectCode#','#yr#')">	
									   
								   <cfelse>
								        <!---
								   		<table><tr><td class="labelit" align="center" bgcolor="FFFF00" style="width:11;height:11px;border:1px solid gray"></td></tr></table>	   
										--->
								   </cfif>
								   
								   </td>
							   </tr>
							   
							   <cfif activityid neq "" and activityid neq "0">															   
															   
									<cfquery name="Act" 
										datasource="AppsProgram" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT    *
										FROM      ProgramActivity
										WHERE     ProgramCode = '#url.programcode#'
										AND       ActivityId = '#activityid#'	
									</cfquery>
								   									   
								   <tr class="labelmedium2">
									   <td>#activityid#</td>
									   <td></td>
									   <td colspan="6" bgcolor="CAFBD7">
										   <table>
										   <tr>
										   <td><img src="#session.root#/images/join.gif" alt="" border="0"></td>
										   <td style="padding-left:4px;width:80px">#dateformat(act.ActivityDateStart,client.dateformatshow)#</td>						   
										   <td style="padding-left:4px;width:80px">#dateformat(act.ActivityDate,client.dateformatshow)#</td>
										   <td style="padding-left:4px">#Act.ActivityDescription#</td>										  
										   </tr>
										   </table>
								   </tr>							   
							   
							   </cfif>
							   
							</cfif>  
							
							<!--- this are the individual lines ---> 							
						 							
						   <cfoutput>						   						   
						   
						   		<cfif Children eq "1" or (RequestRemarks eq "" and RequestType neq "Ripple")>
								 	<cfset row = row+1>
									<cfset cl = "regular">
								</cfif>	
														   
						        <cfif actionStatus eq "9">
								  	<cfset color = "FF8080">
								<cfelseif actionstatus eq "0">  
								    <cfset color = "FAC5BE">
								<cfelseif allotment gte "1">  
								    <cfset color = "FFFFfF">
								<cfelse>
								    <cfset color = "transparent">
								</cfif>  	   
								
								<tr bgcolor="#color#" class="navigation_row labelmedium2 #cl#" name="l#RequirementIdParent#_#ObjectCode#_#yr#">						
								
									<td width="20" style="border-bottom:1px solid silver;padding-left:30px">
									<cfif RequestType eq "ripple">
										<!--- no number --->
									<cfelse>
										<cfif children eq "1" or RequestRemarks eq "">#row#.</cfif>
									</cfif>
									</td>
									<td style="border-bottom:1px solid silver;padding-left:10px;width:25px;" align="center">
																		
									<cfif Allotment eq "0" or Allotment eq "">
																											
										<cfif RequestType eq "ripple">
										
											<!--- only budget manager has access to rippled stuff 
																						
											<cfif requirementLock eq "0" and (BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL")>	
																					
												<cf_img icon="edit" navigation="Yes" onclick="alldetinsert('resource','#editionid#','#objectcode#','#requirementid#','resource')">
											
											</cfif>
											
											--->	
										
										<cfelse>
									
											<cfif requirementLock eq "0">		
																						
												<cf_img icon="open" navigation="Yes" onclick="alldetinsert('resource','#editionid#','#objectcode#','#requirementid#','resource')">
																
											</cfif>
										
										</cfif>
										
									<cfelse>																		
																	
									</cfif>
									
									</td>
									<td colspan="2" style="border-bottom:1px solid silver;padding-left:3px">
										<cfif RequestType eq "ripple">
										<font size="1" color="808080"><cf_tl id="ripple">:&nbsp;</font>
										</cfif>#ItemMasterDescription# #RequestDescription#
									</td>		
									<td style="border-bottom:1px solid silver;padding-left:4px">#OfficerLastName# <font size="1">#dateformat(Created,client.dateformatshow)#</font></td>					
									<td style="border-bottom:1px solid silver;padding-left:4px">#dateformat(RequestDue,"YYYY : MMM")#</td>
									<td style="border-bottom:1px solid silver;padding-left:4px">#Fund#</td>							
									<td align="right" style="border-bottom:1px solid silver;padding-left:4px">#numberformat(RequestAmountBase,"#format#")#</td>									
									<td align="right" style="border-bottom:1px solid silver;padding-left:4px"></td>																		
									<td align="right" style="border-bottom:1px solid silver;padding-right:15px">		
																											
									<!--- condition for delete if edition is open --->								
									<cfif Allotment eq "0">
									
										<cfif RequestType eq "ripple"> <!--- only budget manager has access to rippled stuff --->
										
											<cfif RequirementLock eq "0" and (BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL")>												
												<cfif AuditId neq "">												
												   <cf_img icon="delete" 
													   onclick = "_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDeleteQuantity.cfm?mode=resource&requirementid=#requirementid#&auditId=#AuditId#&&cell=resource','boxresource')">																							
												<cfelse>												
												    <cf_img icon="delete" 
													   onclick = "_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDelete.cfm?mode=resource&requirementid=#requirementid#&cell=resource','boxresource')">																				 	
												</cfif>	
											
											</cfif>											
										
										<cfelse>
													
											<cfif requirementLock eq "0">		
											
												<cfif AuditId neq "">
											
												   	<cf_img icon="delete" 
													   onclick = "_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDeleteQuantity.cfm?mode=resource&requirementid=#requirementid#&auditId=#AuditId#&&cell=resource','boxresource')">											
											
											   <cfelse>																				
																						
											    	<cf_img icon="delete" 
													   onclick = "_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('#SESSION.root#/programrem/Application/Budget/Request/RequestDelete.cfm?mode=resource&requirementid=#requirementid#&cell=resource','boxresource')">
													   
												</cfif>	   																			 	
																					
										   </cfif>		
										   
										 </cfif>  
										
									<cfelse>
																											
										<cfif cl eq "regular">
											 <cf_img icon="log" onclick="toggleallotment('#RequirementIdParent#','#ObjectCode#','#yr#')">							
										</cfif>			
									
									</cfif>								
									</td>
								</tr>							
						  						   
						   </cfoutput>
						   
					   		<tr id="box#RequirementIdParent#_#ObjectCode#_#yr#" class="hide">
							    <td colspan="2"></td>
								<td id="content#RequirementIdParent#_#ObjectCode#_#yr#" colspan="#cols#"></td></tr>
						   
						 </cfoutput>  
						 
					 </cfoutput>			 
				   
				   </cfoutput>	
				   	
		   </cfoutput>		
		   
		  </cfloop> 
			  	
		</cfif>	
			
	</cfloop>	
	   
	</table>
	
	<cfset AjaxOnLoad("doHighlight")>	
	<script>
		Prosis.busy('no')
	</script>
