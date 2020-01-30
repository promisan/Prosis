
<cfquery name="SearchResult"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *, T.Description as Type
		FROM  #CLIENT.LanPrefix#Ref_Indicator O, 
		      Ref_IndicatorMission M,
		      Ref_ProgramCategory C,
			  Ref_IndicatorType T
		WHERE M.IndicatorCode = O.IndicatorCode
		AND   M.Mission = '#url.Mission#'
		AND   C.Code = O.ProgramCategory
		AND   O.IndicatorType = T.Code
		ORDER BY M.Mission, C.AreaCode, C.Code, O.IndicatorCode, O.IndicatorCodeDisplay
</cfquery>	

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">

	<tr><td height="25" colspan="12" align="center" bgcolor="ffffff">
	<cfoutput>
		 <input type="button" value="Add" class="button10g"  onclick="javascript:recordadd('#mission#')">
	</cfoutput>	 
		
	</td></tr>			
			
	<cfoutput query="searchresult" group="AreaCode">
		
		<cfoutput group="Code">
		    <tr class="linedotted">
			    <td colspan="12" height="25" class="labelmedium"><b>#Code# #Description#</b></td>
		    </tr>	
			
			<cfoutput>		
			<TR class="cellcontent linedotted navigation_row">		
			<td height="18" width="4%" align="center"></td>
			<TD><a href="javascript:recordedit('#mission#','#IndicatorCode#')"><font color="0080FF">#IndicatorCode#</a></TD>
			<cfif indicatorcode neq IndicatorCodeDisplay>
			<TD>
			<a href="javascript:recordedit('#mission#','#IndicatorCode#')">#IndicatorCodeDisplay#</a>
			</td>
			<cfelse>
			<td></td>
			</cfif>
			<TD style="word-wrap: break-word; word-break: break-all;" width="45%">#IndicatorDescription#</TD>
			<td>#Type#</td>
			<td align="center">
			<cfif targetdirection eq "Down">
			<img src="#SESSION.root#/Images/arrow-down.gif" alt="" border="0">
			<cfelseif targetdirection eq "Up">
			<img src="#SESSION.root#/Images/arrow-up.gif" alt="" border="0">
			<cfelse>
			<img src="#SESSION.root#/Images/arrow-steady.gif" alt="" border="0">
			</cfif></td>
			<td>
			<cfif auditsource eq "External">
			<img src="#SESSION.root#/Images/upload3.gif" height="13" width="13" alt="External Source" border="0">
			<cfelse>
			<img src="#SESSION.root#/Images/manual_entry.gif" height="13" width="13" alt="Manual Entry" border="0">	
			</cfif>
			</td>
			<td>
			<cfif indicatordrilldown eq "1">
			<img src="#SESSION.root#/Images/locate3.gif" height="14" width="14" alt="Drill down" border="0">
			</cfif>
			</td>
			<TD>
			<!---
		     <cf_helpfile 
				 code     = "Program" 
				 class    = "Indicator"
				 id       = "#IndicatorCode#"
				 name     = "#IndicatorDescription#"
				 display  = "Icon"
				 edit     = "0"
				 showText = "0">
				 --->
			</TD>
			<td width="10">#IndicatorWeight#</td>
			<td>	
			<TD width="120">#left(OfficerFirstName,1)#. #OfficerLastName#</TD>
			</TR>		
							
		</CFOUTPUT>	
		</CFOUTPUT>			
		
	</CFOUTPUT>
	
	<cfif getAdministrator("*") eq "1">
	<cfoutput>	
		<tr><td align="left" colspan="12" class="labelmedium" style="padding-left:20px">;
		 <img src="#SESSION.root#/Images/finger.gif"
		     alt="edit"
		     border="0"
		     align="absmiddle"
		     style="cursor: pointer;">	
		<a href="javascript:init('#mission#')"><font color="0080C0">Generate Indicator and Target entry records for programs with associated categories under tree <b>#mission#</b></a>
		</td>
		</tr>
	</cfoutput>
	</cfif>
	
	</table>
	
<cfset ajaxonload("doHighlight")>