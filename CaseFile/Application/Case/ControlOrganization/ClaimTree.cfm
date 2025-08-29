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
<cfquery name="StatusList" 
  datasource="AppsCaseFile" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT   E.EntityCode,
	         E.EntityStatus as Status, 
	         E.StatusDescription as Description						 
    FROM     Organization.dbo.Ref_EntityStatus E
    WHERE    E.EntityCode IN (SELECT 'Clm'+Code 
	                          FROM   Ref_ClaimTypeTab 
							  WHERE  Mission = '#url.id2#')
	ORDER BY EntityCode, EntityStatus						  
</cfquery>		

<cfset mode = "entity">

<cfif statuslist.recordcount eq "0">
	
	<cfquery name="StatusList" 
		datasource="AppsCaseFile"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Status
		WHERE    StatusClass  = 'clm'
	    ORDER BY ListingOrder
	</cfquery>	 
	
	<cfset mode = "status">

</cfif>

<table width="100%" class="tree formpadding">

	<cfinvoke component = "Service.Access"  
	   method           = "CaseFileManager" 	   
	   returnvariable   = "accessLevel"
	   Mission          = "#url.id2#">	 

<cfoutput>	   

<cfif accesslevel eq "ALL" or accessLevel eq "EDIT">			  
				
	<tr><td class="labelmedium" style="height:22;padding-left:10px">
	<img src="#Client.VirtualDir#/images/select.png" alt="" border="0">&nbsp;
	<a href="javascript:showclaim('','#URL.id2#')"><cf_tl id="Record New Case"></a>
	</td></tr>
				  
</cfif>		  

<tr><td class="labelmedium" style="height:22;padding-left:10px">
<img src="#Client.VirtualDir#/images/select.png" alt="" border="0">&nbsp;
<a href="javascript:printme("><cf_tl id="Print"></a>
</td></tr>

</cfoutput>

<tr><td colspan="1" class="line"></td></tr>

<tr><td valign="top" width="100%" height="100%"  style="padding-top:6px;padding-left:10px;">

