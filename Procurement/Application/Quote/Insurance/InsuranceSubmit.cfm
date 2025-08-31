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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<!--- save address --->

<cfset dateValue = "">
<CF_DateConvert Value="#DateFormat(Form.ContactDOB,CLIENT.DateFormatShow)#">
<cfset dob = dateValue>

<cfif Form.AddressId neq "">

	<cfquery name="Check" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT * FROM vwOrganizationAddress 	  
	   WHERE AddressId  = '#Form.AddressId#'
	</cfquery>
	
	<cfif Check.recordcount eq "1">
	
		<cfquery name="Update" 
		   datasource="AppsOrganization" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   UPDATE System.dbo.Ref_Address 
		   SET   Address             = '#Form.Address1#',
				 Address2            = '#Form.Address2#',
				 AddressCity         = '#Form.City#',
				 State               = '#Form.State#',
				 AddressPostalCode   = '#Form.PostalCode#',
				 Country             = '#Form.Country#',
				 eMailAddress        = '#Form.eMailAddress#',
				 Remarks             = '#Form.Remarks#'
		   WHERE AddressId  = '#Form.AddressId#'
		</cfquery>
		
		<cfquery name="Update" 
		   datasource="AppsOrganization" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   UPDATE OrganizationAddress
		   SET TelephoneNo         = '#Form.TelephoneNo#',
			   MobileNo            = '#Form.MobileNo#',
			   FaxNo               = '#Form.FaxNo#',			
			   Contact             = '#Form.Contact#',
			   ContactId           = '#Form.ContactId#',
			   ContactDOB          = #dob#,
			   FiscalNo            = '#Form.FiscalNo#'
		   WHERE AddressId  = '#Form.AddressId#'
		   AND OrgUnit ='#url.orgunit#'		
		</cfquery>   	
		
	
	</cfif>

</cfif>

<cftransaction>

<!--- save the insurance --->

<cfquery name="JobVendor" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		UPDATE  JobVendor
		SET     Insurance = '#Form.Insurance#',
		        InsuranceNo = '#Form.InsuranceNo#',
			    InsuranceAmount = '#Form.InsuranceAmount#',
			    PaymentCondition = '#Form.PaymentCondition#',
			    PaymentAdvance   = '#Form.PaymentAdvance#',
			    ContractType     = '#Form.ContractType#'		
		WHERE   OrgUnitVendor = '#url.orgunit#'				
		AND     JobNo = '#Url.JobNo#'
</cfquery>


<cfquery name="Tracking" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT  * 
		FROM    Ref_Tracking
		WHERE   TrackingClass IN ('Contract','Insurance')		
</cfquery>


<cfquery name="Clear" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		DELETE FROM JobVendorTracking
		WHERE   OrgUnitVendor = '#url.orgunit#'				
		AND     JobNo = '#Url.JobNo#'
		AND     TrackingCode IN (SELECT  Code 
		                         FROM    Ref_Tracking
		                         WHERE   TrackingClass IN ('Contract','Insurance')		
								)  		
</cfquery>

<cfloop query="Tracking">

	<cfparam name="form.TrackingDate_#code#" default="">
	<cfparam name="form.TrackingMemo_#code#" default="">
	
	<cfset date = evaluate("form.TrackingDate_#code#")>
	<cfset memo = evaluate("form.TrackingMemo_#code#")>
	
	<cfif date neq "">
	
		<cfset dateValue = "">
		<CF_DateConvert Value="#DateFormat(date,CLIENT.DateFormatShow)#">
		<cfset dte = dateValue>	

	<cfquery name="Insert" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			INSERT INTO JobVendorTracking
			(JobNo,OrgUnitVendor,TrackingCode,TrackingDate,TrackingMemo,OfficerUserId,OfficerLastName,OfficerFirstName)
			VALUES
			('#Url.JobNo#','#url.orgunit#','#code#',#dte#,'#memo#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')			  		
	</cfquery>
	
	</cfif>

</cfloop>

</cftransaction>	


<cfinclude template="InsuranceDetail.cfm">

