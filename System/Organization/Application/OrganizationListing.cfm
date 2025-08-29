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
<cfparam name="URL.ID1" default="all">
<cfparam name="URL.ID2" default="0">
<cfparam name="URL.ID3" default="0000">
<cfparam name="URL.page" default="1">

<cfparam name="client.orgmode" default="listing">

<cf_screentop height="100%" 
              blockevent="rightclick" 
			  ValidateSession="Yes"
			  scroll="yes" 
			  jQuery="Yes"
			  html="No">

<script>

 function hlnode(itm,fld) {			
											 	 	
	 if (fld != "normal"){
		 itm.className = "highlight1";
	 }else{
	     itm.className = "";		
	 }
    }		 
	
	w = 0
	h = 0	
	

function tree(parent,name) {
     
	url = "#SESSION.root#/System/Organization/Tree/OrgTreeLevel.cfm?direction=horizontal&parent="+parent+"&tree=operational&nme="+name+"&selectiondate=&fund=&postClass=&Layout=&Summary="
	ptoken.navigate(url,'treeview')		
				 
}

</script>

<cf_dropdown>
<cf_presentationScript>
<cf_dialogOrganization>

<cfset CLIENT.search = "&ID2=#URL.ID2#&ID3=#URL.ID3#">

<input type="hidden" name="mission" id="mission" value="<cfoutput>#URL.ID2#</cfoutput>">

 <cfquery name="Mandate" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM   Ref_Mandate
   WHERE  Mission = '#URL.ID2#'
</cfquery>
      
<cfif URL.ID2 eq "0">
   <cfabort>
</cfif>

<table width="98%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<tr class="line"><td colspan="2" height="1">

<cfset url.header = 0>
<cfinclude template="OrganizationViewHeader.cfm">

</td></tr>

