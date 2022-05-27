
<cfquery name="Reset"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		TRUNCATE TABLE skMissionItemPrice 

	    INSERT INTO skMissionItemPrice
				( Mission, 
				  ItemNo, 
				  Category, 
				  UoM, 
				  UoMName, 
				  PriceSchedule, 
				  PriceScheduleDescription, 
				  PriceQuantity,
				  FieldDefault, 
				  ListingOrder, 
				  Promotion,
				  Currency, 
				  SalesPrice, 
				  PriceDate, 
				  PriorPrice, 
				  PriorDate, 
				  PriceOff, 
				  PriceOffPercentage )
	
		SELECT     Mission,	          
		           ItemNo, 
			       Category,			 
				   UoM,
				   UoMDescription as UoMName, 
				   PriceSchedule, 
				   PriceScheduleDescription, 
				   PriceQuantity,
				   FieldDefault, 
				   ListingOrder,
				   Promotion,
				   Currency, 
				   SalesPrice, 			  
				   PriceDate, 
				   PriorPrice, 
				   PriorDate,
				   ISNULL((SalesPrice-PriorPrice), 0) as PriceOff,
				   CASE	WHEN (PriorPrice = 0 OR PriorPrice IS NULL) THEN 0
						ELSE FLOOR(ISNULL((100*(PriorPrice - SalesPrice))/PriorPrice, 0)*-1) 
						END AS PriceOffPercentage			   
						
		FROM       (  SELECT MP.Mission,
				               I.Category,
							   MP.ItemNo, 
						       IU.UoMDescription,
							   MP.UoM, 
						       PriceSchedule, 							  
						       MP.Currency, 
							   
							    ( SELECT TOP (1) Promotion 
						         FROM   ItemUoMPrice AS LP INNER JOIN (	SELECT   ItemNo, 
																			     UoM, 
																			     PriceSchedule, 
																			     MAX(DateEffective) AS LastDate
																		FROM     ItemUoMPrice AS P
																		WHERE    Mission    = MP.Mission
																		AND      Currency   = MP.Currency
																		AND      DateEffective <= GETDATE()
																		GROUP BY ItemNo, 
																				 UoM, 
																				 PriceSchedule  ) AS L
											 ON L.ItemNo           = LP.ItemNo
												AND L.UoM            = LP.UoM
												AND L.PriceSchedule  = LP.PriceSchedule
												AND L.LastDate       = LP.DateEffective
												
												AND LP.ItemNo        = MP.ItemNo
												AND LP.UoM           = MP.UoM
												AND LP.PriceSchedule = MP.PriceSchedule
												
												AND LP.Mission       = MP.Mission
												AND LP.Currency      = MP.Currency
												
								) AS Promotion, 
							   							   
							   ( SELECT TOP (1) ROUND(LP.SalesPrice, 2) 
						         FROM   ItemUoMPrice AS LP INNER JOIN (	SELECT   ItemNo, 
																			     UoM, 
																			     PriceSchedule, 
																			     MAX(DateEffective) AS LastDate
																		FROM     ItemUoMPrice AS P
																		WHERE    Mission    = MP.Mission
																		AND      Currency   = MP.Currency
																		AND      DateEffective <= GETDATE()
																		GROUP BY ItemNo, 
																				 UoM, 
																				 PriceSchedule  ) AS L
											 ON L.ItemNo           = LP.ItemNo
												AND L.UoM            = LP.UoM
												AND L.PriceSchedule  = LP.PriceSchedule
												AND L.LastDate       = LP.DateEffective
												
												AND LP.ItemNo        = MP.ItemNo
												AND LP.UoM           = MP.UoM
												AND LP.PriceSchedule = MP.PriceSchedule
												
												AND LP.Mission       = MP.Mission
												AND LP.Currency      = MP.Currency
												
								) AS SalesPrice, 
								
							  ( SELECT TOP (1) LP.DateEffective AS Expr1
							    FROM  ItemUoMPrice AS LP INNER JOIN	( SELECT   ItemNo, 
																               UoM, 
																	           PriceSchedule, 
																	 		   MAX(DateEffective) AS LastDate
																	  FROM     ItemUoMPrice AS P
																	  WHERE    Mission = MP.Mission
																	  AND      Currency = MP.Currency
																	  AND      DateEffective <= GETDATE()
																	  GROUP BY ItemNo, 
																				UoM, 
																				PriceSchedule ) AS L_1 
																		
											ON L_1.ItemNo            = LP.ItemNo
												AND L_1.UoM           = LP.UoM
												AND L_1.PriceSchedule = LP.PriceSchedule
												AND L_1.LastDate      = LP.DateEffective
												
												AND LP.ItemNo         = MP.ItemNo
												AND LP.UoM            = MP.UoM
												AND LP.PriceSchedule  = MP.PriceSchedule
												AND LP.Mission        = MP.Mission
												AND LP.Currency       = MP.Currency
												
									            ORDER BY DateEffective DESC
												
								) AS PriceDate, 
								
								( SELECT TOP (1) LP.PriceQuantity AS Expr1
							      FROM  ItemUoMPrice AS LP INNER JOIN ( SELECT   ItemNo, 
																               UoM, 
																	           PriceSchedule, 
																	 		   MAX(DateEffective) AS LastDate
																	  FROM     ItemUoMPrice AS P
																	  WHERE    Mission = MP.Mission
																	  AND      Currency = MP.Currency
																	  AND      DateEffective <= GETDATE()
																	  GROUP BY ItemNo, 
																				UoM, 
																				PriceSchedule ) AS L_1 
																		
											ON L_1.ItemNo            = LP.ItemNo
												AND L_1.UoM           = LP.UoM
												AND L_1.PriceSchedule = LP.PriceSchedule
												AND L_1.LastDate      = LP.DateEffective
												
												AND LP.ItemNo         = MP.ItemNo
												AND LP.UoM            = MP.UoM
												AND LP.PriceSchedule  = MP.PriceSchedule
												AND LP.Mission        = MP.Mission
												AND LP.Currency       = MP.Currency
												
									            ORDER BY DateEffective DESC
												
								) AS PriceQuantity, 
								
								
								(	SELECT TOP (1) ROUND(LP.SalesPrice, 2) AS Expr1
									FROM ItemUoMPrice AS LP INNER JOIN 	(
										SELECT 	ItemNo, 
												UoM, 
												PriceSchedule, 
												MAX(DateEffective) AS LastDate
										FROM 	ItemUoMPrice AS P
										WHERE 	Mission = MP.Mission
											AND Currency = MP.Currency
											AND DateEffective <= GETDATE()
										GROUP BY 	ItemNo, 
													UoM, 
													PriceSchedule ) AS L_1 
													
										  ON L_1.ItemNo = LP.ItemNo
											    AND L_1.UoM = LP.UoM
											    AND L_1.PriceSchedule = LP.PriceSchedule
												AND L_1.LastDate > LP.DateEffective
												
												AND LP.ItemNo        = MP.ItemNo
												AND LP.UoM           = MP.UoM
												AND LP.PriceSchedule = MP.PriceSchedule
												AND LP.Mission       = MP.Mission
												AND LP.Currency      = MP.Currency
									            ORDER BY DateEffective DESC
												
								) AS PriorPrice, 
					
					
								(	SELECT TOP (1) LP.DateEffective AS Expr1
									FROM ItemUoMPrice AS LP	INNER JOIN	(
										SELECT ItemNo, 
											   UoM, 
											   PriceSchedule, 
											   MAX(DateEffective) AS LastDate
										FROM ItemUoMPrice AS P
										WHERE   Mission = MP.Mission
											AND Currency = MP.Currency
											AND DateEffective <= GETDATE()
										GROUP BY   ItemNo, 
												  UoM, 
												  PriceSchedule
									) AS L_1 ON L_1.ItemNo = LP.ItemNo
												AND L_1.UoM = LP.UoM
												AND L_1.PriceSchedule = LP.PriceSchedule
												AND L_1.LastDate > LP.DateEffective
												
												AND LP.ItemNo         = MP.ItemNo
												AND LP.UoM            = MP.UoM
												AND LP.PriceSchedule  = MP.PriceSchedule
												AND LP.Mission        = MP.Mission
												AND LP.Currency       = MP.Currency
									ORDER BY DateEffective DESC
									
								) AS PriorDate, 
								
						  S.Description AS PriceScheduleDescription, 
						  S.FieldDefault,
						  S.ListingOrder
						
					FROM  ItemUoMPrice AS MP
						  INNER JOIN Ref_PriceSchedule S ON MP.PriceSchedule = S.Code
						  INNER JOIN ItemUoM IU ON IU.ItemNo = MP.ItemNo AND IU.UoM = MP.UoM
						  INNER JOIN Item I ON I.ItemNo = MP.ItemNo
					
					<!---
					AND    IU.EnablePortal = '1'
					--->
					AND    Warehouse is NULL
					AND    S.Operational = 1
					AND    MP.Mission is not NULL
					
					GROUP BY MP.Mission, 
							 Currency, 
							 MP.ItemNo, 
							 MP.UoM,
							 IU.UoMDescription, 							 
							 I.Category,
							 MP.PriceSchedule, 							
							 S.Description, 
							 S.FieldDefault,
							 S.ListingOrder
								 
			      ) AS B	
				  
	WHERE  1=1			  
				  
