<!--
    Copyright © 2025 Promisan B.V.

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
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="WhsClaim">

<cfquery name="step" 
datasource="appsTravelClaim" >
SELECT   Req.Mission AS Mission_dim, 
         Clm.PaymentMode AS PaymentMode_dim, 
	     Per.Gender AS Gender_dim, 
		 Per.Nationality AS Nationality_dim, 
		 St.Description AS Status_nme, 
		 St.Status AS Status_dim, 
		 YEAR(Clm.ClaimDate) AS Year_dim, 
		 MONTH(Clm.ClaimDate) AS Month_dim, 
		 Clm.ClaimId, 
		 Clm.DocumentNo, 
		 SUM(CONVERT(decimal(10, 2), 
		 ClmLine.AmountClaimBase)) AS ClaimAmount, 
         Req.DocumentNo AS TravelRequestNo, 
         Req.ClaimantType, 
	     Pay.Description AS PaymentModeDescription, 
		 Clm.ClaimAsIs, 
		 Per.IndexNo, 
		 Per.FirstName + ' ' + Per.LastName AS Name,               
         Clm.eMailAddress, 
		 Req.OrgUnit
INTO     MartPMSS.dbo.WhsClaim
FROM     Claim Clm INNER JOIN ClaimLine ClmLine ON Clm.ClaimId = ClmLine.ClaimId INNER 
JOIN     ClaimRequest Req ON Clm.ClaimRequestId = Req.ClaimRequestId INNER 
JOIN     Ref_Status St ON Clm.ActionStatus = St.Status INNER 
JOIN     stPerson Per ON Req.PersonNo = Per.PersonNo INNER 
JOIN     Ref_PaymentMode Pay ON Clm.PaymentMode = Pay.Code
GROUP BY Clm.ClaimId, Clm.DocumentNo, Req.Mission, Req.DocumentNo, Req.ClaimantType, Clm.PaymentMode, Clm.ClaimAsIs, 
	St.Description, St.Status, Per.Gender, Per.Nationality, Per.IndexNo, Per.LastName, Per.FirstName, Clm.eMailAddress, 
	Req.OrgUnit, Clm.ClaimDate, Pay.Description

</cfquery>
