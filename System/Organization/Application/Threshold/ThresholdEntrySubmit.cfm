
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<script language="JavaScript">

function editThreshold(id) {
	window.location = "ThresholdEdit.cfm?ID=" + id ;
}
</script>

<cfif Len(Form.Memo) gt 100>
  <cfset remarks = left(Form.Memo,100)>
<cfelse>
  <cfset remarks = Form.Memo>
</cfif> 

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<!---
<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = #dateValue#>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	
--->

<!--- verify if record exist --->

<cfquery name="Threshold" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   OrganizationThreshold
WHERE  OrgUnit        = '#Form.OrgUnit#' 
  AND  ThresholdType  = '#Form.ThresholdType#'
  AND  DateEffective  = #STR#
</cfquery>

<cfif Threshold.recordCount gte 1> 

<cfoutput>

<cfparam name="URL.ID" default="#form.OrgUnit#">

<table>
<tr><td style="padding-top:10px" class="labelmedium">

<font color="FF0000">A threshold with this Effective date was already registered</font>

</td>
</tr>

<tr><td>

   <input type="button"
          class="button10g" 
		  value="Edit Threshold" 
		  onClick="javascript:editThreshold('#Threshold.ThresholdId#');">
		  
		  </td></tr>
		  
</td></tr></table>		  

</cfoutput>

<CFELSE>

      <cfquery name="InsertAccount" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO OrganizationThreshold 
	         (Orgunit,
			  DateEffective,
			  ThresholdType,
			  Currency,
			  AmountThreshold,
			  Memo,			
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName)
	      VALUES ('#Form.Orgunit#',
	           #STR#,
			   '#form.thresholdtype#',
			   '#Form.Currency#',
			   '#Form.amountThreshold#',
			   '#Form.Memo#',			  
			   '#SESSION.acc#',
	    	   '#SESSION.last#',		  
		  	   '#SESSION.first#')
 	  </cfquery>
	  
     <cfoutput>
	 
     <script>	 
		 window.location = "ThresholdListing.cfm?ID=#Form.OrgUnit#";    
     </script>	
	 
	 </cfoutput>
	
	
</cfif>	