</cfquery>			  

<!--- delete 0 --->

<cfquery name="Reset"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM skMissionItemPrice
	WHERE SalesPrice = 0
</cfquery>

<cfquery name="Default"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Ref_PriceSchedule WHERE FieldDefault = 1
</cfquery>

<cfquery name="Schedule"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Ref_PriceSchedule WHERE FieldDefault = 0 AND Operational = 1
</cfquery>

<cfif Default.recordcount eq "1">
	
	<cfloop query="Schedule">
	
		<cfquery name="Apply"
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			INSERT INTO  skMissionItemPrice
			    (Mission, 
			     ItemNo, 
				 Category, 
				 UoM, 
				 UoMName, 
				 PriceSchedule, 
				 PriceScheduleDescription, 
				 FieldDefault, 
				 ListingOrder, 
				 Currency, 
				 SalesPrice, PriceDate, PriorPrice, PriorDate, PriceOff, PriceOffPercentage, Created)
			
			SELECT     Mission, ItemNo, Category, UoM, UoMName, '#Code#', '#Description#', '0', ListingOrder, Currency, SalesPrice, PriceDate, PriorPrice, PriorDate, PriceOff, PriceOffPercentage, Created
			FROM       skMissionItemPrice AS K
			WHERE      PriceSchedule = '#default.code#' 
			AND        NOT EXISTS
			               (SELECT     'X' AS Expr1
			                FROM       skMissionItemPrice
			                WHERE      Mission = K.Mission 
							AND        ItemNo = K.ItemNo 
							AND        UoM = K.UoM 
							AND        SalesPrice <> 0 
							AND        PriceSchedule = '#code#' 
							AND        Currency = K.Currency)
		
		</cfquery>		
	
	</cfloop>
	
</cfif>
