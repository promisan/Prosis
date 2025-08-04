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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cf_wait Text="Generating Export file">

<!--- Export file for UNHQ --->

<cfparam name="URL.Mission" default="UNHQ">

<!---
<cftry>
--->

<CF_DropTable dbName="appsQuery" tblName="stExportInstance">

<cftransaction>

	<!--- Select claims not exported before --->
	<!--- generate DSA into stExport --->
	<!--- generate TRM into stExport--->
	<!--- generate SFT/Others into stExport --->
	<!--- generate export file format from table stExport into library --->	
	<!--- enter record in stExportFile --->
	<!--- update dbo.Claim --->	
	<!--- Generate export format --->
			
	<!--- enter record in stExportFile --->
	
	<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
	
		<cfquery name="Parameter" 
	    datasource="appsTravelClaim" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Parameter
		</cfquery>
		
		<cfset No = Parameter.ExportNo+1>
		<cfif No lt 1000>
		     <cfset No = 1000+No>
		</cfif>
			
		<cfquery name="Update" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Parameter
			SET    ExportNo = '#No#'
		</cfquery>
			
	</cflock>
			
	<!--- create export fileNo --->
		
	<cfquery name="Insert" 
	datasource="appsTravelClaim"
	   username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		INSERT INTO stExportFile
		(ExportNo, 
		ExportFileName, 
		OfficerUserId, 
		OfficerLastName, 
		OfficerFirstName)
		VALUES ('#No#','#URL.Mission# F.10 Export file','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
	</cfquery>	
		
	<!--- identify claims to be exported with 3 safeguards --->
	
	<cfquery name="Update" 
	datasource="appsTravelClaim" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		UPDATE Claim
		SET    ExportNo = '#No#'
		WHERE  ActionStatus = '3' 
		AND    ExportNo  IS NULL <!--- NOT exported before --->
		<!--- relax 
		AND    Reference IS NULL <!--- NOT uploaded in IMIS yet --->
		--->
		AND    (AccountPeriod is not NULL and AccountPeriod <> '' and AccountPeriod <> 'NULL')
		AND    ClaimRequestId IN (SELECT ClaimRequestId 
		                          FROM ClaimRequest 
								  WHERE Mission = '#URL.Mission#')
		<!--- prevent exporting empty claims --->					  
		AND    ClaimId IN (SELECT ClaimId FROM ClaimLine)						  
		AND    ClaimId IN (#preservesinglequotes(url.select)#)
		
	</cfquery>	
	
	<cfset header0 = "ReqDocumentId,
	                  ReqDocumentNo,
	                  ReqLineNo,
					  ClaimId,
					  ClaimPrefix,
					  ClaimException,
					  PaymentCurrency,
					  PaymentFund,
					  PaymentMode,
					  AccountPeriod,
					  PortalLineAccountNo,
					  Consolidation,
				      DocumentNo,
				  	  ClaimDate,
					  ClaimIndexNo">
					  
	<cfset header1 = "Fd.ClaimRequestId,
	                  Fd.f_tvrq_doc_id, 
			          Fd.f_tvrl_seq_num, 
					  C.ClaimId,
			          '#Parameter.ClaimPrefix#',
			          C.ClaimException,
			          C.PaymentCurrency,
	                  C.PaymentFund,
			          C.PaymentMode,
					  AccountPeriod,
					  Fd.seq_num,
			         '#Parameter.Consolidation#',
			          C.DocumentNo, 
		              C.ClaimDate, 
		              Person.IndexNo"> 
	
	<cfset fund1  =  "f_accn_ser_num, 
	                  f_fnlp_fscl_yr, 
					  f_fund_id_code, 
					  f_orgu_id_code, 
					  f_proj_id_code, 
					  proj_external_symbol, 
					  f_pgmm_id_code, 
					  f_objt_id_code, 
					  f_refx_agsr_seq_num, 
					  f_objc_id_code, 
					  f_actv_id_code">
			
	<!--- generate DSA into stExport --->
	
	<cf_waitEnd>
	<cf_wait Text="Generating Export file : DSA">
		
	<cfinclude template="ExportDSA.cfm">
	
	<!--- generate TRM into stExport--->
	
	<cf_waitEnd>
	<cf_wait Text="Generating Export file : TRM">
	
	<cfinclude template="ExportTRM.cfm">
	
	<!--- generate SFT/Others into stExport --->
	
	<cf_waitEnd>
	<cf_wait Text="Generating Export file : MSC,SFT">
	
	<cfinclude template="ExportOTH.cfm">
	
	<!--- generate Finishing --->
	
	<cf_waitEnd>
	<cf_wait Text="Generating Export file : Finishing">
	
	<cfinclude template="ExportFinish.cfm">
	
	<cfinclude template="ExportFile.cfm">
	
	</cftransaction>	
	
	<!---
		
	<cfcatch>
			
			<cf_waitEnd>
	    	<cftransaction action = "rollback"/>
						    		
				 <cf_ErrorInsert
					 ErrorSource      = "CFCATCH"
					 ErrorReferer     = ""
					 ErrorDiagnostics = "#CFCatch.Message# - #CFCATCH.Detail#"
					 Email = "1">
											 								   			
				<cf_message message="An internal error has occurred and was sent to the administrator for review. <br><br><b>Your export was NOT processed!" return="back">
					
				<cfabort>
								
		</cfcatch>
		
		
		
 </cftry> 
 --->
	
			
<CF_DropTable dbName="AppsQuery" tblName="ClaimExport_#SESSION.acc#">

<cfoutput>
	<script language="JavaScript">
	window.location = "ExportList.cfm?#URL.String#"
	</script>
</cfoutput>
