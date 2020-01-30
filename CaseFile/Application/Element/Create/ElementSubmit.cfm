
<!--- element submit 
	
	Steps
	
	1. Check if element exists, if exists use this (select)
	2a. Add element or update element
	2b. Add Element to the case
	3. Refresh listing
	4. Allow for entry of additional info like lines or person by reloading the content. etc.

--->

<cfparam name="url.forclaimid"     default="">
<cfparam name="url.elementid"      default="">
<cfparam name="url.submitmode"     default="close">

<cfif url.drillid eq "">
  <cfset url.drillid = url.caseelementid>
</cfif>

<cfquery name="Element" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Element
	 WHERE   ElementId  = '#elementid#'	
</cfquery>

<cfif url.forclaimid neq "">
	
	<cfquery name="Case" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    Claim.*
	    FROM      Claim 
		WHERE     ClaimId = '#url.forclaimid#'			
	</cfquery>

<cfelse>
	
	<cfquery name="Case" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    Claim.*
	    FROM      Claim INNER JOIN ClaimElement ON Claim.ClaimId = ClaimElement.claimId              
		WHERE     CaseElementid = '#url.drillid#'			
	</cfquery>
	
	<cfset url.forclaimid = case.claimid>

</cfif>

<!--- record the action --->

<cfparam name="url.actionid" default="">

<cfif url.actionid eq "">
	<cf_assignid>
	<cfset url.actionid = rowguid>
</cfif>		

<cfif element.recordcount eq "0">
	 <cfset act = "EL1">
<cfelse>
   	 <cfset act = "EL2">
</cfif>

<!--- record the workflow action table --->

<cfparam name="form.ActionMemo" default="">

<cfquery name="Action" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 INSERT INTO CaseAction	
		 (ActionId,
		  ActionCode,
		  ActionSubmitted,
		  NodeIP,
		  ActionMemo,	 
		  OfficerUserId,
		  OfficerLastName,
		  OfficerFirstName)
	 VALUES
		 ('#url.actionid#',
		  '#act#',
		  getDate(),
		  '#CGI.Remote_Addr#',
		  '#Form.ActionMemo#',
		  '#SESSION.acc#',
		  '#SESSION.last#',
		  '#SESSION.first#')	 
</cfquery>

<cfquery name="Parameter" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ParameterMission
	 WHERE   Mission  = '#Case.Mission#'	
</cfquery>

<!--- assign values for the element --->
<cfif url.elementid eq "">
    <cf_assignid>
    <cfset elementid = rowguid>	
<cfelse>
    <cfset elementid = url.elementid> 	
</cfif>

<!--- assign values for the case element --->
<cfif url.caseelementid eq "">
    <cf_assignid>
    <cfset caseelementid = rowguid>		
</cfif>

<cfif len(form.elementmemo) gt "2000">
   <cfset memo = left(form.elementmemo,2000)>
<cfelse>
   <cfset memo = form.elementmemo>
</cfif>


<cfparam name="form.dependentid" default="">

<cfquery name="Element" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Element
	 WHERE   ElementId  = '#elementid#'	
