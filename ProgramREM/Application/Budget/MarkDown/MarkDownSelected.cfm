
<!--- create action master record --->

<cfquery name="Clean" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM RequestAction
	  WHERE  OfficerUserid = '#SESSION.acc#' 
	  AND    ActionSubmitted is NULL
</cfquery>	

<cfquery name="Create" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  INSERT INTO RequestAction
	  (ActionId,OfficerUserId,OfficerLastName,OfficerFirstName)
	  VALUES ('#rowguid#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
</cfquery>	

<cfquery name="Create" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  INSERT INTO ProgramAllotmentRequestBatchAction
	  (RequirementId,ActionId,RequestQuantity,RequestPrice,RequestAmountBase)
	  SELECT  RequirementId,'#rowguid#',RequestQuantity,RequestPrice,RequestAmountBase
	  FROM    Program AS P INNER JOIN
	          ProgramPeriod AS Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
	          Organization.dbo.Organization AS O ON Pe.OrgUnit = O.OrgUnit INNER JOIN
			  ProgramAllotmentRequest AS A ON A.ProgramCode = P.ProgramCode
	  <!--- selected programs --->		  
	  WHERE   Pe.ProgramId IN (#preservesinglequotes(url.programselect)#)					
	  <!--- selected objects --->
	  AND     A.ObjectCode IN (#preservesinglequotes(url.objectselect)#)	
	  
	  
	   AND   (
	         A.RequirementId NOT IN  (
						    SELECT   RequirementId
   		                    FROM     ProgramAllotmentDetailRequest DR,
									 ProgramAllotmentDetail D
	       		            WHERE    DR.RequirementId = A.RequirementId
							AND      DR.TransactionId = D.TransactionId
							AND      D.Status = '1'     
						   )	
			 OR		
			 
			 A.RequirementId NOT IN (
						    SELECT   RequirementId
	     		            FROM     ProgramAllotmentDetailRequest DR															
	             		    WHERE    DR.RequirementId = A.RequirementId																										
						 )		   
			 )				 	
	  	  
	  AND     A.EditionId = '#URL.EditionId#'	
	  AND     A.Period    = '#url.period#' 	 		
	  AND     A.ActionStatus IN ('0','1')				 	
</cfquery>	  

<!--- ---------------- --->
<!--- relative amounts --->
<!--- ---------------- --->

<cfquery name="Total" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT sum(RequestAmountBase) as Total
	FROM  ProgramAllotmentRequestBatchAction
	WHERE ActionId = '#rowguid#'
</cfquery>	
	
<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE ProgramAllotmentRequestBatchAction
	SET RequestAmountPercentage = RequestAmountBase/#total.total#
	WHERE ActionId = '#rowguid#'
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
				  SUM(A.RequestAmountBase) as Total					  		
				  
		FROM      Program AS P INNER JOIN
	              ProgramPeriod AS Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
	              Organization.dbo.Organization AS O ON Pe.OrgUnit = O.OrgUnit INNER JOIN
				  ProgramAllotmentRequest AS A ON A.ProgramCode = P.ProgramCode INNER JOIN
                  Ref_Object AS R ON A.ObjectCode = R.Code
					 
		<!--- selected programs --->		  
		WHERE     Pe.ProgramId IN (#preservesinglequotes(url.programselect)#)					
		<!--- selected objects --->
		AND       A.ObjectCode IN (#preservesinglequotes(url.objectselect)#)
		
		   AND   (
	         A.RequirementId NOT IN  (
						    SELECT   RequirementId
   		                    FROM     ProgramAllotmentDetailRequest DR,
									 ProgramAllotmentDetail D
	       		            WHERE    DR.RequirementId = A.RequirementId
							AND      DR.TransactionId = D.TransactionId
							AND      D.Status = '1'     
						   )	
			 OR		
			 
			 A.RequirementId NOT IN (
						    SELECT   RequirementId
	     		            FROM     ProgramAllotmentDetailRequest DR															
	             		    WHERE    DR.RequirementId = A.RequirementId																										
						 )		   
			 )		
			 
		AND      A.EditionId = '#URL.EditionId#'	
		AND      A.Period    = '#url.period#' 	 		 	
		
		AND       A.ActionStatus IN ('0','1')
		GROUP BY  P.Mission, 
	              Pe.OrgUnit, 
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
				  					  										
		ORDER BY O.HierarchyCode,Pe.PeriodHierarchy, R.ListingOrder	
				 		 
</cfquery>
		
<table width="98%" cellspacing="0" cellpadding="0" align="right">
	    <tr><td height="9"></td></tr>
		<tr><td colspan="6"></td></tr>
		<tr class="labelmedium line">
			<td><cf_tl id="Unit"></td>				
			<td><cf_tl id="Code"></td>
			<td><cf_tl id="Budget Code"></td>
			<td><cf_tl id="Name"></td>
			<td><cf_tl id="Object"></td>
			<td align="right"><cf_tl id="Total"></td>			
		</tr>
							
		<cfoutput query="Getprogram" group="HierarchyCode">
			
		<tr class="labelmedium line">
			<td colspan="6" height="20">#OrgUnitName#</td>			
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
				<td class="labelit" align="right">#numberformat(total,"__,__.__")#</td>			
			</tr>			
			</cfoutput>
									
	    </cfoutput>
		    	
	</cfoutput>
	
	<cfoutput>			
			
		<tr><td height="2"></td></tr>
		<tr><td colspan="6" height="1" class="line"></td></tr>		
		<tr bgcolor="ffffcf">
			<td colspan="4" height="16" class="labelit">&nbsp;Total:</td>
			<td></td>
			<td align="right" class="labelit">#numberformat(total.total,"__,__.__")#</td>		
		</tr>
		<tr><td colspan="6" height="1" class="line"></td></tr>			
		<tr><td height="14"></td></tr>		
	
	</cfoutput>
				
</table>			