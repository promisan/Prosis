
<cfoutput>

<table width="100%" style="border:0px solid silver">

   <cfif new eq "1">
			
		<tr>
			
			<td colspan="2">
			<cf_space spaces="60">
			<table>
			<tr>
			<td class="labellarge" style="padding-left:10px;font-size:18px;font-weight:300">Inquiry Function Name:<font color="FF0000">*</font></td>
			<td>
				<input type="text" 
				  onchange="ptoken.navigate('InquiryEditValidate.cfm?systemfunctionid=#url.systemfunctionid#&name='+this.value,'verifylabel')" 
				  name="FunctionHeaderLabel" id="FunctionHeaderLabel" 
				  value="#header.FunctionName#" 
				  size="40" style="background-color:ffffaf" 
				  class="regularxxl"
				  maxlength="50">
			</td>
			<td width="3"></td>
			<td id="verifylabel"></td>
			</tr></table>
			
			</td>
	
		</tr>
	
			
	</cfif>

    <tr>
	<td width="100%" valign="top" colspan="2">
	
		<table cellspacing="0" width="100%">
						
			<tr class="fixrow" style="background-color:fafafa" class="line">
			
				<td style="padding-top:3px" valign="bottom">
				
				<table class="formspacing">
				
				<tr>
				
				<TD style="padding-left:8px" class="labelmedium"><cf_tl id="Data source">:</TD>
				<td>				
	
					<cfset ds = "#List.QueryDataSource#">
					<cfif ds eq "">
					    <cfset ds = "AppsSystem">
					</cfif>
					<!--- Get "factory" --->
					<CFOBJECT ACTION="CREATE"
					TYPE="JAVA"
					CLASS="coldfusion.server.ServiceFactory"
					NAME="factory">
					<!--- Get datasource service --->
					<CFSET dsService=factory.getDataSourceService()>
					<!--- Get datasources --->
					
					
					<!--- Extract names into an array 
					<CFSET dsNames=StructKeyArray(dsFull)>
					--->
					<cfset dsNames = dsService.getNames()>
					<cfset ArraySort(dsnames, "textnocase")> 
					
					<select name="querydatasource" id="querydatasource" class="regularxxl">
						<option value="" selected>--- select ---</option>
						<CFLOOP INDEX="i"
						FROM="1"
						TO="#ArrayLen(dsNames)#">
						
						<CFOUTPUT>
						<option value="#dsNames[i]#" <cfif #ds# eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
						</cfoutput>
						</cfloop>
					</select>
					
					</td>
					
					<td>
					<input type="button" value="Test Query" style="width:170;border:1px solid gray" class="button10g" 
					 onclick="ptoken.navigate('#SESSION.root#/System/Modules/InquiryBuilder/QueryValidate.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#','testresult','','','POST','inquiryform')"/>
					</td>						
					
					<td>	
					<input type="button" name="testing" id="testing" class="button10g" style="width:170;border:1px solid gray" Value="Preview"
					  onclick="preview('#URL.SystemFunctionId#')">			
				    </td>			   
				    
					<td>	
						<input type="button" name="testing" id="testing" class="button10g" style="width:170;border:1px solid gray" Value="Copy Listing"
						  onclick="copy('#URL.SystemFunctionId#')">
				    </td>
					
					 <td align="right" style="padding-left:40px;padding-right:10px">Preparation SQL script:</td>		
					<td width="20" align="right" style="padding-left:4px">
					<input value="Query" class="button10g" style="width:100;font-size:12px;border:1px solid gray" type="button" onclick="editpreparation('#url.systemfunctionid#','#url.functionserialno#')"/>		
						</td>
					
			   
			   </tr>

			   <tr><td colspan="3" id="dCopyingListing"></td></tr>
			   
			   </table>
			   
			   </td>			  			   
			  
		    </tr>
						
			<tr><td colspan="2" height="100%" width="100%" style="padding:1px">
			
				<textarea name="queryscript" 
				   class="regular0" 
				   style="resize:vertical;min-height:100px;min-width:100%;padding:7px; border: 0px solid silver; width: 100%; height: 99%; word-break: break-all; background: ffffff; font-size: larger;">#List.QueryScript#</textarea>		
				
			</td></tr>
			 
			<tr style="border-top:1px solid silver">			 
			 <td colspan="2" style="min-width:700px">
				<table width="100%" style="padding:1px;background-color:fafafa">					
					<tr class="labelmedium">
					<td style="min-width:200px" id="testresult"></td>
					<td align="right">
					<table><tr>
						<td style="padding-left:4px">@mission</td><td width="2">=</td><td style="padding-right:4px">Mission</td>
						<td style="padding-left:4px">@user</td><td width="2">=</td><td style="padding-right:4px">User</td>
						<td style="padding-left:4px">@now</td><td width="2">=</td><td style="padding-right:4px">Timestamp</td>
						<td style="padding-left:4px">@today</td><td width="2">=</td><td style="padding-right:4px">Today</td>
						<td style="padding-left:4px">@today-N</td><td width="2">=</td><td style="padding-right:4px">Rel.&nbsp;date</td>
						<td style="padding-left:4px">@answerN</td><td width="2">=</td><td style="padding-right:4px">Table</td>
						</tr>
					</table></td>
					</tr>
				</table>
			   </td>
			</tr> 
						
		</table>
	</td>
	</tr>
		
</table>

</cfoutput>