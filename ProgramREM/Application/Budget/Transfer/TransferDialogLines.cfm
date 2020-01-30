<!--- clean transactions --->

<cfparam name="url.processmode" default="all">
		
<cfquery name="Param"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#url.mission#'		
</cfquery>
		
<cfquery name="Lines"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM #SESSION.acc#BudgetTransfer_#client.sessionNo#		
		WHERE ActionClass != '#url.actionclass#'
		  OR EditionId    != '#url.editionid#' 
		  OR Period       != '#url.period#'
		  <!---
		  OR ObjectCode NOT IN (SELECT Code 
		                        FROM Program.dbo.Ref_Object 
								WHERE Resource = '#url.resource#')
								--->
</cfquery>
 
<cfif url.direction eq "to" and url.actionclass eq "Amendment">

	<!--- no show of this option --->
		
<cfelse>

<table width="96%" class="formspacing"      
       cellspacing="0"
       cellpadding="0">	
	
	<cfif url.direction eq "from">
	
	    <cfif url.actionclass eq "Amendment">
		
			<tr><td class="labellarge" style="padding-left:9px;height:24px" colspan="10"><cf_tl id="Amendment"></font></td></tr>

		<cfelse> 

			<tr><td class="labellarge" style="padding-left:9px;height:24px" colspan="10"><cf_tl id="Transfer from"></font></td></tr>
			
		</cfif>
		
		<tr><td colspan="10" class="line"></td></tr>
		
		<tr>
		 <td class="input" colspan="6"></td>
		 <td class="labelmedium" colspan="2" style="height:24px" align="center"><cf_tl id="Available">  <cfoutput>#Param.BudgetCurrency#</cfoutput></td>
		 <cfif url.actionclass eq "Amendment">
		 <td class="labelmedium" style="height:24px" align="right"><b><cf_tl id="Amendment"></td>	
		 <cfelse>
		 <td class="labelmedium" style="height:24px" align="right"><b><cf_tl id="Transfer"></td>	
		 </cfif>
		 <td class="input" align="right"></td>	
		</tr>
		
	<cfelse>
	
		<tr><td style="height:24px;padding-left:9px" class="labellarge" colspan="10">To</td></tr>
		<tr><td colspan="10" class="line"></td></tr>
		<tr>
			 <td class="input" colspan="6"></td>
			 <td class="labelmedium" style="height:24px" colspan="2" align="center"><cf_tl id="Current"></td>
			 <td class="labelmedium" style="height:24px" align="right"><cf_tl id="Receipt"></td>	
			 <td class="input" align="right"></td>	
		</tr>
		
	</cfif>
	
	<tr><td colspan="10" class="line"></td></tr>
	
    <tr class="line labelmedium">
	<td colspan="3"><cf_space spaces="5"></td>	
	<td width="350"><cf_tl id="Program"></td>
	<td><cf_space spaces="20"><cf_tl id="Fund"></td>
	<td><cf_space spaces="60">Object</td>	
	<td><cf_space spaces="20"><cf_tl id="In Process"></td>
	<td align="right"><cf_space spaces="25"><cf_tl id="Unused"></td>	
	<cfif url.actionclass eq "Amendment">
	<td align="right"><cf_space spaces="25">Revised&nbsp;Cleared</td>
	<cfelse>
	<td align="right"><cf_space spaces="25"><cf_tl id="Amount"></td>
	</cfif>
	<td class="input"><cf_space spaces="5"></td>
	</tr>	
	
	<tr><td height="2"></td></tr>
			
	<cfparam name="url.serialNo" default="">
		
	<cfquery name="Lines"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT   * 
			FROM     #SESSION.acc#BudgetTransfer_#client.sessionNo# S, 
			         Program.dbo.Program P,
				     Program.dbo.ProgramPeriod Pe,
				     Program.dbo.Ref_Object O
			WHERE    S.ProgramCode = P.ProgramCode
			AND      S.ProgramCode = Pe.ProgramCode
			AND      S.ObjectCode = O.Code
			AND      S.Period = Pe.Period
			
			<cfif url.actionClass eq "Transfer">

				<cfif url.direction eq "from">
				AND   Amount <= 0
				<cfelse>
				AND   Amount > 0
				</cfif>
				
			</cfif>
				
	</cfquery>
	
	<cfoutput query="Lines">
	
	    <cfif url.serialNo eq serialNo>
							
			<tr>
				<td colspan="3"><cf_space spaces="30"></td>
				
				<td style="padding:2px;height:30;border:1px solid silver" class="input" id="Program#url.direction#">
				
					<cfset url.field = "program">
					<cfset url.objectcode = objectcode>		
					<cfset url.programcode = programcode>	
					<cfset url.program     = url.program>	
					<cfset url.refresh = "0">			
					<cfinclude template="FieldSelect.cfm">
					
				</td>	
				<td style="padding:2px;border:1px solid silver" class="input">
				
				   <cfdiv id="Fund#url.direction#">
							
						<cfquery name="FundList" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT DISTINCT Fund 
							FROM   ProgramAllotmentDetail
							WHERE  EditionId   = '#editionid#' 
							AND    ProgramCode = '#programcode#'
							AND    Period      = '#period#'    
							AND    Amount > 0
							AND    Status IN ('0','1')		
						</cfquery>							
						
						<select name="fundcode#url.direction#" id="fundcode#url.direction#" class="regularxl" style="border:0px;width:100%"
						     onchange="amount('#url.direction#','pending','');amount('#url.direction#','amount','')">					  
							<cfloop query="FundList">
								<option value="#Fund#" <cfif lines.fund eq fund>selected</cfif>>#Fund#</option>
							</cfloop>
						</select>	
						
				   </cfdiv>				
				
				</td>
				<td style="padding:2px;border:1px solid silver" class="input">
				
				<cfdiv id="Object#url.direction#">
				
					<cfquery name="Allotment" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * 
						FROM   ProgramAllotment
						WHERE  ProgramCode = '#url.program#'
						AND    Period      = '#url.period#'
						AND    EditionId   = '#url.editionid#'					
					</cfquery>	
				
					<cfquery name="ObjectList" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * 
						FROM   Ref_Object O
						<cfif url.resource neq "">
						WHERE  Resource = '#url.resource#'
						<cfelse>
						WHERE  1=1
						</cfif>
						
						<!--- prevent selection of the support cost OE this is generated --->		
						AND   Code != '#allotment.SupportObjectCode#' 
						<!--- ---------------------------------------------------------- --->
						
						<cfif url.direction eq "From">
						
						   AND ( O.Code IN (						
									SELECT DISTINCT ObjectCode 
									FROM   ProgramAllotmentDetail
									WHERE  EditionId   = '#editionid#' 
									AND    ProgramCode = '#programcode#'
									AND    Period      = '#period#' 
									AND    ObjectCode  = O.Code
									AND    Status IN ('0','1')
							)
						<cfelse>	
						
						 AND ( O.Code IN (						
								SELECT DISTINCT ObjectCode 
								FROM   ProgramAllotmentDetail
								WHERE  EditionId   = '#editionid#' 
								AND    ProgramCode = '#programcode#'
								AND    Period      = '#period#' 
								AND    ObjectCode  = O.Code
								AND    Status IN ('0','1')
							)
						
							AND (
					    		 Code NOT IN (SELECT ObjectCode 
					            		      FROM   userquery.dbo.#SESSION.acc#BudgetTransfer_#client.sessionNo# 
											  WHERE  ProgramCode = '#ProgramCode#'
											  AND    Fund        = '#fund#')
							 
						     )
							
						</cfif>		
												 
						 OR Code = '#Lines.objectcode#'	
						 
						 )						
						
					</cfquery>							
					
					<select name="objectcode#url.direction#" id="objectcode#url.direction#" class="regularxl" style="border:0px;width:100%"
					onchange="amount('#url.direction#','pending','');amount('#url.direction#','amount','')">
					 	<cfloop query="ObjectList">
							<option value="#Code#" <cfif code eq Lines.objectcode>selected</cfif>>#Code# #Description#</option>
						</cfloop>
					</select>	
									
				</cfdiv>		
				
				</td>	
				<td style="border:1px solid silver;padding-right:3px;min-width:110px" align="right" class="input">
				<cfdiv bind="url:AmountSelect.cfm?status=pending&direction=#url.direction#&mode=edit&period=#url.period#&editionid=#url.editionid#&programcode=#programcode#&fund=#fund#&objectcode=#objectcode#&resource=#url.resource#" 
				       id="pending#url.direction#">	
				</td>
				
				<td style="border:1px solid silver;padding-right:3px;min-width:110px" align="right" class="input">
				<cfdiv bind="url:AmountSelect.cfm?status=cleared&direction=#url.direction#&mode=edit&period=#url.period#&editionid=#url.editionid#&programcode=#programcode#&fund=#fund#&objectcode=#objectcode#&resource=#url.resource#" 
				       id="cleared#url.direction#">
				</td>
								
				<td id="entry#url.direction#" style="border:1px solid silver;padding-right:3px" width="150" align="right" class="input">
															
					    <cfif url.direction eq "to" or url.actionclass eq "Amendment">
						
							<input type="text" 
							    name="Amount#url.direction#" id="Amount#url.direction#"
								value="#numberformat(amount,',__.__')#" 
								style="text-align:right;border:0px;background-color:DAF9FC"
								class="regularxl"
								size="10" 
								maxlength="20">		
														
						<cfelse>
												
							<input type="text" 
								name="Amount#url.direction#" id="Amount#url.direction#" 
								value="#numberformat(-amount,',__.__')#" 
								style="text-align:right;border:0px;;background-color:DAF9FC" 
								size="10" 
								class="regularxl"
								maxlength="20">			
												
						</cfif>
						
				</td>
							
				<td style="padding-left:3px;border:1px solid silver;padding-right:3px;min-width:83px">
								
						<input type="button" 
						  name="save#url.direction#" id="save#url.direction#"
						  value="Save"
						  style="width:80;height:25px;border:0px;" 
						  class="button10g" 
						  onclick="ColdFusion.navigate('AmountEntrySubmit.cfm?mission=#url.mission#&processmode=#url.processmode#&actionclass=#url.actionclass#&direction=#url.direction#&serialNo=#serialNo#','lines#url.direction#','','','POST','transferform')">
						  
				</td>
			</tr>					
			
			<tr>
			  <td colspan="3"></td>	
			  <td colspan="3" class="input" id="unit#url.direction#"></td>
  		    </tr>
		
		<cfelse>
	
			<tr>
			
				<td style="border-bottom:1px solid silver;padding-left:2px;padding-right:2px" align="center" class="input">		
				  <cf_img icon="expand" toggle="yes" 				 			      
					   onclick="allotdetail('#programcode#','#period#','#editionid#','#fund#','#objectcode#','#editionid#','no')">		
				</td>
			
			    <!--- edit button --->
				<td style="height:30px;border-bottom:1px solid silver;padding-left:2px;padding-right:2px" align="center" class="input">
				  <cf_img icon="edit" onclick="ptoken.navigate('TransferDialogLines.cfm?mission=#url.mission#&processmode=#url.processmode#&actionclass=#url.actionclass#&program=#url.program#&direction=#url.direction#&serialNo=#serialNo#&action=edit&editionid=#url.editionid#&period=#url.period#&resource=#url.resource#','lines#url.direction#')">					
				</td>
				
				<!--- delete button --->
				<td style="border-bottom:1px solid silver;padding-left:2px;padding-right:2px" align="center" class="input">		
				  <cfif url.processmode eq "all">
					  <cf_img icon="delete" onclick="ColdFusion.navigate('TransferDialogDelete.cfm?mission=#url.mission#&processmode=#url.processmode#&actionclass=#url.actionclass#&program=#url.program#&direction=#url.direction#&serialNo=#serialNo#&action=delete&editionid=#url.editionid#&period=#url.period#&resource=#url.resource#','lines#url.direction#')">				  		
				  </cfif>
				</td>
				
								
				<td style="border:1px solid silver;padding-left:3px;padding-right:3px" class="labelmedium">#Reference# #ProgramName#</td>
				<td style="border:1px solid silver;padding-left:3px" class="labelmedium">#Fund#</td>
				<td style="border:1px solid silver;padding-left:3px" class="labelmedium">#ObjectCode# #Description#</td>
				<td style="border:1px solid silver;padding-left:3px" class="labelmedium" align="right">
				
				<cfquery name="Amount" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    SUM(Amount) as Amount
					FROM      ProgramAllotmentDetail
					WHERE     ProgramCode = '#programcode#'
					AND       Period      = '#period#'
					AND       EditionId   = '#editionid#' 
					AND       ObjectCode  = '#objectcode#'
					AND       Fund        = '#fund#'			
					AND       Status = '0'
					
				</cfquery>	
							
				#numberformat(Amount.Amount,"__,__.__")#
				
				</td>
				<td style="border:1px solid silver;padding-left:3px" class="labelmedium" align="right">#numberformat(AmountCurrent,"__,__.__")#</td>
				<td style="border:1px solid silver;padding-left:3px" class="labelmedium" align="right" bgcolor="DFEFFF" style="border-left: 1px solid Gray;">
				<cfif url.actionClass eq "Amendment">
				   <font color="green">#numberformat(Amount,"(__,__.__)")#</font>
				<cfelse>
					<cfif amount lt 0>
					<font color="FF0000">#numberformat(Amount,"(__,__.__)")#</font>
					<cfelse>#numberformat(Amount,"__,__.__")#
					</cfif>
				</cfif>	
				</td>	
				<td style="border:1px solid silver" class="input"></td>
				
			</tr>
			
			<tr id="box_#objectcode#_#editionid#" class="hide">
			   <td colspan="10" id="detail_#objectcode#_#editionid#"></td>
		    </tr>
						
			
		</cfif>	
	
	</cfoutput>
	
	<!--- we only allow adding if the mode is enabled --->
				
	<cfif url.serialNo eq "" and url.processmode eq "all">	
	
		<cfoutput>
		
			<tr>
				<td colspan="3"></td>				
				<td style="padding:2px;border:1px solid silver">	
				
					<cfdiv bind="url:FieldSelect.cfm?actionclass=#url.actionclass#&direction=#url.direction#&field=program&period=#url.period#&editionid=#url.editionid#&resource=#url.resource#&program=#url.program#" 
					       id="Program#url.direction#">			
						   
				</td>	
				<td style="padding:2px;border:1px solid silver"><cfdiv id="Fund#url.direction#"></td>
				<td style="padding:2px;border:1px solid silver"><cfdiv id="Object#url.direction#"></td>	
				<td style="padding:2px;border:1px solid silver" id="pending#url.direction#"  width="110" align="right"></td>
				<td style="padding:2px;border:1px solid silver" id="cleared#url.direction#"  width="110" align="right"></td>
				<td style="padding:2px;border:1px solid silver" id="entry#url.direction#"    width="150" align="right">
				
				</td>
				<td style="padding:2px;border:1px solid silver;min-width:83px" width="30">
				
				  <input type="button"
				      name="save#url.direction#" id="save#url.direction#"
					  value="Add" 
					  style="width:80px;height:26px;border:0px" 
					  class="hide" 
					  onclick="ptoken.navigate('AmountEntrySubmit.cfm?mission=#url.mission#&processmode=#url.processmode#&actionclass=#url.actionclass#&direction=#url.direction#','lines#url.direction#','','','POST','transferform')">
				
				</td>
			</tr>	
			
			<tr>
				<td colspan="3"></td>			
				<td colspan="3" class="labelmedium" id="unit#url.direction#"></td>
		    </tr>
		
		</cfoutput>	
	
	</cfif>
	
	<tr><td height="2"></td></tr>
	
	<tr><td colspan="10" class="line"></td></tr>
	
	<tr><td height="2"></td></tr>
	
	<cfif url.actionClass eq "Amendment" and Lines.recordcount gte "1">
	  	   
	   	<tr>
			<td colspan="10" align="center" height="40">
												   		
				<input type="button" name="Submit" value="Close" class="button10g" style="width:176;height:28" onclick="window.close()">	
				<input type="button" name="Submit" style="width:170;height:28"
					value="Submit Amendment" class="button10g" onclick="ptoken.navigate('TransferSubmit.cfm','result','','','POST','transferform')">	
					
			</td>
			
		</tr>	
		
	</cfif>
	
</table>

</cfif>


