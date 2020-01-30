<!--- initialization --->
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_Logging_Details">
<cfset url.action = "Operations">

<cfquery name="Create"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	CREATE TABLE dbo.#SESSION.acc#_Logging_Details (
	[ItemSupplyNo] [varchar] (20) NULL ,
	[ItemSupplyDescription] [varchar] (200) NULL ,
	[Location] [uniqueidentifier] NULL ,
	[LocationDescription] [varchar] (60) NULL ,
	[Category] [varchar] (20) NULL ,
	[ItemNo] [varchar] (20) NULL ,
	[ItemDescription] [varchar] (200) NULL ,
	[TransactionDate] [datetime] NULL ,
	[FuelConsumed] [float] NULL ,
	[Metric] [varchar] (200) NULL ,
	[MetricValue] [float] NULL ,
	[Ratio] [float] NULL ,
	[Target] [float] NULL)
</cfquery>

<cfquery name="Consumption" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">   
	SELECT  S.*, I.ItemDescription AS ItemDescription, U.UoMDescription AS UoMDescription
    FROM    ItemSupply S INNER JOIN
            Item I ON S.SupplyItemNo = I.ItemNo INNER JOIN
            ItemUoM U ON S.SupplyItemNo = U.ItemNo AND S.SupplyItemUoM = U.UoM	
</cfquery>

