
<!--- -------------------------------------------------------- --->
<!--- validation condition script for budget sufficiency check --->
<!--- -------------------------------------------------------- --->

<cfquery name="Check" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT     P.*
	 FROM       ItemMaster IM INNER JOIN
                RequisitionLine L ON IM.Code = L.ItemMaster INNER JOIN
                Ref_ParameterMissionEntryClass P ON IM.EntryClass = P.EntryClass 
			AND L.Mission = P.Mission 
			AND L.Period = P.Period
	 WHERE      L.RequisitionNo = '#Object.ObjectKeyValue1#' 
</cfquery>	

<cfset Funds = "No">

<cfif Check.EntityClass neq "" and Check.EditionId neq "">

	   	<CF_RequisitionFundingCheck 
		     RequisitionNo = "'#Object.ObjectKeyValue1#'" 
			 editionid     = "#check.editionid#">
			 
		<!--- method will set the variable funds --->
		
</cfif>
