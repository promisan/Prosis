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

 
<table width="100%" border="0" cellspacing="0" cellpadding="0">

<cfquery name="get" 
 	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *		
		FROM     RosterSearch
		WHERE    SearchId = '#URL.ID#'		
</cfquery>


<cfquery name="Master" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	  SELECT   DISTINCT ExperienceClass, 
	           R.Description, 
			   <!--- DescriptionFull, --->
			   R.ListingOrder, 
			   R.Parent
	  FROM     Ref_ExperienceClass R  <!--- , OccGroup --->
	  WHERE    Parent = '#Parent#'
	 <!---  AND      OccGroup.OccupationalGroup = Ref_ExperienceClass.OccupationalGroup  --->
	  AND      ExperienceClass IN (SELECT ExperienceClass 
		                           FROM   Ref_ExperienceClassOwner 
								   WHERE  Owner = '#get.Owner#')
	  AND      Operational = '1'
	  ORDER BY Parent DESC, 
	           <!--- OccGroup.DescriptionFull,  --->
			   R.ListingOrder
</cfquery>

<cfif master.recordcount eq "0">
	
	<cfquery name="Master" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		   SELECT   DISTINCT ExperienceClass, 
	           R.Description, 
			   <!--- DescriptionFull, --->
			   R.ListingOrder, 
			   R.Parent
	  FROM     Ref_ExperienceClass R  <!--- , OccGroup --->
	  WHERE    Parent = '#Parent#'
	 <!---  AND      OccGroup.OccupationalGroup = Ref_ExperienceClass.OccupationalGroup  --->	
	  AND      Operational = '1'
	  ORDER BY Parent DESC, 
	           <!--- OccGroup.DescriptionFull,  --->
			   R.ListingOrder
	</cfquery>

</cfif>

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Background">	
			
<cfquery name="Select" 
 	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   SelectId, F.ExperienceClass
		INTO     UserQuery.dbo.tmp#SESSION.acc#Background
		FROM     RosterSearchLine S, Ref_Experience F, Ref_ExperienceClass P
		WHERE    S.SearchId = '#URL.ID#'
		AND      P.Parent = '#Parent#'		
		AND      S.SelectId = F.ExperienceFieldId
		AND      F.ExperienceClass = P.ExperienceClass
		AND      F.Status = '1'
		ORDER BY F.ListingOrder, F.Description 
</cfquery>

<cfquery name="Entries" 
    datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT SelectId
	   FROM UserQuery.dbo.tmp#SESSION.acc#Background 
</cfquery>

<cfset sel = "">
<cfoutput query = "Entries">
   <cfset sel = sel & "," & #SelectId#>
</cfoutput>

<input type="hidden" id="Rows" name="Rows" value="<cfoutput>#Master.recordcount#</cfoutput>">

<cfoutput query="Master" group="Parent">
     
	<!--- 
	  
	<cfoutput group="DescriptionFull">
	
	  <cfif DescriptionFull neq "">
	  <tr>
	  	<td class="labelmedium">#DescriptionFull#</td>
	  </tr>  
	  </cfif>
	  
	  --->
	
	<cfoutput>
	
    <cfset ar = Master.ExperienceClass>
					
	<tr><td>
	
		<cfquery name="count" 
	  datasource="AppsSelection" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT  count(*) as Count
	  FROM    RosterSearchLine S
	  WHERE   S.SearchId = '#URL.ID#'
	  AND     S.SelectId IN (SELECT ExperienceFieldId FROM Ref_Experience WHERE ExperienceClass = '#Ar#')
	  </cfquery>
	
	   <input type="hidden" id="#ar#clCount" name="#ar#clCount" value="#count.count#">

	   <table width="100%" class="regular">
	   <TR><td align="left">
						
		  <cfquery name="Entries" 
		   datasource="AppsSelection" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   SELECT SelectId
		   FROM   UserQuery.dbo.tmp#SESSION.acc#Background
		   WHERE  ExperienceClass = '#Ar#' 
		  </cfquery>
		  
		   <cfquery name="Check2" 
		   datasource="AppsSelection" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   SELECT *
			   FROM   Ref_ExperienceClass
			   WHERE  Parent = '#Parent#' 
		  </cfquery>
		  		  
		  <cfif Entries.recordCount gt "0">
		   <cfset show = "1">
		  <cfelse>
		   <cfset show = "0"> 
		  </cfif>
		 					
		   <table width="100%" border="0" cellspacing="0" cellpadding="0">		 
		   <tr class="linedotted"><td width="4%" align="center">
		  		   		   
		    <cfif show eq "0">
			
			   <img src="#SESSION.root#/Images/arrowright.gif" alt="" 
			   id="#Ar#Exp" name="#Ar#Exp" border="0" height="11px" class="<cfif #Entries.recordCount# gt "0">hide<cfelse>regular</cfif>" 
			   align="middle" style="cursor: pointer;" onClick="expand('#Ar#','Exp','#CurrentRow#')">
			   			   
			 <cfelse>			
									 
			    <img src="#SESSION.root#/Images/arrowright.gif" alt="" 
			    id="#Ar#Exp" name="#Ar#Exp" border="0" height="11px" class="<cfif #Entries.recordCount# gt "0">hide<cfelse>regular</cfif>" 
			    align="middle" style="cursor: pointer;" onClick="expand('#Ar#','Exp','#CurrentRow#')">
			   			
			 </cfif>  
			 			 
			    <img src="#SESSION.root#/Images/arrowdown.gif" id="#Ar#Min" id="#Ar#Min"
			    alt="" border="0" align="middle" class="hide" width="11px" style="cursor: pointer;" onClick="expand('#Ar#','Min','#CurrentRow#')">
			 			   
			   </td>
		
		    <td width="70%" style="padding-left:1px;cursor: pointer;" class="labelmedium" onClick="expand('#Ar#','Exp','#CurrentRow#')"><font color="0080C0">#Description#
			 <input type="hidden" name="cl#currentrow#"></td>
			<td></td>
		  </TR>
		  </table>
		  </td></tr>
										
    	  <TR><td width="100%" colspan="2">
										
			<cfif show eq "1">
    			<table width="100%" border="0" align="right" class="regular" id="#Ar#">
			<cfelse>
	    		<table width="100%" border="0" align="right" class="hide" id="#Ar#">
			</cfif>

			<tr class="linedotted">
   			<td width="90" valign="top"></td>
			<td width="100%" class="labelit" style="padding-left:40px;padding-bottom:5px"> 
			<cfif show eq "0"> 
			    <cfdiv id="i#ar#">				
			<cfelse>
			    <cf_securediv id="i#ar#" bind="url:#SESSION.root#/roster/RosterGeneric/RosterSearch/Structured/Search4KeywordDetail.cfm?ID=#URL.ID#&AR=#AR#&row=#CurrentRow#">				
			</cfif>
			</td></tr>
			</table>
		</td></tr>
		</table>
	</td></tr>
				
	</cfoutput>	
	
	<!---
</cfoutput>		
--->

</cfoutput>
				
</table>