<cfloop query="Consumption">  

	<!---- Diesel, Petrol --->

	<cfquery name = "qLocations"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">   
			SELECT 	Distinct L.Location, L.LocationName 
			FROM    AssetItem AI INNER JOIN ItemSupply IMS 
					ON AI.ItemNo  = IMS.ItemNo 
			INNER JOIN Item I ON I.ItemNo = AI.ItemNo
			INNER JOIN AssetItemLocation AL ON 
					AI.AssetId = AL.AssetId AND Status!=9
		    INNER JOIN Location L ON L.Location = AL.Location					
			WHERE IMS.SupplyItemNo = '#Consumption.SupplyItemNo#'
	</cfquery>
	
	<cfloop query = "qLocations">
	
	<!--- Locations --->

	<cfquery name = "qItems"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">   
			SELECT Distinct AI.ItemNo, I.Category, I.ItemDescription
			FROM 
			AssetItem AI INNER JOIN ItemSupply IMS 
					ON AI.ItemNo  = IMS.ItemNo 
				INNER JOIN Item I ON I.ItemNo = AI.ItemNo
				INNER JOIN AssetItemLocation AL ON 
					AI.AssetId = AL.AssetId AND Status!=9				
			WHERE IMS.SupplyItemNo = '#Consumption.SupplyItemNo#'
			AND AL.Location = '#qLocations.Location#'
	</cfquery>

	<cfloop query = "qItems">
    
			<!---- ItemNos--->
	
			<cfquery name="Issues" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				 SELECT   CONVERT(VARCHAR(10),I.TransactionDate,126) as TransactionDate,
				          SUM(I.TransactionQuantity) as TransactionQuantityBase	
										  
				 FROM     ItemTransaction AS I INNER JOIN
		                  ItemSupply AS S ON S.SupplyItemNo = I.ItemNo AND S.SupplyItemUoM = I.TransactionUoM INNER JOIN
		                  AssetItem AI ON I.AssetId = AI.AssetId AND S.ItemNo = AI.ItemNo	INNER JOIN 
						  AssetItemLocation AL ON AI.AssetId = AL.AssetId AND Status!=9				
						  
				  
			     WHERE   AI.ItemNo = '#qItems.ItemNo#' 
				 AND 	 I.TransactionType = '2'
				 AND     I.ItemNo          = '#Consumption.SupplyItemNo#'
				 AND     I.TransactionUoM  = '#Consumption.SupplyItemUoM#'
				 AND     AL.Location = '#qLocations.Location#'				 
				 GROUP BY CONVERT(VARCHAR(10),I.TransactionDate,126)
				 ORDER BY CONVERT(VARCHAR(10),I.TransactionDate,126) 
			</cfquery>
			
			<cfquery name="getMetrics" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  A.Metric, R.Measurement
				FROM    Ref_AssetActionMetric A INNER JOIN
				        Ref_Metric R ON A.Metric = R.Code  
				WHERE   A.ActionCategory = '#url.action#' 
				AND     A.Category       = '#qItems.Category#'	
				AND     R.Operational    = 1
			</cfquery>	
	
			<cfloop query = "getMetrics">
			
				<!---- Metrics ---->
						
				<cfset i = 0 >			
				<cfloop query = "Issues">
				<!--- Issues ---->
				
					<cfif currentrow eq "1">
						<cfset prior = TransactionDate>
					<cfelseif currentrow gte "2">	
							<cfset i = i + 1 >
							
							<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#_Logging_#qItems.ItemNo#_#i#">	
		
							<cfquery name="MetricValues" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT   H.ActionDate, 
								         M.MetricValue	
								FROM     AssetItem I INNER JOIN AssetItemAction H ON I.AssetId = H.AssetId INNER JOIN
										 AssetItemActionMetric M ON H.AssetActionId  = M.AssetActionId INNER JOIN 
										 AssetItemLocation AL ON I.AssetId = AL.AssetId AND Status!=9			
								WHERE    I.ItemNo         = '#qItems.ItemNo#'
								AND      H.ActionCategory = '#url.action#'
								AND      M.Metric         = '#getMetrics.metric#'	
								AND      ActionDate >=   '#dateformat(prior,client.dateSQL)#'
								AND      ActionDate <=   '#dateformat(Issues.TransactionDate,client.dateSQL)#' 				
								AND      AL.Location = '#qLocations.Location#'						
								ORDER BY ActionDate	 
							</cfquery>								
									
						    <cfif getMetrics.Measurement eq "Cumulative">
								
								<cfloop query="MetricValues">
																				
								    <cfif currentrow eq "1">
										 <cfset opening = metricvalue>
										 
									</cfif> 
									
									<cfif recordcount eq currentrow>
										 <cfset closing = metricvalue> 				 
									</cfif>
		
								</cfloop>	
									
							<cfelse>
							
								<cfloop query="MetricValues">
									
									    <cfif currentrow eq "1">
											 <cfset opening = metricvalue>
											 <cfset closing = metricvalue>
										<cfelse>
											<cfset closing = closing+metricvalue>	 
										</cfif> 											
		
								</cfloop>				
							
							</cfif>		
		
							
							<cfset val = -transactionQuantityBase>				
							
							<cfif MetricValues.recordcount gte "1">
												
								<cfquery name="Target" 
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									 SELECT  *
									 FROM    ItemSupplyMetric
								     WHERE   ItemNo         = '#qItems.ItemNo#'
									 AND     SupplyItemNo   = '#Consumption.SupplyItemNo#'
									 AND     SupplyItemUoM  = '#Consumption.SupplyItemUoM#'
									 AND     Metric         = '#getMetrics.metric#'					
								</cfquery>								
							
								<cfset total = closing-opening>			
					
								<cfset tgt = target.targetratio>						
		
								<cfquery name="Create"
								datasource="AppsQuery" 	
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									INSERT INTO dbo.#SESSION.acc#_Logging_Details
									VALUES ( '#Consumption.SupplyItemNo#',
										'#Consumption.ItemDescription#',
										'#qLocations.Location#',
										'#qLocations.LocationName#',
										'#qItems.Category#',
										'#qItems.ItemNo#',
										'#qItems.ItemDescription#',
										'#dateformat(MetricValues.actiondate,client.dateSQL)#',
										#val#,
										'#getMetrics.metric#',								
										#total#,
										#total/val#,
										'#tgt#')																	
								</cfquery>
											
							</cfif>							
												
							<cfset prior = TransactionDate>
						</cfif>													
					
				<!---- Issuances ---->
				
				</cfloop>

			<!---- Metrics --->
			
			</cfloop>


    <!---- ItemNos--->
	</cfloop> 	
	
	<!--- Locations --->
	</cfloop>
	
<!---- Diesel, Petrol --->
</cfloop>	

