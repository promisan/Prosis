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

<CF_DateConvert Value="#url.date#">
<cfset dat = dateValue> 

<cfif url.expiration neq "">
	<CF_DateConvert Value="#url.expiration#">
	<cfset exp = dateValue>
<cfelse>
	<cfset exp = 'NULL'>
</cfif>	

<cfset skip = 0>
<cfset vMess = "">
<cfset prevExpirationDates = "">

<cfif url.date eq "">
	<cf_tl id="Please enter an effective date" var="1">
	<cfset vMess = "#vMess# #lt_text# \n">
  	<cfset skip = 1>
</cfif>

<cfif url.programcode eq "">
	<cf_tl id="Please select a project" var="1">
	<cfset vMess = "#vMess# #lt_text# \n">
  	<cfset skip = 1>
</cfif>

 <cfquery name="PositionParent" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT *
		 FROM   PositionParent
		 WHERE  PositionParentId = '#URL.ID#'
</cfquery>

<cfif dat lt positionParent.dateEffective>
	<cf_tl id="The effective date cannot be less than the parent effective date" var="1">
	<cfset vMess = "#vMess# #lt_text# (" & dateFormat(positionParent.dateEffective, client.dateformatShow) & ") \n">
  	<cfset skip = 1>
</cfif>

<cfif exp gt positionParent.dateExpiration and url.expiration neq "">
	<cf_tl id="The expiration date cannot be greater than the parent expiration date" var="1">
	<cfset vMess = "#vMess# #lt_text# (" & dateFormat(positionParent.dateExpiration, client.dateformatShow) & ") \n">
  	<cfset skip = 1>
</cfif>

<cfquery name="getLastDate" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	MAX(DateExpiration) as DateExpiration
		FROM  	PositionParentFunding 
		WHERE 	PositionParentId = '#URL.ID#'
		<cfif url.fundingId  neq "">
		AND  	DateExpiration !=
				(
					SELECT 	Fx.DateExpiration
					FROM 	PositionParentFunding Fx
					WHERE	FundingId = '#url.FundingId#'
				)
		</cfif>
</cfquery>

<cfif getLastDate.recordCount eq 1 and getLastDate.DateExpiration neq "" and url.fundingId eq "">
	
	<cfquery name="getLastDateRecord" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM  	PositionParentFunding 
			WHERE 	PositionParentId = '#URL.ID#'
			AND 	DateExpiration = '#getLastDate.DateExpiration#'
	</cfquery>

	<cfif getLastDateRecord.recordCount gt 0>
		<cfset prevExpirationDates = dateAdd('d', -1, dat)>

		<cfif dat lte getlastDateRecord.dateEffective>
			<cf_tl id="The effective date should be greater than the last effective date" var="1">
			<cfset vMess = "#vMess# #lt_text# (" & dateFormat(getLastDateRecord.dateEffective, client.dateformatShow) & ") \n">
		  	<cfset skip = 1>
		</cfif>
	</cfif>

</cfif>

<cfif skip eq 1>
	<cfoutput>
		<script>
	  	  alert("#vMess#");
	  	</script>
  	</cfoutput>
</cfif>

<cftransaction>

	<cfif skip eq "0"> 

			<cfif prevExpirationDates neq "">

				<cfquery name="updatePreviousExpirationDates" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE 	PositionParentFunding 
						SET 	DateExpiration = #prevExpirationDates#
						WHERE 	PositionParentId = '#URL.ID#'
						AND 	DateExpiration = '#getLastDate.DateExpiration#'						
				</cfquery>

			</cfif>
			
			
					
			<cfif url.FundingId eq "">	
			
			
				  										
			       <cfquery name="Check" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     SELECT *
						 FROM  PositionParentFunding 
						 WHERE PositionParentId = '#URL.ID#'
						 AND   Fund       = '#url.Fund#'
						 AND   ObjectCode = '#url.ObjectCode#'
						 <cfif url.ProgramCode neq "">
						 AND   ProgramCode = '#url.ProgramCode#'
						 AND   DateEffective    = #dat#
					 </cfif>
					 
					</cfquery>
					
					<cfif Check.recordcount eq "0">
				
						<cfquery name="InsertFunding" 
						     datasource="AppsEmployee" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
						     INSERT INTO PositionParentFunding 
						         (PositionParentId,
								 Fund,
								 FundClass,
								 ObjectCode,
								 <cfif url.ProgramCode neq "">
								 ProgramCode,
								 </cfif>
								 DateEffective,
								 DateExpiration,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
						      VALUES ('#URL.ID#',
						      	  '#url.Fund#',
								  '#url.fundClass#',
								  '#url.ObjectCode#',
								  <cfif url.ProgramCode neq "">
								  '#url.ProgramCode#',
								  </cfif>
								  #dat#,
								  #exp#,
								  '#SESSION.acc#',
						    	  '#SESSION.last#',		  
							  	  '#SESSION.first#') 
						</cfquery>
						
						 <cfquery name="Check" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						     SELECT *
							 FROM   PositionParentFunding
							 WHERE  PositionParentId = '#URL.ID#'	
						 </cfquery>
						 
						 <cfif Check.recordcount eq "1">
						 
						   <cfquery name="UpdateFunding" 
						     datasource="AppsEmployee" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
						     UPDATE   PositionParentFunding 
							 SET      DateEffective    = '#PositionParent.DateEffective#'
							 WHERE    PositionParentId = '#URL.ID#'	
					    	</cfquery>
						 					 
						 </cfif>
						 
					</cfif>	 
							
			<cfelse>	
			
				

				<cfquery name="getFunding" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT 	*
						FROM  	PositionParentFunding
						WHERE   FundingId = '#url.FundingId#'
				</cfquery>

				<cfquery name="getFundingCluster" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT 	*
						FROM  	PositionParentFunding
						WHERE     PositionParentId = '#getFunding.PositionParentId#'
					 	AND  	  DateEffective = '#getFunding.DateEffective#'
					 	AND   	  DateExpiration = '#getFunding.DateExpiration#'
				</cfquery>
				
				
			
		       <cfquery name="UpdateFunding" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     UPDATE    PositionParentFunding 
					 SET	   ObjectCode       = '#url.ObjectCode#',
							   FundClass        = '#url.fundclass#',  
				     		   <cfif getFundingCluster.recordCount lt 2>
							 	   Fund             = '#url.Fund#',
								   <cfif url.ProgramCode neq "">
								      ProgramCode      = '#url.ProgramCode#', 
								   </cfif>
							   </cfif>	
							   DateEffective    = #dat#,
							   DateExpiration   = #exp#,
							   OfficerUserId    = '#SESSION.acc#',
							   OfficerLastName  = '#SESSION.last#',
							   OfficerFirstName = '#SESSION.first#'
					 <cfif getFundingCluster.recordCount lt 2>
						WHERE     FundingId = '#url.FundingId#'
						
					 <cfelse>
					 	WHERE     PositionParentId = '#getFunding.PositionParentId#'
					 	AND  	  DateEffective    = '#getFunding.DateEffective#'
					 	AND   	  DateExpiration   = '#getFunding.DateExpiration#'						
					 </cfif>
					 
			    </cfquery>
			
			</cfif>
					
	</cfif>		

	<cfquery name="Check" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     DELETE FROM PositionParentFunding
			 WHERE  PositionParentId = '#URL.ID#'	
			 AND    DateEffective > '#PositionParent.DateExpiration#' 
	</cfquery>

</cftransaction>
