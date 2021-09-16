
<!--- various options to apply the quote --->

<cfparam name="url.action" default="">

<cfswitch expression="#url.action#">

    <cfcase value="Quote"> 
				
		<cfset fileName = "myQuote_#form.requestno#">
				
		 <cfquery name="template"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  * 
			FROM    WarehouseJournal 
			WHERE   Warehouse    = '#Form.Warehouse#'						
			AND     Area         = 'Sale'
		</cfquery>

		<cfsavecontent variable="DocumentContent">		
		<cfif template.transactionTemplateMode1 eq "">
             <cfinclude template="defaultQuote.cfm">
		<cfelse>
			 <cfinclude template="../../../../#template.transactionTemplateMode1#">
		</cfif>
		</cfsavecontent>
				
		<!--- embed into the mail framework and record the action : CustomerRequestAction --->
		
		<!--- for testing only --->
		
		<cfset text = replace("#DocumentContent#", "@pb", "<p style='page-break-after:always;'>&nbsp;</p>", "ALL")>
				
		<cffile action="WRITE" 
		      file="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#fileName#.htm" 
			  output="#text#" 
			  addnewline="Yes" 
			  fixnewline="No">		
				 
		<!--- on-the-fly converter of htm content to pdf --->
		<cf_htm_pdf fileIn= "#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#fileName#">
				 

		<cfquery name="setAction" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
								
			INSERT INTO CustomerRequestAction ( 	
				        RequestNo,
						ActionCode, 
						ActionMemo,
						OfficerUserId, 
						OfficerLastName, 
						OfficerFirstName )
					
			VALUES ( '#form.RequestNo#', 
					 'Send', 
					 '----', 			
					 '#session.acc#',
					 '#session.last#',
					 '#session.first#' )
					 
		</cfquery>

		<cfoutput>
     	<script>		  
			ptoken.open('#SESSION.root#/CFRStage/User/#SESSION.acc#/#fileName#.pdf','_new')
		</script>
		</cfoutput>

	</cfcase>
	
	<cfcase value="POS">
		
		<cfquery name="getRequest"
				datasource="AppsMaterials"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				UPDATE CustomerRequest
				SET    ActionStatus = '1'
				WHERE  RequestNo = '#Form.RequestNo#'
				AND    RequestNo IN (SELECT RequestNo FROM CustomerRequestLine)
		</cfquery>
		
		<!--- keep the daatbase clean 
		remove entries without lines
		reset other quotes of this person 
		--->
		
		<cfquery name="clearRequest"
				datasource="AppsMaterials"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				DELETE CustomerRequest				
				WHERE  Source        = 'Quote'
				AND    OfficerUserid = '#session.acc#'				
				AND    RequestNo NOT IN (SELECT RequestNo FROM CustomerRequestLine)
		</cfquery>
		
		<cfquery name="resetRequest"
				datasource="AppsMaterials"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				UPDATE CustomerRequest
				SET    ActionStatus  = '9'
				WHERE  ActionStatus  = '0' 
				AND    Source        = 'Quote'
				AND    OfficerUserid = '#session.acc#'				
		</cfquery>
				
		<script>
		    alert('Quote has been submitted')
			addquote()
		</script>
			
	</cfcase>
	
	<cfcase value="WorkOrder"></cfcase>

</cfswitch> 
