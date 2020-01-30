

<cfquery name="DocumentType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  * 
    FROM    Ref_DocumentType
    WHERE   DocumentUsage in ('2','3')
	AND     DocumentType = '#url.docType#'   
</cfquery>

<cfif DocumentType.VerifyDocumentNo gte "1">

<font color="#FF0000">*)</font>
	
</cfif>					 
