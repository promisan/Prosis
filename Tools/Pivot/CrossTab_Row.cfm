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

<cfsilent>
	
	<cfset cw = "#(100/Formula.recordcount)#%">
	
	<cfquery name="CellOutput" 
	    dbtype="query">
		SELECT XAxArray, 
		       YaxArray,
			   #preservesinglequotes(formulaC)#
		FROM   CrossTabData
		ORDER BY YaxArray,XaxArray
	</cfquery>
	
	<cfset pvt=ArrayNew(3)>
	
	<cfloop index="F" from="1" to="#formula.recordcount#">
		<cfloop query="CellOutput">
			<cfset Pvt[#YaxArray#][#XaxArray#][#F#] = evaluate("CellValue#F#")>
		</cfloop>
	</cfloop>	
	
	<cfquery name="CellOutputTotal" 
	    dbtype="query">
		SELECT YaxArray,
			    #preservesinglequotes(formulaT)#
		FROM   CrossTabData
		GROUP BY YaxArray
		ORDER BY YaxArray
	</cfquery>
	
	<cfset tot=ArrayNew(2)>
	
	<cfloop index="F" from="1" to="#formula.recordcount#">
		<cfset c = "0">
		<cfloop query="CellOutputTotal">
			<cfset tot[#YaxArray#][#F#] = evaluate("CellValue#F#")>
		</cfloop>
	</cfloop>	

</cfsilent>

<!---  2 of 3 horizontal line Row-Cel1-Cel2-Celn-Total --->
<cfoutput query="Yax">

	<cfif format eq "HTML">
	
	<cfif mode eq "0">
		<tr id="#node#_#group#_row">
		<td class="ctHdr">#FieldHeader#&nbsp;</td>
 	<cfelseif mode eq "1">
		<tr id="#node#_#group#_row" class="hide">
	    <td align="right" class="ctHdr">#FieldHeader#:&nbsp;</td>
	<cfelseif mode eq "2">
		<tr id="#node#_#group#_row" class="hide">
	    <td align="right" class="ctHdr">#FieldHeader#:&nbsp;</td>
	</cfif>
	
	<cfelse>
		<tr><td class="ctHdr">&nbsp;&nbsp;&nbsp;&nbsp;#FieldHeader#&nbsp;</td>
	</cfif>
		
	<cfsilent>
	    <!---
		<cfset y     = "#ListingOrder#">
		--->
		<cfset y     = "#SerialNo#">
		<cfset y_nme = "#FieldName#">
		<cfset y_val = "#FieldValue#">
		<cfset y_ser = "#SerialNo#">
		<cfset drillbox = "#box#_#y#">
	</cfsilent>
		
	<cfloop query="Xax">
		
			<cfsilent>
				<!---
				<cfset x   = "#ListingOrder#">	
				--->
				<cfset x   = "#SerialNo#">
				<cfparam name="pvt[#y#][#x#][1]" default="">
				<cfset ser = "#serialNo#">	
				<cfset flv = "#fieldValue#">		
				<cfset nme = "#fieldName#">
				<cfset hdr = "#fieldHeader#">
			</cfsilent>
			<cfif #pvt[y][x][1]# eq "">
			
				<cfloop query="Formula">
				<td class="blank">&nbsp;</td>
				</cfloop>
			<cfelse>
			
				<cfif client.pvtDrill eq "0">				
				   
					<cfloop query="Formula">
					<td class="cell_#currentrow#"><cfparam name="pvt[#y#][#x#][#currentrow#]" default="">
					<cf_CrossTab_Cell tpe="#fieldDataType#" val="#pvt[y][x][currentrow]#">
					</td>
					</cfloop>
					
				<cfelse>
									
					<cfloop query="Formula">
					<td class="cell_#currentrow#"
					    style="cursor: pointer;"
					    onClick="request('#controlid#','#alias#','#node#','#group#','#drillbox#','','#grp1Nme#','#group1#','#grp1Ser#','#grp2Nme#','#group2#','#grp2Ser#','#Y_nme#','#Y_val#','#Y_ser#','#nme#','#flv#','#ser#','#hdr#','','')">
					<cfparam name="pvt[#y#][#x#][#currentrow#]" default="">
					<cf_CrossTab_Cell tpe="#fieldDataType#" val="#pvt[y][x][currentrow]#">
					</td>
					</cfloop>
					
				</cfif>
				
			</cfif>	
	</cfloop>
	
	<cfloop query="Formula">
	    <cfif currentrow eq formula.recordcount>
		 <td class="cellT_E" bgcolor="d4d4d4">
		<cfelse>
		<td class="cellT" bgcolor="d4d4d4"> 
		</cfif>
		
			<cfparam name="tot[y][currentrow]" default="0">
			<cf_CrossTab_Cell tpe="#fieldDataType#" val="#tot[y][currentrow]#">
		</td>
	</cfloop>
	
	</tr>
		
</cfoutput>	

<cfsetting enablecfoutputonly="NO">

