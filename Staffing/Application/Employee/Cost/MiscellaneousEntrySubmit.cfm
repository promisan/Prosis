
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_systemscript>

<script language="JavaScript">

function editEntitlement(persno, no) {
	ptoken.location("MiscellaneousEdit.cfm?ID=" + persno + "&ID1=" + no);
}
</script>

<cfif Len(Form.Remarks) gt 100>
  <cfset remarks = left(Form.Remarks,100)>
<cfelse>
  <cfset remarks = Form.Remarks>
</cfif>  

<cfparam name="Form.Entitlement" default="">

<cfif Form.Entitlement eq "">
    <script>
		alert("You must select a category.")
		history.back()
	</script>
</cfif>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset dateValue = "">
<cfif Form.DocumentDate neq ''>
    <CF_DateConvert Value="#Form.DocumentDate#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<!--- verify if record exist --->

<cfquery name="Entitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   PersonMiscellaneous
	WHERE  PersonNo       = '#Form.PersonNo#' 
	AND    PayrollItem    = '#Form.Entitlement#' 
	AND    DateEffective  = #STR#
</cfquery>

<cfparam name="Entitlement.RecordCount" default="0">

<cfif Entitlement.recordCount gte 1> 
	
	<cfoutput>
	
	<cfparam name="URL.ID" default="#Entitlement.PersonNo#">
	<cfinclude template="../PersonViewHeader.cfm">
	
	<table align="center">
	<tr class="labelmedium">
	    <td height="50">
		<cf_tl id="An entry with this effective date was already registered">
	    </td>
	</tr>
	<tr><td align="center">
		<cf_tl id="Edit Entitlement" var="1">
		<input type="button" class="button10g" value="#lt_text#" onClick="javascript:editEntitlement('#Entitlement.PersonNo#','#Entitlement.CostId#');">
	</td></tr>
	</table>
	
	</cfoutput>

<cfelse>

	 <cfquery name="PayrollItem" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 	SELECT * 
		FROM   Ref_PayrollItem
		WHERE  PayrollItem = '#Form.Entitlement#'
	 </cfquery>

      <cfquery name="InsertEntitlement" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 
     INSERT INTO PersonMiscellaneous 
         
			 (PersonNo,
			  CostId,
			  Mission,
			  DateEffective,
			  DocumentReference,
			  DocumentDate,
			  EntitlementClass,
			  PayrollItem,
			  Currency,
			  Status,
			  Amount,
			  Remarks,
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName)
		 
      VALUES 
	  
		     ('#Form.PersonNo#',
		      '#Form.CostId#',
			  '#Form.Mission#',
		      #STR#,
			  '#Form.DocumentReference#',
			  #END#,
			  '#Form.EntitlementClass#',
			  '#Form.Entitlement#',
			  '#Form.Currency#',
			  <cfif form.entityclass neq "">
			  '0',
			  <cfelse>
			  '2',
			  </cfif> 
			  '#Form.Amount#',
			  '#Remarks#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
		  
	  </cfquery>	  		    
	  
   	 
		<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Person
			WHERE  PersonNo = '#Form.PersonNo#' 
		</cfquery>
		
		<cfif form.entityclass neq "">
							 	
			<cfset link = "Staffing/Application/Employee/Cost/MiscellaneousEdit.cfm?id=#form.personno#&id1=#form.costid#">
			
			<cf_ActionListing 
			    EntityCode       = "EntCost"
				EntityClass      = "#form.entityclass#"
				EntityGroup      = ""
				EntityStatus     = ""
				Mission 		 = "#form.Mission#"
				PersonNo         = "#Person.PersonNo#"
				ObjectReference  = "#Entitlement.PayrollItem#"
				ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
				ObjectKey1       = "#Form.PersonNo#"
				ObjectKey4       = "#Form.CostId#"
				ObjectURL        = "#link#"
				Show             = "No"
				CompleteFirst    = "No">
			
		</cfif>	
		
		<cfoutput>>
		
	     <script language = "JavaScript">
		 	   ptoken.location ("EmployeeMiscellaneous.cfm?ID=#Form.PersonNo#&ID1=#Form.IndexNo#");
	     </script>	

        </cfoutput>	   
	
</cfif>	