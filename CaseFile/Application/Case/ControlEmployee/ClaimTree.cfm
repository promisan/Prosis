
<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">

<cfinvoke component = "Service.Access"  
   method           = "CaseFileManager" 	   
   returnvariable   = "accessLevel"
   Mission          = "#url.mission#">	   

<tr><td height="3"></td></tr>

<cfoutput>

<cfif accesslevel eq "ALL" or accessLevel eq "EDIT">			  
				
	<tr><td class="labelmedium" style="height:22;padding-left:10px">
	<img src="#Client.VirtualDir#/images/select.png" alt="" border="0">&nbsp;
	<a href="javascript:showclaim('','#URL.mission#')"><font color="0080C0"><cf_tl id="Record New Case"></a>
	</td></tr>
				  
</cfif>		  

<tr><td class="labelmedium" style="height:22;padding-left:10px">
<img src="#Client.VirtualDir#/images/select.png" alt="" border="0">&nbsp;
<a href="javascript:printme("><font color="0080C0"><cf_tl id="Print"></a>
</td></tr>

<tr><td colspan="1" class="linedotted"></td></tr>

</cfoutput>

<tr><td valign="top" width="100%" height="100%"  style="padding-top:8px;padding-left:8px;">

<cfform>

	<cftree name="root"
		        font="Calibri"
		        fontsize="12"		
		        bold="No"   
				format="html"    
		        required="No">

			<cfset Mission = URL.mission>
						
			<cfinclude template="ClaimTreeOrganization.cfm">
			
			<!--- check if we have workflow status --->
									
			<cfquery name="Status" 
			  datasource="AppsCaseFile" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			    SELECT   E.EntityCode,
				         E.EntityStatus, 
				         E.StatusDescription						 
			    FROM     Organization.dbo.Ref_EntityStatus E
			    WHERE    E.EntityCode IN (SELECT 'Clm'+Code 
				                          FROM   Ref_ClaimTypeTab 
										  WHERE  Mission = '#mission#')
				ORDER BY EntityCode, EntityStatus						  
			</cfquery>		
			
			<cfif Status.recordcount gte "1">
			
				<cfoutput query="Status" group="EntityCode">		
				
						<cf_tl id="File status" var="1">			
					
						<cftreeitem value="#EntityCode#"
			            display   = "<td class='labellarge'>#lt_text#"						
			           	expand    = "Yes">	
						
					<cfoutput>	
							
						<cftreeitem value="#EntityCode#_#EntityStatus#"
				            display="#StatusDescription#"
				            parent="#EntityCode#"
				            
				            href="javascript:list('status','#EntityStatus#','#mission#')"
				            queryasroot="No"
				            expand="No">						
						
					</cfoutput>
					
			    </cfoutput>		
			
			<cfelse>	
								
				<cfquery name="Step" 
					datasource="AppsCaseFile"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM     Ref_Status
					WHERE    StatusClass = 'clm'
					AND      Status IN (SELECT ActionStatus FROM Claim WHERE Mission = '#mission#')
				    ORDER BY ListingOrder
				</cfquery>	 	
					
				<cfoutput query="Step" group="StatusClass">					
					
						<cftreeitem value="#statusclass#"
				            display   = "<td class='labelmedium'>Case File Status"								
				           	expand    = "Yes">	
						
					<cfoutput>	
							
						<cftreeitem value="#statusclass#_#status#"
				            display="#Description#"
				            parent="#statusclass#"				            
				            href="javascript:list('status','#status#','#mission#')"
				            queryasroot="No"
				            expand="No">						
						
					</cfoutput>
					
			    </cfoutput>		
				
			</cfif>	
				
				
			<cfquery name="Loc" 
				datasource="AppsCaseFile"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT DISTINCT C.Location, C.Casualty, R.Name
					FROM   ClaimIncident C INNER JOIN System.dbo.Ref_Nation R ON C.Location = R.Code
					WHERE  Location <> '-'
					AND    ClaimId IN (SELECT ClaimId FROM Claim WHERE Mission = '#mission#')
					<cfif accessLevel eq "NONE">
					<!--- check if person has been granted access on-the-fly to the workflow on the claim level --->
					
					AND    ClaimId IN (SELECT DISTINCT O.ObjectKeyValue4
									   FROM   Organization.dbo.OrganizationObject AS O INNER JOIN
						                      Organization.dbo.OrganizationObjectActionAccess AS A ON O.ObjectId = A.ObjectId
									   WHERE  O.EntityCode = 'ClmNoticas' 									 
									   AND    A.UserAccount = '#SESSION.acc#'
									   )
									   
					</cfif>				 
				
			</cfquery>	 
			
			<cfif Loc.recordcount gt "0">
			
				<cftreeitem value="Loc"
			            display="<td class='labelmedium'>Location</td>"							
			           	expand="No">						
					
				<cfoutput query="Loc" group="Location">		
				
				    <cfif name neq "">		
					
						<cftreeitem value="#location#"
				            display="#name#"
							href="javascript:list('nation','#location#')"
							parent="Loc"																
				           	expand="No">	
							
						<cfoutput>	
								
							<cftreeitem value="#location#_#casualty#"
				            display="#Casualty#"
				            parent="#location#"
				            img="#SESSION.root#/Images/select.png"
				            href="javascript:list('nation','#location#','#casualty#')"
				            queryasroot="No"
				            expand="Yes">						
							
						 </cfoutput>
					 
					</cfif>	 
					
			    </cfoutput>	
			
			</cfif>	
			
	</cftree>
			
</cfform>
</td></tr></table>


