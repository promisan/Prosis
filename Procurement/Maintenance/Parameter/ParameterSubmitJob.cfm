
<cfquery name="Update" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_ParameterMission
		SET QuotationPrefix          = '#Form.QuotationPrefix#',
			QuotationSerialNo        = '#Form.QuotationSerialNo#',
			QuotationLibrary         = '#Form.QuotationLibrary#',
			QuotationTemplate        = '#Form.QuotationTemplate#',
			EnableVendorRoster       = '#Form.EnableVendorRoster#',
			EnableQuickQuote         = '#Form.EnableQuickQuote#',
			TaxDefault               = '#Form.TaxDefault/100#',
			DefaultTaxIncluded       = '#Form.DefaultTaxIncluded#',
			BuyerDescription         = '#Form.BuyerDescription#', 
			JobReferenceName         = '#Form.JobReferenceName#',			
			AwardLowestBid           = '#Form.AwardLowestBid#',
			AddressTypeRFQ           = '#Form.AddressTypeRFQ#',
			OfficerUserId 	 		 = '#SESSION.ACC#',
			OfficerLastName  		 = '#SESSION.LAST#',
			OfficerFirstName 		 = '#SESSION.FIRST#',
			Created          		 =  getdate()			
	WHERE Mission                    = '#url.Mission#'
</cfquery>

<!--- apply to all entries of that mission --->

<cfquery name="Class" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMissionEntryClass 
		WHERE  Mission    = '#URL.Mission#'	
</cfquery>

<cfloop query="Class">

    <cfparam name="Form.name0_#entryclass#"                default="">
	<cfparam name="Form.BuyerDefaultThreshold_#entryclass#"       default="0">
	<cfparam name="Form.name1_#entryclass#"          default="">
	<cfparam name="Form.BuyerDefaultBackupThreshold_#entryclass#" default="0">
	
	<cfset buy       = evaluate("Form.name0_#entryclass#")>
	<cfset buythres = evaluate("Form.BuyerDefaultThreshold_#entryclass#")>
	<cfset bck      = evaluate("Form.name1_#entryclass#")>
	<cfset bckthres = evaluate("Form.BuyerDefaultBackupThreshold_#entryclass#")>
	
	<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE  Ref_ParameterMissionEntryClass 
		SET     BuyerDefault                = '#buy#', 
			    BuyerDefaultThreshold       = '#buythres#',
				BuyerDefaultBackup          = '#bck#',
				BuyerDefaultBackupThreshold = '#bckthres#',
				OfficerUserId 	 			= '#SESSION.ACC#',
				OfficerLastName  			= '#SESSION.LAST#',
				OfficerFirstName 			= '#SESSION.FIRST#',
				Created          			=  getdate()				
		WHERE   Mission               = '#url.Mission#' 
		AND     EntryClass            = '#entryclass#'
	</cfquery>
	
</cfloop>

<cfinclude template="ParameterEditJob.cfm">

	
