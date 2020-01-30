<!-- JG added this because if the file was already exported for the day 07-10-2010 
no matter what do not export it again 

Exclusively used only by Scheduler to automatically export stuff .

1. I am checking for cases where a manual export was done ,if so do not export it once again
2. Check for the previos run and if the run output is not known to the portal do not run it again.

--->
<cfquery name="CheckExported" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT     ExportNo, ExportFileId, ExportFileName, SummaryLines, SummaryAmounts, ActionStatus, OfficerUserId, OfficerLastName, OfficerFirstName, 
                      Created
FROM         stExportFile
WHERE     (CONVERT(datetime, FLOOR(CONVERT(float(24), Created))) = CONVERT(datetime, FLOOR(CONVERT(float(24), GETDATE()))))
			
</cfquery>

<cfquery name="CheckClaimExported" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT     LN.ExportNo, LN.ExportSerialNo, LN.ClaimId, LN.DocumentNo, LN.ReqDocumentId, LN.ReqDocumentNo, LN.ReqLineNo, LN.ReferenceTVLT, 
                      LN.ClaimObligated, LN.ClaimPrefix, LN.ClaimException, LN.ClaimantType, LN.ClaimIndexNo, LN.Consolidation, LN.PaymentMode, LN.ReferenceACPD, 
                      LN.ReferencePYMD, LN.DateCreated, LN.AccountPeriod, LN.ClaimDate, LN.PaymentCurrency, LN.PaymentFund, LN.PaymentDescription, 
                      LN.PortalLineNo, LN.LineCurrency, LN.LineAmount, LN.PointerClaimFinal, LN.LineClaimantType, LN.LineIndexNo, LN.LineDate, LN.LinePercentage, 
                      LN.LineDescription, LN.LineDateEnd, LN.LocationCountry, LN.LocationCode, LN.IndicatorFood, LN.IndicatorAccom, LN.PortalLineAccountNo, 
                      LN.f_accn_ser_num, LN.f_fnlp_fscl_yr, LN.f_fund_id_code, LN.f_orgu_id_code, LN.f_proj_id_code, LN.proj_external_symbol, LN.f_pgmm_id_code, 
                      LN.f_objt_id_code, LN.f_refx_agsr_seq_num, LN.f_objc_id_code, LN.f_actv_id_code, LN.LineAccountAmount, LN.SFTInvoiceNo, LN.SFTDescription, 
                      LN.BankCode, LN.BankAccountNo,max(HD.created) as last

FROM         stExportFileline LN , stexportfile HD
WHERE     claimid in (select claimid from claim where actionstatus ='3' )
and LN.ExportNo =HD.ExportNo
group by 
LN.ExportNo, LN.ExportSerialNo, LN.ClaimId, LN.DocumentNo, LN.ReqDocumentId, LN.ReqDocumentNo, LN.ReqLineNo, LN.ReferenceTVLT, 
                      LN.ClaimObligated, LN.ClaimPrefix, LN.ClaimException, LN.ClaimantType, LN.ClaimIndexNo, LN.Consolidation, LN.PaymentMode, LN.ReferenceACPD, 
                      LN.ReferencePYMD, LN.DateCreated, LN.AccountPeriod, LN.ClaimDate, LN.PaymentCurrency, LN.PaymentFund, LN.PaymentDescription, 
                      LN.PortalLineNo, LN.LineCurrency, LN.LineAmount, LN.PointerClaimFinal, LN.LineClaimantType, LN.LineIndexNo, LN.LineDate, LN.LinePercentage, 
                      LN.LineDescription, LN.LineDateEnd, LN.LocationCountry, LN.LocationCode, LN.IndicatorFood, LN.IndicatorAccom, LN.PortalLineAccountNo, 
                      LN.f_accn_ser_num, LN.f_fnlp_fscl_yr, LN.f_fund_id_code, LN.f_orgu_id_code, LN.f_proj_id_code, LN.proj_external_symbol, LN.f_pgmm_id_code, 
                      LN.f_objt_id_code, LN.f_refx_agsr_seq_num, LN.f_objc_id_code, LN.f_actv_id_code, LN.LineAccountAmount, LN.SFTInvoiceNo, LN.SFTDescription, 
                      LN.BankCode, LN.BankAccountNo

			
</cfquery>
<cfquery name="CheckifExported" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT     *
FROM         Claim 
WHERE     actionstatus ='3'
			
</cfquery>

<cfif CheckExported.recordcount gt 0   OR CheckClaimExported.recordcount gt 0  OR CheckifExported.recordcount eq 0 >
<cfoutput> "This is not getting exported "</cfoutput>
	<cfif CheckExported.recordcount gt 0 >
		<cfset Information ="The Export process was already run either manually or automatically ">
	<cfelseif CheckifExported.recordcount eq 0 >
		<cfset Information ="The Export process Had no records to Export Thank you">
	<cfelse>
		<cfset Information ="The Previous Run did not complete and we have records with status exported sitting without getting feedback" >
	</cfif>
<cfset a=0>
<cfmail 
			        to       = "george6@un.org"
					from     = "Travel Claim Portal <tcp_Do-not-reply@un.org>"
			        subject  = "Export Possible Reasons #Information# "
			        failto   = "george6@un.org"
			        mailerid = "TCP"
			        type="HTML">
																					
					<cfinclude template="../../Workflow/eMail/UNHQ/ExportFile.cfm">						
											
			    </cfmail>

<cfelse>
 

  



<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cf_wait Text="Generating Export file">

<!--- Export file for UNHQ --->

<cfparam name="URL.Mission" default="UNHQ">
<cfparam name="SESSION.acc" default="oppbajg1">
<cfparam name="SESSION.first" default="Joseph">
<cfparam name="SESSION.last" default="George">
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
		AND claimid in (select claimid from claim where actionstatus ='3')
					<!---  JG commented it for export automation
		AND    ClaimId IN (#preservesinglequotes(url.select)#)
		--->
		
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
<cfinclude template="ExportList.cfm">
<!---
<cfoutput>
	<script language="JavaScript">
	window.location = "ExportList.cfm?#URL.String#"
	</script>
</cfoutput>
--->
</cfif>
