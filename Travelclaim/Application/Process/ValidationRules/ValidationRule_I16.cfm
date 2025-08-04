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
<cfsilent>
 <proUsr>Joseph George</proUsr>
  <proOwn>Joseph George</proOwn>
 <proDes>Template for validation Rule I16 </proDes>
 <proCom>New File For Validation I16 Prevents submission or moving forward. </proCom>
</cfsilent>


<!--- 
Validation Rule :  I16
Name			:  Prevent NOn Mapped City with NO-DSA mapping done in the Maintainence 
                   Screen REf_countrycitylocation does not have a valid matching record 
				   so raise an alarm
Steps			:  Just do an outer join with REf_countrycitylocation and get the records only 
                   for the particular claim ,if so prevent submission.
Date			:  15-july-2008 JG3
--->

<cfquery name="NoMatchCityDSA" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
	
SELECT DISTINCT A.ClaimId, A.PersonNo, A.ClaimCategory, A.CountryCityId, A.LocationCode, 
		A.CalendarDate,B.dateeffective, B.dateExpiration, B.countrycityid as EmptyCityid,
		datediff(dd,A.CalendarDate,isnull(B.dateExpiration,'01/01/2099')) as diffdate
FROM         ClaimLineDSA  A , Ref_countrycitylocation B
WHERE     (A.ClaimId = '#Claim.ClaimId#')
		and A.countrycityid *= B.countrycityid 
		and B.locationdefault =1
		and  datediff(dd,A.CalendarDate,isnull(B.dateExpiration,'01/01/2099')) >=1 
		and  datediff(dd,A.CalendarDate,isnull(B.dateEffective,'01/01/1980')) <=1 
GROUP BY  A.ClaimId, A.PersonNo, A.ClaimCategory, A.CountryCityId, A.LocationCode, 
		A.CalendarDate,B.dateeffective, B.dateExpiration,b.countrycityid
HAVING 
 	B.countrycityid is null
	order by A.countrycityid,A.locationCode
 </cfquery>	
<!--- 	 Old code that was there , this is not correct since it was entirely doing
something different and not of any use.

 <cfquery name="NonObligated" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   C.ClaimEventId, 
			         C.IndicatorCode, 
					 C.CostLineNo, 
					 C.InvoiceAmount, 
					 CL.ClaimEventId AS Exist
			FROM     ClaimEventIndicatorCost C LEFT OUTER JOIN
            	     ClaimEventIndicatorCostLine CL ON C.ClaimEventId = CL.ClaimEventId AND C.IndicatorCode = CL.IndicatorCode AND 
                     C.CostLineNo = CL.CostLineNo
			WHERE    C.ClaimEventId IN (SELECT  ClaimEventid
                                          FROM    ClaimEvent
                                          WHERE   ClaimId = '#Claim.ClaimId#')
			GROUP BY   C.ClaimEventId, 
			           C.IndicatorCode, 
					   C.CostLineNo, 
					   C.InvoiceAmount, 
					   CL.ClaimEventId
			HAVING     CL.ClaimEventId IS NULL
	</cfquery>	
	---->
	<cfset msg =''>
	<cfif NoMatchCityDSA.recordcount gte "1">
	<cfoutput query="NoMatchCityDSA" group="countrycityid">
				<cfif msg eq "">
					<cfset msg = " Cityid- .#CountryCityID# . Locationcode- .#locationCode# ">
				<cfelse>
					<cfset msg = "#msg#.Cityid-.#CountryCityID# .Locationcode-.#locationCode#  ">
				</cfif>	
	</cfoutput >		
			
			 <cfset submission = "0">
			 
			 <tr><td valign="top" bgcolor="C0C0C0"></td></tr>
			 <tr>
			  <td valign="top" bgcolor="FDDFDB">
			  <table width="94%" cellspacing="2" cellpadding="2" align="center">
			  <tr><td valign="top" height="30">
			      <font color="FF0000"><b>Problem</b></font>
			      <br>
				    <cfoutput>#MessagePerson#.#msg#</cfoutput>
				  <br>						  
				  </td></tr>
			  </table>
			  </td>	  
		     </tr>   
					
	</cfif>	
	