<cfloop index="buy" list="BuyerDefault,BuyerDefaultBackup" delimiters=",">
								
		<cfquery name="FlowSetting" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
				SELECT   R.Reference, S.*, R.OfficerUserid as Requester
				FROM     RequisitionLine R INNER JOIN
		                 ItemMaster M ON R.ItemMaster = M.Code INNER JOIN
		                 Ref_ParameterMissionEntryClass S ON R.Mission = S.Mission AND R.Period = S.Period AND M.EntryClass = S.EntryClass
				WHERE    R.RequisitionNo = '#req#' 
		</cfquery>	

        <cfset buyer     = evaluate("FlowSetting.#buy#")>
		<cfset threshold = evaluate("FlowSetting.#buy#Threshold")>
				
		<cfif buyer eq "@requester" or buyer eq " @requester">									
													
			<cfquery name="Check" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     SELECT * 
				 FROM   System.dbo.UserNames
				 WHERE  Account = '#FlowSetting.Requester#'				
		    </cfquery>
		
		<cfelse>

			<cfquery name="Check" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     SELECT * 
				 FROM   System.dbo.UserNames
				 WHERE  Account = '#buyer#'
		    </cfquery>
		
		</cfif>
		
		<cfset go = "0">
			
		<cfif check.recordcount eq "1">
		
		    <!--- check the threshold --->
			
			<cfif threshold gt "0">
							
				<cfquery name="get" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     SELECT SUM(RequestAmountBase) as total 
					 FROM   RequisitionLine
					 WHERE  Reference = '#flowsetting.Reference#'
			    </cfquery>
			
				<cfif get.total lte threshold>
				
					<cfset go = "1">
					
				</cfif>
							
			<cfelse>
			
				<cfset go = "1">
						
			</cfif>
			
			<cfif go eq "1">
											
				<cfquery name="InsertActor" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO RequisitionLineActor 
							 (RequisitionNo, 
							  Role, 
							  ActorUserId, 
							  ActorLastName, 
							  ActorFirstName, 
							  OfficerUserId, 
							  OfficerLastName, 
							  OfficerFirstName) 
					 SELECT   RequisitionNo, 
						      'ProcBuyer', 
							  '#Check.Account#', 
							  '#Check.LastName#', 
							  '#Check.FirstName#', 
							  '#SESSION.acc#', 
							  '#SESSION.last#', 
							  '#SESSION.first#'
					 FROM     RequisitionLine D
					 WHERE    RequisitionNo = '#req#'
					 AND      RequisitionNo NOT IN (
		                                SELECT RequisitionNo 
			                            FROM   RequisitionLineActor
									    WHERE  Role          = 'ProcBuyer'
										AND    RequisitionNo = D.RequisitionNo
									    AND    ActorUserId   = '#Check.Account#'
									   )
				</cfquery>
				
				<!--- pass to buyer if certification is defined as performed --->
			
			    <!---
				<cfif st eq "2i">
				--->
				
					<!---  1. update requisition lines --->
					<cfquery name="Update" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     UPDATE  RequisitionLine
						 SET     ActionStatus    = '2k' 
						 WHERE   RequisitionNo   = '#req#'
					</cfquery>
				
				<!---																	
				</cfif>
				--->
				
				<!--- set the status as 2k skipping --->
				<cfset st = "2k">
				
			</cfif>	
							
		</cfif>
		
</cfloop>