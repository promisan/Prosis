
<!--- get the DSA current rate --->

<cfparam name="url.location" default="">

<cfquery name="get"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP (1) AmountBase
	FROM     Ref_ClaimRates
	WHERE    ServiceLocation = '#url.location#' 
	AND      DateEffective < GETDATE() 
	AND      (DateExpiration IS NULL OR DateExpiration > GETDATE())
	ORDER BY DateEffective DESC, RatePointer
</cfquery>