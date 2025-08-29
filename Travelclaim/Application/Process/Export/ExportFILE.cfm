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
<cfquery name="ExportFile" 
datasource="appsTravelClaim"   
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT ClaimPrefix, 
       ReqDocumentNo, 
	   ReqLineNo, 
	   PortalLineNo, 
	   PortalLineAccountNo, 
	   ClaimException, 
	   ClaimantType, 
	   ClaimIndexNo, 
	   Consolidation, 
	   ReferenceACPD, 
	   ReferencePYMD, 
	   CONVERT(char(10), DateCreated, 101) AS DateCreated, 
	   AccountPeriod, 
	   'TCP' + CONVERT(varchar(10), DocumentNo, 101) as DocumentNo, 
	   CONVERT(char(10), ClaimDate, 101) AS ClaimDate, 
	   PaymentCurrency, 
	   PaymentFund, 
	   PaymentDescription, 
	   LineCurrency, 
	   LineAmount, 
	   PointerClaimFinal, 
	   ReferenceTVLT, 
	   LineClaimantType, 
	   LineIndexNo, 
	   CONVERT(char(10), LineDate, 101) AS LineDate, 
	   LineDescription, 
	   CONVERT(char(10), LineDateEnd, 101) AS LineDateEnd, 
	   LocationCountry, 
	   LocationCode, 
	   IndicatorFood, 
	   IndicatorAccom, 
	   f_accn_ser_num, 
	   f_fnlp_fscl_yr, 
	   f_fund_id_code, 
	   f_orgu_id_code, 
       f_proj_id_code, 
	   proj_external_symbol, 
	   f_pgmm_id_code, 
	   f_objt_id_code, 
	   f_refx_agsr_seq_num, 
	   f_actv_id_code, 
	   f_objc_id_code, 
	   LineAccountAmount, 
       SFTInvoiceNo, 
	   SFTDescription,
	   BankCode,
	   BankAccountNo
INTO  userQuery.dbo.stExportInstance	   
FROM  stExportFileLine
WHERE ExportNo = '#No#'	
ORDER BY DocumentNo, PortalLineNo, PortalLineAccountNo 
</cfquery>	

<cfquery name="ExportFile" 
  datasource="appsTravelClaim"   
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT   *
	FROM     userQuery.dbo.stExportInstance	
</cfquery>

<cfquery name="Fields" 
  datasource="appsTravelClaim"   
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT   C.name, C.userType 
	FROM     userQuery.dbo.SysObjects S, 
	         userQuery.dbo.SysColumns C 
	WHERE    S.id = C.id
	AND      S.name = 'stExportInstance'	
	ORDER BY C.ColId
</cfquery>

<cfset list = "">
<cfloop query="Fields">
    <cfif list eq "">
	    <cfset list = "#Fields.Name#"> 
	<cfelse>
		<cfset list = "#list#,#Fields.Name#">
	</cfif>	
</cfloop>

<cfquery name="Sum" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   stExportFile
WHERE  ExportNo = '#No#'	
</cfquery>	

<cfsavecontent variable="exportfile">
<cfoutput query="ExportFile"><cfloop index="name" list="#list#" delimiters=",">#evaluate(name)#|</cfloop>;
</cfoutput>

<cfoutput>TRL|#Sum.SummaryLines#|#Sum.SummaryAmounts#|#DateFormat(Sum.Created, client.DateSQL)#</cfoutput>
</cfsavecontent>

<cffile action="WRITE" 
        file="#Parameter.DocumentLibrary#\Export\#sum.ExportFileId#" 
		output="#exportfile#">



