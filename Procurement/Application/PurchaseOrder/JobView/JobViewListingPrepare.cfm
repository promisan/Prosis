
<cfset condition = "">

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     Job.*, RequisitionLine.*
FROM         RequisitionLine INNER JOIN
                      Job ON RequisitionLine.JobNo = Job.JobNo
WHERE     (RequisitionLine.RequisitionNo NOT IN
                          (SELECT     RequisitionNo
                            FROM          PurchaseLine))
#preserveSingleQuotes(condition)#  
ORDER BY  Job.Created		
</cfquery>

<cflocation url="JobViewListing.cfm?Period=#URL.Period#&Mission=#URL.Mission#&ID=#URL.ID#&ID1=#URL.ID1#" addtoken="No">