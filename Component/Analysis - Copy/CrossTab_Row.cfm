

<cfsetting enablecfoutputonly="YES">

	<cfset cw = "#(100/Formula.recordcount)#%">
	
	<cfparam name="mde" default="detail">
		
	<cfquery name="CellOutput" 
	    dbtype="query">
		SELECT   XAxArray,YaxArray,#formulaC#
		FROM     CrossTabData
		ORDER BY YaxArray,XaxArray
	</cfquery>	
	
	<!--- <cfoutput>:#cfquery.executiontime#:</cfoutput> --->
	
	<cfset pvt=ArrayNew(3)>
	<cfset pvb=ArrayNew(3)>
			
	<cfloop index="F" from="1" to="#formula.recordcount#">
		<cfloop query="CellOutput">
			<cfset Pvt[YaxArray][XaxArray][F] = evaluate("CellValue#F#")>
			<cfset Pvb[YaxArray][XaxArray][F] = evaluate("CellValue#F#Total")>
		</cfloop>
	</cfloop>	
	
	<cfquery name="CellOutputTotal" 
	    dbtype="query">
		SELECT   YaxArray, #formulaT#
		FROM     CrossTabData
		GROUP BY YaxArray
		ORDER BY YaxArray
	</cfquery>
		
	<!--- -------------------------------------------------------- --->
	<!--- Hanno 6/12/2012 : maybe this one is taking too much time --->
	<!--- -------------------------------------------------------- --->
	
	<cfset tot=ArrayNew(2)>
	<cfset bas=ArrayNew(2)>
	
	<cfloop index="F" from="1" to="#formula.recordcount#">
		<cfset c = "0">
		<cfloop query="CellOutputTotal">
			<cfset tot[YaxArray][F] = evaluate("CellValue#F#")>
			<cfset bas[YaxArray][F] = evaluate("CellValue#F#Total")>
		</cfloop>
	</cfloop>	
	
<!---  2 of 3 horizontal line Row-Cel1-Cel2-Celn-Total --->

