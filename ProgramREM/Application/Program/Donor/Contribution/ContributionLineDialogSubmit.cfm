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

<cfparam name="form.ParentContributionLineId" default="">

<cfquery name="qLine" 
	datasource="AppsProgram"  
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   ContributionLine
		WHERE  ContributionLineId = '#URL.ContributionLineId#'
</cfquery>

<cfquery name="qContribution" 
	datasource="AppsProgram"  
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Contribution
	WHERE  ContributionId = '#qLine.ContributionId#'
</cfquery>

<cfparam name="url.isPop" default="0">

<cfif Form.DateReceived neq "">
	<CF_DateConvert Value="#Form.DateReceived#">
	<cfset dateRec    = dateValue>
<cfelse>
	<cfset dateRec    = "NULL">	
</cfif>	

<cfif Form.DateEffective neq "">
	<CF_DateConvert Value="#Form.DateEffective#">
	<cfset dateEff     = dateValue>
<cfelse>
	<cfset dateEff     = "NULL">
</cfif>	

<cfif Form.DateExpiration neq "">
	<CF_DateConvert Value="#Form.DateExpiration#">
	<cfset dateExp    = dateValue>
	<cfif dateExp lte dateEff>
		  <cfset dateExp = "NULL">
	</cfif>
<cfelse>
	<cfset dateExp    = "NULL">
</cfif>	