</cfquery>

	<cftransaction>
	
		<cfif Element.recordcount eq "0"> 
			
			<cfquery name="Class" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					 SELECT   *
				     FROM     Ref_ElementClass 
					 WHERE    Code = '#url.elementclass#'				
			</cfquery>
				
			<cfif Class.ReferencePrefix neq "">   
					
				  <!--- this sets the reference --->					 
				  <cfinclude template="AssignReference.cfm">
				 			  
			<cfelse>
			
				  <cfset ref = "#form.ElementReference#">		  
				  
			</cfif>	  
					
			<cfquery name="Insert" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 INSERT INTO Element
				 (ElementId,
				  ElementClass,
				  ActionId,
				  Source,
				  Reference,
				  <cfif form.dependentid neq "">
				  DependentId,
				  </cfif>
				  ElementMemo,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)	
			     VALUES
				 ('#elementid#',
				  '#url.elementclass#',
				  '#url.actionid#',
				  'MANUAL',
				  '#ref#',
				  <cfif form.dependentid neq "">
				  '#form.dependentid#',
				  </cfif>
				  '#memo#',
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')	
			</cfquery>
			
			<!--- add association --->
			
			<cf_assignid>
			
			<cfparam name="form.sourceElementId" default="">
			
			<cfif form.sourceelementid eq "">
			   <cfset sourceid = 'NULL'>
			<cfelse>  
			  <cfset sourceid = "'#form.sourceelementid#'">		  
			  <cfset client.sourcedocument = form.sourceElementId>
			</cfif>
			
			<cfquery name="InsertCaseAssociation" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 INSERT INTO ClaimElement
						 (ClaimId,
						  CaseElementId,
						  ElementId,
						  SourceElementId,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)	
			     VALUES
					   ('#url.forclaimid#',
					    '#caseelementid#',
					    '#elementid#',
						#preservesinglequotes(sourceid)#,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#')	
			</cfquery>		
					
			<cfset url.drillid = caseelementid>
					
		<cfelse>
		
		    <cfparam name="form.sourceElementId" default="">
		
			<cfif form.sourceelementid eq "">
			
				<cfquery name="Update" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					 UPDATE ClaimElement
					 SET    SourceElementId  = NULL 			       
					 WHERE  CaseElementId = '#url.caseelementid#'				 
				</cfquery>
					
			<cfelse>
			
				<cfset client.sourcedocument = form.sourceElementId>
			
				<cfquery name="Update" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					 UPDATE ClaimElement
					 SET    SourceElementId  = '#form.sourceElementId#' 			       
					 WHERE  CaseElementId = '#url.caseelementid#'			 
				</cfquery>
			
			</cfif>
		
			<cfquery name="Update" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 UPDATE Element
				 SET    Reference   = '#form.elementreference#', 
					    <cfif form.dependentid eq "">
						DependentId = NULL,
						<cfelse>
						DependentId = '#Form.DependentId#',
						</cfif>
				        ElementMemo = '#memo#'
				 WHERE  ElementId   = '#elementid#'			 
			</cfquery>
		
		</cfif>
	
	</cftransaction>
		
	<cfinclude template="ElementSubmitCustom.cfm">

<cfoutput>
		
<cfif Element.recordcount eq "0">		   

 	 <script>		
		 
	 	try {				
		opener.applyfilter('1','','content') 
		} catch(e) { 	
		}    
		
		try {				
		parent.listingcontent.applyfilter('1','','content')		
		} catch(e) { 				
		}    
			
					 
	 	<cfif Class.ReferencePrefix neq "">   
			// alert("Assigned Element Reference: #ref#")
		</cfif>	   
		
		<cfif url.submitmode eq "close">	  		  
		   parent.ColdFusion.Window.hide('mydialog')	
		    try { parent.ColdFusion.Window.hide('editelement') } catch(e) {}								
		</cfif>   
			
     </script>	
		    
<cfelse>		
	
    <script> 	    
	    
	    try {				
		opener.applyfilter('1','','#url.caseelementid#') } catch(e) {}    	
		<cfif url.submitmode eq "close">
	       try { parent.ColdFusion.Window.hide('editelement') } catch(e) {}
    	</cfif>
		
   </script>
	
</cfif>	

<cfif url.submitmode eq "open">
	
	 <script language="JavaScript">
	    ptoken.navigate('ElementEditForm.cfm?mission=#url.mission#&drillid=#url.drillid#&forclaimid=#url.forclaimid#&elementid=#url.elementid#&elementclass=#url.elementclass#&mode=edit','contentbox1')
	 </script>  
	 
<cfelseif url.submitmode eq "new">

	 <script language="JavaScript">
	   
	    <!--- drillid eq "" means triggering a new record --->
	    ptoken.navigate('ElementEditForm.cfm?mission=#url.mission#&drillid=&forclaimid=#url.forclaimid#&caseelementid=#caseelementid#&elementid=&elementclass=#url.elementclass#&mode=edit','contentbox1')		
	 </script>  	 

</cfif>
		
</cfoutput>

