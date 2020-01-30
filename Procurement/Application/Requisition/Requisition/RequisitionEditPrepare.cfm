<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<!--- -------------------------------------------------------------------------------------------- --->
<!--- this template determines the access based on the roles and status unless it is determined -- --->
<!--- -------------------------------------------------------------------------------------------- --->

<cfparam name="URL.Mode"       default="entry">
<cfparam name="URL.Archive"    default="0">
<cfparam name="client.orgunit" default="">

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM RequisitionLine L
	WHERE RequisitionNo = '#URL.ID#'
</cfquery>

<cfquery name="Master" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  L.*
    FROM    ItemMaster L
	WHERE   Code = '#Line.ItemMaster#'
</cfquery>

<cfquery name="Funding" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM   RequisitionLineFunding L
	WHERE  RequisitionNo = '#URL.ID#'
</cfquery>

<cfset url.mission = LINE.mission>

<cfparam name="url.period" default="#Line.Period#">

<cfif url.archive eq "0">
	
	<cfoutput>
		
		<script>
						
		function cancelreq() {		
		 
		   se = document.getElementById("reqaction")
		   ln = document.getElementById("submitline")
		  
		   if (se.className == "hide") {
		       se.className = "regular"
			   ln.className = "hide"
			  
		   } else {
		       se.className = "hide"	
			   ln.className = "regular"   
		   } 	   
				
		}
			
		function asksendback(target) {
		
		if (confirm("Do you want to return this requisition to the requester for adjustment ?")) {		   
			ColdFusion.navigate('RequisitionEditSubmit.cfm?mode=dialog&id=#url.id#&action=revert',target,'','','POST','processaction')
			}			
		}
		
		function askcancel(target) {
		
		if (confirm("Do you want to cancel this requisition ?")) {
			ColdFusion.navigate('RequisitionEditSubmit.cfm?mode=dialog&id=#url.id#&action=cancel',target,'','','POST','processaction')
			}			
		}
		
		function askreinstate() {
		
		if (confirm("Do you want to reinstate this requisition to its prior status ?")) {
			ColdFusion.navigate('RequisitionEditSubmit.cfm?mode=dialog&id=#url.id#&action=reinstate','submitline')
			}			
		}
		
		function copyRequisition(requisitionNo){
			if (confirm('Are you sure that you want to clone this requisition?')){
				ColdFusion.navigate('../Requisition/applyCopyRequisition.cfm?requisitionNo='+requisitionNo,'submitline');
			}
		}
		
		function askpurge() {
		
		if (confirm("Do you want to remove this requisition from the system ?")) {
			ptoken.navigate('RequisitionEditSubmit.cfm?mode=#url.mode#&id=#url.id#&action=purge&refer=#url.refer#','submitline')
			}			
		}
		
		function askclone() {
		
		if (confirm("Do you want to clone this requisition ?")) {
			ColdFusion.navigate('RequisitionEditSubmit.cfm?mode=dialog&id=#url.id#&action=clone','submitline')
			}			
		}
		
		function hla(itm,val,fld){

		     se = document.getElementById(itm+'_0')	
			
			 if (fld != false) {
				 se.className = "highLight5";
				 document.getElementById(itm).value = val		
				  try {				
					 document.getElementById(itm+'_1').className = "regular"						
					 document.getElementById(itm+'_2').className = "regular"			
					 } catch(e) {}	
			 } else { 
			      se.className = "header"; 
				   document.getElementById(itm).value = ""
				  try {
					 document.getElementById(itm+'_1').className = "hide"
					 document.getElementById(itm+'_2').className = "hide"
					 } catch(e) {}	
			 }
			 	
		  }  
				
		</script>
	
	</cfoutput>
	
	<cf_verifyOperational module="Warehouse" Warning="No">
	
	<cf_dialogOrganization>
	<cf_dialogMaterial>
	<cf_dialogProcurement>

</cfif>


<cfquery name="Parameter" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#Line.Mission#' 
</cfquery>

<!--- verify buyers --->

