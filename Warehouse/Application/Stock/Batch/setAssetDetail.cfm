
<!--- refreshes asset information --->

<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

	     SELECT   <!--- unit --->
				  T.OrgUnit, 
				  T.OrgUnitCode, 
				  T.OrgUnitName, 
				  <!--- asset --->
				  T.AssetId,
				  AI.Make,
				  AI.Model,
				  AI.AssetBarCode,
				  AI.AssetDecalNo,
				  AI.SerialNo,				  
				  <!--- check for metrics --->
				  				   
				  (SELECT TOP 1 Metric
					FROM    AssetItemAction AI INNER JOIN
					        AssetItemActionMetric AAM ON AI.AssetActionId = AAM.AssetActionId
					WHERE   TransactionId = T.Transactionid) as Metric,
					
				  (SELECT TOP 1 MetricValue
					FROM    AssetItemAction AI INNER JOIN
					        AssetItemActionMetric AAM ON AI.AssetActionId = AAM.AssetActionId
					WHERE   TransactionId = T.Transactionid) as MetricValue,
				   
				   <!--- person --->
				   T.PersonNo, 
				   P.FirstName,
				   P.LastName,
				   P.Reference
				   
		FROM      ItemTransaction T
		          INNER JOIN Ref_TransactionType R ON T.TransactionType = R.TransactionType
				  INNER JOIN ItemUoM I ON T.ItemNo = I.ItemNo AND T.TransactionUoM = I.UoM 
				  INNER JOIN WarehouseBatch B ON B.BatchNo = T.TransactionBatchNo 
				  INNER JOIN AssetItem AI ON AI.AssetId = T.AssetId
				  INNER JOIN Employee.dbo.Person P ON T.PersonNo = P.PersonNo
  		WHERE     T.TransactionId  = '#URL.TransactionId#'  	
		   
</cfquery>

<cfoutput query="get">

	<cfif field eq "asset">

		<cfif Make neq "">#Make#<cfelse>#Model#</cfif>/		
		<a href="javascript:AssetDialog('#assetid#')">											
		<font color="0080C0"><cfif assetdecalNo neq "">#AssetDecalNo#<cfelse>#AssetBarCode#</cfif></font>
		</a>		
	
	<cfelseif field eq "metric">	
	 #numberformat(MetricValue,"__,__._")#				
	<cfelseif field eq "person">	
	 #FirstName# #LastName# (#Reference#)			
	</cfif>
		
</cfoutput>		