<cfoutput query="Yax">

	<cfif format eq "HTML">
		
	<cfif mode eq "0">
		<tr id="#node#_#group#_row" name="#node#_#group#_row">
		<td class="ctHdr labelmedium" style="font-size:13px;height:20px;padding-left:4px;padding-right:4px">#FieldHeader#</td>
 	<cfelseif mode eq "1">
		<tr id="#node#_#group#_row" name="#node#_#group#_row" class="hide">
	    <td align="right" class="ctHdr labelmedium" style="font-size:13px;height:20px;padding-left:4px;padding-right:4px">#FieldHeader#:</td>
	<cfelseif mode eq "2">
		<tr id="#node#_#group#_row" name="#node#_#group#_row" class="hide">
	    <td align="right" class="ctHdr labelmedium" style="font-size:13px;height:20px;padding-left:4px;padding-right:4px">#FieldHeader#:</td>
	<!--- 3rd level --->	
	<cfelseif mode eq "3">
		<tr id="#node#_#group#_row" name="#node#_#group#_row" class="hide">
	    <td align="right" class="ctHdr labelmedium" style="font-size:13px;height:20px;padding-left:4px;padding-right:4px">#FieldHeader#:</td>			
	</cfif>
	
	<cfelse>
		<tr><td bgcolor="f4f4f4" class="ctHdr labelmedium" style="padding-left:10px">#FieldHeader#</td>
	</cfif>
		
	<cfsilent>
		<cfset y        = "#ListingOrder#">
		<cfset y_nme    = "#FieldName#">
		<cfset y_val    = "#FieldValue#">
		<cfset y_ser    = "#SerialNo#">
		<cfset drillbox = "#box#_#y#">
	</cfsilent>	
		
	<cfloop query="Xax">
		
			<cfsilent>
				<cfset x   = "#ListingOrder#">	
				<cfparam name="pvt[#y#][#x#][1]" default="">
				<cfset ser = "#serialNo#">	
				<cfset flv = "#fieldValue#">		
				<cfset nme = "#fieldName#">
				<cfset hdr = "#fieldHeader#">
				<cfset cur = "#currentrow#">
			</cfsilent>
			<cfif pvt[y][x][1] eq "">
			
				<cfloop query="Formula">
					<td class="blank"></td>
				</cfloop>
				
			<cfelse>
			
				<cfif client.pvtDrill eq "0">
				
					<cfloop query="Formula">
						<td class="cell_0" class="labelit" id="#drillbox#_#cur#_#currentrow#">				
							<cfparam name="pvt[#y#][#x#][#currentrow#]" default="">
							<cfparam name="pvb[#y#][#x#][#currentrow#]" default="">
							<cf_CrossTab_Cell 
							     tpe  = "#fieldDataType#" 
							     val  = "#pvt[y][x][currentrow]#" 
								 base = "#pvb[y][x][currentrow]#">						
							
						</td>
					</cfloop>
					
				<cfelse>
				
					<cfloop query="Formula">
					
						<cfif format eq "HTML">
					
						    <cfset cellid = cellid+1>
							<cfset colexp = "#SESSION.root#/Tools/CFReport/Analysis/CrossTab_ColExpand.cfm?cellid=#cellid#&controlid=#controlid#&node=#node#&group=#group#&box=#box#&mde=#mde#&grp1Nme=#grp1Nme#&group1=#urlencodedformat(group1)#&grp1ser=#grp1Ser#&grp2Nme=#grp2Nme#&group2=#urlencodedformat(group2)#&grp2ser=#grp2Ser#&yax=#Yax.FieldName#&yaxval=#urlencodedformat(Y_val)#&xax=#nme#&xaxval=#urlencodedformat(flv)#&formula=#presentation#&drillfield='+document.getElementById('drillfield_#node#').value+'">
		   				    <cfset drillp = "drill('#controlid#','#alias#','#node#','#fileno#','#group#','#drillbox#','','#grp1Nme#','#urlencodedformat(group1)#','#grp1Ser#','#grp2Nme#','#urlencodedformat(group2)#','#grp2Ser#','#Y_nme#','#urlencodedformat(Y_val)#','#Y_ser#','#nme#','#urlencodedformat(flv)#','#ser#','#hdr#','','')">
		   					
							<td class="cell_#currentrow#" 							
							    onmouseover="this.className='ctCellSel'" 							
								onmouseout="this.className='cell_#currentrow#'"						    
							    oncontextmenu="#drillp#">
																
								<table width="100%" cellspacing="0">							    
								<tr>								    
									<td onclick="_cf_loadingtexthtml='';drilldown('#node#_#cellid#');ColdFusion.navigate('#colexp#','#node#_#cellid#')" class="cell labelmedium" id="par_#node#_#cellid#">										
										<cfparam name="pvt[#y#][#x#][#currentrow#]" default="">
										<cfparam name="pvt[#y#][#x#][#currentrow#]" default="">
										<cf_CrossTab_Cell
									     tpe  = "#fieldDataType#" 
										 val  = "#pvt[y][x][currentrow]#" 
										 base = "#pvb[y][x][currentrow]#">										
									</td>
								</tr>								
								<tr class="hide" id="row_#node#_#cellid#"><td id="#node#_#cellid#" valign="top"></td></tr>											
								</table>								
							
							</td>
						
						<cfelse>
						
							<td>								
									<cfparam name="pvt[#y#][#x#][#currentrow#]" default="">
									<cfparam name="pvt[#y#][#x#][#currentrow#]" default="">
									<cf_CrossTab_Cell
									     tpe  = "#fieldDataType#" 
										 val  = "#pvt[y][x][currentrow]#" 
										 base = "#pvb[y][x][currentrow]#">
							</td>
						
						</cfif>
					</cfloop>
				</cfif>
				
			</cfif>	
	</cfloop>
	
	<cfloop query="Formula">
		
			<cfset cellid = cellid+1>
			<cfset colexp = "#SESSION.root#/Tools/CFReport/Analysis/CrossTab_ColExpand.cfm?cellid=#cellid#&controlid=#controlid#&node=#node#&group=#group#&box=#box#&mde=#mde#&grp1Nme=#grp1Nme#&group1=#urlencodedformat(group1)#&grp1ser=#grp1Ser#&grp2Nme=#grp2Nme#&group2=#urlencodedformat(group2)#&grp2ser=#grp2Ser#&yax=#Yax.FieldName#&yaxval=#urlencodedformat(Y_val)#&xax=#Xax.FieldName#&xaxval=&formula=#presentation#&drillfield='+document.getElementById('drillfield_#node#').value+'">
		    <cfset drillp = "drill('#controlid#','#alias#','#node#','#fileno#','#group#','#drillbox#','','#grp1Nme#','#urlencodedformat(group1)#','#grp1Ser#','#grp2Nme#','#urlencodedformat(group2)#','#grp2Ser#','#Y_nme#','#urlencodedformat(Y_val)#','#Y_ser#','','','0','','','')">
	   		
			<cfif format eq "HTML">		
			
					<cfparam name="tot[y][currentrow]" default="0">
					<cfparam name="bas[y][currentrow]" default="0">
			
					<td class="cell_#currentrow#" style="<cfif currentrow eq formula.recordcount>border-right: 1px solid silver;</cfif>" 			
					onmouseover="this.className='ctCellSel'" onmouseout="this.className='cell_#currentrow#'" oncontextmenu="#drillp#">				
					<table width="100%">							    
						<tr>							    
							<td onclick="_cf_loadingtexthtml='';drilldown('#node#_#cellid#');ColdFusion.navigate('#colexp#','#node#_#cellid#')" class="cell" id="par_#node#_#cellid#">														
							<cf_CrossTab_Cell tpe="#fieldDataType#" val="#tot[y][currentrow]#" base="#bas[y][currentrow]#">									
							</td>
						</tr>													
						<tr class="hide" id="row_#node#_#cellid#"><td valign="top" id="#node#_#cellid#"></td></tr>											
					</table>				
					</td>
					
			<cfelse>
			
				<cfparam name="tot[y][currentrow]" default="0">
				<cfparam name="bas[y][currentrow]" default="0">
				<td class="labelmedium"><cf_CrossTab_Cell tpe="#fieldDataType#" val="#tot[y][currentrow]#" base="#bas[y][currentrow]#"></td>
			
			</cfif>		
	</cfloop>	
	</tr>
		
</cfoutput>	

<cfsetting enablecfoutputonly="NO">