<tr>
    <td height="30" colspan="2" width="100%">
				
	<!--- Query returning search results --->
	
	<cfif URL.ID1 eq "NULL">
	  <cfset cond = "AND O.HierarchyCode is NULL">
	<cfelseif URL.ID1 eq "all">
	   <cfset cond = "AND (O.ParentOrgUnit IS NULL or O.ParentOrgUnit = '')">
	<cfelse>
	   <cfset cond = "AND O.OrgUnit = '#URL.ID1#'">
	</cfif>
	
		
	<cfif URL.ID1 neq "NULL">
		
		<cfquery name="SearchResult" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   Distinct O.*
		    FROM     #LanPrefix#Organization O							
			WHERE    O.Mission = '#URL.ID2#'
			AND      O.MandateNo = '#URL.ID3#'
				     #preserveSingleQuotes(cond)# 
			ORDER BY O.Mission, TreeOrder
		</cfquery>
	
	<cfelse>
			
		<cfquery name="SearchResult" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT O.*
			FROM   #LanPrefix#Organization O	
			WHERE  Mission = '#URL.ID2#' 
			AND    MandateNo = '#URL.ID3#' 
			AND    HierarchyCode IS NULL 	
			ORDER BY Mission, TreeOrder
		</cfquery>
	
	</cfif>
	
	<cfif searchResult.recordcount eq "0">
	   <cfset man = URL.ID3>
	<cfelse>
	   <cfset man = SearchResult.MandateNo>
	</cfif>   
	
	<cfinvoke component="Service.Access"  
	  method="org" 
	  orgunit="#SearchResult.OrgUnit#" 
	  mission="#URL.ID2#"
	  returnvariable="access">   
	  
	<cfoutput>	  
	
	<table width="100%" height="100%">
	<tr>
	
	<td width="90%" height="4">
		<cfif client.orgmode eq "listing">
			<div id="filterContainer">
				<cfinvoke component = "Service.Presentation.tableFilter"  
				   method           = "tablefilterfield" 
				   filtermode       = "fly"
				   name             = "filtersearch"
				   style            = "font:14px;height:25px;width:200px;"
				   rowclass         = "clsSearchrow"
				   rowfields        = "ccontent">
			</div>
		</cfif>
	</td>
	
	<CFIF Access EQ "ALL" or Access EQ "Edit" or url.id4 eq "Limited"> 
	
		  <td>
		  
		  <cf_tl id="Add Node" var="vAdd">
		  
	      <input type="button" 
		     value="#vAdd#" 
		     class="button10s" 
			 style="width:100"
			 onclick="addOrgUnit('#URL.ID2#','#man#','#SearchResult.OrgUnitCode#','#SearchResult.OrgUnitCode#','base','#url.id4#')">
		  </td>
		
	</cfif>
	
	<td style="padding-left:20px;">
	<input type="radio" style="height:18px; width:18px;" name="ListMode" id="ListMode1" value="Listing"  <cfif client.orgmode eq "listing">checked</cfif> onclick="ColdFusion.navigate('OrganizationListingList.cfm?page=1&id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&id4=#url.id4#','treeview'); $('##filterContainer').css('display','block'); $('##filtersearchsearch').val('');">
	</td>
	<td class="labellarge" style="padding-left:5px;"><label for="ListMode1"><cf_tl id="Listing"></label></td>
	<td style="padding-left:5px;"><label for="ListMode1"><img src="#SESSION.root#/images/listing.gif" height="23" width="23" alt="" border="0"></label>
	<td style="padding-left:20px;">
		<input type="radio" style="height:18px; width:18px;" name="ListMode" id="ListMode2" value="Tree" <cfif client.orgmode neq "listing">checked</cfif> onclick="ColdFusion.navigate('#SESSION.root#/System/Organization/Tree/OrgTreeInit.cfm?direction=horizontal&orgunit=#SearchResult.OrgUnit#&nme=#SearchResult.OrgUnitName#','treeview'); $('##filterContainer').css('display','none');">
	</td>	
	<td class="labellarge" style="padding-left:5px; text-transform:capitalize;"><label for="ListMode2"><cf_tl id="Tree" var="1">#lcase(lt_text)#</label></td>
	<td style="padding-left:5px;"><label for="ListMode2"><img src="#SESSION.root#/images/orgchart.gif" height="23" width="23" alt="" border="0"></label>
	</td>
	<td style="padding-left:20px; padding-right:10px;">
	
		<span id="printTitle" style="display:none;"><cf_tl id="Organization">: #Mission.Mission# [#URL.ID3#]</span>
		<cf_tl id="Print" var="1">
		<cf_button2 
			mode		= "icon"
			type		= "Print"
			title       = "#lt_text#" 
			id          = "Print"					
			height		= "25px"
			imageheight  = "20px"
			width		= "30px"
			printTitle	= "##printTitle"
			printContent = "##mainOrgContainer">
			
	</td>
	</tr>
	</table>
	
	</cfoutput>
			
	</td>
	
</tr>

<tr><td colspan="2" height="100%" valign="top">  
  
  	<cf_divscroll style="height:100%; padding-left:3px;padding-right:3px" overflowx="Auto" id="mainOrgContainer">
  
	    <cfif url.id1 eq "all">
		  <cfset mode = "tree">	
		  <cfset nme  = "#SearchResult.mission#">
		<cfelse>
		  <cfset mode = "unit">	
		  <cfset nme  = "#SearchResult.OrgUnitName#">
		</cfif>
		
	    <cfif client.orgmode eq "listing">
	    	<cf_securediv id="treeview" bind="url:OrganizationListingList.cfm?page=1&id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&id4=#url.id4#">
		<cfelse>
			<cf_securediv id="treeview" bind="url:#SESSION.root#/System/Organization/Tree/OrgTreeInit.cfm?direction=horizontal&mode=#mode#&orgunit=#SearchResult.OrgUnit#&nme=#nme#">
		</cfif>	
	
	</cf_divscroll>
	   
  </td>
  
  </tr>
	   
</table>

<cf_screenbottom html="No">