<cfif Line.ActionStatus eq "2i">
	
	<cfset req = Line.RequisitionNo>	
	<cfinclude template="../Process/setDefaultBuyer.cfm">
						
</cfif>

<cfquery name="Master" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM ItemMaster
	WHERE Code = '#Line.ItemMaster#'
</cfquery>

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Organization
	WHERE  OrgUnit = '#client.orgunit#' 
	AND    Mission = '#url.mission#'	
</cfquery>

<cfquery name="OrgUnit" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Organization
	<cfif line.actionstatus neq "0" or Line.OrgUnitImplement neq "">
	WHERE OrgUnit = '#Line.OrgUnitImplement#'
	<cfelse>
		<cfif Check.recordcount eq "1">	
			WHERE OrgUnit = '#client.orgunit#' 
		<cfelse>
			WHERE 1=0
		</cfif>
	</cfif>
</cfquery>

<!--- check access rights 
1. define status and orgunit/mission of requisition
2. define role of user that access
3. compare and decide edit or view
--->

<cfset access = "View">
<cfset back   = "0">

<!--- if not processed from a workflow, define if edit mode is to be shown --->

<!---
<cfif url.mode neq "workflow">
--->

	<cfswitch expression="#Line.ActionStatus#">
	
	    <cfcase value="">
		
			  <cfset access = "edit">
			  <cfset back    = "0">
			  
		</cfcase>
	
	    <cfcase value="0">
		
			  <cfset access = "edit">			  
			  <cfset back   = "0">
			  
		</cfcase>
	
	    <cfcase value="1">
		
			<!--- requisitioner and workflow enabled person may modify (correct ?) --->
				
			 <cfset access = "edit">
			 <cfset back   = "0">
					
		</cfcase>
		
		<cfcase value="1f">
		
			<!--- requisitioner and workflow enabled person may modify (correct ?) --->
				
			 <cfset access = "edit">
			 <cfset back   = "0">
					
		</cfcase>
	
	    <cfcase value="1p">
		
			<!--- designated reviewer may modify (correct ?) --->
		
		   <cfif getAdministrator(line.mission) eq "1">
		   
			   <cfset access = "edit">
			   <cfset back   = "0">
		   
		   <cfelse> 
		   
			   <!--- only edit requisition if user has access --->
			
			   <cfquery name="Check" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT AccessId
					FROM  Organization.dbo.OrganizationAuthorization A
					 WHERE A.Role IN ('ProcReqReview')
					 AND   A.UserAccount      = '#SESSION.acc#'
					 AND   A.OrgUnit          = '#Line.OrgUnitImplement#'
					 AND   A.ClassParameter   = '#Master.EntryClass#'
					 AND   A.AccessLevel IN ('1','2')
				    UNION				 
					SELECT AccessId
					FROM Organization.dbo.OrganizationAuthorization 
					WHERE Role IN ('ProcReqReview')
					AND   UserAccount = '#SESSION.acc#'
					AND   OrgUnit is NULL
					AND   ClassParameter   = '#Master.EntryClass#'
					AND   Mission = '#OrgUnit.Mission#'
					AND   AccessLevel IN ('1','2') 
			    </cfquery>
				
				<cfparam name="url.refer" default="">
											
				<cfif Check.recordcount gte "1">
				
				    <cfset access = "edit">
				    <cfset back   = "0">
					
				<cfelseif url.refer eq "workflow">	
				    
					<!--- if the user is accessing this form through the workflow to process a step
					we do provide limited access as this asttus but only if the user has --->
					
					<cf_wfactive entitycode="ProcReview" objectkeyvalue1="#URL.ID#">

					<cfif wfstatus eq "Open" and wfaccess eq "EDIT">					    	
						
						 <cfquery name="getStep" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">						
							SELECT    * 
							FROM      Ref_EntityActionPublish
							WHERE     (ActionPublishNo = '#wfPublish#') 
							AND (ActionCode = '#wfaction#')
						</cfquery>
						
						<!--- enable for inherit to the parent --->
												
						<cfif getstep.EntityAccessPointer eq "1">
						
							<cfset access = "limited">
							<cfset back   = "0">
						
						</cfif>	
						
						
					</cfif>	
					
				</cfif>
			
			</cfif>
			
			
		</cfcase>
	
		<cfcase value="2">
		
			<!--- certifier and funding account may modify (only funding for account manager ?) --->
			
			<cfif getAdministrator(line.mission) eq "1">
		   
			   <cfset access = "edit">
			   <cfset back   = "1">
			   	   
		    <cfelse> 
			
				<cfquery name="Check" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT AccessId
					FROM  Organization.dbo.OrganizationAuthorization A
					 WHERE A.Role IN ('ProcReqApprove','ProcReqObject','ProcReqCertify','ProcAcc','ProcAccManager')
					 AND   A.UserAccount      = '#SESSION.acc#'
					 AND   A.OrgUnit          = '#Line.OrgUnitImplement#'
					 <!---
					 AND   A.ClassParameter   = '#Master.EntryClass#'
					 --->
					 AND   A.AccessLevel IN ('1','2')
				    UNION				 
					SELECT AccessId
					FROM Organization.dbo.OrganizationAuthorization 
					WHERE Role IN ('ProcReqApprove','ProcReqObject','ProcReqCertify','ProcAcc','ProcAccManager')
					AND   UserAccount        = '#SESSION.acc#'
					AND   OrgUnit is NULL
					AND   Mission            = '#OrgUnit.Mission#'
					<!---
					 AND  ClassParameter     = '#Master.EntryClass#'
					 --->
					AND   AccessLevel IN ('1','2')
			    </cfquery>									
						
				<cfif Check.recordcount gte "1">
					   <cfset access = "edit">
					   <cfset back   = "1">
				</cfif>
				
			</cfif>	
	
		</cfcase>
		
		<cfcase value="2a">
		
			<!--- certifier and funding account may modify (only funding for account manager ?) --->
						
			<cfif getAdministrator(line.mission) eq "1">
		   
			   <cfset access = "edit">
			   <cfset back   = "1">
			   	   
		    <cfelse> 
			
				<cfquery name="Check" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT AccessId
					FROM  Organization.dbo.OrganizationAuthorization A
					 WHERE A.Role IN ('ProcReqObject','ProcReqCertify','ProcAcc','ProcAccManager')
					 AND   A.UserAccount      = '#SESSION.acc#'
					 AND   A.OrgUnit          = '#Line.OrgUnitImplement#'
					 <!---
					 AND   A.ClassParameter   = '#Master.EntryClass#'
					 --->
					 AND   A.AccessLevel IN ('1','2')
				    UNION				 
					SELECT AccessId
					FROM Organization.dbo.OrganizationAuthorization 
					WHERE Role IN ('ProcReqObject','ProcReqCertify','ProcAcc','ProcAccManager')
					AND   UserAccount        = '#SESSION.acc#'
					AND   OrgUnit is NULL
					AND   Mission            = '#OrgUnit.Mission#'
					<!---
					 AND  ClassParameter     = '#Master.EntryClass#'
					 --->
					AND   AccessLevel IN ('1','2')
			    </cfquery>									
						
				<cfif Check.recordcount gte "1">
					   <cfset access = "edit">
					   <cfset back   = "1">
				</cfif>
				
			</cfif>	
	
		</cfcase>
		
		<cfcase value="2b">
		
			<!--- certifier and funding account may modify (only funding for account manager ?) --->
						
			<cfif getAdministrator(line.mission) eq "1">
		   
			   <cfset access = "edit">
			   <cfset back   = "1">
			   	   
		    <cfelse> 
			
				<cfquery name="Check" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT AccessId
					FROM  Organization.dbo.OrganizationAuthorization A
					 WHERE A.Role IN ('ProcReqObject','ProcReqCertify','ProcAcc','ProcAccManager')
					 AND   A.UserAccount      = '#SESSION.acc#'
					 AND   A.OrgUnit          = '#Line.OrgUnitImplement#'
					 <!---
					 AND   A.ClassParameter   = '#Master.EntryClass#'
					 --->
					 AND   A.AccessLevel IN ('1','2')
				    UNION				 
					SELECT AccessId
					FROM Organization.dbo.OrganizationAuthorization 
					WHERE Role IN ('ProcReqObject','ProcReqCertify','ProcAcc','ProcAccManager')
					AND   UserAccount        = '#SESSION.acc#'
					AND   OrgUnit is NULL
					AND   Mission            = '#OrgUnit.Mission#'
					<!---
					 AND  ClassParameter     = '#Master.EntryClass#'
					 --->
					AND   AccessLevel IN ('1','2')
			    </cfquery>									
						
				<cfif Check.recordcount gte "1">
					   <cfset access = "edit">
					   <cfset back   = "1">
				</cfif>
				
			</cfif>	
	
		</cfcase>
	
		<cfcase value="2f">
						
			<!--- certifier may modify (correct ?) --->
			
			<cfif getAdministrator(line.mission) eq "1">
		   
			    <cfset access = "edit">
				 <cfset back   = "1">
		   
		    <cfelse> 
			
				<cfquery name="Check" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT AccessId
					FROM  Organization.dbo.OrganizationAuthorization A
					 WHERE A.Role IN ('ProcReqCertify')
					 AND   A.UserAccount       = '#SESSION.acc#'
					 AND   A.OrgUnit           = '#Line.OrgUnitImplement#'
					 AND   A.AccessLevel IN ('1','2')
				    UNION				 
					SELECT AccessId
					FROM   Organization.dbo.OrganizationAuthorization 
					WHERE  Role IN ('ProcReqCertify')
					AND    UserAccount = '#SESSION.acc#'
					AND    OrgUnit is NULL
					AND    Mission = '#OrgUnit.Mission#'
					AND    AccessLevel IN ('1','2')
			    </cfquery>
				
				<cfif Check.recordcount gte "1">
					  <cfset access = "edit">
					  <cfset back   = "1">
				</cfif>
								
			</cfif>
		
		</cfcase>
	
		<cfcase value="2i">
		
		   <!--- certifier may STILL modify --->
			
			<cfquery name="Check" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT AccessId
				FROM  Organization.dbo.OrganizationAuthorization A
				 WHERE A.Role IN ('ProcReqCertify')
				 AND   A.UserAccount = '#SESSION.acc#'
				 AND   A.OrgUnit     = '#Line.OrgUnitImplement#'
				 AND   A.AccessLevel IN ('1','2')
			    UNION				 
				SELECT AccessId
				FROM Organization.dbo.OrganizationAuthorization 
				WHERE Role IN ('ProcReqCertify')
				AND   UserAccount = '#SESSION.acc#'
				AND   OrgUnit is NULL
				AND   Mission = '#OrgUnit.Mission#'
				AND   AccessLevel IN ('1','2')
		    </cfquery>
			
			<cfif Check.recordcount gte "1" or getAdministrator(line.mission) eq "1">
			 	 <cfset access = "edit">
				 <cfset back = "1">
			</cfif>
		
		</cfcase>
	
		<cfcase value="2k">
		
			<cfset back = "1">
			
			<cfquery name="Check" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM  RequisitionLineActor
				WHERE RequisitionNo = '#URL.ID#'
				AND   ActorUserId = '#SESSION.acc#'
				AND   Role = 'ProcBuyer'				
		    </cfquery>
			
			<cfif Check.recordcount gte "1">
				<cfset Access = "Limited">
			</cfif>	
		
			<!--- buyer is allowed to 
		
			- split the requisition and change UoM, Price and description 
			- send requisition back --->
		
		</cfcase>
		
		<cfcase value="3">
		
			<!--- Hanno 14/1/05 to be defined later, the issue is that some changes would have to affect the PO --->
		
		</cfcase>

	</cfswitch>

<!---	
</cfif>	
--->

<cfif OrgUnit.Mission eq "">
    <cfset mis = "#URL.Mission#">
<cfelse>
	<cfset mis = "#OrgUnit.Mission#">
</cfif>

