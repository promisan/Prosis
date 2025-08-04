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

<!--- show selected device --->

<cfparam name="url.action" default="">
<cfparam name="url.itemno" default="">

<cfparam name="client.itemselect" default="''">

<cfif url.action eq "delete">

   <cfset val = replaceNoCase("#client.itemselect#","#url.itemno#","")>  
   <cfset client.itemselect = val>
   
<cfelse>   

	<cfif not find("'#url.itemno#'",client.itemselect)>
		<cfif client.itemselect neq "" and client.itemselect neq "''">
	   		<cfset client.itemselect = "#client.itemselect#,'#url.itemno#'">
		<cfelse>
			<cfset client.itemselect = "'#client.itemselect#','#url.itemno#'">
		</cfif>
	</cfif>
   
</cfif>

<cfquery name="ListItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	  SELECT    *
	  FROM      Item
	  WHERE     ItemNo IN (#preservesinglequotes(client.itemselect)#)		
      AND       ItemNo IN (SELECT ItemNo FROM Materials.dbo.Item WHERE ItemClass ='#url.MaterialsClass#')						   		  					  					 				 
</cfquery>	

<table width="100%" cellspacing="1" cellpadding="1" align="center">
<tr>
	<cfoutput query="ListItem">
		<td style="border:1px dotted silver" width="200" height="80" valign="top">
			<table width="100%" cellspacing="0" cellpadding="0">
			
			    <tr>
				<td style="padding-top:6px;padding-left:6px">
				
				<cfif FileExists("#SESSION.rootDocumentPath#/Warehouse/Pictures/#ItemNo#.jpg")>		 
				
				    <img src="#SESSION.rootDocument#/Warehouse/Pictures/#ItemNo#.jpg"
						     alt="#ItemDescription#"
						     width="70"
						     height="70"
						     border="0"
						     align="absmiddle">											 
				 							 
			  	<cfelse>		 
				 
				      <b><img src="#SESSION.root#/images/image-not-found1.gif" alt="#ItemDescription#" width="50"
							     height="50" border="0" align="absmiddle"></b>
					  
			    </cfif>			
				
				</td>				
				<td width="80%" style="padding-left:10px" valign="top">
				<table width="100%" cellspacing="3" cellpadding="3">
				<tr><td style="padding-top:4px">	
				    <table cellspacing="0" cellpadding="0">
					<tr class="labelit">
					<td>#ItemDescription#</td>
					<td style="padding-left:2px">
						<img src="#SESSION.root#/images/delete5.gif" 
						 onclick="_cf_loadingtexthtml='';ColdFusion.navigate('../templates/RequestDeviceGet.cfm?materialsclass=#url.materialsclass#&action=delete&itemno=#itemno#','process_#url.MaterialsClass#')"
						 width="13" height="13" border="0">
					 </td>
					 </tr>
					 </table>	
				   </td>
				</tr>				
				<tr><td class="labelit"><font face="Verdana" size="1" color="808080">id:</font>#ItemMaster#</td></tr>
				
				<cfquery name="UoM" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				  	  SELECT    *
					  FROM      ItemUoM
					  WHERE     ItemNo = '#itemno#'		 				 
				</cfquery>	
				
				<cfloop query="UoM">
					<tr><td class="labelit">
						#UoMDescription#: #APPLICATION.BaseCurrency# #numberformat(StandardCost,"__,__.__")#		
					</td></tr>
				</cfloop>
				
				</table>
				</tr>
				
			</table>
		</td>
		<td style="width:4px"></td>		
	</cfoutput>
</tr> 
</table>

	
	