<cftransaction>

		<cfquery name="validateChange" 
		    datasource="AppsProgram" 
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT	* 
			FROM	ContributionLine
			WHERE   ContributionLineId = '#URL.ContributionLineId#'
			AND		DateReceived       <cfif DateRec eq "NULL">is<cfelse>=</cfif> #DateRec#
			AND	   	DateEffective      <cfif DateEff eq "NULL">is<cfelse>=</cfif> #DateEff#
			AND    	DateExpiration     <cfif DateExp eq "NULL">is<cfelse>=</cfif> #DateExp#
			AND	   	Reference          = '#Form.Reference#'
			AND    	Fund               = '#Form.Fund#'
			AND    	Currency           = '#Form.Currency#'
			<cfif form.ParentContributionLineId neq "">
			AND     ParentContributionLineid = '#form.ParentContributionLineId#'
			<cfelse>
			AND     ParentContributionLineid = NULL
			</cfif>
			AND    	Amount             = '#Replace(Form.Amount,",","","all")#'
			AND    	AmountBase         = '#Replace(Form.AmountBase,",","","all")#'   
		</cfquery>
		
		<cfif validateChange.recordCount eq 0>
		
			<cfquery name="qLast" 
			    datasource="AppsProgram" 
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT   TOP 1 SerialNo
				FROM     ContributionLineLog
				WHERE    ContributionLineId = '#URL.ContributionLineId#'
				ORDER BY Created DESC		   
			</cfquery>	
			
			<cfif qLast.recordcount eq 0>
				<cfset serialNo = 1>
			<cfelse>
				<cfset serialNo = qLast.SerialNo + 1>	
			</cfif>
					
			<cfquery name="qInsertLog" 
			    datasource="AppsProgram" 
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				
				
				INSERT INTO ContributionLineLog 
				
		           (   SerialNo,
			           ContributionId,
			           ContributionLineId,
			           DateReceived,
			           DateEffective,
			           DateExpiration,
			           Reference,
			           Fund,
			           Currency,
			           Amount,
			           AmountBase,
					   OverAllocate,
					   ParentContributionLineId,
					   ActionStatus,
					   Remarks,
			           OfficerUserId,
			           OfficerLastName,
			           OfficerFirstName
				   )
				   
				SELECT '#serialNo#',
			           ContributionId,
			           ContributionLineId,
		    	       DateReceived,
			           DateEffective,
			           DateExpiration,
		    	       Reference,
			           Fund,
			           Currency,
		    	       Amount,
		        	   AmountBase,
					   OverAllocate,
					   ParentContributionLineId,
					   ActionStatus,
		   			   Remarks,
			           '#SESSION.acc#',
			           '#SESSION.last#',
		    	       '#SESSION.first#'
					   
				FROM  ContributionLine
				WHERE ContributionLineId = '#URL.ContributionLineId#'
			</cfquery>	
			
		</cfif>
		
		<cfset all = evaluate("Form.OverAllocate")>	
		<cfset all = replace(all," ","","ALL")> 											
		<cfset all = replace(all,",","","ALL")> 
		
		<cfquery name="qSubmitLine" 
		    datasource="AppsProgram" 
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			UPDATE ContributionLine
			SET    DateReceived        = #DateRec#,
				   DateEffective       = #DateEff#,
			       DateExpiration      = #DateExp#,
				   Reference           = '#Form.Reference#',
			       Fund                = '#Form.Fund#',				   
			       Currency            = '#Form.Currency#',
			       Amount              = '#Replace(Form.Amount,",","","all")#',
				   OverAllocate        = '#all#',
			       AmountBase          = '#Replace(Form.AmountBase,",","","all")#',
				   Remarks             = '#Form.Remarks#',
				   <cfif form.ParentContributionLineId neq "">
			       ParentContributionLineId = '#form.ParentContributionLineId#',
				   <cfelse>
				   ParentContributionLineId = NULL,
		           </cfif>				   
				   OfficerUserId       = '#SESSION.acc#',
				   OfficerLastName     = '#SESSION.last#',
				   OfficerFirstName    = '#SESSION.first#',
				   Created             = getDate() 
			WHERE  ContributionLineId  = '#URL.ContributionLineId#'		 
			
		</cfquery>
		
		<!--- update period --->
		
		<cfquery name="clear" 
		    datasource="AppsProgram" 
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			DELETE FROM ContributionLinePeriod			
			WHERE  ContributionLineId = '#URL.ContributionLineId#'		   
		</cfquery>
		
		<cfquery name="qPeriod" 
				datasource="AppsProgram"  
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT   *						   
				FROM      Organization.dbo.Ref_MissionPeriod AS M INNER JOIN
                          Program.dbo.Ref_Period AS P ON M.Period = P.Period
				WHERE     M.Mission = '#qContribution.Mission#' 				
				<cfif qLine.dateExpiration neq "">
				AND       P.DateEffective <= '#dateformat('#qLine.dateExpiration#',client.dateSQL)#'
				</cfif>
				AND       P.DateExpiration >= '#dateformat('#qLine.dateEffective#',client.dateSQL)#'				
				ORDER BY P.DateEffective, P.Period				
		</cfquery>	
						
		<cfloop query="qPeriod">
								
			<cfparam name="Form.Amount_#currentrow#" default="">
				
			<cfset amt = evaluate("Form.Amount_#currentrow#")>	
			<cfset amt = replace(amt," ","","ALL")> 											
			<cfset amt = replace(amt,",","","ALL")> 
		
			<cfif isNumeric(amt)>
			
				<cfquery name="qInsertPeriod" 
				    datasource="AppsProgram" 
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
					
					INSERT INTO ContributionLinePeriod 
			           (ContributionLineId, Period, AmountBase,OfficerUserId,OfficerLastName,OfficerFirstName)
					   
					VALUES ('#URL.ContributionLineId#',
					       '#Period#',
						   '#amt#',
						   '#SESSION.acc#',
						   '#SESSION.last#',
						   '#SESSION.first#')
				</cfquery>		
			
			</cfif>
					
		</cfloop>		

</cftransaction>

<cfoutput>

<cfquery name="qLines" datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT   CL.*, C.ActionStatus as HeaderStatus
	FROM     ContributionLine CL, Contribution C
	WHERE    CL.ContributionId = C.ContributionId
	AND      ContributionLineId = '#URL.ContributionLineId#'		   
	ORDER BY DateReceived ASC
</cfquery>

<cfif url.isPop eq 1>

    <cfoutput>
	<script>		
		parent.parent.editRowRefresh('#url.systemfunctionid#','#URL.ContributionId#')
		parent.parent.ColdFusion.Window.hide('mydialog')		
	</script>
	</cfoutput>

<cfelse>
	
	<cfsavecontent variable="singleline">
		<cfinclude template="ContributionSingleLine.cfm">
	</cfsavecontent>
	
	<cfset singleline=REReplace(singleline,"#chr(13)#|#chr(9)#|\n|\r","","ALL")>
	
	<script>
		$('##e_#URL.ContributionLineId#').hide();
		$('##l_#URL.ContributionLineId#').html('#PreserveSingleQuotes(singleline)#');
		$('##l_#URL.ContributionLineId#').show();	
	</script>

</cfif>

</cfoutput>