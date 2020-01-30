
<cfparam name="Form.DependentId"      default="">
<cfparam name="Form.PersonNo"        default="">
<cfparam name="Form.OrgUnitClaimant" default="">
<cfparam name="Form.ClaimtypeClass" default="">
<cfparam name="Form.ClaimMemo"       default="">

<cfset dateValue = "">
	 <CF_DateConvert Value="#Form.DocumentDate#">
 <cfset DTE = dateValue>
	
<cfquery name="Check" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Claim
		WHERE ClaimId = '#url.Claimid#'
</cfquery>
		
<cfif Check.recordcount eq "0">

  <!--- define if we assign a new caseNo --->
  
  <cfquery name="CheckCase" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Claim
		WHERE Mission      = '#form.fMission#'
		AND   PersonNo     = '#form.PersonNo#'
		AND   OrgUnit      = '#form.OrgUnit#'
		AND   ClaimType    = '#Form.ClaimType#'
		AND   DocumentDate = #dte#
  </cfquery>
	
  <cfif CheckCase.recordcount gte "1">
   
	    <cfset caseno = CheckCase.CaseNo>
		
  <cfelse>
   
  	 <cfquery name="Last" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT TOP 1 *
		    FROM  Claim
			ORDER BY CaseNo DESC
 	 </cfquery>
	 
	 <cfif last.recordcount eq "0">
	      <cfset caseno = "1">
	 <cfelse>
	 	  <cfset caseno = "#last.caseno+1#">	
	  </cfif>
	
  </cfif>	  

     <cfquery name="InsertClaim" 
     datasource="AppsCaseFile" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO Claim
         (ClaimId,
		 CaseNo,
		 Mission,
		 DocumentNo,
		 DocumentDate,
		 DocumentDescription,
		 OrgUnit,
		 PersonNo,
		 DependentId,
		 OrgUnitClaimant,
		 ClaimantEMail,
		 ClaimType,  
		 <cfif form.claimtypeclass neq "">
		 ClaimTypeClass,
		 </cfif>
		 ClaimMemo,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
      VALUES ('#URL.ClaimId#',
	      '#caseno#',
          '#Form.fMission#',
		  '#Form.DocumentNo#',
		  #dte#,
		  '#Form.DocumentDescription#',
		  '#Form.OrgUnit#',
		  '#Form.PersonNo#',
		  <cfif form.dependentid eq "">
		  NULL,
		  <cfelse>
		  '#Form.DependentId#',
		  </cfif>
		  '#Form.OrgunitClaimant#',
		  '#Form.ClaimantEMail#',
		  '#Form.ClaimType#',			  
		  '#Form.ClaimTypeClass#',
		  '#Form.ClaimMemo#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
  </cfquery>	
  
  <cfquery name="Claim" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Claim
		WHERE  ClaimId = '#URL.claimid#'	
	</cfquery>
	
 <cfquery name="ClaimTypeClass" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
	    FROM    Ref_ClaimTypeClass
		WHERE   ClaimType = '#Form.ClaimType#'	
		AND     Code      = '#Form.ClaimTypeClass#'
  </cfquery>
		
  <cfif claim.recordcount eq "1">
  
    <cfif ClaimTypeClass.entityclass neq "">

		<cfset link = "CaseFile/Application/Claim/CaseView/ClaimView.cfm?claimid=#Claim.claimId#">
			
		<cf_ActionListing 
			EntityCode       = "Clm#Claim.ClaimType#"
			EntityClass      = "#ClaimTypeClass.EntityClass#"
			EntityGroup      = ""
			EntityStatus     = ""
			Mission          = "#claim.mission#"
			OrgUnit          = "#claim.orgunit#"
			PersonNo         = "" 
			PersonEMail      = "#Claim.ClaimantEmail#"
			ObjectReference  = "Insurance Claim: #Claim.DocumentNo#"
			ObjectReference2 = ""
			ObjectKey4       = "#Claim.ClaimId#"
			ObjectURL        = "#link#"
			Show             = "No"									
			CompleteCurrent  = "No">
			
	   </cfif>	
				
  </cfif>	
 
<cfelse>

	<cftry>

	 <cfquery name="UpdateCase" 
     datasource="AppsCaseFile" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 UPDATE Claim
	 SET    DocumentNo      = '#Form.DocumentNo#',
	        ClaimantEMail   = '#Form.ClaimantEMail#',	
   			PersonNo	    = '#Form.PersonNo#',
			<cfif form.dependentid eq "">
		    DependentId = NULL,
		    <cfelse>
		    DependentId = '#Form.DependentId#',
		    </cfif>
			OrgUnitClaimant = '#Form.OrgunitClaimant#',
			DocumentDescription =  '#Form.DocumentDescription#',
			<cfif Form.ClaimMemo neq "null">
				<!---Preventing a fast clicker to break the code 
				Jorge Mazariegos on Sept 8 2010 --->
				ClaimMemo       = '#Form.ClaimMemo#',
			</cfif>					
			OrgUnit         = '#Form.OrgUnit#',
			<cfif form.claimtypeclass neq "">
			ClaimTypeClass = '#Form.ClaimTypeClass#',
			</cfif>
			DocumentDate   = #dte#
     WHERE  ClaimId = '#URL.ClaimID#' 
     </cfquery>
	 
	 <cfcatch>
	 <table align="center"><tr><td>
	 <font size="2" color="#FF0000"><cf_tl id="Error occurred when trying to saving your update">.</font>
	 </td></tr></table>
	 </cfcatch>
	 
	 </cftry>

</cfif>	
<cf_getmid>
<cfif Check.recordcount eq "0">	

	<cfoutput>
	
		<script language="JavaScript">
		    parent.window.location = "../Caseview/CaseView.cfm?claimid=#url.claimid#&mid=#mid#"
			try { 					
					parent.opener.applyfilter('1','','content')  
				} catch(e) {}	
			
		</script>
		
	</cfoutput>

<cfelse>

   <cfoutput>

	    <cfset url.init = 0>

		<script>
				 	
			try { 
					parent.window.location = "../Caseview/CaseView.cfm?claimid=#url.claimid#&mid=#mid#"
					parent.opener.applyfilter('1','','#url.claimid#')  
				} catch(e) {}		
								
		</script>
	
   </cfoutput>	
		
</cfif>
	