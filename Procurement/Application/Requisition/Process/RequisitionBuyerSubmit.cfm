<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.RequisitionNo" default="">

<cfoutput>
<cfif Form.RequisitionNo eq "">
    <script>
	   
		alert("You have not selected any requisition lines. Operation not allowed.")	
		ColdFusion.navigate('RequisitionBuyerPrepare.cfm?Mission=#URL.Mission#&period=#URL.Period#','box')
	</script>
	
	<cfabort>
</cfif>
</cfoutput>

<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
</cfquery>	

<!--- 1. update requisition lines 
	  2. enter action 
	  3. return to screen --->

<cfif ParameterExists(Form.Deny)> 

   <cfset st = "9">
   <cfset txt = "cancelled">

<cfelse>

   <cfset st = "2k"> <!--- reviewed --->
   <cfset txt = "assigned">

</cfif>

<cfloop index="req" list="#PreserveSingleQuotes(Form.RequisitionNo)#" delimiters=",">
	
	<cfset url.id = req>
	<cfset url.archive = 1>
	<cfsavecontent variable="content">
	    <cfoutput>
			<cfinclude template="../Requisition/RequisitionEditLog.cfm">
		</cfoutput>
	</cfsavecontent>
			
	<cftransaction>
	
		<!---  1. update requisition lines --->
		<cfquery name="Update" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE RequisitionLINE
			 SET ActionStatus = '#st#'
			 WHERE RequisitionNo = '#req#'
		</cfquery>
		
		<!---  2a. clean buyer --->
		<cfquery name="RemoveActor" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     DELETE FROM RequisitionLineActor 
			 WHERE RequisitionNo = '#req#'
			 AND Role = 'Buyer'
		</cfquery>
		
		<!---  2b. enter buyer --->
		<cfquery name="InsertActor" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RequisitionLineActor 
			 (RequisitionNo, Role, ActorUserId, ActorLastName, ActorFirstName, OfficerUserId, OfficerLastName, OfficerFirstName) 
			 SELECT RequisitionNo, 'ProcBuyer', '#Form.UserId#', '#Form.LastName#', '#Form.FirstName#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#'
			 FROM RequisitionLine
			 WHERE RequisitionNo = '#req#'
		</cfquery>
		
		<!---  3. enter action --->
		<cfquery name="InsertAction" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RequisitionLineAction 
			         (RequisitionNo, ActionProcess, ActionStatus, ActionDate, ActionContent, OfficerUserId, OfficerLastName, OfficerFirstName) 
			 SELECT  RequisitionNo, '2k','#st#', getDate(), '#content#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#'
			 FROM    RequisitionLine
			  WHERE  RequisitionNo = '#req#'
		</cfquery>
					
	</cftransaction>	
	
	<cfif Parameter.EnableActorMail eq "1" and st neq "1" and st neq "9">
				
			<cfinclude template="ActorMail.cfm">					
									
		</cfif>
	
</cfloop>

<cfoutput>

	<script>
		ColdFusion.navigate('RequisitionBuyerPrepare.cfm?Mission=#URL.Mission#&period=#URL.Period#','box')
		try { 
		se = opener.document.getElementById('button_procmanager') 		
		se.click() } catch(e) {}
	</script>

</cfoutput>	
	
	