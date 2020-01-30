

<cfquery name="Listing" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	

	SELECT     P.ProgramCode, 
	           P.ProgramName,
			   OP.OrgUnitName, 
			   OP.OrgUnitNameShort,
			   OP.HierarchyCode,
			   Pe.Reference, 
			   Pa.EditionId,
			   PA.SupportPercentage,
			   
			   (SELECT TOP 1 ObjectCode 
			    FROM   ProgramAllotmentObject 
				WHERE  ProgramCode = P.ProgramCode
			    AND    Period      = Pe.Period 
				AND    EditionId   = Pa.EditionId
			   ) as Individual,			
			   
			  <!--- requested amount ---> 
               
              (SELECT    ROUND(ISNULL(SUM(RequestAmountBase),0), 0)/1000 AS Expr1
               FROM      ProgramAllotmentRequest
               WHERE     ProgramCode  = P.ProgramCode 
			   AND       Period       = Pe.Period
			   AND       EditionId    = Pa.EditionId 
			   <cfif url.fund neq "">
			   AND       Fund = '#url.fund#'			   
			   </cfif>
			   AND       ActionStatus IN ('1')) AS AmountRequested,			   
			   
			   <!--- required amount to allot ---> 
               
              (SELECT    ROUND(ISNULL(SUM(Amount),0), 0)/1000 AS Expr1
               FROM      ProgramAllotmentDetail D
               WHERE     ProgramCode  = P.ProgramCode 
			   AND       Period       = Pe.Period
			   AND       EditionId    = Pa.EditionId 
			   AND       ActionId NOT IN (SELECT   ActionId
        		                          FROM     ProgramAllotmentAction
										  WHERE    ActionId = D.ActionId
                		                  AND      ActionClass IN ('Amendment', 'Transfer'))
			   <cfif url.fund neq "">
			   AND       Fund = '#url.fund#'			   
			   </cfif>
			   AND       Status IN ('P','0','1')) AS AmountRequestedTotal, 
			   
			  <!--- vetted amount ---> 
               
              (SELECT    ROUND(ISNULL(SUM(AmountBaseAllotment),0), 0)/1000 AS Expr1
               FROM      ProgramAllotmentRequest
               WHERE     ProgramCode  = P.ProgramCode 
			   AND       Period       = Pe.Period
			   AND       EditionId    = Pa.EditionId 
			   <cfif url.fund neq "">
			   AND       Fund = '#url.fund#'			   
			   </cfif>
			   AND       ActionStatus IN ('1')) AS AmountVetted,
			   			   
			  <!--- required amount ---> 
			  
			  (SELECT    ROUND(ISNULL(SUM(AmountBaseAllotment),0), 0)/1000 AS Expr1
	           FROM      ProgramAllotmentRequest
	           WHERE     ProgramCode  = P.ProgramCode 
			   AND       Period       = Pe.Period
			   AND       EditionId    = Pa.EditionId 
			   <cfif url.fund neq "">
			   AND       Fund = '#url.fund#'			   
			   </cfif>
			   AND       ActionStatus IN ('1')) AS AmountVettedToAllotTotal,    <!--- cleared for allotment : can be corrected --->           
			 				
			  (SELECT    ROUND(ISNULL(SUM(AmountBaseAllotment*AmountBasePercentageDue),0), 0)/1000 AS Expr1
	           FROM      ProgramAllotmentRequest
	           WHERE     ProgramCode  = P.ProgramCode 
			   AND       Period       = Pe.Period
			   AND       EditionId    = Pa.EditionId 
			   <cfif url.fund neq "">
			   AND       Fund = '#url.fund#'			   
			   </cfif>
			   AND       ActionStatus IN ('1')) AS AmountVettedToAllotToDate,	<!--- due as per today's date using the release percentage --->					 

			  <!--- alloted to date confirmed/unconfirmed--->
				  													 
             (SELECT     ROUND(ISNULL(SUM(Amount), 0), 0)/1000 
              FROM       ProgramAllotmentDetail D
              WHERE      ProgramCode = P.ProgramCode 
			  AND        Period = Pe.Period 
			  AND        EditionId = Pa.EditionId
			  AND        ActionId NOT IN (SELECT   ActionId
        		                          FROM     ProgramAllotmentAction
										  WHERE    ActionId = D.ActionId
                		                  AND      ActionClass IN ('Amendment', 'Transfer'))
			  <cfif url.fund neq "">
			  AND        Fund = '#url.fund#'			   
			  </cfif>
			  AND        Status = '1') 
				  
			  AS AllotedToDate,
			  
			  (SELECT     ROUND(ISNULL(SUM(Amount), 0), 0)/1000 
              FROM       ProgramAllotmentDetail D
              WHERE      ProgramCode = P.ProgramCode 
			  AND        Period = Pe.Period 
			  AND        EditionId = Pa.EditionId
			  AND        ActionId IN (SELECT   ActionId
        		                      FROM     ProgramAllotmentAction
									  WHERE    ActionId = D.ActionId
                		              AND      ActionClass IN ('Amendment', 'Transfer'))
			  <cfif url.fund neq "">
			  AND        Fund = '#url.fund#'			   
			  </cfif>
			  AND        Status = '1') 
				  
			  AS AmountAmended,
			  
						 
				 <!--- wf confirmed only --->		 
						 
				(SELECT    ROUND(ISNULL(SUM(Amount), 0), 0)/1000 
                  FROM     ProgramAllotmentDetail PAD
                  WHERE    ProgramCode = P.ProgramCode 
				  AND      Period      = Pe.Period 
				  AND      EditionId   = Pa.EditionId 
				  <cfif url.fund neq "">
			      AND       Fund = '#url.fund#'			   
			      </cfif>
				  AND      Status = '1'
				  AND      (ActionId is NULL OR ActionId IN (SELECT Actionid 
				                                             FROM   ProgramAllotmentAction 
															 WHERE  Actionid = PAD.ActionId 
															 AND    Status = '3'))) 
				  
				         AS AllotedToDate2		 
							
							
