
<cfquery name="Check" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   RequestAction
	WHERE  ActionId = '#url.actionid#'	
</cfquery>

<!--- show listing --->		  
	
<cfquery name="GetProgram" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  
	   SELECT     P.Mission, 
	              Pe.OrgUnit, 
				  O.OrgUnitCode, 
				  O.OrgUnitName, 
				  O.HierarchyCode, 
				  P.ProgramCode, 
				  P.ProgramClass, 
				  P.ProgramName, 
				  Pe.PeriodDescription as ProgramDescription, 
	              Pe.PeriodHierarchy,
				  Pe.ProgramId,
				  <cfloop index="itm" from="1" to="6">
				  Pe.ReferenceBudget#itm#,
				  </cfloop>
				  Pe.Reference,
				  A.ObjectCode,
				  R.ListingOrder, 
				  R.Description, 
				  SUM(Re.RequestAmountBase) as Total,
				  SUM(Re.RevisedAmountBase) as Revised					  		
				  
		FROM      Program AS P INNER JOIN
	              ProgramPeriod AS Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
	              Organization.dbo.Organization AS O ON Pe.OrgUnit = O.OrgUnit INNER JOIN
				  ProgramAllotmentRequest AS A ON A.ProgramCode = P.ProgramCode AND Pe.Period = A.Period  INNER JOIN
                     Ref_Object AS R ON A.ObjectCode = R.Code INNER JOIN
					 ProgramAllotmentRequestBatchAction Re ON A.RequirementId = Re.RequirementId 
			  
		WHERE     Re.ActionId = '#url.actionid#'					
		
		GROUP BY  P.Mission, 
	              Pe.OrgUnit, 
				  Pe.Period,
				  O.OrgUnitCode, 
				  O.OrgUnitName, 
				  O.HierarchyCode, 
				  P.ProgramCode, 
				  P.ProgramClass, 
				  P.ProgramName, 
				  Pe.PeriodDescription, 
	              Pe.PeriodHierarchy,
				  Pe.ProgramId,
				  <cfloop index="itm" from="1" to="6">
				  Pe.ReferenceBudget#itm#,
				  </cfloop>
				  Pe.Reference,
				  A.ObjectCode, 
				  R.Listingorder,
				  R.Description						  										
		ORDER BY O.HierarchyCode,Pe.Period, R.ListingOrder	
				 		 
</cfquery>
		
<table width="98%" cellspacing="0" cellpadding="0" align="right">
	    <tr><td height="9"></td></tr>
		<tr><td colspan="6"></td></tr>
		<tr class="line labelmedium">
			<td><cf_tl id="Unit"></td>				
			<td><cf_tl id="Code"></td>
			<td><cf_tl id="Budget Code"></td>
			<td><cf_tl id="Name"></td>
			<td><cf_tl id="Object"></td>
			<td align="right"><cf_tl id="Current"></td>
			<td align="right"><cf_tl id="Revised"></td>		
		</tr>
					
		<cfoutput query="Getprogram" group="HierarchyCode">
			
		<tr class="line">
			<td colspan="7" class="labelmedium" height="20">#OrgUnitName#</td>			
		</tr>
					  		
		<cfoutput group="ProgramCode">
		
			<tr><td height="3"></td></tr>						
			<tr>
			    <td width="20" bgcolor="white"></td>
				<td class="labelit"><cfif Reference eq "">#ProgramCode#<cfelse>#Reference#</cfif></td>
				<td class="labelit">
				 <cfloop index="itm" from="1" to="6">
				  #evaluate("ReferenceBudget#itm#")#<cfif itm neq "6">-</cfif>
				  </cfloop>
				</td>
				<td class="labelit">#ProgramName#</td>
				<td></td>
				<td></td>
			</tr>
			
			<cfoutput>
			
			<tr>
				<td colspan="4"></td>
				<td class="labelit">#ObjectCode# #Description#</td>
				<td align="right" class="labelit">#numberformat(total,"__,__.__")#</td>
				<td align="right" class="labelit">
				<cfif check.actionstatus eq "0">
				<font color="blue">
				<cfelse>
				<font color="green">
				</cfif>
				#numberformat(revised,"__,__.__")#</td>			
			</tr>
			
			</cfoutput>
									
	    </cfoutput>	
		
	</cfoutput>
	
	<cfoutput>
	
	<cfquery name="Total" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT sum(RevisedAmountBase) as Revised,
			      sum(RequestAmountBase) as Total
			FROM  ProgramAllotmentRequestBatchAction
			WHERE ActionId = '#url.actionid#'
		</cfquery>	
		
		<tr><td colspan="7" height="1" class="line"></td></tr>		
		<tr bgcolor="ffffcf">
		<td colspan="4" class="labelit">&nbsp;Total:</td>
		<td></td>
		<td align="right" class="labelit">#numberformat(total.total,"__,__.__")#</td>		
		<td align="right" class="labelit"><font color="blue">#numberformat(total.revised,"__,__.__")#</td>
		</tr>
		<tr><td colspan="7" height="1" class="line"></td></tr>			
		
		<tr><td height="10"></td></tr>		
		<tr><td colspan="7">
		
		<form name="applyform" method="post">
		
			<table width="100%">
			<tr class="line">
			<td valign="top" style="padding-top:3px" class="labelit" width="100"><cf_tl id="Reason">:</td>
			<td>
			<cfif check.actionStatus eq "0">
			<input type="text" 
			    name="ActionMemo" 
				class="regularxl" 
				style="width:100%;background-color:f1f1f1" 
				value="" 
				maxlength="100">
			<cfelse>
			  #Check.ActionRemarks#
			</cfif>	
				</td>
			</tr>
			</table>
			
		</form>
			
		</td></tr>
		
		<cfif check.actionStatus eq "0">
		<tr><td colspan="7" align="center" height="47" id="apply">
			<input type="button" 
			       name="Apply" 
				   class="button10g"
				   style="width:270;height:34;font-size:15px"
				   value="Apply selected scenario" 
				   onclick="ColdFusion.navigate('MarkDownApply.cfm?ActionId=#url.actionid#','apply','','','POST','applyform')">
		</td></tr>
		</cfif>
		
	</cfoutput>	
				
</table>		