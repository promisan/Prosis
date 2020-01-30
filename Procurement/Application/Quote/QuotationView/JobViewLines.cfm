<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		
		<tr><td>
					
		<cfswitch expression="#URL.Sort#">
	
			<cfcase value="Line">
			
			<!--- create selection lines --->
	
				<cfquery name="Requisition" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    L.*, 
				          I.Description AS Description, 
						   (SELECT COUNT(*) 
						    FROM RequisitionLineService 
							WHERE requisitionNo = L.Requisitionno) as Details,
						  Org.Mission AS Mission, 
				          Org.MandateNo AS MandateNo, 
						  Org.HierarchyCode AS HierarchyCode, 
						  Org.OrgUnitName AS OrgUnitName, 
						  (SELECT PurchaseNo FROM PurchaseLine WHERE RequisitionNo = L.RequisitionNo) as PurchaseNo,
	                    
							(SELECT COUNT(*)
							  FROM RequisitionLineTopic RLT INNER JOIN Ref_Topic T ON RLT.Topic = T.Code
							  WHERE RequisitionNo = L.Requisitionno
							  AND T.TopicClass    = 'Requisition') as Topics						   
				FROM      RequisitionLine L INNER JOIN
	                      Organization.dbo.Organization Org ON L.OrgUnit = Org.OrgUnit INNER JOIN
	                      ItemMaster I ON L.ItemMaster = I.Code 
				WHERE     L.ActionStatus NOT IN ('9','0z')
				AND       L.JobNo  = '#URL.ID1#' 
				<!---
				AND       (L.Period = '#URL.Period#')
				--->
				ORDER BY  Org.Mission, 
				          Org.MandateNo, 
						  Org.HierarchyCode, 
						  L.RequisitionNo 		
						  	
				</cfquery>
								
				<cfset fun = "job">		
				<cfinclude template="QuotationListing.cfm"> 
								
			</cfcase>
			
			<cfdefaultcase>
			
				<cfset fun = "job">
				<cfinclude template="VendorListing.cfm">
									
			</cfdefaultcase>
				
		</cfswitch>
				
		</td></tr>
		
	</table>