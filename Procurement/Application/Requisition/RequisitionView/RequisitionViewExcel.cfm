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

<!--- Requisition --->

<cfparam name="session.selectedreq" default="">

<cfif session.selectedreq eq "">
 <cfset session.selectedreq = "''">
</cfif>

<cfquery name="Drop"
	datasource="appsQuery">
      if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwRequisitionListing#SESSION.acc#]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwRequisitionListing#SESSION.acc#]
</cfquery>
 
<cfquery name="Req" 
    datasource="appsQuery">				
	CREATE VIEW dbo.vwRequisitionListing#SESSION.acc# AS	
	SELECT    R.*, Description as ItemMasterDescription, EntryClass
	FROM      Purchase.dbo.RequisitionLine R INNER JOIN
	          Purchase.dbo.ItemMaster I ON R.ItemMaster = I.Code
	WHERE     R.RequisitionNo IN (	#preservesinglequotes(session.selectedreqs)# )  
</cfquery> 

<cfset table1   = "vwRequisitionListing#SESSION.acc#">	

<cfquery name="Drop"
	datasource="appsQuery">
      if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwRequisitionFundListing#SESSION.acc#]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwRequisitionFundListing#SESSION.acc#]
</cfquery>

<cfquery name="Req" 
    datasource="appsQuery">				
	CREATE VIEW dbo.vwRequisitionFundListing#SESSION.acc# AS	
	SELECT    R.*, 
	          L.ObjectCode, 
			  O.Description as ObjectDescription,
			  L.Fund, 
			  L.ProgramCode, 
			  P.ProgramName, 
			  L.Percentage * R.RequestAmountBase AS ReservationAmount
	FROM      Purchase.dbo.RequisitionLine R INNER JOIN
	          Purchase.dbo.RequisitionLineFunding L ON R.RequisitionNo = L.RequisitionNo LEFT OUTER JOIN 
			  Program.dbo.Program P ON L.ProgramCode = P.ProgramCode INNER JOIN 
			  Program.dbo.Ref_Object O ON L.ObjectCode = O.Code
	WHERE     R.RequisitionNo IN (	#preservesinglequotes(session.selectedreqs)# ) 
</cfquery> 

<cfset table2   = "vwRequisitionFundListing#SESSION.acc#">	