<cfform>

	<cftree name="root"
		        font="Verdana"
		        fontsize="11"		
		        bold="No"   
				format="html"    
		        required="No">
				
			<cf_tl id="Case File" var="1">
				
			<cftreeitem value="status"
		            display="<span style='padding-top:3px;padding-bottom:3px;color: B08C42;' class='labellarge'><b>#lt_text#</b></span>"									
		           	expand="Yes">		
							
			<cfoutput query="StatusList">				
										
					<cftreeitem value="#mode#_#status#"
			            display="<b>#Description#</b>"
			            parent="status"		           
			            href="javascript:list('#mode#','#url.id2#','#status#','','')"
			            queryasroot="No"
			            expand="yes">						
					
					<cfquery name="ClaimType" 
							datasource="AppsCaseFile" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT RCT.Code,RCT.Description,'#status#' as Status,'#statusclass#' as StatusClass 
								FROM   Ref_ClaimType RCT
								WHERE EXISTS ( SELECT * 
											   FROM   Claim C 
											   WHERE  RCT.Code = C.ClaimType
											   AND    ActionStatus = '#status#'
											   AND    Mission = '#url.id2#'
								)
					</cfquery>	
					
					<cfloop query="ClaimType">
					
						<cfinvoke component="Service.Access"  
					     	 method="CaseFileManager" 
						     mission="#url.id2#" 
							 claimtype="#Code#"
						     returnvariable="access">
						 
						<cfif access neq "NONE">
					
							<cftreeitem value="#mode#_#status#_#code#"
					            display="#Description#"
					            parent="#mode#_#status#"					            
								href="javascript:list('#mode#','#url.id2#','#status#','#code#','')"
					            queryasroot="No"
					            expand="no">		
						
								<cfquery name="ClaimTypeClass" datasource="AppsCaseFile" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									
									SELECT ClaimType, 
									       Code as ClaimTypeClassCode, 
										   Description 
									FROM   Ref_ClaimTypeClass R
									WHERE  ClaimType = '#code#'
									AND Code IN ( 
										SELECT ClaimTypeClass
										FROM   Claim C 
										WHERE  C.ClaimType = R.ClaimType
										AND    ActionStatus = '#status#'
										AND    Mission      = '#url.id2#'
									   )
									
								</cfquery>
							
								<cfset st = status>
								
								<cfloop query="ClaimTypeClass">
								
									<cftreeitem value="#st#_#ClaimType#_#ClaimTypeClassCode#"
							            display="#Description#"
							            parent="#mode#_#st#_#claimtype#"							            
							            href="javascript:list('#mode#','#url.id2#','#st#','#ClaimType.Code#','#ClaimTypeClassCode#')"
							            queryasroot="No"
							            expand="no">									
									
									<cfquery name="Element" datasource="AppsCaseFile" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT   R.Code, 
										         R.Description, 
												 R.ListingOrder,
												 count(DISTINCT E.Reference) as Total	
										FROM     ClaimElement C INNER JOIN
										         Element E ON C.ElementId = E.ElementId INNER JOIN
										         Ref_ElementClass R ON E.ElementClass = R.Code
										WHERE    C.ClaimId IN
						                          (SELECT  ClaimId
						                            FROM   Claim
						                            WHERE  Mission = '#url.id2#' 
													AND    ClaimType = '#ClaimType.Code#' 
													AND    ClaimTypeClass = '#claimtypeclasscode#')		
										GROUP BY  R.Code, 
										          R.Description, 
												  R.ListingOrder			
										ORDER BY R.ListingOrder										
									</cfquery>
									
									<cfloop query="Element">
									
										<cf_assignid>
									
										<cftreeitem value="#code#_#rowguid#"
							            display="#Description# [#total#]"
							            parent="#st#_#ClaimTypeClass.ClaimType#_#ClaimTypeClass.ClaimTypeClassCode#"							            
							            href="javascript:elementlist('#code#','#url.id2#','#ClaimTypeClass.claimtypeclasscode#','')"
							            queryasroot="No"
							            expand="no">									
									
									</cfloop>
								
								</cfloop>
							
						</cfif> 
											
				</cfloop>					
							
		 </cfoutput>		
		 
		 <cf_tl id="Elements" var="1">
		 
		 	<cfquery name="Element" datasource="AppsCaseFile" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   R.Code, 
						         R.Description, 
								 R.ListingOrder,
								 count(*) as Total	
						FROM     ClaimElement C INNER JOIN
						         Element E ON C.ElementId = E.ElementId INNER JOIN
						         Ref_ElementClass R ON E.ElementClass = R.Code
						WHERE    C.ClaimId IN
		                          (SELECT  ClaimId
		                            FROM   Claim
		                            WHERE  Mission = '#url.id2#')		
						GROUP BY R.Code, 
						                R.Description, 
										R.ListingOrder			
						ORDER BY R.ListingOrder										
			</cfquery>
		 
		 	<CFIF element.recordcount gte "1">
				
			   	<cftreeitem value="elements"
		            display="<span style='padding-top:3px;padding-bottom:3px;color: B08C42;' class='labellarge'><b>#lt_text#</b></span>"									
		           	expand="Yes">				 						
										
				<cfquery name="Element" datasource="AppsCaseFile" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   R.Code, 
						         R.Description, 
								 R.ListingOrder,
								 count(*) as Total	
						FROM     ClaimElement C INNER JOIN
						         Element E ON C.ElementId = E.ElementId INNER JOIN
						         Ref_ElementClass R ON E.ElementClass = R.Code
						WHERE    C.ClaimId IN
		                          (SELECT  ClaimId
		                            FROM   Claim
		                            WHERE  Mission = '#url.id2#')		
						GROUP BY R.Code, 
						                R.Description, 
										R.ListingOrder			
						ORDER BY R.ListingOrder										
				</cfquery>
										
				<cfloop query="Element">
					
						<cf_assignid>
					
						<cftreeitem value="#code#_#rowguid#"
			            display="#Description# [#total#]"
			            parent="elements"			            
			            href="javascript:elementlist('#code#','#url.id2#','','')"
			            queryasroot="No"
			            expand="no">									
					
				</cfloop>	 
				
			</cfif>	
			
	</cftree>
			
</cfform>

</td></tr></table>
