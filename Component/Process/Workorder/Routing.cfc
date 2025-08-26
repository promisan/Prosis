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
<cfcomponent output="false">

    <cfset VARIABLES.Instance = {} />
	<cfset VARIABLES.Instance.Matrix = "" />
	<cfset VARIABLES.Instance.driver_capacity = 0 />
	<cfset VARIABLES.Instance.number_cars = 0 />
	<cfset VARIABLES.Instance.listing_order = 0 />
	<cfset VARIABLES.Instance.date = "" />
	<cfset VARIABLES.Instance.depth = 2/>
	<cfset VARIABLES.Instance.debug = 0/>
	<cfset VARIABLES.Instance.driver = 0/>	 
	<cfset VARIABLES.Instance.start_latitude = 0/>	 
	<cfset VARIABLES.Instance.start_longitude = 0/>	 
	<cfset VARIABLES.Instance.delta = 0.05/>
	<cfset VARIABLES.Instance.mission = 0.05/>
	<cfset VARIABLES.Instance.country = 0.05/>
	<cfset VARIABLES.Instance.dateSQL = "">
	<cfset VARIABLES.Instance.WorkPlanMission = "">
	

 	 <cffunction name="init" access="public">
 	 	<cfargument name="date"   			required="true" type="string" default = "">
		<cfargument name="driver_capacity" 	required="false" type="numeric" default = 20>
		<cfargument name="debug" 			required="false" type="numeric" default = 0>
		<cfargument name="depth" 			required="false" type="numeric" default = 2>
		<cfargument name="mission" 			required="false" type="string" default = "">		
 	 	

		<cfset VARIABLES.Instance.DRIVER_CAPACITY = arguments.driver_capacity />
		<cfset VARIABLES.matrix = QueryNew("Node   , Zip    , Indicator, Proximity, OrgUnitOwner, OrgUnitOwnerName, WorkOrderLineId, CustomerName, Branch, Latitude, Longitude, Region,  Driver, Distance_from_SP, Duration_from_SP, MasterRoute, Evaluated",
										   "Integer, Varchar, Integer  , Integer  , Integer     , Varchar         , Varchar        , Varchar     ,Bit   , Double  , Double   , VarChar, VarChar, Double          , Double          , Integer    , Bit")>

		<cfset dateValue = "">
		<CF_DateConvert Value="#arguments.date#">
		<cfset DTS = dateValue>		
		<cfset VARIABLES.Instance.date    = DTS/>
		<cfset VARIABLES.Instance.debug   = arguments.debug/>
		<cfset VARIABLES.Instance.depth   = arguments.depth/>
		<cfset VARIABLES.Instance.mission = arguments.mission/>
		<cfset VARIABLES.Instance.dateSQL = DateFormat(arguments.date,"DDMMYYY")/>
		

		<cfquery name="qMission"
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT CountryCode
			FROM Ref_Mission 
			WHERE Mission = '#VARIABLES.Instance.mission#'
		</cfquery>			
		
		<cfset VARIABLES.Instance.country = qMission.CountryCode/>

	 </cffunction>	

	
	  <cffunction name="loadDeliveries" access="public" returntype="numeric">
		<cfargument name="date"   			required="true" type="string" default = "">
		<cfargument name="start_latitude"  	required="true" type="numeric" default = 0>
		<cfargument name="start_longitude" 	required="true" type="numeric" default = 0>
		<cfargument name="start_zip" 		required="true" type="numeric" default = 0>
		<cfargument name="driver_capacity" 	required="false" type="numeric" default = 20>
		<cfargument name="debug" 			required="false" type="numeric" default = 0>
		<cfargument name="depth" 			required="false" type="numeric" default = 2>
		<cfargument name="delta" 			required="false" type="numeric" default = 0.05>
		<cfargument name="mission" 			required="false" type="string" default = "">
	        
	    
	    <cfparam name="SESSION.units_scope" default="">

		<cfset init(
			date			= ARGUMENTS.date,
			driver_capacity = ARGUMENTS.driver_capacity,
			mission 		= ARGUMENTS.mission,
			debug			= ARGUMENTS.debug,
			depth			= ARGUMENTS.depth
		)>

	    <cfset prepareDB()>
	    
	    <cfset VARIABLES.Instance.start_latitude = arguments.start_latitude/>	 
	    <cfset VARIABLES.Instance.start_longitude = arguments.start_longitude/>	 
		<cfset VARIABLES.Instance.delta = arguments.delta/>

	 	<cfset CleanTables()>

		<cfset i=0>

		<cfquery name="qDeliveries"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
						SELECT   A.DateTimePlanning, 	
						         W.WorkOrderId,
								 WL.WorkOrderLineId,
								 W.OrgUnitOwner,
								 (SELECT OrgUnitName FROM Organization.dbo.Organization WHERE OrgUnit = W.OrgUnitOwner) as OrgUnitOwnerName,
								 C.PostalCode,
								 C.Address,
								 C.City,
						         C.CustomerName	
					    FROM     WorkOrder AS W 
								 INNER JOIN Customer as C ON W.CustomerId = C.CustomerId  
						         INNER JOIN WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId 
								 INNER JOIN WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine 
												
					   WHERE     A.ActionClass = 'Delivery' 
					   AND       A.DateTimePlanning = #dts#
					   AND       W.Mission = '#VARIABLES.Instance.mission#'		   	
					   AND       WL.Operational  = '1'
					   AND       W.ActionStatus != '9'
					   <cfif SESSION.units_scope neq "">
					   	    AND W.OrgUnitOwner in (#SESSION.units_scope#)
					   </cfif>							   
		</cfquery>
		
		<cfif qDeliveries.recordcount neq 0>
		
		<cfset setHistoricalSettings(Deliveries=qDeliveries.recordcount)>

		
		<cfloop query="qDeliveries">
			
			   <cfset setProgressData("Loading Deliveries")> 
			   			
			   <cfquery name="CheckDelivery"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					SELECT *
					FROM   stPostalCode
					WHERE  PostalCode = '#qDeliveries.PostalCode#'
			   	</cfquery>				
	
				<cfif CheckDelivery.recordcount eq "0">				   
					<cfset vLatitude = 0>
					<cfset vLongitude = 0>
				<cfelse>
					<cfset vLatitude  = CheckDelivery.latitude>
					<cfset vLongitude = CheckDelivery.longitude>
				</cfif>			
			
			  <cfset i=i+1>
		      <cfset variables.temp = QueryAddRow(variables.matrix, 1)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "Node", i)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "Zip", qDeliveries.PostalCode)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "OrgUnitOwner", qDeliveries.OrgUnitOwner)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "OrgUnitOwnerName", qDeliveries.OrgUnitOwnerName)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "WorkOrderLineId", qDeliveries.WorkOrderLineId)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "CustomerName", qDeliveries.CustomerName)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "Branch", 0)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "Latitude", vLatitude)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "Longitude", vLongitude)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "Region", "")>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "Distance_From_SP", 0)> 
			  <cfset variables.temp = QuerySetCell(variables.matrix, "Duration_From_SP", 0)>
			  <cfset variables.temp = QuerySetCell(variables.matrix, "Evaluated",0)>
			  
			  
			  <cfquery name="qUpdateCurrent"
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE skDeliveryMatrix_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# 
						SET CurrentDay = CurrentDay + 1
						WHERE OrgUnitOwner = '#qDeliveries.OrgUnitOwner#'
			  </cfquery>				  
			  
			  
			  
		</cfloop>	
		
		
		<cfquery name="qBranches" dbtype="Query">
			SELECT DISTINCT OrgUnitOwner, OrgUnitOwnerName  
			FROM qDeliveries
			WHERE OrgUnitOwner IS NOT NULL 
			AND OrgUnitOwnerName IS NOT NULL
		</cfquery>
		
		<cfloop query="qBranches">
		   <cfquery name="getBranchAddress"
		   datasource="appsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">			
				 SELECT *
				 FROM   Organization.dbo.Organization O, Organization.dbo.vwOrganizationAddress A
				 WHERE  O.OrgUnit = A.OrgUnit
				 AND    O.OrgUnit = '#qBranches.OrgUnitOwner#'
				 AND    AddressType = 'Office'
		  </cfquery>
		  
		  <cfset vPostalCode = "">
		  <cfif getBranchAddress.recordCount eq 0>
		  		<cfset vPostalCode = "2497NB">
		  <cfelseif getBranchAddress.postalCode eq "">
		  		<cfset vPostalCode = "2497NB">
		  <cfelse>
		  		<cfset vPostalCode = getBranchAddress.postalCode> 
		  </cfif>	
				
			<cfif vPostalCode neq "">		
						
				  <cfset i=i+1>   
				  
		        	<cfset setProgressData("Loading Branches")> 
				  
				  
				  <cfquery name="CheckBranch"
					datasource="appsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
						SELECT *
						FROM   stPostalCode
						WHERE  PostalCode = '#getbranchaddress.PostalCode#'
				  </cfquery>				  
				  
					<cfif CheckBranch.recordcount eq "0">				   
						<cfset vLatitude = 0>
						<cfset vLongitude = 0>
					<cfelse>
						<cfset vLatitude  = CheckBranch.latitude>
						<cfset vLongitude = CheckBranch.longitude>
					</cfif>				  
				  
			      <cfset variables.temp = QueryAddRow(variables.matrix, 1)>
			      <cfset variables.temp = QuerySetCell(variables.matrix, "Node", i)>
			      <cfset variables.temp = QuerySetCell(variables.matrix, "Zip", getbranchaddress.PostalCode)>
			      <cfset variables.temp = QuerySetCell(variables.matrix, "OrgUnitOwner", qBranches.OrgUnitOwner)>
			      <cfset variables.temp = QuerySetCell(variables.matrix, "OrgUnitOwnerName", qBranches.OrgUnitOwnerName)>
			      <cfset variables.temp = QuerySetCell(variables.matrix, "WorkOrderLineId", "")>
			      <cfset variables.temp = QuerySetCell(variables.matrix, "Branch", 1)>
			      <cfset variables.temp = QuerySetCell(variables.matrix, "Latitude", vLatitude)>
			      <cfset variables.temp = QuerySetCell(variables.matrix, "Longitude", vLongitude)>
			      <cfset variables.temp = QuerySetCell(variables.matrix, "Region", getRegion(
																						start_latitude	= VARIABLES.Instance.start_latitude, 
																						start_longitude	= VARIABLES.Instance.start_longitude, 
																						to_latitude		= vLatitude,
																						to_longitude	= vLongitude))>
	
				  <cfset vDistance = getDistanceFromOrigin(destination = "#vLatitude#,#vLongitude#")>
	
				  <cfset variables.temp = QuerySetCell(variables.matrix, "Distance_From_SP",vDistance.Distance)> 
				  <cfset variables.temp = QuerySetCell(variables.matrix, "Duration_From_SP",vDistance.Duration)>
				  <cfset variables.temp = QuerySetCell(variables.matrix, "Evaluated",0)>
		    </cfif>
		    
		</cfloop>
		
		</cfif>					
			
		<cfset VARIABLES.Instance.Matrix = variables.matrix>	
		<cfreturn qDeliveries.recordcount> 

	  </cffunction>
	  

	  <cffunction name="prepareDB" access="public">
	  		  
	  		<CF_DropTable dbName="AppsQuery" tblName="skRoutesTemp_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#">  
	  		<CF_DropTable dbName="AppsQuery" tblName="skDeliveryMatrix_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#">
			
	  		<cfquery name="qRemoveTemp"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				CREATE TABLE skRoutesTemp_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(
					_Year int NOT NULL,
					_Month int NOT NULL,
					_Day int NOT NULL,
					OrgUnitOwner int NOT NULL,
					PositionNo int NOT NULL,
					WorkActionId uniqueidentifier NULL)
			</cfquery>	
			
		
	  		<cfquery name="qGetHistoricalRoutes"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Userquery.dbo.skRoutesTemp_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# (_Year, _Month, _Day, OrgUnitOwner,PositionNo,WorkActionId)
						SELECT   Year(W.DateEffective) as _Year, 	
						         Month(W.DateEffective) as _Month,
								 Day(W.DateEffective) as _Day,
								 WO.OrgUnitOwner,
								 W.PositionNo,
								 WD.WorkActionId
						FROM     WorkPlan W 
									INNER JOIN WorkPlanDetail WD 	
								 		ON W.WorkPlanId = WD.WorkPlanId 
								 	INNER JOIN WorkOrderLineAction WA 
								 		ON WA.WorkActionId = WD.WorkActionId 
								 	INNER JOIN WorkOrderLine WOL 
								 		ON WOL.WorkOrderId = WA.WorkOrderId AND WOL.WorkOrderLine = WA.WorkOrderLine
								 	INNER JOIN WorkOrder WO
								 		ON WO.WorkOrderId = WOL.WorkOrderId
						AND      W.DateEffective >= Dateadd(Day, -3, getdate())
						AND      PositionNo IS NOT NULL AND PositionNo!=''
	  		</cfquery>		

			
	  		<cfquery name="qGetHistoricalRoutes"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO skRoutes (_Year, _Month, _Day, OrgUnitOwner, PositionNo,  Total)
						SELECT   _Year, 	
						         _Month,
								 _Day,
								 OrgUnitOwner,	
								 PositionNo,												
						         COUNT(WorkActionId) as Total
						FROM     Userquery.dbo.skRoutesTemp_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# T
						WHERE    PositionNo IS NOT NULL AND PositionNo!=''
						AND NOT EXISTS
						(
							SELECT 'X'
							FROM skRoutes
							WHERE _Year  = T._Year
							AND   _Month = T._Month
							AND   _Day   = T._Day
							AND OrgUnitOwner =  T.OrgUnitOwner
							AND PositionNo =   T.PositionNo
							
						)
						GROUP BY _Year,_Month,_Day,OrgUnitOwner, PositionNo
	  		</cfquery>			



             <cfquery name="qInsertBranches"
                   datasource="appsWorkOrder" 
                   username="#SESSION.login#" 
                   password="#SESSION.dbpw#">               
                   INSERT INTO skWorkPlanDriverBranches (OrgUnitOwner,PositionNo,PlanOrderCode,Counter)
                          SELECT   WO.OrgUnitOwner,W.PositionNo, WD.PlanOrderCode, COUNT(DISTINCT WO.OrgUnitOwner) as Counter
							FROM     WorkPlan W 
										INNER JOIN WorkPlanDetail WD 	
									 		ON W.WorkPlanId = WD.WorkPlanId 
									 	INNER JOIN WorkOrderLineAction WA 
									 		ON WA.WorkActionId = WD.WorkActionId 
									 	INNER JOIN WorkOrderLine WOL 
									 		ON WOL.WorkOrderId = WA.WorkOrderId AND WOL.WorkOrderLine = WA.WorkOrderLine
									 	INNER JOIN WorkOrder WO
									 		ON WO.WorkOrderId = WOL.WorkOrderId
							AND W.DateEffective >= Dateadd(Day, -3, getdate()) 
							AND PositionNo IS NOT NULL AND PositionNo!=''
							AND NOT EXISTS
							(
								SELECT 'X'
								FROM skWorkPlanDriverBranches
								WHERE OrgUnitOwner  = WO.OrgUnitOwner
								AND   PositionNo    = W.PositionNo
								AND   PlanOrderCode = WD.PlanOrderCode
								
							)							
							GROUP BY WO.OrgUnitOwner,W.PositionNo, WD.PlanOrderCode
             </cfquery>                                             


						

			<cfquery name="qZips"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT Distinct OrgUnitOwner 
					FROM skRoutes
					WHERE OrgUnitOwner!=''
			</cfquery>	
		
			<cfquery name="qCreateMatrix"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				CREATE TABLE skDeliveryMatrix_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
				(
					PositionNo   int,
					OrgUnitOwner int,
					Percentage   Float,
					CurrentDay   Int
				)
			</cfquery>				
			
			<cfquery name="qPositions"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT Distinct PositionNo 
					FROM skRoutes
					WHERE PositionNo!=''
			</cfquery>	
			
			<cfloop query="qPositions">
					
					<cfquery name="qZips"
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT OrgUnitOwner, SUM(Total) as Total
							FROM skRoutes
							WHERE PositionNo = '#qPositions.PositionNo#'
							GROUP BY OrgUnitOwner
					</cfquery>	


					<cfset setProgressData("Loading Historical Drivers")>					
					
					<cfquery name="qZipsTotal"
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT SUM(total) as Total
							FROM skRoutes
							WHERE PositionNo = '#qPositions.PositionNo#'
					</cfquery>									
			
					<cfloop query="qZips">

						<cfset vRatio = (#qZips.total#/#qZipsTotal.total#)*100>
	
						<cfquery name="qPeopleInsert"
							datasource="AppsQuery" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								INSERT INTO skDeliveryMatrix_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(PositionNo,OrgUnitOwner,Percentage, CurrentDay)
								Values ('#qPositions.PositionNo#','#qZips.OrgUnitOwner#',#Round(vRatio)#,0)
						</cfquery>		

					</cfloop>
			
			</cfloop>

		
		
	 </cffunction>
	 
	<cffunction name="setHistoricalSettings">
		<cfargument name="deliveries" required="true" type="numeric">
	
	
			<CF_DropTable dbName="AppsTransaction" tblName="stWorkPlanSelection_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#">
			<CF_DropTable dbName="AppsTransaction" tblName="stWorkPlanSettings_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#">
			<CF_DropTable dbName="AppsQuery" tblName="stWorkPlanSummary_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#">
			<CF_DropTable dbName="AppsTransaction" tblName="stWorkPlanSummaryDrivers_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#">
				
				
			<cfset vDelta = Ceiling(Arguments.Deliveries*VARIABLES.Instance.delta)>
			<cfset vLowLimit = Round(Arguments.Deliveries-vDelta)>
			<cfset vHighLimit = Round(Arguments.Deliveries+vDelta)>
			
			<cfquery name="qCheckLimits"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">					
				SELECT #VARIABLES.Instance.date#,_year,_month,_day,SUM(total),COUNT(DISTINCT PositionNo)
				FROM skRoutes
				GROUP BY _Year,_Month,_Day
				HAVING SUM(total)>#vLowLimit# and SUM(total)<#vHighLimit#	
			</cfquery>
			
			<cfif qCheckLimits.recordcount eq 0>
				<!---- This means the limits are off as nothign was found, Prosis will iterate until it found some--->
				<cfset vFound = FALSE>
				
				<cfloop condition="NOT vFound">
					
					<cfset vLowLimit = Round(vLowLimit-vDelta)>
					<cfset vHighLimit = Round(vHighLimit+vDelta)>

					<cfset setProgressData("Setting driver conditions")>
					
					<cfquery name="qCheckLimits"
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">					
						SELECT #VARIABLES.Instance.date#,_year,_month,_day,SUM(total),COUNT(DISTINCT PositionNo)
						FROM skRoutes
						GROUP BY _Year,_Month,_Day
						HAVING SUM(total)>#vLowLimit# and SUM(total)<#vHighLimit#	
					</cfquery>
					
					<cfif qCheckLimits.recordcount neq 0>	
						<cfset vFound = TRUE>
					</cfif>				
				</cfloop>
			</cfif>			




			<cfquery name="qCreatePlanSummary"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				CREATE TABLE stWorkPlanSummary_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(
						Date datetime NOT NULL,
						_Year int NOT NULL,
						_Month int NOT NULL,
						_Day int NOT NULL,
						TotalDeliveries int NULL,
						TotalDrivers int NULL)
			</cfquery>

			<cfquery name="qInsertSummary"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				INSERT INTO Userquery.dbo.stWorkPlanSummary_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(Date,_Year,_Month,_Day, TotalDeliveries, TotalDrivers)
				SELECT #VARIABLES.Instance.date#,_year,_month,_day,SUM(total),COUNT(DISTINCT PositionNo)
				FROM skRoutes
				GROUP BY _Year,_Month,_Day
				HAVING SUM(total)>#vLowLimit# and SUM(total)<#vHighLimit#			
			</cfquery>			
			
			<cfquery name="qWPSettings"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				CREATE TABLE stWorkPlanSettings_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(
					Date datetime NOT NULL,
					Total int NULL,
					LowLimit int NULL,
					HighLimit int NULL,
					CapacityPerDriver int NULL,
					CapacityPerDriverManual int NULL,
					TotalDriversManual int NULL)
			</cfquery>				
			

			<cfquery name="qWPSelection"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					CREATE TABLE stWorkPlanSelection_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(
						ClusterNo int IDENTITY(1,1) NOT NULL,
						RouteId uniqueidentifier NULL,
						Date date NULL,
						Step int NULL,
						Created datetime NULL,
						CONSTRAINT PK_stWorkPlanSelection_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# PRIMARY KEY CLUSTERED 
						(ClusterNo ASC))
			</cfquery>
	
	
			<cfquery name="qInsertSettings"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO stWorkPlanSettings_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(Date,Total, LowLimit,HighLimit)
				VALUES(#VARIABLES.Instance.date#, '#ARGUMENTS.Deliveries#', '#vLowLimit#', '#vHighLimit#')
			</cfquery>
			
			
			<cfquery name="qSummaryDrivers"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				CREATE TABLE stWorkPlanSummaryDrivers_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(
					Date datetime NOT NULL,
					TotalDrivers int NOT NULL,
					TotalUsed int NULL,
					TotalUsedPercentage float NULL)
			</cfquery>					
			
			
			<cfquery name="qInsertSummaryDrivers"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				INSERT INTO stWorkPlanSummaryDrivers_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(Date,TotalDrivers,TotalUsed,TotalUsedPercentage)		
					SELECT Date,TotalDrivers,COUNT(1), 0
					FROM Userquery.dbo.stWorkPlanSummary_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
					WHERE Date = #VARIABLES.Instance.date#
					GROUP BY Date,TotalDrivers
					ORDER BY COUNT(1) DESC
			</cfquery>				
			
			
			<cfquery name="qUpdateDriversPercentage"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				 UPDATE stWorkPlanSummaryDrivers_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
				 SET TotalUsedPercentage = (TotalUsed* 100 / (Select Sum(TotalUsed) FROM stWorkPlanSummaryDrivers_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# WHERE Date=#VARIABLES.Instance.date#))	
				 WHERE Date = #VARIABLES.Instance.date#	
			</cfquery>
			
			
			<cfset setDriverCapacity()>

	</cffunction>


	<cffunction name="setDriverCapacity">

			<CF_DropTable dbName="AppsQuery" tblName="stWorkPlanSuggestedDrivers_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#">
	
			<cfquery name="qSettings"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				 SELECT *
			     FROM stWorkPlanSettings_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
				 WHERE Date = #VARIABLES.Instance.date#
			</cfquery>	
			
			
			<cfquery name="qHistoryDrivers"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT TOP 1 *
			     FROM stWorkPlanSummaryDrivers_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
				 WHERE Date = #VARIABLES.Instance.date#
				 ORDER BY TotalUsedPercentage DESC
			</cfquery>		
			

			<cfset vDeliveriesPerDriver = Round(qSettings.Total/qHistoryDrivers.TotalDrivers)>
			<cfset VARIABLES.Instance.driver_capacity =  Round(vDeliveriesPerDriver+vDeliveriesPerDriver*VARIABLES.Instance.delta)/>	
			
			<cfquery name="qUpdatSettings"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE stWorkPlanSettings_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
				SET CapacityPerDriver = '#VARIABLES.Instance.driver_capacity#'
				 WHERE Date =#VARIABLES.Instance.date#
			</cfquery>		

			<cfset VARIABLES.Instance.number_cars = qHistoryDrivers.TotalDrivers />
			
			<cfquery name="qSuggestedDrivers"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					SELECT #VARIABLES.Instance.date# Date, PositionNo, SUM(Total) Total
					INTO Userquery.dbo.stWorkPlanSuggestedDrivers_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# 
					FROM skRoutes R
					WHERE EXISTS
					(
						SELECT 'X' FROM
						Userquery.dbo.stWorkPlanSummary_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# O
						WHERE TotalDrivers= '#qHistoryDrivers.TotalDrivers#'
						AND O._day        = R._Day
						AND O._month      = R._Month
						AND O._year       = R._Year
					)
					GROUP BY PositionNo
					ORDER BY SUM(total) DESC	
			</cfquery>	
			
			<cfquery name="qOrdering"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT * 
				FROM stWorkPlanSuggestedDrivers_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#	
				WHERE Date =#VARIABLES.Instance.date#		
				ORDER BY Total DESC
			</cfquery>			
			
			<cfset counted = 0>
			<cfloop query="qOrdering">
				<cfset counted = counted +1>
				<cfif counted gt VARIABLES.Instance.number_cars >
						<cfquery name="qDelete"
							datasource="AppsQuery" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">				
							DELETE stWorkPlanSuggestedDrivers_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#	
							WHERE Date     = #VARIABLES.Instance.date#
							AND PositionNo = '#qOrdering.PositionNo#'
						</cfquery>												
				</cfif>
			</cfloop>
			
	
	</cffunction>

	 
	 
	 
	 
	 <cffunction name="CleanTables" access="public">
	 	
			<CF_DropTable dbName="AppsTransaction" tblName="stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#">
			<CF_DropTable dbName="AppsTransaction" tblName="stWorkPlan_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#">
			<CF_DropTable dbName="AppsTransaction" tblName="stWorkPlanDetails_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#">	
			<CF_DropTable dbName="AppsTransaction" tblName="stWorkPlanSelection_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#">

	  		<cfquery name="qCreateNodes"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				CREATE TABLE stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(
					Date date NOT NULL,
					Node int NOT NULL,
					ZipCode varchar(10) NULL,
					OrgUnitOwner int NULL,
					WorkOrderLineId uniqueidentifier NULL,
					CustomerName varchar(50) NULL,
					Branch varchar(50) NULL,
					Latitude float NULL,
					Longitude float NULL,
					Region varchar(10) NULL,
					Distance_from_SP float NULL,
					Duration_from_SP float NULL,
					MasterRoute bit NULL,
					ActionStatus varchar(2) NULL
				 CONSTRAINT PK_stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# PRIMARY KEY CLUSTERED 
				(
					Date ASC,
					Node ASC
				)) 			
	  		</cfquery>


			<cfquery name="qCreateWP" datasource="AppsTransaction">
				CREATE TABLE stWorkPlan_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(
					RouteId uniqueidentifier NOT NULL,
					Date date NOT NULL,
					Region varchar(100) NULL,
					Step int NULL,
					PositionNo int NULL,
					PersonNo varchar(20) NULL,
					ActionStatus varchar(2) NOT NULL
					CONSTRAINT PK_stWorkPlan_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# 
					PRIMARY KEY CLUSTERED (RouteId ASC))
			</cfquery>		
				
			<cfquery name="qCreateWPD" datasource="AppsTransaction">
				CREATE TABLE stWorkPlanDetails_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#(
					RouteId uniqueidentifier NOT NULL,
					Date date NOT NULL,
					Node int NOT NULL,
					Distance float NULL,
					Duration float NULL,
					ActionStatus varchar(2) NOT NULL,
					ListingOrder int NULL,
					PlanOrder varchar(10) NULL,
 					CONSTRAINT PK_stFlow_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# 
 					PRIMARY KEY CLUSTERED (RouteId ASC,Date ASC,Node ASC))
			</cfquery>		

	  		<cfquery name="qRemoveInvalidWeights"
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM PostalDistance   
				WHERE (Distance = 0 AND Duration = 0) OR PostalCodeFrom=''
			</cfquery>	
	 	
	 </cffunction>	
	  
	  <cffunction name="writeDB" access="public">
				
			<cfquery name="qAll" dbtype="Query">
				SELECT *
				FROM VARIABLES.Instance.Matrix 
			</cfquery>	
	

			<cfloop query="qAll">
				
				<cfset setProgressData("Writing results")>
				
				<cfquery name="qCheck" datasource="AppsTransaction">
					SELECT * FROM stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
					WHERE Date = #VARIABLES.Instance.date#
					AND   Node = '#qAll.Node#'
				</cfquery>
				
				<cfif qCheck.recordcount eq 0>
					<cfquery name="qInsertNode" datasource="AppsTransaction">
						INSERT INTO stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
						           (Date
						           ,Node
						           ,ZipCode
						           ,OrgUnitOwner
						           <cfif qAll.WorkOrderLineId neq "">
						           		,WorkOrderLineId
						           </cfif>	
						           ,CustomerName
						           ,Branch
						           ,Latitude
						           ,Longitude
						           ,Region
						           ,Distance_from_SP
						           ,Duration_from_SP
						           ,MasterRoute
						           ,ActionStatus)
						     VALUES
						           (#VARIABLES.Instance.date#
						           ,'#qAll.Node#'
						           ,'#qAll.Zip#'
						           ,'#qAll.OrgUnitOwner#'
						           <cfif qAll.WorkOrderLineId neq "">
						           	  ,'#qAll.WorkOrderLineId#'
						           </cfif>
						           ,'#qAll.CustomerName#'
						           ,'#qAll.Branch#'
						           ,'#qAll.Latitude#'
						           ,'#qAll.Longitude#'
						           ,'#qAll.Region#'
						           ,'#qAll.Distance_from_SP#'
						           ,'#qAll.Duration_from_SP#'
						           ,'#qAll.MasterRoute#'
						           ,0)
					</cfquery>
				</cfif>

           </cfloop>			

	  </cffunction>
	  
	  
	  <cffunction name="uploadDeliveries" access="public" returntype="numeric">
		<cfargument name="date"   			required="true" type="string" default = "">
		<cfargument name="driver_capacity" 	required="false" type="numeric" default = 20>
		<cfargument name="debug" 			required="false" type="numeric" default = 0>
		<cfargument name="depth" 			required="false" type="numeric" default = 2>
		<cfargument name="mission" 			required="false" type="string" default = "">
	         
		<cfset init(
			date			= ARGUMENTS.date,
			driver_capacity = ARGUMENTS.driver_capacity,
			mission 		= ARGUMENTS.mission,
			debug			= ARGUMENTS.debug,
			depth			= ARGUMENTS.depth
		)>

		<cfquery name="qDeliveries"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
						SELECT   *
					    FROM     stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#												
					   	WHERE    Date = #dts#
					   	AND      ActionStatus = '0'
					   	ORDER BY Node ASC
		</cfquery>

		<cfset i = 0>
		<cfif qDeliveries.recordcount neq 0>
			<cfloop query="qDeliveries">
			  
			  <cfset setProgressData("Calculating route")>
			  	
			  <cfset i = i + 1>	

			  <cfif i neq qDeliveries.Node>			  
			  	  <cfloop index = "j" from = "#i#" to = "#qDeliveries.Node-1#">
			  	  		<cfset variables.temp = QueryAddRow(variables.matrix, 1)>
			  	  </cfloop>				  	
	  			  <cfset i = qDeliveries.Node>
			  </cfif>

		      <cfset variables.temp = QueryAddRow(variables.matrix, 1)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "Node", qDeliveries.Node)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "Zip", qDeliveries.ZipCode)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "OrgUnitOwner", qDeliveries.OrgUnitOwner)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "WorkOrderLineId", qDeliveries.WorkOrderLineId)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "CustomerName", qDeliveries.CustomerName)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "Branch", qDeliveries.Branch)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "Latitude", qDeliveries.Latitude)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "Longitude", qDeliveries.Longitude)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "Region", qDeliveries.Region)>
		      <cfset variables.temp = QuerySetCell(variables.matrix, "Distance_From_SP", qDeliveries.Distance_From_SP)> 
			  <cfset variables.temp = QuerySetCell(variables.matrix, "Duration_From_SP", qDeliveries.Duration_From_SP)>
			  <cfset variables.temp = QuerySetCell(variables.matrix, "MasterRoute",qDeliveries.MasterRoute)>
	
			
			</cfloop>	
		
			<cfset setDriverCapacity()>
			<cfset VARIABLES.Instance.Matrix = variables.matrix>
		</cfif>
		
		<cfreturn qDeliveries.recordcount> 
		
	  </cffunction>
	  
	  
	  
	  
	  <cffunction name="getDate" returntype="any" access="public">
	  		
	  		<cfreturn VARIABLES.Instance.date>
	  		 
	  </cffunction>	
	  
	  <cffunction name="isOffRoad" returntype="boolean" access="public">
	  		<cfargument name="From" 	required="true" type="numeric" >
	  		<cfargument name="To" 		required="true" type="numeric" >
			
			<cfset var qFrom 			= ''>
			<cfset var qTo	 			= ''>
			<cfset var vZipFrom			= ''>
			<cfset var vZipTo			= ''>
			<cfset var qCheckException	= ''>
			<cfset var qCheckOffRoad	= ''>
			<cfset var qInsertException	= ''>
			
			

			<cfquery name="qFrom" dbtype="Query">
				SELECT *
				FROM VARIABLES.Instance.Matrix
				WHERE Node = '#Arguments.From#' 
			</cfquery>	
	  		
	  		<cfset vZipFrom = Left(rtrim(ltrim(qFrom.Zip)),2)>
	  		
			<cfquery name="qTo" dbtype="Query">
				SELECT *
				FROM VARIABLES.Instance.Matrix
				WHERE Node = '#Arguments.To#' 
			</cfquery>	
			
			<cfset vZipTo = Left(rtrim(ltrim(qTo.Zip)),2)>
			
			
			<cfif vZipFrom neq vZipTo>
					<cfquery name="qCheckException"
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * FROM skRoutesExceptions
						WHERE (ZipFrom = '#vZipFrom#' AND ZipTo = '#vZipTo#')
						OR  
						(ZipFrom = '#vZipTo#' AND ZipTo = '#vZipFrom#')
					</cfquery>	
		
					<cfif qCheckException.recordcount eq 0>
						<!---Now checking the historical of this combination, if any, then we are good, if not then what is the probabily of bundle them together --->	  	
						<cfquery name="qCheckOffRoad"
							datasource="appsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT SUM(Total) as Total 
								FROM skRoutes R1
								WHERE PostalCode = '#vZipFrom#'
								AND EXISTS 
								(
									SELECT 'X'
									FROM skRoutes R2
									WHERE     R2.PostalCode = '#vZipTo#'
									AND       R2.PositionNo = R1.PositionNo
									AND       R2._Year      = R1._Year
								    AND       R2._Month     = R1._Month
									AND       R2._Day       = R1._Day						
								)
								AND R1.PositionNo = '#VARIABLES.Instance.driver#'
						</cfquery>				  		
						
						
						<cfquery name="qCheckOffRoad_All"
							datasource="appsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT SUM(Total) as Total 
								FROM skRoutes R1
								WHERE PostalCode = '#vZipFrom#'
								AND EXISTS 
								(
									SELECT 'X'
									FROM skRoutes R2
									WHERE     R2.PostalCode != '#vZipTo#'
									AND       R2.PositionNo = R1.PositionNo
									AND       R2._Year      = R1._Year
								    AND       R2._Month     = R1._Month
									AND       R2._Day       = R1._Day						
								)
								AND R1.PositionNo = '#VARIABLES.Instance.driver#'
						</cfquery>								
						
						<cfif qCheckOffRoad.recordcount eq 0 or qCheckOffRoad.total eq "">
							<cfreturn TRUE>
						</cfif>
						
						<cfif qCheckOffRoad_All.recordcount eq 0 or qCheckOffRoad_All.total eq "">
							<cfreturn FALSE>
						</cfif>						
						
						
						<cfif (100*(qCheckOffRoad.Total/qCheckOffRoad_all.Total)) gte 40>
							<cfreturn FALSE>
						<cfelse>
							<!--- Very unlikely this is a usual path so it is OFFROAD, it is logged so it helps next time--->
							<cfquery name="qInsertException"
								datasource="appsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								INSERT INTO skRoutesExceptions(ZipFrom,ZipTo)
								VALUES ('#vZipFrom#','#vZipTo#')
							</cfquery>	
							<cfreturn TRUE>	
						</cfif>
					<cfelse>
						<!--- the combination has been found in the exception list, thus we need to return that the combination is OFFROAD --->
					  <cfreturn TRUE>	
					</cfif>		
			<cfelse>
				<cfreturn FALSE>
			</cfif> <!---- comparison between zipfrom and zipto --->
	  	
	  		
	  </cffunction>	
	  
	  <cffunction name="writeResults" access="public">
		<cfargument name="Routes" required="true" type="array">
		<cfargument name="Step"   required="true" type="any">
		<cfargument name="ActionStatus"   required="false" type="numeric" default=0>
		
		
				<cfloop array=#Arguments.ROUTES# index="element">
					
					<cfset setProgressData("Finalizing")>
					
		    		<cfif ArrayLen(element.Routes) gt 0>
		    			<cfset writeResults(Routes= element.Routes, Step=Arguments.Step, ActionStatus=Arguments.ActionStatus)>
		    		<cfelse>
		    			<cf_assignId>
		    			<cfset id = rowguid>
						
						<cfset i = 0>
						
		    			<cfloop query="element.Path">
		    				
		    				<cfif Element.Path.Branch eq "1">
		    					<cfquery name="qCheck" dbtype="query" >
			    					SELECT * 
		    						FROM element.Path
		    						WHERE OrgUnitOwner ='#Element.Path.OrgUnitOwner#' 
		    						AND Branch = 0 
		    					</cfquery>
		    					
		    					<cfif qCheck.recordcount gt 0>
		    						<cfset doIt = 1>
		    					<cfelse>
		    						<cfset doIt = 0>
		    					</cfif>	
		    					
		    				<cfelse>
		    					<cfset doIt = 1>	
		    				</cfif>	
		    				
		    				<cfif doIt eq 1>
								
								<cfset i = i + 1>
										    					
		    					<cfif i eq 1>
			    					<cfquery name="qCheckFirst" dbtype="query" >
				    					SELECT * 
			    						FROM element.Path
			    						WHERE Listing_Order = 1 
			    					</cfquery>
			    					
			    					
			    					<cfquery name="qCheckRegion" dbtype="query" >
				    					SELECT * 
			    						FROM VARIABLES.Instance.Matrix
			    						WHERE Node ='#qCheckFirst.Node#' 
			    					</cfquery>
		    						
									<cfquery name="qInsertNode" datasource="AppsTransaction">
										INSERT INTO stWorkPlan_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
										           (RouteId
										           ,Date
										           ,Region
												   ,PositionNo
										           ,Step
										           ,ActionStatus)
										     VALUES
										           ('#Id#'
										           ,#VARIABLES.Instance.date#
										           ,'#qCheckRegion.Region#'
												   ,'#VARIABLES.Instance.driver#'
										           ,'#ARGUMENTS.Step#'
										           ,'#ARGUMENTS.ActionStatus#')
									</cfquery>
		    							
		    					</cfif>	
		    					
								<cfquery name="qInsertNode" datasource="AppsTransaction">
									INSERT INTO stWorkPlanDetails_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
									           (RouteId,
									           Date
									           ,Node
									           ,Duration
									           ,Distance
									           ,ListingOrder
									           ,PlanOrder
									           ,ActionStatus)
									     VALUES
									           ('#Id#'
									           ,#VARIABLES.Instance.date#
									           ,'#element.Path.Node#'
									           ,'#element.Path.Duration#'
									           ,'#element.Path.Distance#'
									           ,'#element.Path.Listing_Order#'
									           ,NULL
									           ,'#ARGUMENTS.ActionStatus#')
								</cfquery>
								
								<cfquery name="qUpdateNode" datasource="AppsTransaction">
									UPDATE stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
									SET ActionStatus = '#ARGUMENTS.ActionStatus#'
									WHERE Node = '#element.Path.Node#'
									AND   Date = #VARIABLES.Instance.date#
								</cfquery>	
								
							</cfif>
		    			</cfloop>	
		    		</cfif>
				</cfloop>
				

				<cfquery name="qWorkPlan" datasource="AppsTransaction">
					SELECT * 
					FROM stWorkPlan_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
					WHERE ActionStatus  = '#ARGUMENTS.ActionStatus#'
					AND   Step          = '#ARGUMENTS.Step#'
				</cfquery>	
				
				<cfloop query="qWorkPlan">
					<cfquery name="qWorkPlanDetails" datasource="AppsTransaction">
						SELECT D.*,N.Branch FROM stWorkPlanDetails_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# D INNER JOIN stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# N 
							ON D.Node = N.Node AND D.Date = N.Date
						WHERE D.RouteId = '#qWorkPlan.RouteId#'
						ORDER BY D.ListingOrder
					</cfquery>				

					<cfset k = 0>
					<cfset current_order = 1>
					
					<cfloop query="qWorkPlanDetails">
							<cfif qWorkPlanDetails.Branch eq 0>
		    					<cfset k = k + 1>
							</cfif>	
		    				
							<cfquery name="qTimeSlot"
								datasource="AppsWorkOrder"> 
								SELECT Code,Description
								FROM Ref_PlanOrder
								WHERE ListingOrder = '#current_order#'
							</cfquery>
							
							<cfquery name="qUpdatePlan" datasource="AppsTransaction">
								UPDATE stWorkPlanDetails_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL#
								SET PlanOrder = '#qTimeSlot.Code#'
								WHERE RouteId = '#qWorkPlanDetails.RouteId#'
									  AND Date    = '#qWorkPlanDetails.Date#'
									  AND Node    = '#qWorkPlanDetails.Node#'
							</cfquery>
							
							
		    				<cfif k eq 2>
								<cfset k = 0>
								<cfset current_order = current_order + 1>		    					
		    				</cfif>	
		    				
											
					</cfloop>			
					
				</cfloop>	
				
	  </cffunction>		
	  

	  <cffunction name="getRegion"   returntype="string" access="public">
		<cfargument name="start_latitude"  	required="true" type="numeric" default=0>
		<cfargument name="start_longitude" 	required="true" type="numeric" default=0>
		<cfargument name="to_latitude"  	required="true" type="numeric" default=0>
		<cfargument name="to_longitude" 	required="true" type="numeric" default=0>

			<cfset delta_latitude  = arguments.start_latitude  - arguments.to_latitude>
			<cfset delta_longitude = arguments.start_longitude - arguments.to_longitude>
			
			<cfif delta_latitude lt 0 >
				<cfset vRegion = "NORTH">
			<cfelse>
				<cfset vRegion = "SOUTH">
			</cfif>	
			
			<cfif delta_longitude lt 0 >
				<cfset vRegion = "#vRegion#-EAST">
			<cfelse>
				<cfset vRegion = "#vRegion#-WEST">
			</cfif>	

			<cfReturn vRegion>

	  </cffunction>	  
	  
	  <cffunction name="getDistanceFromOrigin" returnType="any">
			    <cfargument name="destination" required="true" type="string" default="">
	  
	  			<cfset var oDistance		= ''>
	  
				<cfset oDistance = getDistance(origin     = "#VARIABLES.Instance.start_latitude#,#VARIABLES.Instance.start_longitude#", 
											   destination = "#arguments.destination#")>		
				<cfif oDistance.Distance eq 0 or oDistance.Distance eq "">
					<cfset oDistance = getDistanceMapQuest(origin     = "#VARIABLES.Instance.start_latitude#,#VARIABLES.Instance.start_longitude#", 
												           destination = "#arguments.destination#")>		
				</cfif>								   
				<cfreturn oDistance>	  	
	  </cffunction>
	  
	  <cffunction name="getDistance" returntype="any" access="public">
	    <cfargument name="origin"      required="true" type="string" default="">
	    <cfargument name="destination" required="true" type="string" default="">
	    <cfargument name="language" required="false" type="string" default="">
		<!--- by dev on 1/5/2015, Promisan b.v. ---->
		
		<cftry>    

			  <cfset variables.distance_query = QueryNew("Status, Duration, Duration_Text, Distance, Distance_Text", "varchar, varchar, varchar, varchar, varchar")>

			  <cfset arguments.origin = replace(arguments.origin," ","","ALL")>
			  <cfset arguments.destination = replace(arguments.destination," ","","ALL")>
			  		    	
		      <cfset variables.base_url = "https://maps.googleapis.com/maps/api/distancematrix/xml?">
		      <cfif len(trim(arguments.origin)) is not 0>
		        	<cfset variables.final_url = variables.base_url & "origins=" & arguments.origin>
		      <cfelse>
  			      <cfset variables.temp = QueryAddRow(variables.distance_query, 1)>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Status", "Please pass in either the address or the latitude and lautitude.")>
			      <cfabort>
		      </cfif>

		      <cfif len(trim(arguments.destination)) is not 0>
		        	<cfset variables.final_url = variables.final_url & "&destinations=" & arguments.destination>
		      <cfelse>
  			      <cfset variables.temp = QueryAddRow(variables.distance_query, 1)>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Status", "Please pass in either the address or the latitude and lautitude.")>
			      <cfabort>
		      </cfif>
		      
		      <cfif len(trim(arguments.language)) is not 0>
		        <cfset variables.final_url = variables.final_url & "&language=" & arguments.language>
		      </cfif>

		      
		      <!--- This is a new key I needed to generated using our gmail account dev@email, to discuss with Hanno
		      on how to add this to the client variables 1/5/2015 ---->
		      
		      <cfif len(trim(client.googleMAPId)) is not 0>
		        <cfset variables.final_url = variables.final_url & "&key=AIzaSyAgMoDlVUhdNqRPoQy20Y7YeuaMMlaEG1w">
		      </cfif>
			  	
			  	
			  <cfhttp url="#variables.final_url#" result="variables.resultxml">
			  
			  <cfset variables.parsed_result = xmlParse(variables.resultxml.fileContent)>
			  
			  <cfset variables.result_status = variables.parsed_result.DistanceMatrixResponse.status.xmltext>
			  	
			  <cfif variables.result_status eq "OK">
  			      <cfset variables.temp = QueryAddRow(variables.distance_query, 1)>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Status", "OK")>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Duration", variables.parsed_result.DistanceMatrixResponse.row.element.duration.value.xmltext)>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Duration_Text", variables.parsed_result.DistanceMatrixResponse.row.element.duration.text.xmltext)>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Distance", variables.parsed_result.DistanceMatrixResponse.row.element.distance.value.xmltext)>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Distance_Text", variables.parsed_result.DistanceMatrixResponse.row.element.distance.text.xmltext)>
			  </cfif>	
		
			    
		<cfcatch>
		</cfcatch>
		
		</cftry>		
	
		<cfreturn variables.distance_query>
		
	</cffunction>



	  <cffunction name="getDistanceMapQuest" returntype="any" access="public">
	    <cfargument name="origin"      required="true" type="string" default="">
	    <cfargument name="destination" required="true" type="string" default="">
		<!--- by dev on 3/17/2015, Promisan b.v. ---->
	
			<cftry>   
		  
			  <cfset variables.distance_query = QueryNew("Status, Duration, Duration_Text, Distance, Distance_Text", "varchar, varchar, varchar, varchar, varchar")>
			  	
			  <cfset arguments.origin = replace(arguments.origin," ","","ALL")>
			  <cfset arguments.destination = replace(arguments.destination," ","","ALL")>
			  		    	
		      <cfset variables.base_url = "http://open.mapquestapi.com/directions/v2/optimizedroute?">
		      <cfif len(trim(arguments.origin)) is not 0>
		        	<cfset variables.final_url = variables.base_url & "from=" & arguments.origin>
		      <cfelse>
  			      <cfset variables.temp = QueryAddRow(variables.distance_query, 1)>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Status", "Please pass in either the address or the latitude and lautitude.")>
			      <cfabort>
		      </cfif>

		      <cfif len(trim(arguments.destination)) is not 0>
		        	<cfset variables.final_url = variables.final_url & "&to=" & arguments.destination>
		      <cfelse>
  			      <cfset variables.temp = QueryAddRow(variables.distance_query, 1)>
			      <cfset variables.temp = QuerySetCell(variables.distance_query, "Status", "Please pass in either the address or the latitude and lautitude.")>
			      <cfabort>
		      </cfif>
		      
		      <!--- This is a new key I needed to generated using our gmail account dev@email, to discuss with Hanno
		      on how to add this to the client variables 1/5/2015 ---->
		      <cfset variables.final_url = variables.final_url & "&key=Fmjtd%7Cluu82lut2l%2C7g%3Do5-9480qu&unit=k">

			  <cfhttp url="#variables.final_url#" result="variables.result">

			  <cfif variables.result.statuscode eq "200 OK">
			  	<cfset variables.parsed_result = deserializeJSON(variables.result.fileContent)>
			    <cfset variables.temp = QueryAddRow(variables.distance_query, 1)>
				<cfset vDistance = variables.parsed_result.route.distance*1000>
			    <cfset variables.temp = QuerySetCell(variables.distance_query, "Status", "OK")>
			    <cfset variables.temp = QuerySetCell(variables.distance_query, "Duration", variables.parsed_result.route.time)>
			    <cfset variables.temp = QuerySetCell(variables.distance_query, "Duration_Text", variables.parsed_result.route.time)>
			    <cfset variables.temp = QuerySetCell(variables.distance_query, "Distance", vDistance)>
			    <cfset variables.temp = QuerySetCell(variables.distance_query, "Distance_Text", vDistance)>				
			  </cfif>
			    
		<cfcatch>
		</cfcatch>
		
		</cftry>	
		<cfreturn variables.distance_query>
		
	</cffunction>

	  
	<cffunction name="setMasterRoutes" access="public">
		<cfargument name="mode" required="true" type="string" default="ByRegion">
	   
	   	    <cfswitch expression="#arguments.mode#">
	    		<cfcase value="ByRegion">
					<cfquery name="qRegion" dbtype="Query">
						SELECT Region,Duration_From_SP,Node
						FROM VARIABLES.Instance.Matrix 
						WHERE Region!='' and Node > 0
		   			    Order by Region,Duration_From_SP ASC
					</cfquery>	
					
					<cfset vRegion = ""> 
					
					<cfloop query="qRegion">
						
						<cfif vRegion neq qRegion.Region>
							<cfset vRegion = qRegion.Region>
							<cfset count = 1>
						<cfelse>
							<cfset count = count + 1>	 
						</cfif>	
							
						<cfset temp = QuerySetCell(VARIABLES.Instance.Matrix, "MasterRoute", count, qRegion.Node)>
						
					</cfloop>
					
				</cfcase>
				<cfcase value="ByDriver">
				
				
					<cfquery name="qBranches" dbtype="Query">
						SELECT Region,Duration_From_SP,Node, Zip, Driver
						FROM VARIABLES.Instance.Matrix 
						WHERE Node > 0 AND Branch = 1
		   			    Order by Duration_From_SP ASC
					</cfquery>	
					
					<cfset count = 0 >
					<cfloop query="qBranches">
					
							
						<cfquery name="qDrivers" datasource="AppsWorkOrder">
								SELECT TOP 1 P.FullName,M.*
								FROM skDeliverymatrix_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# M INNER JOIN stWorkPlanSuggestedDrivers_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# P on M.PositionNo=P.PositionNo
								WHERE Currentday !=0
								AND OrgUnitOwner = '#Left(qBranches.Zip,2)#'
								ORDER BY P.Total DESC						
						</cfquery>								
							
						<cfif qDrivers.recordcount neq 0>
							<cfset count = count + 1>
							<cfset temp = QuerySetCell(VARIABLES.Instance.Matrix, "MasterRoute", count, qBranches.Node)>
							<cfset temp = QuerySetCell(VARIABLES.Instance.Matrix, "Region", qDrivers.FullName, qBranches.Node)>	 
							<cfset temp = QuerySetCell(VARIABLES.Instance.Matrix, "Driver", qDrivers.PersonNo, qBranches.Node)>	
						</cfif>	
							
					</cfloop>				
						
				</cfcase>
				
				
				
			</cfswitch>	

	</cffunction>  
	  

	<cffunction name="getMatrix" returntype="query" access="public">
		<cfargument name="mode" required="true" type="string" default="">
	    <cfswitch expression="#arguments.mode#">
	    	
	    	<cfcase value="ByRegion">

	    			<cfquery name="qRegion" dbtype="Query">
	    				SELECT DISTINCT Region
	    				FROM VARIABLES.Instance.Matrix 
	    				WHERE Branch = 1  
	    			</cfquery>

					<cfset selected = "0">
					<cfloop query="qRegion">
			    			<cfquery name="qNodes" dbtype="Query">
			    				SELECT Node
			    				FROM VARIABLES.Instance.Matrix 
			    				WHERE Region = '#qRegion.Region#'
			    				AND   MasterRoute > 0 
			    				ORDER BY MasterRoute ASC 
			    			</cfquery>
							<cfset k = 1>
							<cfloop query="qNodes">
								<cfif k lte VARIABLES.Instance.depth>
									<cfset selected = "#selected#,#qNodes.Node#">
								</cfif>	
								<cfset k = k + 1>
							</cfloop>	
					</cfloop>	


	    			<cfquery name="qMatrix" dbtype="Query">
	    				SELECT *
	    				FROM VARIABLES.Instance.Matrix 
	    				WHERE MasterRoute > 0
	    				AND Node in (#selected#)
	    			</cfquery>
	    			
	    				
					<cfreturn qMatrix>
	    			
	    			
	    	</cfcase>	 

	    	<cfcase value="ByDriver">

	    			<cfquery name="qNodes" dbtype="Query">
	    				SELECT *
	    				FROM VARIABLES.Instance.Matrix 
	    				WHERE Branch = 1  
						AND MasterRoute > 0
						ORDER BY MasterRoute ASC
	    			</cfquery>

					<cfset selected = "0">
					<cfset k = 1>
					<cfloop query="qNodes">
						<cfif k lte VARIABLES.Instance.depth>
							<cfset selected = "#selected#,#qNodes.Node#">
						</cfif>	
						<cfset k = k + 1>
					</cfloop>	


	    			<cfquery name="qMatrix" dbtype="Query">
	    				SELECT *
	    				FROM VARIABLES.Instance.Matrix 
	    				WHERE MasterRoute > 0
	    				AND Node in (#selected#)
	    			</cfquery>
	    			

					<cfreturn qMatrix>
	    			
	    			
	    	</cfcase>
	    	
	    </cfswitch>
	</cffunction>  

	<cffunction name="pickUp" returntype="query" access="public">
		<cfargument name="branch" required="true" type="string" default="">
	    		
			<cfset var qDeliveriesInBranch = ''>
					
			<cfquery name="qDeliveriesInBranch" dbtype="Query">
				SELECT *
				FROM VARIABLES.Instance.Matrix 
				WHERE OrgUnitOwner = '#arguments.branch#'
				AND Branch = 0   
			</cfquery>	
			
				
			<cfreturn qDeliveriesInBranch>
	    			
	</cffunction>  
	
	
	<cffunction name="getDistanceFromNodes" returntype="query" access="public">
		<cfargument name="fromNode" required="true" type="numeric" default=0>
		<cfargument name="toNode"   required="true" type="numeric" default=0>

			<cfset var qFrom 			= ''>
			<cfset var qTo	 			= ''>
			<cfset var vDistance		= ''>
	    			
			<cfquery name="qFrom" dbtype="Query">
				SELECT *
				FROM VARIABLES.Instance.Matrix 
				WHERE Node = '#arguments.fromNode#'
			</cfquery>	
			
			<cfquery name="qTo" dbtype="Query">
				SELECT *
				FROM VARIABLES.Instance.Matrix 
				WHERE Node = '#arguments.toNode#'
			</cfquery>	
			

 		    <cfset vDistance = getDistance(origin     = "#qFrom.latitude#,#qfrom.longitude#", 
										   destination = "#qTo.latitude#,#qTo.longitude#")>


			<cfif vDistance.Distance eq 0 or vDistance.Distance eq "">

	 		    <cfset vDistance = getDistanceMapQuest(origin     = "#qFrom.latitude#,#qfrom.longitude#", 
											           destination = "#qTo.latitude#,#qTo.longitude#")>
			</cfif>							   
										   
			<cfreturn vDistance>
	    			
	</cffunction>	
	
	<cffunction name="checkDistance" returntype="struct">
		<cfargument name="vFrom"      required="true" type="numeric" default=0>
		<cfargument name="vTo"        required="true" type="numeric" default=0>	
	
				<cfset var vDurationFromTo =  ''>
				<cfset var stNode			= ''>
			    <cfset var vDistance		= ''>
			    <cfset var vDuration		= ''>
				<cfset var temp				= ''>
				<cfset var qFrom			= ''>
				<cfset var qTo				= ''>
				<cfset var qCheckWeight		= ''>
				<cfset var vDurationFromTo	= ''>
				<cfset var vDistance		= ''>
				<cfset var vDuration		= ''>
				<cfset var qInsertWeight	= ''>
				
							
				<cfquery name="qFrom" dbtype="Query">
					SELECT Zip  
					FROM VARIABLES.Instance.Matrix
					WHERE Node = '#arguments.vFrom#'
				</cfquery>

				<cfquery name="qTo" dbtype="Query">
					SELECT Zip  
					FROM VARIABLES.Instance.Matrix
					WHERE Node = '#arguments.vTo#'
				</cfquery>
				
				<cfset vFromZip = Replace(qFrom.Zip," ","","All")>
				<cfset vToZip = Replace(qTo.Zip," ","","All")>							
				
				<cfquery name="qCheckWeight" datasource="AppsSystem">
					SELECT * FROM PostalDistance
					WHERE PostalCodeFrom = '#vFromZip#'
					AND PostalCodeTo = '#vToZip#'
					AND Country = '#VARIABLES.Instance.country#'
				</cfquery>
				
				<cfif qCheckWeight.recordCount eq 0 >	

							<cfset vDurationFromTo = getDistanceFromNodes(
													fromNode = arguments.vFrom,
													toNode   = arguments.vTo
											)/>
											
							<cfset vDistance = vDurationFromTo.Distance>
							<cfset vDuration = vDurationFromTo.Duration>
							
							<cfif vDistance neq 0 and vDistance neq "">
								<cfquery name="qInsertWeight" datasource="AppsSystem">
									INSERT INTO PostalDistance (Country,PostalCodeFrom, PostalCodeTo, Distance, Duration)
									Values ('#VARIABLES.Instance.country#','#vFromZip#', '#vToZip#', '#vDistance#', '#vDuration#')
								</cfquery>
							</cfif>
				<cfelse>
						<cfset vDistance = qCheckWeight.Distance>
						<cfset vDuration = qCheckWeight.Duration>   				
				</cfif>

				<cfset stNode = StructNew()/>
				<cfset tmp = StructInsert(stNode, "Distance", vDistance)>
				<cfset tmp = StructInsert(stNode, "Duration", vDuration)>
						
				<cfreturn stNode>

	</cffunction>
	

	<cffunction name="insertNode"   access="public">
		<cfargument name="CurrentNode" required="true" type="struct" default=0>
		<cfargument name="vFrom"      required="true" type="numeric" default=0>
		<cfargument name="vTo"        required="true" type="numeric" default=0>
		<cfargument name="Reference"  required="true" type="string"  default="">
		<cfargument name="Branch"  	  required="true" type="numeric" default="0">
		<cfargument name="Neighbors"  required="true" type="query" default="0">

					<cfset var qCheck 			= ''>
					<cfset var CurrentNeighbor	= ''>
					<cfset var oDistance		= ''>

				
					<cfquery name="qCheck" dbtype="Query">
						SELECT *
						FROM Arguments.Neighbors 
						WHERE Node = '#vTo#'
					</cfquery>	
					
					<cfif qCheck.recordcount eq 0>
						
						  <cfset oDistance = checkDistance(vFrom="#arguments.vFrom#",vTo="#arguments.vTo#")>
					      <cfset CurrentNeighbor = QueryAddRow(arguments.Neighbors, 1)>
					      <cfset temp = QuerySetCell(arguments.Neighbors, "Node", vTo)>
					      <cfset temp = QuerySetCell(arguments.Neighbors, "Reference", arguments.Reference)>
					      <cfset temp = QuerySetCell(arguments.Neighbors, "Distance", oDistance.Distance)>
					      <cfset temp = QuerySetCell(arguments.Neighbors, "Duration", oDistance.Duration)>
					      <cfset temp = QuerySetCell(arguments.Neighbors, "Branch", arguments.Branch)>
					  
					</cfif>			
					
	
	</cffunction>	

	<cffunction name="insertPath"   access="public">
		<cfargument name="CurrentNode" 	 required="true" type="struct" default=0>
		<cfargument name="Node"  		 required="true" type="string"   default="">
		<cfargument name="Distance"      required="true" type="any"      default="">
		<cfargument name="Duration"  	 required="true" type="any"      default="">
		<cfargument name="Listing_Order" required="true" type="numeric"  default="0">
		<cfargument name="From"  		 required="true" type="string"   default="">

					<cfset var qCheck 			= ''>
					<cfset var qNodeInformation = ''>
					<cfset var CurrentStep      = ''>
					<cfset var temp			    = ''>


					<cfquery name="qCheck" dbtype="Query">
						SELECT *
						FROM CurrentNode.Path
						WHERE Node = '#Arguments.Node#'
					</cfquery>	

					<cfif qCheck.recordcount eq 0>

						  <cfquery name="qNodeInformation" dbtype="Query">
							SELECT *
							FROM VARIABLES.Instance.Matrix 
							WHERE Node = '#Arguments.Node#'
						  </cfquery>
						
					      <cfset CurrentStep = QueryAddRow(Arguments.CurrentNode.Path, 1)>
					      <cfset temp = QuerySetCell(Arguments.CurrentNode.Path, "Node", Arguments.Node)>
					      <cfset temp = QuerySetCell(Arguments.CurrentNode.Path, "Branch", qNodeInformation.Branch)>
					      <cfset temp = QuerySetCell(Arguments.CurrentNode.Path, "OrgUnitOwner", qNodeInformation.OrgUnitOwner)>
					      <cfset temp = QuerySetCell(Arguments.CurrentNode.Path, "Distance", arguments.Distance)>
					      <cfset temp = QuerySetCell(Arguments.CurrentNode.Path, "Duration", arguments.Duration)>
					      <cfset temp = QuerySetCell(Arguments.CurrentNode.Path, "Listing_Order", arguments.Listing_Order)>
					      <cfset temp = QuerySetCell(Arguments.CurrentNode.Path, "From", arguments.From)>
	 					  
					</cfif>			
	
	</cffunction>
	

	<cffunction name="getHistoricalBranches" returntype="query" access="public">
		<cfargument name="FirstStep"    required="false" type="string" default="Yes">
		<cfargument name="ExcludeList" required="false" type="string" default="">
	
			<cfset var qBranches			= ''>
			<cfset var vMax     			= ''>
			<cfset var qCheckCandidates		= ''>

			<cfif Arguments.FirstStep eq "Yes">
						
				
					   <cfquery name="qBranches"
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">					
							SELECT N.OrgUnitOwner, SUM(S.Counter) as Total
							 FROM 	skWorkPlanDriverBranches S INNER JOIN UserTransaction.dbo.stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# N
							 		ON N.OrgUnitOwner = S.OrgUnitOwner AND N.Branch='1' 
							WHERE S.PositionNo = '#VARIABLES.Instance.driver#'	
							AND N.Date         = #VARIABLES.Instance.date#
							AND N.Branch       = 1
							AND N.ActionStatus = 0
							GROUP BY N.OrgUnitOwner
							ORDER BY SUM(S.Counter) DESC			
						</cfquery>	
			
						
						<!----Now looking for candidates on where to start --->
						<cfset vMax = 0>
						<cfloop query ="qBranches">
							<cfif vMax lt qBranches.Total>
								<cfset vMax = qBranches.Total>
							</cfif> 
						</cfloop>
			
						<cfquery name="qCheckCandidates" dbtype="query">
							SELECT OrgUnitOwner 
							FROM qBranches
							WHERE Total = '#vMax#' 
						</cfquery>
						
					   <cfquery name="qBranches"
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
								SELECT N.Node, N.OrgUnitOwner, Min(PlanOrderCode), SUM(counter)
								FROM 	skWorkPlanDriverBranches S INNER JOIN 
										 UserTransaction.dbo.stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# N ON N.OrgUnitOwner = S.OrgUnitOwner AND N.Branch='1' 
										INNER JOIN Organization.dbo.Organization O ON O.OrgUnit=S.orgunitOwner
								WHERE 
								N.Date = #VARIABLES.Instance.date#
								AND N.Branch = 1
								AND N.OrgUnitOwner in (#ValueList(qCheckCandidates.OrgUnitOwner)#)
								GROUP BY N.Node, N.OrgUnitOwner, PlanOrderCode
								ORDER BY MIN(PlanOrderCode) ASC, SUM(counter) DESC				
						</cfquery>	
			
			<cfelse>

					   <cfquery name="qBranches"
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
								SELECT N.Node,S2.OrgUnitOwner,COUNT(1) 
								FROM skRoutes S1 INNER JOIN skRoutes S2
									ON S1._year=S2._year AND S1._month=S2._month AND S1._day=S2._day
									AND S1.OrgUnitOwner!=S2.OrgUnitOwner AND S1.PositionNo=S2.PositionNo
									INNER JOIN UserTransaction.dbo.stNodes_#VARIABLES.Instance.mission#_#VARIABLES.Instance.dateSQL# N ON N.OrgUnitOwner=S2.OrgUnitOwner AND N.Branch='1' 
								WHERE 
								S1.PositionNo ='#VARIABLES.Instance.driver#'	
								AND N.Date    = #VARIABLES.Instance.date#
								AND S1.OrgUnitOwner IN (#ExcludeList#)
								GROUP BY N.Node,S2.OrgUnitOwner
								ORDER BY COUNT(1) DESC		
						</cfquery>
			
			</cfif>			
	
	
			<cfreturn qBranches/>
	
	</cffunction>
	
	
	
	
	<cffunction name="getBranches" returntype="query" access="public">
			<cfargument name="Remaining" 		required="true" type="numeric" default=0>
			<cfargument name="CurrentNode" 	 	required="true" type="struct" default=0>
			
			<cfset var qBranches			= ''>
			<cfset var vCandidates			= ''>
			<cfset var qCheckRemaining		= ''>
			<cfset var qResult				= ''>
			<cfset var qFinalResult   		= ''>
			<cfset var vRemaining           = Arguments.remaining> 
			<cfset var _RESULT				= ''>
			<cfset var CurrentStep			= ''>
			<cfset var qLocalNode           = ''>
			<cfset var qBranchNode          = ''>
			
			<cfif vRemaining gt 0>
			
				<cfset qBranches = getHistoricalBranches(FirstStep="No", 
														 ExcludeList=#ValueList(ARGUMENTS.CurrentNode.Path.OrgUnitOwner)#)/>				
			
			
				<cfquery name="qResult" dbtype="Query">
					SELECT *
					FROM VARIABLES.Instance.Matrix
					WHERE 
					<cfif qBranches.recordcount neq 0>
						Node in (#ValueList(qBranches.Node)#)
					<cfelse>	
						Branch=1 					
					</cfif>	
				</cfquery>	


				<cfset _RESULT  = QueryNew("Node    , Distance, Duration, OrgUnitOwner", 
									       "Integer , Double  , Double,   Integer" )>

										   
										   
				<cfquery name="qLocalNode" dbtype="Query">
					SELECT *
					FROM VARIABLES.Instance.Matrix 
					WHERE Node='#Arguments.CurrentNode.Node#'
				</cfquery>	

										   
				<cfquery name="qBranchNode" dbtype="Query">
					SELECT *
					FROM VARIABLES.Instance.Matrix 
					WHERE OrgUnitOwner='#qLocalNode.OrgUnitOwner#'
					AND Branch ='1'
				</cfquery>	

				
				<cfloop query="qResult">
					  <cfset oDistance = checkDistance(vFrom="#qBranchNode.Node#",vTo="#qResult.Node#")>
				      <cfset CurrentStep = QueryAddRow(_RESULT, 1)>
				      <cfset temp = QuerySetCell(_RESULT, "Node", qResult.Node)>
					  <cfset temp = QuerySetCell(_RESULT, "OrgUnitOwner", qResult.OrgUnitOwner)>
				      <cfset temp = QuerySetCell(_RESULT, "Distance", oDistance.Distance)>
				      <cfset temp = QuerySetCell(_RESULT, "Duration", oDistance.Duration)>
				</cfloop>
	

				<cfquery name="qFinalResult" dbtype="Query">
					SELECT *
					FROM _RESULT 
					ORDER BY Distance ASC
				</cfquery>	

				<cfset vcounted = 0>	
				<cfset vCandidates = "-1">
				<cfloop query="qFinalResult">
						<cfquery name="qCheckRemaining" dbtype="Query">
							SELECT *
							FROM VARIABLES.Instance.Matrix 
							WHERE OrgUnitOwner = '#qFinalResult.OrgUnitOwner#'
							AND Branch = '0'
						</cfquery>			
						<cfif qCheckRemaining.recordcount lte vRemaining>		
							<cfset vcounted = vcounted + 1>
							<cfset vCandidates = "#vCandidates#,#qFinalResult.Node#">
							<cfset vRemaining = vRemaining - qCheckRemaining.recordcount>
							<cfif vcounted gte 5>
								<cfbreak>
							</cfif>
						</cfif>						
				
				</cfloop>
				
			
				<cfquery name="qFinalResult" dbtype="Query">
					SELECT *
					FROM _RESULT 
					WHERE Node in (#vCandidates#) 
					ORDER BY Duration ASC
				</cfquery>	
					
				<cfreturn qFinalResult>
			<cfelse>
				<cfreturn ''>
			</cfif>
				
	</cffunction>
	
	
	<cffunction name="getObject" returntype="struct" access="public">
		<cfargument name="Node" required="true" type="numeric">
		<cfargument name="Distance"    required="false" type="any" default=0>
		<cfargument name="Duration"    required="false" type="any" default=0>
		<cfargument name="From"        required="false" type="string" default=0>
		
		
			<cfset var stNode			= ''>
			<cfset var tmp				= ''>
			<cfset var PATH				= ''>
			<cfset var ROUTES			= ''>
				

			<cfset stNode = StructNew()/>
			<cfset tmp = StructInsert(stNode, "Node", arguments.Node)>
			<cfset PATH  = QueryNew("Node    , Branch , OrgUnitOwner , Distance, Duration , Listing_Order, From ", 
									"Integer , Bit    , Varchar      , Double  , Double   , Integer      , Varchar" )>
			<cfset ROUTES = CreateObject( 
    			"java", 
    			"java.util.ArrayList" 
    			).Init() />
			
			<cfset tmp = StructInsert(stNode, "Path", PATH)>
			<cfset tmp = StructInsert(stNode, "ROUTES", ROUTES)>

			<cfset VARIABLES.Instance.listing_order = VARIABLES.Instance.listing_order + 1>
			
			<!--- Inserting the current one--->
			<cfset tmp = insertPath(CurrentNode   = stNode,
									Node          = ARGUMENTS.Node,
									Distance      = ARGUMENTS.Distance,
									Duration      = ARGUMENTS.Duration,
									Listing_Order = VARIABLES.Instance.listing_order,
									From          = ARGUMENTS.From)/>
		
			<cfreturn stNode>
		
	</cffunction>	
	
	
	<cffunction name = "getDeliveries" access="public">
		<cfargument name="vFrom"  		 required="true" type="numeric" default="0">
		<cfargument name="OrgUnitOwner"  required="true" type="numeric" default="0">
		<cfargument name="Neighbors"  	 required="true" type="query" default="0">
		<cfargument name="Children" 	 required="true" type="numeric" default="0">
		<cfargument name="CurrentNode" 	 required="true" type="struct" default="">
		<cfargument name="StartPoint" 	 required="true" type="numeric" default="">
		
		
			<cfset var qDeliveries			= ''>
			<cfset var vTo					= ''>
			<cfset var qCheckPath			= ''>
			<cfset var lFrom                = ''>
			
			<cfset lFrom = ARGUMENTS.vFrom>
		
			<cfset qDeliveries = pickUp(Branch = ARGUMENTS.OrgUnitOwner)/>
			<cfloop query="qDeliveries">
					<cfset vTo = qDeliveries.node>
					<cfif lFrom neq vTo>
						
						<cfset doIt = 1>
						<cfif ARGUMENTS.Children eq 1>
								<cfquery name="qCheckPath" dbtype="Query">
									SELECT *
									FROM CurrentNode.Path
									WHERE Node = '#vTo#'
								</cfquery>
								
								<cfif qCheckPath.recordCount neq 0>
									<cfset doIt = 0>
								</cfif>		
			 	
			        	</cfif>
						
						<cfif doIt eq 1>

								<cfset tmp = insertNode(CurrentNode  = ARGUMENTS.CurrentNode,
											vFrom        = lFrom,
											vTo          = vTo,
											Reference    = qDeliveries.CustomerName,
											Branch       = 0,
											NEIGHBORS    = ARGUMENTS.NEIGHBORS )/>
								
							   
							   <!----- <cfset lFrom = vTo>  ---->
							   			
						</cfif>
						
					</cfif> <!--- 'To' is different 'from' ---> 
			</cfloop>		
		
	</cffunction>
	
	<cffunction name="setDriver">
		<cfargument name="driver" required="true" type="any">
		
		<cfset VARIABLES.Instance.driver = arguments.driver>
		
	</cffunction>
	



	<cffunction name="getDriverCapacity" returntype="numeric">
		<cfreturn VARIABLES.Instance.driver_capacity>
	
	</cffunction>	

	
	<cffunction name="evaluateNode" returntype="any" access="public">
		<cfargument name="Node" required="true" type="numeric">
		<cfargument name="RelatedNode" required="false" type="struct">
		<cfargument name="RelatedNEIGHBORS" required="false" type="query">


			<cfset var qNode 			= ''>
			<cfset var NEIGHBORS 		= ''>
			<cfset var CurrentNode 		= ''>
			<cfset var Children 		= ''>
			<cfset var vFrom 			= ''>
			<cfset var qCheckLimit		= ''>
			<cfset var qInTransit 		= ''>
			<cfset var vRemaining 		= ''>
			<cfset var vTotal 			= ''>
			<cfset var qBranches    	= ''>
			<cfset var qCheckPath   	= ''>
			<cfset var doIt 			= ''>
			<cfset var tmp 				= ''>
			<cfset var qCheckNeighbors 	= ''>
			<cfset var qCheckOwner 		= ''>
			<cfset var qCheckPath		= ''>
			<cfset var j				= ''>
			<cfset var StartPoint		= ''>		 	
			<cfset var endos			= ''>
			<cfset var oDistance		= ''>
			
			

			<cfquery name="qNode" dbtype="Query">
				SELECT *
				FROM VARIABLES.Instance.Matrix 
				WHERE Node = '#arguments.Node#'
			</cfquery>	
			
			<cfset setProgressData("Evaluating Node #arguments.Node#")>
		
			<cfset NEIGHBORS  = QueryNew("Node   , Reference, Distance, Duration, Branch", 
										 "Varchar, varchar  , Double , Double , Bit")>

			
			<cfif StructKeyExists(ARGUMENTS,"RelatedNEIGHBORS")>
				<cfquery name="qCheckNeighbors" dbtype="Query">
					SELECT *
					FROM ARGUMENTS.RelatedNEIGHBORS
					WHERE Node != '#arguments.Node#'
					ORDER BY Distance ASC
				</cfquery>
				

				<cfloop query="qCheckNeighbors">
					
					  <cfset oDistance = checkDistance(vFrom=arguments.Node,vTo=qCheckNeighbors.Node)>

					
				      <cfset newNeighbor = QueryAddRow(NEIGHBORS, 1)>
				      <cfset temp = QuerySetCell(NEIGHBORS, "Node", qCheckNeighbors.Node)>
					  <cfset temp = QuerySetCell(NEIGHBORS, "Reference", qCheckNeighbors.Reference)>
					  <cfset temp = QuerySetCell(NEIGHBORS, "Distance", oDistance.Distance)>
					  <cfset temp = QuerySetCell(NEIGHBORS, "Duration", oDistance.Duration)>					  
					  <cfset temp = QuerySetCell(NEIGHBORS, "Branch", qCheckNeighbors.Branch)>
				</cfloop>
					
			</cfif>	


			<cfif StructKeyExists(ARGUMENTS,"RelatedNode")>			
				<cfset CurrentNode = ARGUMENTS.RelatedNode/>
				<cfset Children = 1>
				
				<cfset var _Matrix = VARIABLES.Instance.Matrix>
				<cfset var _Path = CurrentNode.Path>
				 
				<cfquery name="qFirstPoint" dbtype="Query">
					SELECT _Path.Node
					FROM _Path, _Matrix 
					WHERE _Path.Node = _Matrix.Node 
					ORDER BY Duration_from_SP DESC
				</cfquery>								
			
				<cfset vStartPoint = qFirstPoint.Node>		
				
			<cfelse>
				<cfset VARIABLES.Instance.listing_order = 0>

				<cfset oDistance = getDistanceFromOrigin(destination = "#qNode.Latitude#,#qNode.Longitude#")>
					
				<cfset CurrentNode = getObject(Node = arguments.Node, Duration = oDistance.Duration, Distance=oDistance.Distance,From="Origin")/>
				<cfset Children = 0>
				<cfset vStartPoint = arguments.Node>

			</cfif>

			
			<cfset vFrom = qNode.node>
			<!--- Deliveries that are on the same branch as the current Node --->
			<cfset getDeliveries(vFrom 		  = vFrom,
								 OrgUnitOwner = qNode.OrgUnitOwner,
								 Neighbors    = NEIGHBORS,
								 Children     = Children,
								 CurrentNode  = CurrentNode,
								 StartPoint   = vStartPoint)/>
						

			<cfquery name="qCheckLimit" dbtype="query">
				SELECT DISTINCT OrgUnitOwner 
				FROM CurrentNode.Path
			</cfquery>
			
			<cfset vTotal = 0>
			
			<cfloop query="qCheckLimit">
				<cfquery name="qInTransit" dbtype="Query">
					SELECT *
					FROM VARIABLES.Instance.Matrix 
					WHERE OrgUnitOwner = '#qCheckLimit.OrgUnitOwner#'
					AND Branch = 0
				</cfquery>	
				<cfset vTotal = qInTransit.recordcount + vTotal>
			</cfloop>

			<cfset vRemaining =  VARIABLES.Instance.DRIVER_CAPACITY - vTotal>
			

				<!---Limitation Capacity per DRIVER --->			
				<cfif vRemaining gt 0>
						<!--- Review of distance to Branches that has not been processed yet and that has a number of deliveries
						less than vRemaining --->

						<cfset qBranches = getBranches(Remaining = vRemaining, CurrentNode = CurrentNode)/>
						<cfloop query="qBranches">
						
								<cfset setProgressData("Checking remaining")>
						
								<cfquery name="qBranch" dbtype="Query">
									SELECT *
									FROM VARIABLES.Instance.Matrix 
									WHERE Node = '#qBranches.Node#'
								</cfquery>	
						
								<cfset vTo = qBranches.node>
								<cfif vFrom neq vTo>
										<cfset doIt = 1>
										<cfif StructKeyExists(ARGUMENTS,"RelatedNode")>
												<cfquery name="qCheckPath" dbtype="Query">
													SELECT *
													FROM CurrentNode.Path
													WHERE Node = '#vTo#'
												</cfquery>
												<cfif qCheckPath.recordCount neq 0>
													<cfset doIt = 0>
												</cfif>		
							 	
							        	</cfif>
										
										<cfif doIt eq 1>
												
													<cfset tmp = insertNode(CurrentNode  = CurrentNode,
																vFrom        = vFrom,
																vTo          = vTo,
																Reference    = qBranch.OrgUnitOwnerName,
																Branch       = 1,
																NEIGHBORS    = NEIGHBORS )/>

													<cfset getDeliveries(vFrom 		  = vFrom,
																	 OrgUnitOwner = qBranch.OrgUnitOwner,
																	 Neighbors    = NEIGHBORS,
																	 Children     = Children,
																	 CurrentNode  = CurrentNode,
																	 StartPoint   = vStartPoint)/>


												
										</cfif>
								</cfif> <!---- To & From are different --->
						</cfloop>	
				</cfif>
				<!--- End Capacity check per DRIVER --->
			
			
			<cfquery name="qCheckLimit" dbtype="query">
				SELECT * 
				FROM CurrentNode.Path
				WHERE Branch = 0
			</cfquery>
			
			<cfset endos = FALSE>
			
			<cfif qCheckLimit.recordcount lte VARIABLES.Instance.DRIVER_CAPACITY> 
				<cfquery name="qCheckNeighbors" dbtype="Query">
					SELECT *
					FROM NEIGHBORS 
					ORDER BY Distance ASC
				</cfquery>	
				<!--- First deliveries then Branches--->
				
				<cfloop query="qCheckNeighbors">
				
							<cfset setProgressData("Checking nearest neighboard")>
							
							<cfif qCheckNeighbors.Branch eq 0>
								<!--- It is a delivery, we need to verify if in the path already we passed through a Branch --->
								
								<cfquery name="qCheckOwner" dbtype="query">
									SELECT *
									FROM VARIABLES.Instance.Matrix 
									WHERE Node = '#qCheckNeighbors.Node#'
								</cfquery>							
								
								<cfquery name="qCheckPath" dbtype="query">
									SELECT * 
									FROM CurrentNode.Path
									WHERE OrgUnitOwner = '#qCheckOwner.OrgUnitOwner#'
									AND Branch = 1 
								</cfquery>							
								
								<cfif qCheckPath.recordCount eq 0>
									<!--- The delivery cannot be evaluated yet as the branch is not present in the path --->
									<cfset doIt = 0>	
								<cfelse>
									<cfset doIt = 2>
								</cfif>	
							<cfelse>
								<cfset doIt = 1>
							</cfif>	
			
							<cfif doIt gte 1>					
								
								<cfquery name="qCheckPath" dbtype="query">
									SELECT * 
									FROM CurrentNode.Path
									WHERE Node = '#qCheckNeighbors.Node#'
								</cfquery>	
	
								<cfif qCheckPath.recordcount eq 0>
										<cfset endos = TRUE>
										
										<cfset oDistance = checkDistance(vFrom=vFrom,vTo=qCheckNeighbors.Node)>
										
										<cfset CurrentNode.ROUTES[qCheckNeighbors.Node] = getObject(Node   	 = qCheckNeighbors.Node,
																									Distance = oDistance.Distance, 
																									Duration = oDistance.Duration,
																									From     = vFrom)/>
										<!--- Copying Path to the child --->
										<cfloop query="CurrentNode.Path">
											<cfset tmp = insertPath(CurrentNode   = CurrentNode.ROUTES[qCheckNeighbors.Node],
												   					Node          = CurrentNode.Path.Node,
												   					Distance      = CurrentNode.Path.Distance,
												   					Duration      = CurrentNode.Path.Duration,
												   					Listing_Order = CurrentNode.Path.Listing_Order,
												   					From          = CurrentNode.Path.From)/>
										</cfloop>	
										
										
										
										<!--- From here we need to start the recurring method, we send to the method the newly created object--->									
										<cfset evaluateNode(Node = qCheckNeighbors.Node, RelatedNode = CurrentNode.ROUTES[qCheckNeighbors.Node], RelatedNEIGHBORS = NEIGHBORS)>
									
								</cfif>

							</cfif> <!--- Check of Doit --->
							
							<cfif endos>
								<cfbreak>
							</cfif>	
						
				</cfloop>
				
				<cfif VARIABLES.Instance.debug eq 1>
					<HR>							
				</cfif>			
							
			<cfelse>
				<cfbreak>			
			</cfif>
				
			
			<cfreturn CurrentNode>

	</cffunction>
	
	
    <cffunction name="getProgressData" access="remote">
    	
    	<cfif not isdefined('SESSION.message')>
    		<cfset SESSION.message = "Initializing">
    	</cfif>	 

    	 
        <cfset data = {status=SESSION.count * 0.001,message= SESSION.message & "  - Step " & session.count}> 
        <cfreturn data> 
    </cffunction>  	
 
 	<cffunction name="setProgressData">
 		<cfargument name="message" required="false" type="string" default="">
 		
 		<cfset SESSION.message = ARGUMENTS.message>
 		
    	<cfif not isdefined('SESSION.count')> 
         	<cfset SESSION.count = 1> 
    	<cfelse> 
            <cfset SESSION.count = session.count + 1 > 
    	</cfif> 
 	</cffunction>	
 
</cfcomponent>
