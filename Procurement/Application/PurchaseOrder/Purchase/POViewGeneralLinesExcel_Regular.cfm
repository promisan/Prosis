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
<cfquery name="Lines" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT    Q.*, 
	          R.RequestDescription AS RequestDescription, 
			  		  	  
			    (SELECT count(*)
				  FROM   RequisitionLineTopic T, Ref_Topic S
				  WHERE  T.Topic = S.Code
				  AND    S.Operational   = 1
				  AND    T.RequisitionNo = R.RequisitionNo) as Topics,	
			  
			  (
			  SELECT   count(*)
			  FROM     PurchaseLineReceipt 
		   	  WHERE    RequisitionNo = R.RequisitionNo 
		   	  AND      ActionStatus != '9'	
			  ) as Receipts,			 
			  
			  Job.JobNo, 
			  Job.CaseNo AS CaseNo
			  
	INTO	  Userquery.dbo.#SESSION.acc#_POLines
	
	FROM      PurchaseLine Q INNER JOIN
              RequisitionLine R ON Q.RequisitionNo = R.RequisitionNo LEFT OUTER JOIN
              Job ON R.JobNo = Job.JobNo
	WHERE     Q.PurchaseNo = '#URL.purchaseno#' 
	ORDER BY Q.ListingOrder, R.Created
</cfquery>