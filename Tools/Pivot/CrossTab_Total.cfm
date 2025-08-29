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
<cfsetting enablecfoutputonly="YES">

<cfset cw = "#(100/Formula.recordcount)#%">

<!---
<cfsilent>
--->

<cfset fml = ReplaceNoCase(FormulaT, "AVG,STDEV,VAR", "SUM,SUM,SUM")> 

	<!--- cell values --->
	
	<!--- run query once --->
	<cfquery name="CellOutput" 
	    dbtype="query">
		SELECT   XAxArray,
			     #preservesinglequotes(FormulaT)#  
		FROM     CrossTabData 
		GROUP BY XAxArray
		ORDER BY XAxArray
	</cfquery>
		
	<cfset pvt=ArrayNew(2)>
		
	<cfloop index="F" from="1" to="#formula.recordcount#">
	
		<cfset c = "0">
		
		<cfloop query="CellOutput">
		
		    <cfif evaluate("Cell#F#") eq "AVG" or 
			      evaluate("Cell#F#") eq "STDEV" or 
				  evaluate("Cell#F#") eq "VAR">
			
				<cfset Pvt[XaxArray][F] = evaluate("CellWeightValue#F#")/evaluate("CellWeight#F#")>
				
			<cfelse>
			
				<cfset Pvt[XaxArray][F] = evaluate("CellValue#F#")>
			
			</cfif>	
		</cfloop>
		
	</cfloop>	
			
	<!--- total values --->
	
	<!--- run query once --->
	<cfquery name="CellOutput" 
	    dbtype="query">
		SELECT    #preservesinglequotes(FormulaT)# 
		FROM     CrossTabData
	</cfquery>
		
	<cfset tott=ArrayNew(1)>
	<cfset t = 0>
	
	<cfloop index="F" from="1" to="#formula.recordcount#">
			
		<cfloop query="CellOutput">
		
		    <cfif evaluate("Cell#F#") eq "AVG" or 
			      evaluate("Cell#F#") eq "STDEV" or 
				  evaluate("Cell#F#") eq "VAR">
			
				<cfset tott[F] = evaluate("CellWeightValue#F#")/evaluate("CellWeight#F#")>
				
			<cfelse>
			
				<cfset tott[F] = evaluate("CellValue#F#")>
			
			</cfif>	
						
			<cfset t = t+tott[F]>
			
		</cfloop>
		
	</cfloop>	
		
	<cfset lvl = "">
	
<!---	
</cfsilent>
--->

<cfif t neq "0">

