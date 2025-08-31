<!--
    Copyright © 2025 Promisan B.V.

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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="url.mid" default="">

<!--- 
1. check if open record exisits
2. create entry
3. create recipients
--->

<cfquery name="Check" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    BroadCast
	 WHERE   SystemFunctionId = '#url.systemfunctionId#'		
	 AND     FunctionSerialNo = '#url.functionserialno#'
	 AND     BroadCastStatus = '0'
</cfquery>

<!--- if found open the existing broadcast --->

<cfif Check.recordcount eq "0">
	
	<cfparam name="URL.FunctionId" default="00000000-0000-0000-0000-000000000000">
	<cfparam name="URL.Status" default="3">
	
	<cf_assignid>
	
	<cftransaction>
	
	<!--- insert header --->
	
	 <cfquery name="Header" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 	
		SELECT * 
		FROM   Ref_ModuleControl
		WHERE  SystemFunctionId = '#url.systemfunctionid#'			
	</cfquery>	
	
	<cfquery name="Broadcast" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		  INSERT INTO Broadcast
		  (BroadcastId,
		   BroadcastClass,
		   BroadcastReference,
		   BroadCastReferenceId, 
		   BroadCastRecipient,
		   BroadcastFrom,
		   BroadcastReplyTo,
		   BroadcastPriority,
		   BroadcastFailTo,
		   BroadCastMailerId,
		   SystemFunctionId,
		   FunctionSerialNo,
		   OfficerUserId,
		   OfficerLastName,
		   OfficerFirstName)
		  VALUES (
		  '#rowguid#',
		  'Mail', 
		  '#Header.FunctionName#',
		   '#url.systemfunctionid#', 
		  'Listing',
		  '#SESSION.first# #SESSION.last#',
		  '#client.eMail#',
		  '3',
		  '#client.eMail#',
		  'Prosis',
		  '#url.systemfunctionid#',
		  '#url.functionserialno#',	 
		  '#SESSION.acc#',
		  '#SESSION.last#',
		  '#SESSION.first#')
	</cfquery>	
	 
	 <cfquery name="Key" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 	
		SELECT * 
		FROM   Ref_ModuleControlDetail
		WHERE  SystemFunctionId = '#url.systemfunctionid#'		
		AND    FunctionSerialNo = '#url.functionserialNo#'	
	 </cfquery>		
	
	 <cfquery name="Mail" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 	
		SELECT * 
		FROM   Ref_ModuleControlDetailField
		WHERE  SystemFunctionId = '#url.systemfunctionid#'		
		AND    FunctionSerialNo = '#url.functionserialNo#'
		AND    FieldOutputFormat = 'eMail'
	 </cfquery>	
	 
	 <cfquery name="Name" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 	
		SELECT * 
		FROM   Ref_ModuleControlDetailField
		WHERE  SystemFunctionId = '#url.systemfunctionid#'		
		AND    FunctionSerialNo = '#url.functionserialNo#'
		AND    FieldHeaderLabel = 'Name'
	</cfquery>	
	
	</cftransaction>
	
		<cfset l = len(session.listingQuery)>
		<cfif findNoCase("FROM",  session.listingquery)>
		  <cfset s = findNoCase("FROM",  session.listingquery)>
		  <cfset qry = right(session.listingquery,l-s+1)>
		</cfif>
		<!--- the query/table is in memeory for this user --->
		<cfset qry = replaceNoCase(qry,  "WHERE 1=1", "WHERE 1=1 AND #name.fieldname# > '' AND #mail.fieldname# > ''")> 
	
		<cfquery name="getList" 
		datasource="#Key.QueryDataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 	
		SELECT  '#rowguid#',
			    #key.drillfieldkey# as RecipientCode,
			    #mail.fieldname# as eMailAddress,
			    #name.fieldname# as RecipientName
		#preservesinglequotes(qry)#	    
	    </cfquery>	
		
		<cfloop query="getList">
						
			<cfif getList.eMailAddress neq "">
					
				<cftry>
				
					<cfquery name="Recipient" 
					   datasource="#Key.QueryDataSource#" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   INSERT INTO System.dbo.BroadcastRecipient
						        (BroadcastId, 
								RecipientCode, 
								eMailAddress, 
								RecipientName)
						VALUES ('#rowguid#','#RecipientCode#','#eMailAddress#','#RecipientName#')
					   
					</cfquery>
				
					<cfcatch>
					
						<cfquery name="Recipient" 
						   datasource="#Key.QueryDataSource#" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   INSERT INTO System.dbo.BroadcastRecipient
							        (BroadcastId, 					
									eMailAddress, 
									RecipientName)
						   VALUES ('#rowguid#','#eMailAddress#','#RecipientName#')  
						</cfquery>			
								
					</cfcatch>
				
				</cftry>
			
			</cfif>
		
		</cfloop>
				
		<cflocation addtoken="No" url="BroadCastView.cfm?id=#rowguid#&mid=#url.mid#">
	
	<cfelse>
	
		    <cfquery name="Key" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#"> 	
				SELECT * 
				FROM   Ref_ModuleControlDetail
				WHERE  SystemFunctionId = '#url.systemfunctionid#'		
				AND    FunctionSerialNo = '#url.functionserialNo#'	
			 </cfquery>		
			
			 <cfquery name="Mail" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#"> 	
					SELECT * 
					FROM   Ref_ModuleControlDetailField
					WHERE  SystemFunctionId = '#url.systemfunctionid#'		
					AND    FunctionSerialNo = '#url.functionserialNo#'
					AND    FieldOutputFormat = 'eMail'
			 </cfquery>	
			 
			 <cfquery name="Name" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#"> 	
					SELECT * 
					FROM   Ref_ModuleControlDetailField
					WHERE  SystemFunctionId = '#url.systemfunctionid#'		
					AND    FunctionSerialNo = '#url.functionserialNo#'
					AND    FieldHeaderLabel = 'Name'
			</cfquery>	
				
			<cfquery name="Clear" 
				   datasource="#Key.QueryDataSource#" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   DELETE FROM System.dbo.BroadcastRecipient
				   WHERE   BroadCastId = '#check.BroadCastId#'		 				  
			</cfquery>	   
			
			<cfset l = len(session.listingQuery)>
			<cfif findNoCase("FROM",  session.listingquery)>
			  <cfset s = findNoCase("FROM",  session.listingquery)>
			  <cfset qry = right(session.listingquery,l-s+1)>
			</cfif>
			<!--- the query/table is in memeory for this user --->
			<cfset qry = replaceNoCase(qry,  "WHERE 1=1", "WHERE 1=1 AND #name.fieldname# > '' AND #mail.fieldname# > ''")> 
		
			<cfquery name="getList" 
			datasource="#Key.QueryDataSource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 	
			SELECT  '#check.BroadCastId#',
				    #key.drillfieldkey# as RecipientCode,
				    #mail.fieldname# as eMailAddress,
				    #name.fieldname# as RecipientName
			#preservesinglequotes(qry)#	    
		    </cfquery>	
			
			<cfloop query="getList">
							
				<cfif getList.eMailAddress neq "">
						
					<cftry>
					
						<cfquery name="Recipient" 
						   datasource="#Key.QueryDataSource#" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						    INSERT INTO System.dbo.BroadcastRecipient
							         (BroadcastId, RecipientCode, eMailAddress, RecipientName)
							VALUES ('#check.BroadCastId#','#RecipientCode#','#eMailAddress#','#RecipientName#')						   
						</cfquery>
					
						<cfcatch>
						
							<cfquery name="Recipient" 
							   datasource="#Key.QueryDataSource#" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
							   INSERT INTO System.dbo.BroadcastRecipient
								        (BroadcastId, eMailAddress, RecipientName)
							   VALUES ('#check.BroadCastId#','#eMailAddress#','#RecipientName#')  
							</cfquery>			
									
						</cfcatch>
					
					</cftry>
				
				</cfif>
			
			</cfloop>		
					
		<cfif check.officerUserid eq SESSION.acc or SESSION.isAdministrator eq "Yes">	
			<cflocation addtoken="No" url="BroadCastView.cfm?id=#check.broadcastid#&mid=#url.mid#">		
		<cfelse>		
			<cfoutput>
			<table><tr><td class="labelit">Another user (#check.officerFirstName# #Check.OfficerLastName#) is currently preparing an eMail for this listing. Operational not allowed</td></tr></table>
			</cfoutput>		
		</cfif>
	
	</cfif>

