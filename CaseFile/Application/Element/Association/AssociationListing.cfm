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

<!--- 1. get elementid 
      2. determine relevant other element classes 
	  3. loop through these and show the children : ajax  --->

<cfparam name="url.elementid"   default="">
<cfparam name="url.forclaimid"  default="">
<cfparam name="url.show" 	    default="children">

<cfif forclaimid neq "">
	
	<cfquery name="Case" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
	    FROM      Claim  
		WHERE     ClaimId = '#url.forclaimid#'			
	</cfquery>

<cfelse>
	
	<cfquery name="Case" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
	    FROM      Claim  
		WHERE     ClaimId In (SELECT ClaimId 
		                      FROM   ClaimElement 
							  WHERE  CaseElementId = '#url.caseelementid#')			
	</cfquery>

</cfif>

<cfquery name="Element" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
    FROM      Element 
	WHERE     ElementId = '#url.elementid#'			
</cfquery>

<cfquery name="ElementClassList" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
    FROM     Ref_ClaimTypeTab
	WHERE    Mission  = '#case.mission#'			
	AND      Code     = '#case.claimtype#'		
	AND      TabElementClass is not NULL 
	<!--- AND      TabElementClass != '#Element.ElementClass#' --->
	
	AND      TabElementClass IN (
		                         SELECT ElementClassTo  as Class
	                             FROM   Ref_ElementRelation 
								 WHERE	ElementClassFrom = '#Element.ElementClass#'
								 UNION 								 
								 SELECT ElementClassFrom as Class
	                             FROM   Ref_ElementRelation 
								 WHERE	ElementClassTo= '#Element.ElementClass#'
								 )
	
		
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">
	
	<cfif ElementClassList.recordcount eq "0">
		
		<tr><td align="center" height="60" class="labelmedium">
		  <font face="Verdana" size="2" color="FF0000"><cf_tl id="No associations are configured from this class"></font></td>
		</tr>
	
	<cfelse>
		
		<cfoutput query="ElementClassList">
		
			<cfset url.elementclass = tabelementclass>
						
			<tr class="linedotted">
			
			<td width="10%" height="24" valign="top">
			
				<table cellspacing="0" cellpadding="0">
		
					<tr>
					<td valign="top" style="padding-top:6px" class="labelmedium">
						<cfif url.show eq "children">
						
						   <cf_img icon="add" 
						     onclick="associate('','#url.elementclass#','#url.elementid#','#case.mission#','#url.show#')">
							 
						</cfif>		
						</td>
						<td valign="top" class="labelmedium">#tabname#</td>
						
					</tr>	
										
				</table>
			
			</td>
						
			<td width="90%" id="#url.show#_#url.elementclass#_ass">					
			    <cfset url.mission = case.mission>
				<cfinclude template="AssociationListingDetail.cfm">		
			</td>
			
			</tr>
			
		
		</cfoutput>
	
	
	</cfif>
	
</table>
