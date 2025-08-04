<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfparam name="Form.RequisitionNo" default="#url.req#">

<cfif Form.RequisitionNo eq "">

    <cfset message = "<font color='FF0000'>You have not selected any requisition lines. Operation not allowed.</font>"> 	

<cfelse>
    
	<!--- 	
		  1. define reference No 
	      2. create requisition header  
		  3. update requisition lines 
		  4. enter action 
		  5. return to screen		  
	--->
	
	<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Ref_ParameterMission
			WHERE Mission = '#URL.Mission#' 
	</cfquery>
		
	<cfset req = "">
	<cfloop index="itm" list="#Form.RequisitionNo#" delimiters="|">
	    <cfif req neq "">
			<cfset req = "#req#,'#itm#'">
		<cfelse>
			<cfset req = "'#itm#'">		
		</cfif>
	</cfloop>
	
	<cfquery name="Requisition" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   L.*, 
		         I.EntryClass	   			
		FROM     RequisitionLine L INNER JOIN
                 ItemMaster I ON L.ItemMaster = I.Code													 
		WHERE    L.RequisitionNo IN (#preserveSingleQuotes(req)#)		
		ORDER BY EntryClass, Reference		
		
	</cfquery>		
	
	
	<cftransaction>
	
	<cfoutput query="Requisition" group="EntryClass">
		
		<!--- define status per entry class settings --->
			
		<cfquery name="FlowSetting" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
					SELECT   S.*
					FROM     RequisitionLine R INNER JOIN
			                 ItemMaster M ON R.ItemMaster = M.Code INNER JOIN
			                 Ref_ParameterMissionEntryClass S ON R.Mission = S.Mission AND R.Period = S.Period AND M.EntryClass = S.EntryClass
					WHERE    (R.RequisitionNo = '#Requisition.RequisitionNo#')
		</cfquery>		
		
		<cfquery name="Check" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT * FROM UserNames
			 WHERE Account = '#FlowSetting.BuyerDefault#'
		 </cfquery>				
					
		<!--- define status --->
		
		<cfset st = "#url.status#"> <!--- submitted : forecasted --->		
		
					
		<!--- define if status should moved forward beyond "2" --->
			
		<cfif Parameter.EnableReview eq "0" and url.status is "1p"> 
		        <!--- set status as reviewed --->
				<cfset st = "2">
		</cfif>
			
		<cfif st eq "2">
				<cfif Parameter.EnforceProgramBudget eq "0"> <!--- funding processing ala mozambique --->
		    	    <!--- set status as funded as funding is not --->
					<cfset st = "2f">
				<cfelse>
					<cfset st = "2f">
				</cfif>
		</cfif>
			
		<cfif st eq "2f">
				<cfif FlowSetting.EnableCertification eq "0">
				    <!--- set status as certified--->
					<cfset st = "2i">
				</cfif>
		</cfif>	
		
		<cfset txt = "created">
		
		<cfparam name="Form.RequisitionPurpose_#EntryClass#" default="">
		
		<cfset pur = evaluate("Form.RequisitionPurpose_#EntryClass#")>

		<cfif len(pur) gt 500>
		     <cfset pur = left(pur,500)>		
		</cfif>	
				
		<!---  1. define reference No  --->
		<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
		
			<cfquery name="Parameter" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM Ref_ParameterMission
				WHERE Mission = '#URL.Mission#' 
			</cfquery>
									
			<cfset No = Parameter.RequisitionSerialNo+1>
			
			<cfif len(No) eq "3">
			     <cfset No = "0#No#">
			<cfelseif len(No) eq "2">
			     <cfset No = "00#No#">
			<cfelseif len(No) eq "1">
			     <cfset No = "000#No#"> 
			</cfif>
				
			<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Ref_ParameterMission
				SET    RequisitionSerialNo = RequisitionSerialNo+1		
				WHERE  Mission = '#URL.Mission#' 
			</cfquery>
				
		</cflock>
		
		<cftry>
		
			<!--- 2. create requisition header  --->
			<cfquery name="Insert" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Requisition 
						 (Reference, 
						  RequisitionPurpose, 
						  EntryClass, 
						  Period, 
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName) 
			     VALUES ('#Parameter.MissionPrefix#-#Parameter.RequisitionPrefix#-#No#', 
				         '#pur#',
						 '#entryclass#',
						 '#url.Period#', 
				         '#SESSION.acc#', 
						 '#SESSION.last#', 
						 '#SESSION.first#') 
			 </cfquery>
		
		<cfcatch>
		
			<cf_alert message = "Requisition could not be assigned a reference number. Please contact your administrator."> 	
			
			<cfoutput>
				<script>
				 	try {
					ProsisUI.closeWindow('dialogsubmit');
					} catch(e) {}
					
					#ajaxLink('../Process/RequisitionCreatePending.cfm?mission=#URL.Mission#&period=#URL.Period#')#
				</script>
			</cfoutput>
			
			<cfabort>
		
		</cfcatch>
		
		</cftry>
		
		<cfoutput group="Reference">
			
			<cfoutput>
			
				<cfparam name="Form.Reassign#left(RequisitionId,8)#" default="false">
				
				<cfif reference neq "" and evaluate("Form.Reassign#left(RequisitionId,8)#") eq "true">
				
					 <cfset ass = 1>				 
					 
				<cfelseif reference eq "" or actionStatus eq "9">	 
				
					 <cfset ass = 1>
				
				<cfelse>
				
					 <cfset ass = 0> 
					 
				</cfif>
					   
	   			<cfset url.id = RequisitionNo>
				<cfset url.archive = 1>
				<cfsavecontent variable="content">
				    <cfoutput>
						<cfinclude template="../Requisition/RequisitionEditLog.cfm">
					</cfoutput>
				</cfsavecontent>	
				
				<cfquery name="Parameter" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_ParameterMission
					WHERE  Mission = '#URL.Mission#' 
				</cfquery>			
				
				<!---  3. update requisition lines --->
				<cfquery name="Update" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     UPDATE RequisitionLine
					 SET    ActionStatus  = '#st#' 
					 <cfif ass eq "1">
						 ,Reference = '#Parameter.MissionPrefix#-#Parameter.RequisitionPrefix#-#No#'						
					 </cfif>
					 WHERE  RequisitionNo = '#RequisitionNo#' 									 
				</cfquery>
									
													
												
				<!---  4. enter action --->
				<cfquery name="InsertAction" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO RequisitionLineAction 
					         (RequisitionNo, ActionProcess,ActionStatus, ActionDate, ActionContent, OfficerUserId, OfficerLastName, OfficerFirstName) 
					 SELECT RequisitionNo, 
					        '1p',
							'#st#', 
							getDate(), 
							'#content#', 
							'#SESSION.acc#', 
							'#SESSION.last#', 
							'#SESSION.first#'
					 FROM   RequisitionLine
					 WHERE  RequisitionNo = '#RequisitionNo#' 
				</cfquery>
									
				<!--- ----------------------------------------------------- --->
				<!--- ----generate workflow if needed for the line--------- --->
				<!--- ----------------------------------------------------- --->	
				
			
				<cfquery name="Check" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 SELECT    P.EntityClass
						 FROM      ItemMaster IM INNER JOIN
			                       RequisitionLine L ON IM.Code = L.ItemMaster INNER JOIN
				                   Ref_ParameterMissionEntryClass P ON IM.EntryClass = P.EntryClass 
							AND    L.Mission = P.Mission 
							AND    L.Period = P.Period
						 WHERE     L.RequisitionNo = '#RequisitionNo#'  
				</cfquery>						
					
				<cfif check.entityclass neq "">			
							
					<cfset link = "Procurement/Application/Requisition/Requisition/RequisitionEdit.cfm?refer=workflow&id=#RequisitionNo#">
					
					<cfquery name="ArchivePrior" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
							UPDATE Organization.dbo.OrganizationObject
							SET    Operational = '0'
							WHERE  ObjectKeyValue1 = '#Line.RequisitionNo#'
					</cfquery>
					
					<cfif Line.caseNo neq "">
					  <cfset ref = "#CaseNo# (#RequisitionNo#)">
					<cfelse>
					  <cfset ref = "#RequisitionNo#">  
					</cfif>
		 										
					<cf_ActionListing 
						    EntityCode       = "ProcReview"
							EntityClass      = "#Check.EntityClass#"
							EntityGroup      = ""
							EntityStatus     = ""
							CompleteFirst    = "Yes"							
							OrgUnit          = "#OrgUnit#"
							Mission          = "#Mission#"
							ObjectReference  = "#ref#"
							ObjectReference2 = "#RequestDescription#"
							ObjectKey1       = "#RequisitionNo#"
						  	ObjectURL        = "#link#"						
							Show             = "No">			
					
				</cfif>
															
				<!--- ----------------------------------------------------- --->
				<!--- send eMail to the actors for the next step if enabled --->
				<!--- ----------------------------------------------------- --->						
				
				<cfif Parameter.EnableActorMail eq "1">
				
					<cfinclude template="ActorMail.cfm">					
								
				</cfif>
				
			</cfoutput>
			
		</cfoutput>		
								
	</cfoutput>	
			
	<cfset message = "">	  
	
</cfif>

<cfoutput>

<script>

	var cb = $("##menu3")
	var ifrms = parent.document.getElementsByTagName('iframe');
	console.log(ifrms);
	var ifrm; 
	if (parent.parent.right)
		ifrm = ifrms[0]
	else 		//it is called from the workflow
		ifrm = ifrms[1]
	
	if (ifrm)
	{
		var doc = ifrm.contentDocument? ifrm.contentDocument: ifrm.contentWindow.document;
		var m3 = doc.getElementById('menu3');
		m3.click();
		parent.ProsisUI.closeWindow('mysubmit',true);
	}		
					
</script>

</cfoutput>


