
<!--- Hanno 8/8 this will have to be adjusted to work this on the period, in this process we check if the parent 
is indeed enabled for that period, if not, we move this to the top of the hierarchy 

1. I need to check the usage of the hierarchy for the project activity manangement : children 
2. as well as the
children in the budget execution view.
--->

<!--- full periods review --->

<cfquery name="Drop"
	datasource="AppsPurchase">
      if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwItemMasterStandardCost]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwItemMasterStandardCost]
  </cfquery>

  <cfquery name="CreateView"
	datasource="AppsPurchase">
	CREATE VIEW dbo.vwItemMasterStandardCost
	AS
		
	SELECT IM.Code as ItemMaster,	
	       M.TopicValueCode,     
	       IM.Mission,	       
	       M.Location,	       
	       M.DateEffective,
	       ROUND(SUM(M.Total),2) AS StandardCost
	       
	FROM       
	
	(SELECT IMSC2.ItemMaster,IMSC2.Location,IMSC2.TopicValueCode,IMSC2.CostElement,IMSC2.CostAmount,IMSC2.DateEffective,IMSC2.CostOrder,
	  CASE IMSC2.CostBudgetMode   
			WHEN 1 THEN 
					IMSC2.CostAmount*(SELECT SUM(
												CASE IMSC3.CostBudgetMode   
												WHEN 1 THEN 
														IMSC3.CostAmount*(IMSC4.CostAmount)/100			
												WHEN 2 THEN	
													IMSC3.CostAmount
												WHEN 3 THEN	
													IMSC3.CostAmount
												END								
												) 
										FROM 
										Purchase.dbo.ItemMasterStandardCost IMSC3 LEFT OUTER JOIN
										Purchase.dbo.ItemMasterStandardCost IMSC4 ON 
											IMSC3.ItemMaster = IMSC4.ItemMaster
											AND IMSC3.DateEffective = IMSC4.DateEffective
											AND IMSC3.CostOrder>IMSC4.CostOrder
											AND IMSC3.TopicValueCode = IMSC4.TopicValueCode
										WHERE IMSC3.ItemMaster = IMSC2.ItemMaster
										AND IMSC3.DateEffective = IMSC2.DateEffective
										AND IMSC3.TopicValueCode = IMSC2.TopicValueCode
										AND IMSC3.CostOrder<IMSC2.CostOrder
										
										)/100
										
			WHEN 2 THEN	
				IMSC2.CostAmount
			WHEN 3 THEN	
				IMSC2.CostAmount
			END
			as Total
	FROM Purchase.dbo.ItemMasterStandardCost IMSC2 
	
	
	  ) M
	  
	  INNER JOIN Purchase.dbo.ItemMaster IM  ON IM.Code = M.ItemMaster
	  WHERE  M.DateEffective = (SELECT MAX(DateEffective) FROM ItemMasterStandardCost IMSC3 WHERE IMSC3.ItemMaster = M.ItemMaster)	  
	  GROUP BY IM.Code, 
	           IM.CodeDisplay, 
			   IM.Mission,
			   IM.Description,
			   IM.EntryClass,
			   M.DateEffective,
			   M.Location,
			   M.TopicValueCode	
	
  </cfquery>
  

<cf_programPeriodHierarchy>

<cf_message status="Notification" 
            message = "Program hierarchy has been successfully initialised. Please re-init language files if applicable"
            return = "back">
			