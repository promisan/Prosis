
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
<cfif Form.DocumentDate neq ''>
    <CF_DateConvert Value="#Form.DocumentDate#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	



<!--- verify if record exist --->


 <cfquery name="PayrollItem" 
    datasource="AppsPayroll" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
 	SELECT * 
	FROM   Ref_PayrollItem
	WHERE  PayrollItem = '#Form.Entitlement#'
 </cfquery>
 
 <cfloop index="itm" from="1" to="10">	
	  
	 <cfset dte = evaluate("Form.DateEffective_#itm#")>
	 <cfset pay = evaluate("Form.PayrollStart_#itm#")>
	 <cfset cur = evaluate("Form.Currency_#itm#")>
	 <cfset amt = evaluate("Form.Amount_#itm#")>
	 <cfset ecl = evaluate("Form.EntityClass_#itm#")>
	 
	 <cfif dte neq "" and amt neq "">
	 
	 		 <cfset dateValue = "">
			 <CF_DateConvert Value="#dte#">
			 <cfset STR = dateValue>
			 
			<cfset dateValue = "">
			<cfif pay neq ''>
			    <CF_DateConvert Value="#pay#">
			    <cfset PAY = dateValue>
			<cfelse>
			    <cfset PAY = 'NULL'>
			</cfif>	
	 		 	
			<cfquery name="Entitlement" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   PersonMiscellaneous
				WHERE  PersonNo       = '#Form.PersonNo#' 
				AND    PayrollItem    = '#Form.Entitlement#' 
				AND    DateEffective  = #str#
				AND    Status != '9'
			</cfquery>
	
			<cfif Entitlement.recordCount gte 1> 
			
				<cfoutput>
				
				<cfparam name="URL.ID" default="#Entitlement.PersonNo#">
				<cfinclude template="../PersonViewHeader.cfm">
				
				<table align="center" class="formpadding">
				<tr class="labelmedium" style="font-size:20px">
				    <td height="50">
					<cf_tl id="An entry with the following effective date was already registered">#dateformat(str,client.dateformatshow)#
				    </td>
				</tr>
				<tr  class="labelmedium"><td align="center" style="padding-top:5px">
					<cf_tl id="View Entitlement" var="1">
					<input type="button" class="button10g" value="#lt_text#" onClick="javascript:editEntitlement('#Entitlement.PersonNo#','#Entitlement.CostId#');">
				</td></tr>
				</table>
				
				</cfoutput>
				
				<cfabort>
			 
			<cfelse>	 
			
				 <cf_assignid>	
	  	 	
			     <cfquery name="InsertEntitlement" 
				     datasource="AppsPayroll" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">		 
				     INSERT INTO PersonMiscellaneous 
				         
							 (PersonNo,
							  CostId,
							  Mission,				  
							  DocumentReference,
							  DocumentDate,
							  EntitlementClass,
							  PayrollItem,
							  DateEffective,
							  PayrollStart,
							  Currency,				  
							  Amount,
							  Status,
							  Remarks,
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
						 
				      VALUES 
					  
						     ('#Form.PersonNo#',
						      '#rowguid#',
							  '#Form.Mission#',							  			      
							  '#Form.DocumentReference#',				  
							  #END#,
							  '#Form.EntitlementClass#',
							  '#Form.Entitlement#',
							  #STR#,
							  #PAY#,
							  '#Cur#',
							  '#amt#',
							  <cfif ecl neq "">
							  '0',
							  <cfelse>
							  '2',
							  </cfif> 				  
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
					  						
					  <cfif ecl neq "">
					  
					  		<cfparam name="form.actions" default="">
					  
					  		 <!--- obtain the actors --->
					  					  					  
							 <cfset Paction = ArrayNew(1)>
							 <cfset Pactor  = ArrayNew(1)>
							  
							 <cfloop index="itm" from="1" to="3">
							     <cfset Pactor[itm]  = "">
								 <cfset Paction[itm] = "">
							 </cfloop>
					  
							 <cfif form.actions neq "">
							  
							  	  <!-- take 3 actions --->	
							  
								  <cfquery name="Actions" 
									datasource="AppsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT TOP 3 *
										FROM   Ref_EntityAction
										WHERE  ActionCode IN (#preserveSingleQuotes(form.actions)#) 
										ORDER BY ListingOrder
								  </cfquery>
							  
								  <cfloop query="actions">
								  
								  	<cfset Paction[currentrow]  = ActionCode> 							  
									<cfset Pactor[currentrow]   = evaluate("Form.#ActionCode#")>
								  					  
								  </cfloop>
							  
							 </cfif>				
											 	
							<cfset link = "Staffing/Application/Employee/Cost/MiscellaneousView.cfm?id=#form.personno#&id1=#rowguid#">
							
							<cf_ActionListing 
							    EntityCode       = "EntCost"
								EntityClass      = "#ecl#"
								EntityGroup      = ""
								EntityStatus     = ""
								Mission 		 = "#form.Mission#"
								PersonNo         = "#Person.PersonNo#"
								ObjectReference  = "#Entitlement.PayrollItem#"
								ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
								ObjectKey1       = "#Form.PersonNo#"
								ObjectKey4       = "#rowguid#"
								ObjectURL        = "#link#"
								FlyActor         = "#Pactor[1]#"
								FlyActorAction   = "#Paction[1]#"
								FlyActor2        = "#Pactor[2]#"
								FlyActor2Action  = "#Paction[2]#"	
								FlyActor3        = "#Pactor[3]#"
								FlyActor3Action  = "#Paction[3]#"									
								Show             = "No"
								CompleteFirst    = "No">
							
					  </cfif>	
					  
				</cfif>	  
		  
		  </cfif> 
	  
</cfloop> 		  
		
<cfoutput>
		
	  <script language = "JavaScript">
		   ptoken.location ("EmployeeMiscellaneous.cfm?ID=#Form.PersonNo#&ID1=#Form.IndexNo#");
	  </script>	

</cfoutput>	   
