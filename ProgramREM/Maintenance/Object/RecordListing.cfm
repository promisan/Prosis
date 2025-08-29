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
<cfset add          = "1">
<cfset save         = "0"> 

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfajaximport tags="cfdiv">

<cf_verifyOperational 
         datasource= "appsProgram"
         module    = "Procurement" 
		 Warning   = "No">

<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT O.*, 
	       R.Description as ResourceDescription, 
		   R.ListingOrder as ResourceOrder,
		   F.Code as Usagecode,
		   <cfif operational eq "1">
		   (SELECT count(*) 
		    FROM Purchase.dbo.ItemMasterObject 
			WHERE objectCode = O.Code) as ItemMaster,		   
		   </cfif>
		   F.Description as Usage		   
	FROM   #CLIENT.LanPrefix#Ref_Object O LEFT OUTER JOIN 
	       #CLIENT.LanPrefix#Ref_Resource R ON O.Resource = R.Code
		   RIGHT OUTER JOIN Ref_ObjectUsage F ON F.Code = O.ObjectUsage
	WHERE  (ParentCode is NULL OR ParentCode = '')
	ORDER BY F.Code, R.ListingOrder, O.ListingOrder 
</cfquery>

<!--- ----------------------- --->
<!--- populate stObject table --->
<!--- ----------------------- --->

<cfquery name="clean" 
     datasource="AppsProgram" 
  	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     DELETE FROM stObject	
</cfquery>	

<cfquery name="getObject" 
     datasource="AppsProgram" 
  	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO stObject
	 (Code, Resource, ParentCode, Description, HierarchyCode)
	 SELECT Code, Resource, ParentCode, Description, HierarchyCode
	 FROM   Ref_Object	
</cfquery>	

<cfquery name="setObjectParent" 
     datasource="AppsProgram" 
  	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE stObject
	 SET    ParentCode = Code
	 WHERE  ParentCode is NULL or ParentCode NOT IN (SELECT Code FROM Ref_Object)	
</cfquery>	

<!--- ----------------------- --->
<!--- ----------------------- --->
<!--- ----------------------- --->

<cfoutput>

<script>

function item(code) {
  se = document.getElementById(code+'box')
  dt = document.getElementById(code+'detail')
  if (se.className == "hide") {    
	se.className = "regular"
	ColdFusion.navigate('ItemMaster.cfm?code='+code,code+'detail')
  } else {
    se.className = "hide"
  }

}

function itemadd(code) {
    ptoken.open("#SESSION.root#/Procurement/Maintenance/Item/RecordAdd.cfm?object="+code, "_blank");	
 }
 
function refreshlist(code) {
    _cf_loadingtexthtml='';		
	ptoken.navigate('ItemMaster.cfm?code='+code,code+'detail')	
	ptoken.navigate('ItemMasterTotal.cfm?code='+code,code+'sum')
}  

function itemedit(id1,code,mis) {     
	 ptoken.open("#SESSION.root#/Procurement/Maintenance/Item/RecordAdd.cfm?idmenu=#url.idmenu#&mission="+mis+"&ID1=" + id1, "_blank");		
}

function itemdelete(id1,code,mis) {
     _cf_loadingtexthtml='';	
	 ptoken.navigate('ItemMaster.cfm?action=delete&itemmaster='+id1+'&code='+code,code+'detail')
     ptoken.navigate('ItemMasterTotal.cfm?code='+code,code+'sum')
}

function show(use,row) {
  se = document.getElementsByName('box'+use)
  ex = document.getElementById('d'+row+'Exp')
  mi = document.getElementById('d'+row+'Min') 
  cnt = 0
  if (se[0].className == "hide") {    
    mi.className = "regular"
	ex.className = "hide"
    while (se[cnt]) {
	  se[cnt].className = "regular"	 
	  ColdFusion.navigate('RecordSet.cfm?ObjectUsage='+use,'result')
	  cnt++
	} 
  } else {
  	 mi.className = "hide"
	 ex.className = "regular"
     while (se[cnt]) {
	  se[cnt].className = "hide"
	  cnt++
	 } 
  }
}

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=650, height=720, toolbar=no, status=yes, scrollbars=no, resizable=no");
}


