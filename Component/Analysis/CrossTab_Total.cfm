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

<cfsetting enablecfoutputonly="YES">

<cfset cw = "#(100/Formula.recordcount)#%">

<cfparam name="cellid" default="0">

<cfsilent>

<cfset fml = ReplaceNoCase(FormulaT, "AVG,STDEV,VAR", "SUM,SUM,SUM")> 

	<!--- cell values --->
			
	<cfquery name="CellOutput" 
	    dbtype="query">
		SELECT   XAxArray,
			     #preservesinglequotes(FormulaT)#  
		FROM     CrossTabData 
		GROUP BY XAxArray
		ORDER BY XAxArray
	</cfquery>
			
	<cfset pvt=ArrayNew(2)>
	<cfset pvb=ArrayNew(2)>
		
	<cfloop index="F" from="1" to="#formula.recordcount#">
	
		<cfset c = "0">
		
		<cfloop query="CellOutput">
		
		    <cfif evaluate("Cell#F#") eq "AVG" or 
			      evaluate("Cell#F#") eq "STDEV" or 
				  evaluate("Cell#F#") eq "VAR">
				
				<cfset vWeight = 0>
				<cfif isDefined("CellWeightValue#F#")>
					<cfif evaluate("CellWeightValue#F#") neq "">
						<cfset vWeight = evaluate("CellWeightValue#F#")>
					</cfif>
				</cfif>
				
				<cfset Pvt[XaxArray][F] = vWeight/evaluate("CellWeight#F#")>
				<cfset Pvb[XaxArray][F] = evaluate("CellValue#F#Total")>
				
			<cfelse>
			
				<cfset Pvt[XaxArray][F] = evaluate("CellValue#F#")>
				<cfset Pvb[XaxArray][F] = evaluate("CellValue#F#Total")>
			
			</cfif>	
			
		</cfloop>
		
	</cfloop>				
		
	<!--- run query once --->
	
	<cfif CellOutput.recordcount gte "1">
	
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
					  
					<cfset vWeight = 0>
					<cfif isDefined("CellWeightValue#F#")>
						<cfif evaluate("CellWeightValue#F#") neq "">
							<cfset vWeight = evaluate("CellWeightValue#F#")>
						</cfif>
					</cfif>
				
					<cfset tott[F] = vWeight/evaluate("CellWeight#F#")>
					<cfset totb[F] = evaluate("CellValue#F#Total")>
					
				<cfelse>
				
					<cfset tott[F] = evaluate("CellValue#F#")>
					<cfset totb[F] = evaluate("CellValue#F#Total")>
				
				</cfif>	
				
				<cfif tott[F] neq "">			
					
				<cfset t = t+tott[F]>
				
				</cfif>
				
			</cfloop>
			
		</cfloop>	
		
	</cfif>	
		
	<cfset lvl = "">

</cfsilent>

<cfif t neq "0">