FROM            Program AS P INNER JOIN
                ProgramPeriod AS Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
                ProgramAllotment AS Pa ON Pe.ProgramCode = Pa.ProgramCode AND Pe.Period = Pa.Period INNER JOIN
                Organization.dbo.Organization AS O ON Pe.OrgUnit = O.OrgUnit INNER JOIN
                Organization.dbo.Organization AS OP ON O.Mission = OP.Mission AND O.MandateNo = OP.MandateNo AND O.HierarchyRootUnit = OP.OrgUnitCode

WHERE  			P.Mission    = '#url.mission#' 
AND             Pe.Period    = '#url.period#' 
AND             Pa.EditionId = '#url.edition#' 

<cfif url.reviewCycle neq "">
AND             P.ProgramCode IN (SELECT ProgramCode
                                  FROM   ProgramPeriodReview
								  WHERE  ReviewCycleId = '#url.reviewcycle#'
								  AND    ProgramCode   = Pe.ProgramCode
								  AND    Period        = Pe.Period
								  AND    ActionStatus  >= '#url.status#' and ActionStatus <= '3')
</cfif>
<!--- exclude removed projects for this period --->
AND             Pe.RecordStatus != '9'
AND             EXISTS
                          (SELECT   'X' 
                            FROM    ProgramAllotmentDetail 
                            WHERE   ProgramCode = P.ProgramCode 
							AND     Period = Pe.Period 
							<cfif url.fund neq "">
						    AND     Fund = '#url.fund#'			   
					        </cfif>
							AND     Amount > 0 
							AND     EditionId = Pa.EditionId)
							
ORDER BY Op.HierarchyCode,Pe.PeriodHierarchy,Pe.Reference	

</cfquery>