function recordedit(id1) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=750, height=730, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>	

<cfparam name="client.objectusage" default="">

<tr><td style="height:100%">

<cf_divscroll>

	<table width="95%" align="center" class="navigation_table">
	
	<tr class="hide"><td id="result"></td></tr>
	
	<tr class="labelmedium line fixrow">
	    <td height="20"></td>
	    <td>CodeId</td>
		<td>Display</td>
		<td>Description</td>
		<td>Sort</td>
		<td>Parent</td>
		<cfif operational eq "1">
		<td>Item</td>
		<cfelse>
		<td></td>
		</cfif>
		<td>Officer</td>
	    <td>Entered</td>  
	</tr>
	
	<cfset Ord = 100>
	
	<cfoutput query="SearchResult" group="ObjectUsage">
	
	    <tr onclick="show('#usagecode#','#currentrow#')" style="cursor:pointer" class="line navigation_row fixrow2">
		
	    <td colspan="8" height="20">
		
		<cfif client.objectusage eq ObjectUsage>
		    <cfset cl = "regular">
			<cfset cla = "hide">
		<cfelse>
		    <cfset cl = "hide"> 
			<cfset cla = "regular">
		</cfif>
			
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">		
			<tr><td width="30" height="30" style="padding-left:3px" align="left">
				
			<img src="#client.virtualdir#/Images/icon_expand.gif" alt="" 
					name="d#currentrow#Exp" id="d#currentrow#Exp" 
					border="0" 
					align="absmiddle"
					class="#cla#">
						 
			<img src="#client.virtualdir#/Images/icon_collapse.gif" 
					name="d#currentrow#Min" id="d#currentrow#Min" alt="" border="0" 
					align="absmiddle"
					class="#cl#">
			
			</td>
			<td class="labellarge">#Usage#</a></td>		
			</tr>
			
			</table>
		
		</td>
			
		<cfquery name="Total"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT count(*) as count
			FROM   #CLIENT.LanPrefix#Ref_Object O
			WHERE  O.ObjectUsage = '#ObjectUsage#'	
		</cfquery>
	
		<td class="labelmedium" style="padding-right:10px" align="right">#total.count#</td>
			
	    </tr>	
				
		<cfoutput group="ResourceOrder">
		
		<cfoutput group="ResourceDescription">
		
		    <tr id="box#UsageCode#" name="box#UsageCode#" class="#cl#">
		    <td colspan="9" class="labelmedium" style="height:30px;padding-left:6px"><font color="804000">#ResourceDescription#</td>
		    </tr>
			
			<tr id="box#UsageCode#" name="box#UsageCode#" class="#cl#">
			<td height="1" colspan="9"></td></tr>
			
				 <cfif Code neq "">
				 
				  <cfoutput>		
				  
				    <cfset use = usagecode>
														
				  	<cfinclude template="RecordListingDetail.cfm">		  			
						
					<cfquery name="SubLevel1"
				     datasource="AppsProgram" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     SELECT   O.*, 
					          R.Description as ResourceDescription, 
						      <cfif operational eq "1">
						      (SELECT count(*) 
						       FROM Purchase.dbo.ItemMasterObject 
							   WHERE objectCode = O.Code) as ItemMaster,		   
						      </cfif>
						      R.ListingOrder as ResourceOrder
					 FROM     #CLIENT.LanPrefix#Ref_Object O, 
					          #CLIENT.LanPrefix#Ref_Resource R
					 WHERE    O.Resource = R.Code
					 AND      ParentCode = '#SearchResult.Code#' and O.ObjectUsage = '#use#'
					 ORDER BY O.ListingOrder
				    </cfquery>
									
					<cfloop query="SubLevel1">					
						<cfinclude template="RecordListingDetail.cfm">															
					</cfloop>
				
				</CFOUTPUT>		
		
			    </cfif> 
			
		</CFOUTPUT>	
		</CFOUTPUT>
					
	</CFOUTPUT>    
	
	</table>

	</cf_divscroll>
	
	</td></tr>
	
</table>	