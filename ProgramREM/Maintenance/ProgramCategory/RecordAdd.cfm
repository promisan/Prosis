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
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="yes" 
			  label="Add Classification" 
			  layout="webapp"
			  banner="gray"
  			  menuAccess="Yes" 
			  jquery="yes"
              systemfunctionid="#url.idmenu#">

<cfoutput>
<script>
	function selectorHL(s,c,v) {
		if (v) {
			$(s).css('background-color',c);
		}else {
			$(s).css('background-color','');
		}
	}
	
	function toggleClass(s,st) {
		if ($(s).first().is(':visible')) {
			$(s).css('display','none');
			$(st).attr('src','#session.root#/Images/icon_expand2.gif');
		}else{
			$(s).css('display','');
			$(st).attr('src','#session.root#/Images/icon_collapse2.gif');
		}
	}
</script>
</cfoutput>			  

<cf_droptable dbname="AppsProgram" tblname="tmp#SESSION.acc#Category"> 

<cfparam name="url.parent"  default="">
<cfparam name="url.mission" default="">

<cf_droptable dbname="AppsProgram" tblname="tmp#SESSION.acc#Category"> 

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

    <tr><td height="7"></td></tr>
	
	<TR>
    <TD class="labelmedium">Parent:</TD>
    <TD>
		   
		<cfquery name="Parent" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ProgramCategory
			WHERE  Parent is NULL or Parent = ''			
			<cfif url.mission neq "">
			AND    Code in (SELECT Category FROM Ref_ParameterMissionCategory WHERE Mission = '#URL.Mission#')
			</cfif>
			UNION
			SELECT *
			FROM   Ref_ProgramCategory
			WHERE  Parent IN (SELECT Code 
			                  FROM   Ref_ProgramCategory 
							  WHERE  Parent is NULL or Parent = ''
							  <cfif url.mission neq "">
								AND    Code in (SELECT Category FROM Ref_ParameterMissionCategory WHERE Mission = '#URL.Mission#')
							</cfif>)
						  
			ORDER BY HierarchyCode
		</cfquery>	
	
	   <select name="parent" class="regularxl">
	   
		   <option value="">[root]</option>
		   
		   <cfoutput query="Parent">
		   
		   <option value="#Code#" <cfif url.Parent eq Code>selected</cfif>>
		    <cfif Parent neq "">&nbsp;&nbsp;&nbsp;&nbsp;</cfif>
		    #Parent.Code# 
		    <cfif Len(Parent.Description) gt 38>
 		   	   #Left(Parent.Description, 38)#...
	    	<cfelse>
		       #Parent.Description#
	       </cfif>	   
		   </option>
		   </cfoutput>
		   
	   
	   </select>
	  
	  	   
    </TD>
	</TR>
	
	<tr class="labelmedium" id="lineentity">
	   <td class="labelmedium" valign="top" style="padding-top:4px">Entity:</td>
	   <td>
	   <cfdiv bind="url:RecordAddMission.cfm?par={parent}&mission=#url.mission#" 
	          id="entity">
	   </td>
	
	</tr>
	
	<tr class="labelmedium" id="lineclass">
	   <td class="labelmedium">Class:</td>
	   <td>
	   <cfdiv bind="url:RecordAddClass.cfm?par={parent}" 
	          id="class">
	   </td>
	
	</tr>
	
    <TR class="labelmedium">
    <TD>Code:</TD>
    <TD>
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxl">
    </TD>
	</TR>
		
	<cfif url.parent eq "">

		  <cfset next = "">	  

	<cfelse>
		    	
		<cfquery name="check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT max(listingorder) as Last	
			FROM Ref_ProgramCategory		
			WHERE Parent = '#url.parent#'		
		</cfquery>
		<cfif check.last eq "">
		
		 <cfset next = "1">
		 
		<cfelse>
		
		  <cfset next = check.last+1>	 
		
		</cfif>
	
	</cfif>	
	
	<TR class="labelmedium">    
    <TD><cf_tl id="ListingOrder"></td>
	<td>
  	   <cfinput type="Text" value="#next#" name="ListingOrder" message="Please enter an valid integer" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="4" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Entry mode:</TD>
    <TD>
  	   <table>
	   		<tr>
				<td style="padding-left:2px;"><input type="Radio" name="EntryMode" id="EntryMode_Enabled" value="1" checked></td>
				<td style="padding-left:2px;" class="labelmedium"><label for="EntryMode_Enabled">Enabled</label></td>
				<td style="padding-left:5px;"><input type="Radio" name="EntryMode" value="0" id="EntryMode_Disabled"></td>
				<td style="padding-left:2px;" class="labelmedium"><label for="EntryMode_Disabled">Disabled</label></td>
			</tr>
	   </table>	
    </TD>
	</TR>
	
	<tr class="labelmedium" id="linepercent">
	   <td>Percentage:</td>
	   <td>
	   <cfdiv bind="url:RecordAddPercentage.cfm?par={parent}" 
	          id="percent">
	   </td>
	
	</tr>
	
	<TR>
    <TD valign="top" style="padding-top:5px" class="labelmedium">Memo:&nbsp;</TD>
    <TD>
	<textarea style="width:98%;padding:3px;font-size:13px" class="regular" rows="3" name="DescriptionMemo"></textarea>
     </TD>
	</TR>
	
			
	<tr class="line">
		<td style="padding-left:7px" colspan="2">
			<cfset vThisCode = "">
			<cfinclude template="ClassificationDetail.cfm">
		</td>
	</tr>
		
	<tr>	
	<td colspan="2" align="center" height="30">	
		
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="opener.location.reload();window.close()">
    <input class="button10g" type="submit" name="Insert" value="Submit">
	
	</td>	
	</tr>
		
	</table>
	

	</CFFORM>	
