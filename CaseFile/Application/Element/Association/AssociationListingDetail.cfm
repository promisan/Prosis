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

<cfparam name="url.mode" default="edit">
<cfparam name="url.show" default="children">
	
<table width="99%" cellspacing="0" cellpadding="0" class="formpadding">	
	
	<!--- get the relations eitherway --->
	
	<cfquery name="Relation" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   E.PersonNo,
		         R.*, 
		         D.Description as RelationDescription,
				 D.ElementClassTo,
				 D.ElementClassFrom
	    FROM     ElementRelation R, 
		         Element E, 
				 Ref_ElementRelation D

		
		WHERE    R.ElementId      = '#url.elementid#'			
		AND      R.ElementIdChild = E.ElementId
		
		
		AND      R.RelationCode   = D.Code
		AND      E.ElementClass   = '#url.elementclass#'		
		
		UNION
				
		SELECT   E.PersonNo,
		         R.*, 
		         D.Description as RelationDescription,
				 D.ElementClassTo,
				 D.ElementClassFrom
	    FROM     ElementRelation R, 
		         Element E, 
				 Ref_ElementRelation D
		
		WHERE    R.ElementIdChild = '#url.elementid#'
		AND      R.ElementId      = E.ElementId
						
		AND      R.RelationCode   = D.Code
		AND      E.ElementClass   = '#url.elementclass#'				
		
	</cfquery>
	
		
	<cfquery name="getTopicList" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT    R.*
	     FROM      Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
		 WHERE     ElementClass = '#url.elementclass#'	
		 AND       Operational = 1
		 AND       (Mission = '#url.Mission#' or Mission is NULL)	
		 AND       S.PresentationMode IN ('1','6')
		 <!---
		 AND       R.TopicClass != 'Person'
		 --->
		 ORDER BY  S.ListingOrder,R.ListingOrder
	</cfquery>	
					
	<cfoutput query="relation">		
	
		<tr class="linedotted">
		    <td height="20" valign="top" align="center" width="20" rowspan="1" style="padding-top:1px" class="labelit"><cf_space spaces="6">#currentrow#.&nbsp;</td>
			<td width="20" valign="top" align="center" rowspan="1" style="padding-top:8px" onClick="" class="labelit"><cf_space spaces="6">
			
			<!--- defined the element to --->	
			  
			<cfif elementid eq url.elementid>
			   <cfset elementto = elementidchild>
			<cfelse>
			   <cfset elementto = elementid> 
			</cfif>    
			
			<cf_assignid>		
			 			
			<!--- element to be shown for its data --->							
			<cfset elementClass = url.elementclass>		
			  
			<cfif url.mode eq "edit">
						
			  <cfset cl = "hide">
			  <cfset cli = "regular">	
												 			 			  
			  <img src="#Client.VirtualDir#/Images/arrowright.gif" 
			            alt="Expand" 				           
						name="#relationid#_exp" 
						border="0" 
						class="#cli# show" 
						align="absmiddle" 
						style="cursor: pointer;"
						onclick="ColdFusion.navigate('../Association/AssociationAdd.cfm?mission=#url.mission#&scope=embed&elementclass=#elementclass#&elementid=#url.elementid#&drillid=#elementto#&show=#url.show#','box#url.show#_#rowguid#');document.getElementById('#relationid#_exp').className='hide';document.getElementById('#relationid#_col').className='regular'">
			  
			  <img src="#Client.VirtualDir#/Images/arrowdown.gif" 							
						name="#relationid#_col" 
						alt="Collapse" 
						border="0" 
				    	align="absmiddle" 
						class="#cl# hide" 
						style="cursor: pointer"
						onclick="ColdFusion.navigate('../Association/AssociationAdd.cfm','box#url.show#_#rowguid#');document.getElementById('#relationid#_exp').className='regular';document.getElementById('#relationid#_col').className='hide'">			
			  			   
			</cfif>
			</td>
						
		    <td colspan="3" width="100%">		
			
			    <table width="100%" cellspacing="0" cellpadding="0">
				
				<cfif url.mode eq "edit">
				<cfparam name="url.forclaimid" default="">
				<cfif url.forclaimid neq "">
				<tr>
					<td class="labelmedium">				
					<a href="javascript:elementedit('#elementto#','#url.forclaimid#')"><font color="0080FF">#RelationDescription#</font></a>
					</td>				 	
				</tr>
				</cfif>
				</cfif>
					
				<tr>
					<td colspan="1">
						<table cellspacing="0" cellpadding="0" width="95%" align="center">		
						    <cfset element = elementto>					
							<cfinclude template="../Create/ElementViewCustom.cfm">	
						</table>	
					</td>
				</tr>	
							
				</table>
				
		    </td>
			
			<td rowspan="1" width="20" valign="top" style="padding-top:3px;padding-right:10px">
		
				<cfif url.mode eq "edit">				
				    <cf_img icon="delete" onclick="_cf_loadingtexthtml='';	ptoken.navigate('../Association/AssociationDelete.cfm?mission=#url.mission#&forclaimid=#url.forclaimid#&elementclass=#url.elementclass#&elementid=#url.elementid#&elementid1=#elementid#&elementid2=#elementidchild#&show=#url.show#','#url.show#_#url.elementclass#_ass')">
				</cfif>
				
			</td>
		</tr>	
		
		<cf_filelibraryCheck
			DocumentPath="CaseFileAssociation"
			SubDirectory="#relationid#" 
			Filter = "">	
					
		<cfif files gte "1">
					
			<tr>
			<td></td><td></td><td colspan="3">
					
		        <cf_filelibraryN
					DocumentPath="CaseFileAssociation"
					SubDirectory="#relationid#" 
					Filter=""						
					Presentation="all"
					box="view_#relationid#"
					Insert="no"
					Remove="no"
					loadscript="no"
					width="100%"									
					border="1">	
								
			</td>
			</tr>
		
		</cfif>
							
		<tr>		  
		   <td></td>
		   <td></td>
		   <td colspan="4" id="box#url.show#_#rowguid#"></td>		
		</tr>		
		
		
		
	</cfoutput>
	
</table>



