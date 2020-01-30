
<cf_screentop html="No">

 <cfset dateValue = "">
 <CF_DateConvert Value="#Form.DateApproval#">
 <cfset DTE = dateValue>
 
<cfset amt = replace(Form.AmountClaim,',','',"ALL")>
<cfset app = replace(Form.AmountApproval,',','',"ALL")>
 
<cfif IsNumeric(amt) and isNumeric(app)>
	  
	<cfif URL.ID2 neq "new">
	
		<cfquery name="Last" 
		     datasource="AppsCaseFile" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT top 1 ModificationNo
			 FROM ClaimLineAction
			 WHERE  ClaimLineId   = '#URL.ID2#'
			 ORDER BY ModificationNo DESC
		 </cfquery>
		 
		 <cfif last.recordcount eq "0">
		    <cfset last = 1>
		 <cfelse>
		    <cfset last = last.modificationNo+1>	
		 </cfif>
	
		 <cfquery name="Insert" 
		     datasource="AppsCaseFile" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO ClaimLineAction				 
			 (ClaimLineId, 			 
			  ModificationNo,
			  ClaimCategory, 
			  Currency, 
			  AmountClaim, 
			  AmountApproval, 
			  Reference,
			  DateApproval, 
			  ActionStatus, 
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName,
			  Created)		  
			  SELECT ClaimLineId, 
			         '#Last#', 
					 ClaimCategory, 
					 Currency, 
					 AmountClaim, 
					 AmountApproval, 
					 Reference, 
					 DateApproval, 
				     ActionStatus, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName, 
					 Created
			  FROM   ClaimLine
			  WHERE  ClaimLineId   = '#URL.ID2#'
			   AND   ActionStatus != '#Form.ActionStatus#' 
		 </cfquery>
	
		 <cfquery name="Update" 
			  datasource="AppsCaseFile" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE ClaimLine
			  SET    ClaimCategory       = '#Form.ClaimCategory#',
	 		         Currency            = '#Form.Currency#',
					 AmountClaim         = '#amt#',
					 AmountApproval      = '#app#',
					 DateApproval        = #DTE#,
					 ActionStatus        = '#form.actionStatus#',
					 ClaimLineMemo       = '#Form.ClaimLineMemo#',
					 Reference			 = '#Form.Reference#',
					 OfficerUserId       = '#SESSION.acc#',
					 OfficerLastName     = '#SESSION.last#',
					 OfficerFirstName    = '#SESSION.first#',
					 Created             = getDate()
			  WHERE  ClaimLineId = '#URL.ID2#'
			   AND   ClaimId  = '#URL.ClaimId#' 
		</cfquery>
					
	<cfelse>
					
			<cfquery name="Insert" 
			   datasource="AppsCaseFile" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			     INSERT INTO ClaimLine				 
				 (ClaimId, 
				  <cfif url.topiccode neq "">
				  TopicCode,
				  </cfif>				 
				  ClaimCategory, 
				  Currency, 
				  AmountClaim, 
				  AmountApproval, 
				  Reference,
				  DateApproval, 
				  ActionStatus, 
				  ClaimLineMemo,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
			      VALUES (
			      '#URL.ClaimId#',
				  <cfif url.topiccode neq "">
				  '#url.topiccode#',
				  </cfif>		
			      '#Form.ClaimCategory#',
				  '#Form.Currency#',
				  '#amt#',
				  '#app#',
				  '#Form.Reference#',
				  #DTE#,
				  '0',
				  '#Form.ClaimLineMemo#',
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')					 
			</cfquery>
				   	
	</cfif>

	<cfoutput>
	<script>
	  #ajaxLink('#SESSION.root#/CaseFile/Application/Case/Financial/ClaimLine.cfm?ClaimId=#URL.ClaimId#&topiccode=#url.topiccode#')#
	</script>			
	</cfoutput>
	
<cfelse>

<cfoutput>
	<script>	
	  alert("You entered an invalid amount")
	  #ajaxLink('#SESSION.root#/CaseFile/Application/Case/Financial/ClaimLine.cfm?ClaimId=#URL.ClaimId#&topiccode=#url.topiccode#')#
	</script>			
	</cfoutput>

</cfif>	