<cfoutput>
<!---  3 of 3 bottom line Total-Cel1-Cel2-Celn-Overall --->

	<cfset box = "#node#_#group#_total">		
		
		<cfif mode eq "0">
	
			<tr height="20">
		    <td bgcolor="e8e8e8" class="ctHdr" style="padding-left:4px;border-left: 1px solid d7d7d7;border-right: 1px solid d7d7d7">Total</b></td>
			
		<cfelseif mode eq "1">
		
		  	<cfif grp1Hdr eq "">
			    <cfset lvl = "T">
				<cfif format eq "HTML">
					<tr id="#node#_#group1#_row" name="#node#_#group1#_row">
					<td style="padding-left:4px" height="20" align="left" class="ctHdr">Total overall:</b>&nbsp;&nbsp;</b></td>
				<cfelse>
					<tr bgcolor="yellow">
					<td style="padding-left:4px" height="20" align="left" class="ctHdr">Total overall:</b>&nbsp;&nbsp;</b></td>
				</cfif>
				
			<cfelse>		
				<tr>
				<td class="ctCol"
				onmouseover = "this.className='ctColSel'"
				onmouseout  = "this.className='ctCol'"
				onclick="javascript:show('#node#_#group#');">
					<table class="formpadding">
					<tr class="labelmedium">
					<cfif format eq "HTML">
						<td style="padding-left:3px">
						<img class="regular" name="Collapsed" id="#node#_#group#_col" src="#SESSION.root#/Images/icon_expand.gif"   alt="Expand"   border="0">
						<img class="hide"    name="Expanded"  id="#node#_#group#_exp" src="#SESSION.root#/Images/icon_collapse.gif" alt="Collapse" border="0">
						</td><td>&nbsp;</td>
						<td style="font-size:15px" width="#grp1wid*4#">#replace(grp1Hdr," ","&nbsp;")#</td>
					<cfelse>
						<td style="font-size:15px" colspan="3" width="#grp1wid*4#"><b>#replace(grp1Hdr," ","&nbsp;")#</td>
					</cfif>	
					</tr>
					</table>
				</td>	
			</cfif>
		
		<cfelseif mode eq "2">
			
		    <cfif grp1Hdr eq "">
			    <cfset lvl = "T">
				<cfif format eq "HTML">
					<tr class="header">
					<td height="16" style="padding-left:4px;padding-right:5px" class="labelit ctcol">Total overall:</td>
				<cfelse>
					<tr class="header" bgcolor="silver">
					<td height="16" style="padding-left:4px;padding-right:5px" class="labelit">Total overall:</td>
				</cfif>
				
			<cfelseif grp2Hdr neq "">
			
				<cfset hdr = "#grp2Hdr#">
				<cfset lvl = "2">
					
					<cfif format eq "HTML">
					
					<tr class="hide" id="#node#_#groupbox1#_row" name="#node#_#groupbox1#_row">
					
						<!--- child link --->
						<td class="ctcol" id="#node#_#groupbox2#" onmouseover = "this.className='ctColSel'"	onmouseout  = "this.className='ctCol'" onclick = "show('#node#_#groupbox2#')">
						<table cellspacing="0" cellpadding="0" class="formpadding">
						    <tr class="labelmedium">
							<td style="padding-left:30px">
							<img class="regular" name="Collapsed" id="#node#_#groupbox2#_col" src="#SESSION.root#/Images/icon_expand.gif"    alt="Expand" border="0">
							<img class="hide"    name="Expanded"  id="#node#_#groupbox2#_exp" src="#SESSION.root#/Images/icon_collapse.gif"  alt="Collapse" border="0">
							</td><td style="padding-left:5px">#replace(hdr," ","&nbsp;")#</td>
							</tr>
						</table>
						</td>						
							
					<cfelse>
					
						<!--- excel show --->
					
						<tr bgcolor="silver">
						<td class="ctcol">
						<table cellspacing="0" cellpadding="0">
							<tr class="labelmedium">
							<td colspan="3" style="padding-left:4px" width="#grp1wid*4#"><b>&nbsp;#replace(hdr," ","&nbsp;")#</b></td>
							</tr>
						</table>
						</td>		
											
					</cfif>
												
			<cfelse>
			
				<cfset hdr = grp1Hdr>
				
					<cfif format eq "HTML">
						<tr class="header">
				   			<td class="ctcol" onclick="javascript:show('#node#_#groupbox1#')" onmouseover = "this.className='ctColSel'" onmouseout  = "this.className='ctCol'">
							<table cellspacing="0" cellpadding="0" class="formpadding">
							<tr class="labelmedium">
							<td style="padding-left:4px">
							<img class="regular"  name="Collapsed" id="#node#_#groupbox1#_col" src="#SESSION.root#/Images/icon_expand.gif" alt="Expand" border="0">
							<img class="hide"     name="Expanded" id="#node#_#groupbox1#_exp" src="#SESSION.root#/Images/icon_collapse.gif"  alt="Collapse" border="0">
							</td>							
							<td style="padding-left:5px">#replace(hdr," ","&nbsp;")#</td>
					
					<cfelse>
						
						<!--- excel show --->						
						<tr bgcolor="yellow">
			    		<td class="ctcol">
							<table cellspacing="0" cellpadding="0">
							<tr class="labelmedium">
							<td colspan="3">#replace(hdr," ","&nbsp;")#</td>
					</cfif>
					
						</tr>
					</table>
				</td>	
			</cfif>
			
		<cfelseif mode eq "3">
			
		    <cfif grp1Hdr eq "">
			
			    <cfset lvl = "T">
				<cfif format eq "HTML">
					<tr class="header" id="#node#_#groupbox1#_row" name="#node#_#groupbox1#_row">
					<td height="16" class="ctcol labelit">Total overall:&nbsp;&nbsp;</b></td>
				<cfelse>
					<tr class="header" bgcolor="silver">
					<td height="16" class="labelit">Total overall:&nbsp;&nbsp;</b></td>
				</cfif>
				
			<cfelseif grp2Hdr neq "" and grp3Hdr eq "">
						
				<cfset hdr = grp2Hdr>
				<cfset lvl = "2">
					
					<cfif format eq "HTML">
					
					<tr class="hide" id="#node#_#groupbox1#_row" name="#node#_#groupbox1#_row">
					
						<td  class  = "ctcol" 
						onmouseover = "this.className='ctColSel'"
						onmouseout  = "this.className='ctCol'"
						id          = "#node#_#groupbox2#" 
						style       = "cursor: pointer;" 
						onclick     = "show('#node#_#groupbox2#')">
						
						<table class="formpadding">
						    <tr class="labelmedium">							
							<td style="padding-left:50px">
							<img class="regular" name="Collapsed" id="#node#_#groupbox2#_col" src="#SESSION.root#/Images/icon_expand.gif" alt="Expand" border="0">
							<img class="hide"    name="Expanded"  id="#node#_#groupbox2#_exp" src="#SESSION.root#/Images/icon_collapse.gif"  alt="Collapse" border="0">
							</td>
							<td style="padding-left:6px" class="cell">#replace(hdr," ","&nbsp;")#</td>
							</tr>
						</table>
						</td>	
							
					<cfelse>
					
						<!--- excel show --->
					
						<tr bgcolor="silver">
						<td class="ctcol">
						<table cellspacing="0" cellpadding="0">
							<tr><td colspan="3" class="cell" width="#grp1wid*4#">&nbsp;#replace(hdr," ","&nbsp;")#</b></td></tr>
						</table>
						</td>		
											
					</cfif>
					
			<cfelseif grp3Hdr neq "">
			
				<cfset hdr = "#grp3Hdr#">
				<cfset lvl = "3">
					
					<cfif format eq "HTML">
					
					<tr class="hide" id="#node#_#groupbox2#_row" name="#node#_#groupbox2#_row">
					
						<td class="ctcol" id="#node#_#groupbox3#"
						onmouseover = "this.className='ctColSel'"
					    onmouseout  = "this.className='ctCol'"
					    onclick     = "show('#node#_#groupbox3#')">
						
						<table cellspacing="0" cellpadding="0" class="formpadding">
						    <tr class="labelmedium">
							<td style="padding-left:70px">
							<img class="regular" name="Collapsed" id="#node#_#groupbox3#_col" src="#SESSION.root#/Images/icon_expand.gif" alt="Expand" border="0">
							<img class="hide"    name="Expanded"  id="#node#_#groupbox3#_exp" src="#SESSION.root#/Images/icon_collapse.gif"  alt="Collapse" border="0">
							</td><td style="padding-left:10px">#replace(hdr," ","&nbsp;")#</td></tr>
						</table>
						</td>	
							
					<cfelse>
					
						<!--- excel show --->
					
						<tr bgcolor="silver">
						<td class="ctcol">
						<table cellspacing="0" cellpadding="0">
							<tr><td class="labelmedium" colspan="3" width="#grp1wid*4#"><b>&nbsp;#replace(hdr," ","&nbsp;")#</b></td></tr>
						</table>
						</td>		
											
					</cfif>		
					
							
			<cfelse>
			
				<cfset hdr = grp1Hdr>
				
					<cfif format eq "HTML">
						<tr class="header">
				   			<td class="ctcol" onclick="javascript:show('#node#_#groupbox1#')"
							onmouseover = "this.className='ctColSel'"
						    onmouseout  = "this.className='ctCol'">
							<table class="formpadding">
							<tr class="labelmedium"><td>							
							<img class="regular"  name="Collapsed" id="#node#_#groupbox1#_col" src="#SESSION.root#/Images/icon_expand.gif" alt="Expand" border="0">
							<img class="hide"     name="Expanded" id="#node#_#groupbox1#_exp" src="#SESSION.root#/Images/icon_collapse.gif"  alt="Collapse" border="0">
							</td><td style="padding-left:10px">#replace(hdr," ","&nbsp;")#</td></tr></table>
					
					<cfelse>
						
						<!--- excel show --->						
						<tr bgcolor="yellow">
			    		<td class="ctcol">
							<table cellspacing="0" cellpadding="0"><tr><td class="labelmedium" colspan="3"><b>#replace(hdr," ","&nbsp;")#</b></td></tr></table>
							
					</cfif>
					
				</td>	
			</cfif>	
			
		<cfelseif mode eq "4">	
		
		<!--- future provision --->
									
	</cfif>		
	
	<!--- continuation ---> 
			
	<cfloop query="Xax">
	
	    <cfsilent>
			<cfif HideGraph eq "0">	
			  <cfset mde = "graph">
			<cfelse>
			  <cfset mde = "detail">
			</cfif>
			<!--- OLDDDDDD --->
			<cfset x = "#ListingOrder#">
			<!---
			<cfset x   = "#serialNo#">	
			--->
			<cfset ser = "#serialNo#">	
			<cfset flv = "#fieldValue#">		
			<cfset nme = "#fieldName#">
			<cfset cur = "#currentrow#">
			<cfparam name="pvt[#x#][1]" default="">
		</cfsilent>
		
		<cfif pvt[x][1] eq "">

			<cfloop query="Formula">
			    <td class="cellT#lvl#_B"></td> 
			</cfloop>
			
		<cfelse>

			<cfloop query="Formula">
			
				<cfif format eq "HTML">
			
				    <cfset cellid = cellid+1>
					<cfset colexp = "#SESSION.root#/Tools/CFReport/Analysis/CrossTab_ColExpand.cfm?cellid=#cellid#&controlid=#controlid#&node=#node#&group=#group#&box=#box#&mde=#mde#&grp1Nme=#grp1Nme#&group1=#urlencodedformat(group1)#&grp1ser=#grp1Ser#&grp2Nme=#grp2Nme#&group2=#urlencodedformat(group2)#&grp2ser=#grp2Ser#&yax=#Yax.FieldName#&yaxval=&xax=#nme#&xaxval=#urlencodedformat(flv)#&formula=#presentation#&drillfield='+document.getElementById('drillfield_#node#').value+'">
	   				<cfset drillp = "drill('#controlid#','#alias#','#node#','#fileno#','#group#','#box#','#mde#','#grp1Nme#','#urlencodedformat(group1)#','#grp1Ser#','#grp2Nme#','#urlencodedformat(group2)#','#grp2Ser#','#Yax.FieldName#','','','#nme#','#urlencodedformat(flv)#','#ser#','#fieldHeader#','','')">

					<td class="cellT#lvl#" 
					    onmouseover   = "this.className='ctCellSel'" 
						onmouseout    = "this.className='cellT#lvl#'" 		
						oncontextmenu = "#drillp#">				

							<table width="100%">
								<tr>						    
								<td style="padding-left:9px" 
								    onclick="_cf_loadingtexthtml='';drilldown('#node#_#cellid#');ColdFusion.navigate('#colexp#','#node#_#cellid#')"
								    class="cell" id="par_#node#_#cellid#">																									
										<cfparam name="pvt[#x#][#currentrow#]" default="">
										<cfparam name="pvb[#x#][#currentrow#]" default="">
										<cf_CrossTab_Cell tpe="#fieldDataType#"
										      val  = "#pvt[x][currentrow]#" 
											  base = "#pvb[x][currentrow]#">
								</td>
								</tr>
						
								<!--- drillbox --->
								<tr class="hide" id="row_#node#_#cellid#"><td valign="top" id="#node#_#cellid#"></td></tr>	
							</table>		
		
				   </td>	
				   
				 <cfelse>
				 
				 	<td class="cell">
						 	<cfparam name="pvt[#x#][#currentrow#]" default="">
							<cfparam name="pvb[#x#][#currentrow#]" default="">
							<cf_CrossTab_Cell tpe="#fieldDataType#"
								      val  = "#pvt[x][currentrow]#" 
									  base = "#pvb[x][currentrow]#">										  
					</td>					  
				 
				 </cfif>
				   
			</cfloop>
		</cfif>
		
	</cfloop>
	
	<cfloop query="Formula">	
	
		<cfset cellid = cellid+1>	
	
		<cfset colexp = "#SESSION.root#/Tools/CFReport/Analysis/CrossTab_ColExpand.cfm?cellid=#cellid#&controlid=#controlid#&node=#node#&group=#group#&box=#box#&mde=#mde#&grp1Nme=#grp1Nme#&group1=#urlencodedformat(group1)#&grp1ser=#grp1Ser#&grp2Nme=#grp2Nme#&group2=#urlencodedformat(group2)#&grp2ser=#grp2Ser#&yax=#Yax.FieldName#&yaxval=&xax=#nme#&xaxval=&formula=#presentation#&drillfield='+document.getElementById('drillfield_#node#').value+'">
	    <cfset drillp = "drill('#controlid#','#alias#','#node#','#fileno#','#group#','#box#','#mde#','#grp1Nme#','#urlencodedformat(group1)#','#grp1Ser#','#grp2Nme#','#urlencodedformat(group2)#','#grp2Ser#','#Yax.FieldName#','','0','','','0','','','')">
		
		<cfif format eq "HTML">
	    				
			<td class         = "cellT#lvl#" 
			    style         = "<cfif currentrow eq formula.recordcount>border-right: 1px solid Silver;</cfif>" 		    
				onmouseover   = "this.className='ctCellSel'" 
				onmouseout    = "this.className='cellT#lvl#'"
			    oncontextmenu = "#drillp#">
			
				<table width="100%">							    
					<tr>
					<td onclick="_cf_loadingtexthtml='';drilldown('#node#_#cellid#');ColdFusion.navigate('#colexp#','#node#_#cellid#')" 
					class="cell" style="padding-left:9px">
					
					<cf_CrossTab_Cell tpe="#fieldDataType#" val="#tott[currentrow]#" base="#totb[currentrow]#"></td></tr>					
					<!--- drillbox --->
					<tr class="hide" id="row_#node#_#cellid#"><td valign="top" id="#node#_#cellid#"></td></tr>							
				</table>
			
			</td>
		
		<cfelse>
		
			<td class="cell"><cf_CrossTab_Cell tpe="#fieldDataType#" val="#tott[currentrow]#" base="#totb[currentrow]#"></td>
				
		</cfif>
		
		
	</cfloop>
		
	<!--- end of row --->
	</tr>
	
	<cfset drillbox = "#box#">		
		
</cfoutput>

</cfif>

<cfsetting enablecfoutputonly="No">	