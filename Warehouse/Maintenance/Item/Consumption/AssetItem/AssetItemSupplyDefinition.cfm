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

<cfquery name="InsertSupplies" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	INSERT INTO AssetItemSupply
		         (
				  AssetId,
				  SupplyItemNo,
				  SupplyItemUoM,
				  SupplyCapacity,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName
				 )
	SELECT 	AI.AssetId,
			S.SupplyItemNo,
			S.SupplyItemUoM,
			S.SupplyCapacity,
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#'
	FROM 	AssetItem AI
			INNER JOIN ItemSupply S
				ON AI.ItemNo = S.ItemNo
	WHERE 	AI.AssetId = '#URL.id#'
	AND		NOT EXISTS
			(
				SELECT 	'X'
				FROM 	AssetItemSupply 
				WHERE 	AssetId = AI.AssetId
				AND		SupplyItemNo = S.SupplyItemNo
				AND		SupplyItemUoM = S.SupplyItemUoM
			)
	
</cfquery>

<cfquery name="InsertMetrics" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	INSERT INTO AssetItemSupplyMetric
		(
		AssetId,
		SupplyItemNo,
		SupplyItemUoM,
		Metric,
		MetricQuantity,
		TargetRatio,
		TargetDirection,
		TargetRange,
  		OfficerUserId,
	 	OfficerLastName,
		OfficerFirstName
		)
		
	SELECT 	AI.AssetId,
			M.SupplyItemNo,
			M.SupplyItemUoM,
			M.Metric,
			M.MetricQuantity,
			M.TargetRatio,
			M.TargetDirection,
			M.TargetRange,
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#'
	FROM 	AssetItem AI
			INNER JOIN ItemSupplyMetric M
				ON AI.ItemNo = M.ItemNo
	WHERE 	AI.AssetId = '#URL.id#'
	AND		NOT EXISTS
			(
				SELECT 'X' 
				FROM AssetItemSupplyMetric 
				WHERE AssetId = AI.AssetId 
				AND SupplyItemNo = M.SupplyItemNo 
				AND SupplyItemUoM = M.SupplyItemUoM 
				AND Metric = M.Metric
			) 
	

</cfquery>


<cfquery name="InsertMetricsTarget" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	INSERT INTO AssetItemSupplyMetricTarget
		(
		AssetId,
		SupplyItemNo,
		SupplyItemUoM,
		Metric,
		DateEffective,
		OperationMode,
		TargetRatio,
		TargetDirection,
		TargetRange,
  		OfficerUserId,
	 	OfficerLastName,
		OfficerFirstName
		)
		
	SELECT 	AI.AssetId,
			T.SupplyItemNo,
			T.SupplyItemUoM,
			T.Metric,
			'#dateFormat(now(),"yyyymmdd")#',
			T.OperationMode,
			T.TargetRatio,
			T.TargetDirection,
			T.TargetRange,
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#'
	FROM 	AssetItem AI
			INNER JOIN ItemSupplyMetricTarget T
				ON AI.ItemNo = T.ItemNo
	WHERE 	AI.AssetId = '#URL.id#'
	AND		T.Mission = AI.Mission
	AND		T.Location IS NULL
	AND		NOT EXISTS
			(
				SELECT 'X' 
				FROM AssetItemSupplyMetricTarget
				WHERE AssetId = AI.AssetId 
				AND SupplyItemNo = T.SupplyItemNo 
				AND SupplyItemUoM = T.SupplyItemUoM 
				AND Metric = T.Metric
				<!--- AND	DateEffective = '#dateFormat(now(),"yyyymmdd")#' --->
			)
	

</cfquery>