<cfoutput>
<!---  3 of 3 bottom line Total-Cel1-Cel2-Celn-Overall --->

	<cfset box = "#node#_#group#_total">		
		
		<cfif mode eq "0">
	
			<tr height="20">
		    <td bgcolor="e8e8e8" class="labelit" style="border-left: 1px solid d7d7d7;border-right: 1px solid d7d7d7">Total</b></td>
			
		<cfelseif mode eq "1">
		
		  	<cfif grp1Hdr eq "">
			    <cfset lvl = "T">
				<cfif format eq "HTML">
				<tr id="#node#_#group1#_row">
				<td height="20" align="left" class="ctHdr">Total overall:</b>&nbsp;&nbsp;</b></td>
				<cfelse>
				<tr bgcolor="yellow">
				<td height="20" align="left" class="ctHdr">Total overall:</b>&nbsp;&nbsp;</b></td>
				</cfif>
				
			<cfelse>		
				<tr>
				<td class="ctcol">
					<table cellspacing="0" cellpadding="0">
					<tr>
					<cfif format eq "HTML">
						<td>
						<img style="cursor: pointer;" onclick="javascript:show('#node#_#group#')" class="regular" name="Collapsed" id="#node#_#group#_col" src="#SESSION.root#/Images/ct_collapsed.gif" alt="Expand" width="34" height="17" border="0">
						<img style="cursor: pointer;" onclick="javascript:show('#node#_#group#')" class="hide"    name="Expanded" id="#node#_#group#_exp" src="#SESSION.root#/Images/ct_expanded.gif"  alt="Collapse" width="34" height="17" border="0">
						</td><td>&nbsp;</td>
						<td width="#grp1wid*4#"><a href="javascript:show('#node#_#group#')">#replace(grp1Hdr," ","&nbsp;")#</a></td>
					<cfelse>
						<td colspan="3" width="#grp1wid*4#"><b>#replace(grp1Hdr," ","&nbsp;")#</b></td>
					</cfif>	
					</tr>
					</table>
				</td>	
			</cfif>
		
		<cfelseif mode eq "2">
			
		    <cfif grp1Hdr eq "">
			
			    <cfset lvl = "T">
				<cfif format eq "HTML">
					<tr class="header" id="#node#_#groupA#_row">
					<td height="16" class="ctcol">Total overall:&nbsp;&nbsp;</b></td>
				<cfelse>
					<tr class="header" bgcolor="d4d4d4">
					<td height="16">Total overall:&nbsp;&nbsp;</b></td>
				</cfif>
				
			<cfelseif grp2Hdr neq "">
			
				<cfset hdr = "#grp2Hdr#">
				<cfset lvl = "2">
					
						<cfif format eq "HTML">
						<tr class="hide" id="#node#_#groupA#_row">
						<td class="ctcol" id="#node#_#group#">
						<table cellspacing="0" cellpadding="0">
						    <tr>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>
							<img style="cursor: pointer;" onclick="javascript:show('#node#_#group#')" class="regular" name="Collapsed" id="#node#_#group#_col" src="#SESSION.root#/Images/ct_collapsed.gif" alt="Expand" width="34" height="17" border="0">
							<img style="cursor: pointer;" onclick="javascript:show('#node#_#group#')" class="hide"    name="Expanded"  id="#node#_#group#_exp" src="#SESSION.root#/Images/ct_expanded.gif"  alt="Collapse" width="34" height="17" border="0">
							</td><td>&nbsp;</td>
							<td><a href="javascript:show('#node#_#group#')">#replace(hdr," ","&nbsp;")#</a></td>
						<cfelse>
						<tr bgcolor="d4d4d4">
						<td class="ctcol">
						<table cellspacing="0" cellpadding="0">
						    <tr >
							<td colspan="3" width="#grp1wid*4#"><b>&nbsp;#replace(hdr," ","&nbsp;")#</b></td>							
						</cfif>
						</tr>
					</table>
					</td>	
							
			<cfelse>
			
				<cfset hdr = "#grp1Hdr#">
				
						<cfif format eq "HTML">
						<tr class="header">
				   			<td class="ctcol">
							<table cellspacing="0" cellpadding="0">
							<tr>
							<td>
							<img style="cursor: pointer;" onclick="javascript:show('#node#_#group#')" class="regular"  name="Collapsed" id="#node#_#group#_col" src="#SESSION.root#/Images/ct_collapsed.gif" alt="Expand" width="34" height="17" border="0">
							<img style="cursor: pointer;" onclick="javascript:show('#node#_#group#')" class="hide"     name="Expanded" id="#node#_#group#_exp" src="#SESSION.root#/Images/ct_expanded.gif"  alt="Collapse" width="34" height="17" border="0">
							</td>
							<td>&nbsp;</td>
							<td><a href="javascript:show('#node#_#group#')">#replace(hdr," ","&nbsp;")#</a></td>
						<cfelse>
						<tr bgcolor="yellow">
			    		<td class="ctcol">
							<table cellspacing="0" cellpadding="0">
							<tr>
							<td colspan="3"><b>#replace(hdr," ","&nbsp;")#</b></td>
						</cfif>
						</tr>
					</table>
				</td>	
			</cfif>
							
	</cfif>		
			
	<cfloop query="Xax">
	
	    <cfsilent>
			<cfif #HideGraph# eq "0">	
			  <cfset mde = "graph">
			<cfelse>
			  <cfset mde = "detail">
			</cfif>
			<!--- OLDDDDDD
			<cfset x = "#ListingOrder#">
			--->
			<cfset x   = "#serialNo#">	
			<cfset ser = "#serialNo#">	
			<cfset flv = "#fieldValue#">		
			<cfset nme = "#fieldName#">
			<cfparam name="pvt[#x#][1]" default="">
		</cfsilent>
		
		<cfif #pvt[x][1]# eq "">
		<cfloop query="Formula">
			    <td class="cellT#lvl#_B"></td>
			</cfloop>
		<cfelse>
			<cfloop query="Formula">
				<cfif currentrow eq formula.recordcount>
				<td class="cellT#lvl#" 
					onClick="request('#controlid#','#alias#','#node#','#group#','#box#','#mde#','#grp1Nme#','#group1#','#grp1Ser#','#grp2Nme#','#group2#','#grp2Ser#','#Yax.FieldName#','','','#nme#','#flv#','#ser#','#fieldHeader#','','')">
				<cfelse>
				<td class="cellT#lvl#" width="40"
					onClick="request('#controlid#','#alias#','#node#','#group#','#box#','#mde#','#grp1Nme#','#group1#','#grp1Ser#','#grp2Nme#','#group2#','#grp2Ser#','#Yax.FieldName#','','','#nme#','#flv#','#ser#','#fieldHeader#','','')">
				</cfif>	
				
				<cfparam name="pvt[#x#][#currentrow#]" default="">
				<cf_CrossTab_Cell tpe="#fieldDataType#" val="#pvt[x][currentrow]#">
				</td>
			</cfloop>
		</cfif>
		
	</cfloop>
	
	<cfloop query="Formula">	
	    
		<cfif currentrow eq formula.recordcount>
		<td class="cellT#lvl#_E"
		    onClick="request('#controlid#','#alias#','#node#','#group#','#box#','#mde#','#grp1Nme#','#group1#','#grp1Ser#','#grp2Nme#','#group2#','#grp2Ser#','#Yax.FieldName#','','0','','','0','','','')">
		<cfelse>
		<td class="cellT#lvl#" width="40"
		    onClick="request('#controlid#','#alias#','#node#','#group#','#box#','#mde#','#grp1Nme#','#group1#','#grp1Ser#','#grp2Nme#','#group2#','#grp2Ser#','#Yax.FieldName#','','0','','','0','','','')">
		</cfif>
		<b>
		<cf_CrossTab_Cell tpe="#fieldDataType#" val="#tott[currentrow]#">
		</td>
	</cfloop>
	
	</tr>
	
	<cfset drillbox = "#box#">		
		
</cfoutput>

</cfif>

<cfsetting enablecfoutputonly="No">	