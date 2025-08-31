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
<cfparam name="AccessPosition" default="none">

<cfparam name="URL.ID2" default="0">

<script>

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight4";
	 }else{		
     itm.className = "regular";		
	 }
  }

</script>

<cfparam name="URL.Domain" default="Position">

<cfquery name="Position" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  *
	FROM    Position
	WHERE   PositionNo = '#url.id2#'			 
</cfquery>

<cfquery name="GroupAll" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   F.*, S.PositionNo, S.Status AS Status
	FROM     PositionGroup S RIGHT OUTER JOIN
             Ref_Group F ON S.PositionGroup = F.GroupCode AND S.Status <> '9' AND S.PositionNo = '#URL.ID2#' INNER JOIN 
			 Ref_GroupMission M ON F.GroupCode = M.GroupCode AND Mission = '#url.id#'			 
	WHERE    GroupDomain = '#URL.Domain#'
	AND      Operational = 1		
	ORDER BY ListingOrder							 
	
</cfquery>

<cfif groupAll.recordcount eq "0">	
	
	<cfquery name="GroupAll" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   F.*, S.PositionNo, S.Status AS Status
		FROM     PositionGroup S RIGHT OUTER JOIN
	             Ref_Group F ON S.PositionGroup = F.GroupCode AND S.Status <> '9' AND S.PositionNo = '#URL.ID2#'
		WHERE    GroupDomain = '#URL.Domain#'
		AND      Operational = 1				
	</cfquery>

</cfif>

<cfif GroupAll.recordcount eq "0">

<font style="color:gray">No position categorizations enabled for entity</font>

</cfif>
  
<table width="100%">
<tr>			    
	<td style="padding-left:0px">		
	<cfset row = 0>				
	<table>			
		<cfoutput query="GroupAll">							
		<cfif row eq "0"><tr></cfif>			
		<cfset row = row+1>			
		<td>
		
			<table bgcolor="white" class="formpadding">						
			      <TR bgcolor="white">										
					<CFIF AccessPosition eq "EDIT" OR AccessPosition eq "ALL">						
						<TD style="height:14px;padding-right:4px">						
						<cfif PositionNo eq "">
						<input type="checkbox" class="radiol" name="positiongroup" value="#GroupCode#" onClick="hl(this,this.checked)">
						<cfelse>
						<input type="checkbox" class="radiol" name="positiongroup" value="#GroupCode#" checked onClick="hl(this,this.checked)">
					    </cfif>							
						</td>																												   
					</CFIF>														
					<TD class="labelit fixlength" title="#description#" style="padding-left:3px;background-color:f1f1f1;height:14px;padding-right:10px">
					<cfif PositionNo neq ""><cfelse><CFIF AccessPosition eq "EDIT" OR AccessPosition eq "ALL"><cfelse><font color="c8c8c8"></cfif></cfif>#Description#</TD>					
					<td style="width:4px"></td>
				</tr>					
			</table>
		</td>			
		<cfif row eq "3">
		 <cfset row = 0>
		    </tr>
		</cfif>						
		</cfoutput>		
	</table>		
	</td>	
</tr>
</table>
  
