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
<cfquery name="Vendor" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   J.*, O.OrgUnitName, O.OrgUnitCode
     FROM     Job AS J INNER JOIN
              JobVendor AS JV ON J.JobNo = JV.JobNo INNER JOIN
              Organization.dbo.Organization AS O ON JV.OrgUnitVendor = O.OrgUnit					  
	 WHERE   J.JobNo ='#Object.ObjectKeyValue1#'	 
	 AND     JV.OrgUnitVendor = '#Object.ObjectKeyValue2#'
</cfquery>

<cfoutput>
<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td align="center">
	REQUEST FOR QUOTATION
	</td></tr>
	
	<tr><td height="60">Subject:	REF: <b>#Vendor.CaseNo#</b></td></tr>
	
	<tr><td height="20"></td></tr>
	
	<tr><td>
	1.  The Organizations requests your price quotation for the item(s) specified in this Request for Quotation (RFQ).
	</td></tr>
	
	<tr><td>
	2.  We would appreciate receiving your quotation on or before #dateformat(Vendor.Deadline,CLIENT.DateFormatShow)# via fax by close of business.  Your quotation must be valid for at least 30 days.  Your quotation will be reviewed by the Organizations in accordance with its financial rules and regulations as well as the Considerations contained herein.
	</td></tr>
	
	<tr><td>
	3.  Financial rules and regulations of the Organizations preclude advance payments or payments by letter of credit.  Such provisions in a quotation will be prejudicial to its evalutation by the Organizations.  The normal payment terms of the United  Nations is net 30 days (or similar discounted payment terms if offered by your company) upon satisfactory delivery of merchandise and accepance thereof by Organizations.  You must therefore clearly specify in your quotation if our payment term is acceptable.
	</td></tr>
	
	<tr><td>
	4.  Please note the Organizations has tax and duty exemption status and can provide documentation for same.  Hence,  your pricing should take this status into account (USA vendors only).
	</td></tr>
	
	<tr><td>
	5.  It has been officially established that the Organizations is eligible under the Foreign Assistance Act of 1961 to receive full benefits under GSA contracts.  Your quotation must state if the items which you are supplying are currently subject to GSA Federal Supply pricing and indicate the GSA Contract Number and expiration date, where applicable (USA Vendors only).
	</td></tr>
	
	<tr><td height="20"></td></tr>
	<tr><td height="60" align="right">
	
		<table><tr><td>
		#SESSION.first# #SESSION.last#
		</td></tr>
		<tr><td>#client.email#</td></tr>	
		<tr><td>#Vendor.QuotationContact#</td></tr>
		</table>
		
	</td></tr>
	
	<tr><td>Additional remarks:</td></tr>	
	<tr><td><cfif Vendor.QuotationRemarks eq "">None<cfelse>#Vendor.QuotationRemarks#</cfif></td></tr>
		
</table>
	
</cfoutput>	
