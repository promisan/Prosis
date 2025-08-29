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
<cf_screentop height="100%" 
              scroll="yes" 
			  label="Edit Classification" 
			  layout="webapp" 
			  banner="gray" 
			  jQuery="yes">
  
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT       *
	FROM         Ref_ProgramCategory
	WHERE Code = '#URL.ID1#'
</cfquery>

<cf_droptable dbname="AppsProgram" tblname="tmp#SESSION.acc#Category"> 
	   
<cfquery name="Parent" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ProgramCategory
		WHERE  (Parent is NULL or Parent = '')
		AND Code != '#URL.ID1#'
		UNION
		SELECT *
		FROM   Ref_ProgramCategory
		WHERE  Code IN (SELECT Parent FROM Ref_ProgramCategory)
		AND Code != '#URL.ID1#'
		ORDER BY HierarchyCode
</cfquery>	 

<cf_droptable dbname="AppsProgram" tblname="tmp#SESSION.acc#Category"> 

<cfoutput>
<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Program Category?")) {
		return true 
	}	
	return false	
}

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

<cf_divscroll>

<table class="hide"><tr><td colspan="2"><iframe name="result" id="result" width="100%" height="100"></iframe></td></tr></table>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog" target="result">

<!--- edit form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td height="4"></td></tr>
	
	<TR>
    <TD class="labelmedium" width="15%">Parent:</TD>
    <TD>
	   <select name="Parent" class="regularxl">
	   
	   <option value="">[root]</option>
	   
		   <cfoutput query="Parent">
			   <option value="#Parent.Code#" <cfif get.Parent eq "#Parent.Code#">selected</cfif>> <cfif Parent neq "">&nbsp;&nbsp;&nbsp;&nbsp;</cfif>
			   #Parent.Code# 
			
			   <cfif Len(#Parent.Description#) gt 38>
			   	#Left(Parent.Description, 38)#...
		    	<cfelse>
			    #Parent.Description#
		       </cfif>
			   
			   </option>
		   </cfoutput>
    </TD>
	</TR>
	
    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="10" maxlength="10" class="regularxl">
	   <input type="hidden" name="Codeold" value="#get.Code#" size="10" maxlength="10"class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:&nbsp;</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.Description#" message="please enter a description" required="Yes" size="60" maxlength="75" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Subtitle">:</TD>
    <TD>
	<textarea style="width:98%;padding:3px;font-size:14px" class="regular" rows="4" name="DescriptionMemo"><cfoutput>#get.DescriptionMemo#</cfoutput></textarea>
     </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Listing&nbsp;Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" style="text-align:center"
	   message="Please enter an valid integer" value="#get.Listingorder#" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="4" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Mode:</TD>
    <TD>
  	   <table>
	   		<tr>
				<td style="padding-left:2px;"><input type="radio" class="radiol" name="EntryMode" value="1" id="EntryMode_Enabled" <cfif get.EntryMode eq 1>checked</cfif>></td>
				<td style="padding-left:2px;" class="labelmedium">Selection and data entry</td>
				<td style="padding-left:5px;"><input type="radio" class="radiol" name="EntryMode" value="0" id="EntryMode_Disabled" <cfif get.EntryMode eq 0>checked</cfif>></td>
				<td style="padding-left:2px;" class="labelmedium">Selection only</td>
			</tr>
	   </table>	
    </TD>
	</TR>
	
	</cfoutput>
	
	<cfif Get.Parent eq "">

		<cfquery name="MissionList" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *, (SELECT TOP 1 Category 
		           FROM   Ref_ParameterMissionCategory 
				   WHERE  Mission = L.Mission 
				   AND    Category = '#url.id1#') as selected ,
				   
				  (SELECT TOP 1 BudgetEarmark 
		           FROM    Ref_ParameterMissionCategory 
				   WHERE   Mission = L.Mission 
				   AND     Category = '#url.id1#' ) as Earmark 		   
				   
		FROM   Ref_ParameterMission L
		WHERE  Mission IN (SELECT Mission 
		                   FROM   Organization.dbo.Ref_MissionModule 
						   WHERE  SystemModule = 'Program')
		</cfquery>		
		
		<tr><td class="labelmedium" valign="top" style="padding-left:0px;padding-top:3px">Apply to Entity:</td><td colspan="1">
		
			<table cellspacing="0" width="93%" cellpadding="0">
			
			<cfset cnt = 0>
			<cfoutput query="MissionList">
			
			    <cfset cnt = cnt+1>
				<cfif cnt eq "1">
				<tr>
				</cfif>
					<td style="height:20px" class="labelmedium">#Mission#</td>
					<td width="20"><input type="checkbox" name="Mission_#currentrow#" value="#mission#" <cfif selected neq "">checked</cfif>></td>
					<td width="10"></td>
					<td class="labelit" style="padding-right:4px" width="30">Budget:</td>
					<td width="20"><input type="checkbox" name="Earmark_#currentrow#" value="1" <cfif earmark eq "1">checked</cfif>></td>
					<td width="20"></td>
				<cfif cnt eq "3">	
				</tr>
				<cfset cnt = 0>
				</cfif>
			
			</cfoutput>
			
			</table>	
		
		</td></tr>
		
		<tr><td class="labelmedium" style="padding-right:10px">Apply to Class:</td>
		<td>
						
		<cfquery name="ProgramClass" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_ProgramClass	
		</cfquery>
		
		<select name="ProgramClass" class="regularxl">
			<option value="">All Classes</option>
			<cfoutput query="ProgramClass">
			<option value="#Code#" <cfif get.ProgramClass eq code>selected</cfif>>#Description#</option>
			</cfoutput>
		</select>
		
		</td>
		</tr>
		
		<tr><td height="5"></td></tr>
		<tr><td colspan="2" class="linedotted"></td></tr>	
		<tr><td height="5"></td></tr>
		
	</cfif>
	
	<tr><td style="font-size:20px;height:50px" class="labelmedium" colspan="2"><b><font color="0080C0">Data entry interface settings</td></tr>
	
	<TR id="target">
    <TD class="labelmedium"><cf_tl id="Output/Target entry">:</TD>
    <TD>
  	   <table>
	   		<tr>
				<td style="padding-left:2px;"><input type="radio" class="radiol" name="EnableTarget" value="1" id="EntryMode_Enabled" <cfif get.EnableTarget eq 1>checked</cfif>></td>
				<td style="padding-left:2px;" class="labelmedium">Yes</td>
				<td style="padding-left:5px;"><input type="radio" class="radiol" name="EnableTarget" value="0" id="EntryMode_Disabled" <cfif get.EnableTarget eq 0>checked</cfif>></td>
				<td style="padding-left:2px;" class="labelmedium">No</td>
			</tr>
	   </table>	
    </TD>
	</TR>		
		
	<cfquery name="Earmark" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_ParameterMissionCategory
		WHERE     Category = '#get.Parent#' 
		AND       BudgetEarmark = 1
	</cfquery>
	
	<cfif earmark.recordcount gte "1">
	
	<TR>
    <TD class="labelmedium">Percentage:</TD>
    <TD>
  	   <cfinput type="Text" name="EarmarkPercentage" value="#get.EarmarkPercentage#" range="0,100" message="Please enter an valid percentage between 0 and 100" validate="integer" required="Yes" visible="Yes" style="text-align:center" size="3" maxlength="3" class="regularxl">&nbsp;%
    </TD>
	</TR>
		
	</cfif>
			
	<cfset vThisCode = get.code>
	
	<tr><td colspan="2" height="5" style="padding-right:30px">
	<table border="1" style="width:100%">
	<cfinclude template="ClassificationDetail.cfm">
	</table>
	</td></tr>
				
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>	
	<tr><td height="5"></td></tr>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Operational">:</TD>
    <TD>
  	   <table>
	   		<tr>
				<td style="padding-left:2px;"><input type="radio" class="radiol" name="Operational" value="1" <cfif get.Operational eq 1>checked</cfif>></td>
				<td style="padding-left:2px;" class="labelmedium">Yes</td>
				<td style="padding-left:5px;"><input type="radio" class="radiol" name="Operational" value="0" <cfif get.Operational neq 1>checked</cfif>></td>
				<td style="padding-left:2px;" class="labelmedium">No</td>
			</tr>
	   </table>	
    </TD>
	</TR>
	
	
		
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>	
	<tr><td height="5"></td></tr>
	
	<tr>	
		<td colspan="2" align="center">
	    <input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
    	<input class="button10g" type="submit" name="Update" value="Update">
		</td>	
	</tr>
	
</TABLE>
	
</CFFORM>

</cf_divscroll>
