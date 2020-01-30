
<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">

<cfif new eq "1">
			
		<tr>
			<td class="labellarge" style="font-size:24px;font-weight:200">Inquiry Function Label:<font color="FF0000">*</font></td>
			<td>
			<cf_space spaces="60">
			<table cellspacing="0" cellpadding="0">
			<tr><td>
			<input type="text" 
			  onchange="ColdFusion.navigate('InquiryEditValidate.cfm?systemfunctionid=#url.systemfunctionid#&name='+this.value,'verifylabel')" 
			  name="FunctionHeaderLabel" id="FunctionHeaderLabel" 
			  value="#header.FunctionName#" 
			  size="40" 
			  class="regularxl"
			  maxlength="40">
			</td>
			<td width="3"></td>
			<td id="verifylabel"></td>
			</tr></table>
			
			</td>
	
		</tr>
	
			
	</cfif>

<TR>
	<TD width="25%" style="font-size:16px;font-weight:300" class="labelmedium">SQL Data source alias:
	<cf_space spaces="60">
	</TD>
	<td>
				
	<table width="100%" cellspacing="0" cellpadding="0"><tr><td>
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
		
		<select name="querydatasource" id="querydatasource" class="regularxl" style="font:10px">
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
		<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td align="right" style="font-weight:200;padding-right:10px">Extended Preparation SQL script:</td>		
		<td width="20" align="right" style="padding-left:4px">
		<input value="Preparion Query Script" class="button10s" style="height:29px;width:236;font-size:12px" type="button" onclick="editpreparation('#url.systemfunctionid#','#url.functionserialno#')"/>		
		</td>
		</tr>
		</table>
		
	</td>
	</TR>

	<tr>
	<td width="100%" valign="top" colspan="2">
	
		<table cellspacing="0" width="100%" height="200">
		
						
			<CFOUTPUT>		
			<tr>
				<td style="padding-top:3px" valign="bottom">
				
				<table class="formspacing">
				
				<tr>
				
					<td>
					<input type="button" value="Test Query" style="width:130;height:24" class="button10g" 
					 onclick="ptoken.navigate('#SESSION.root#/System/Modules/InquiryBuilder/QueryValidate.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#','testresult','','','POST','inquiryform')"/>
					</td>						
					
					<td>	
					<input type="button" name="testing" id="testing" class="button10g" style="width:120;height:24" Value="Preview"
					  onclick="preview('#URL.SystemFunctionId#')">			
				    </td>			   
				    
					<td>	
						<input type="button" name="testing" id="testing" class="button10g" style="width:120;height:24" Value="Copy Listing"
						  onclick="copy('#URL.SystemFunctionId#')">
				    </td>
			   
			   </tr>

			   <tr><td colspan="3" id="dCopyingListing"></td></tr>
			   
			   </table>
			   
			   </td>
			
			   <td align="right" valign="center">
				<table style="padding:3px;background-color:eaeae" class="formspacing">					
					<tr class="labelit">
					<td style="padding-left:4px">@mission</td><td width="2">=</td><td style="padding-right:4px">Mission|</td>
					<td style="padding-left:4px">@user</td><td width="2">=</td><td style="padding-right:4px">User|</td>
					<td style="padding-left:4px">@now</td><td width="2">=</td><td style="padding-right:4px">Timestamp|</td>
					<td style="padding-left:4px">@today</td><td width="2">=</td><td style="padding-right:4px">Today|</td>
					<td style="padding-left:4px">@today-N</td><td width="2">=</td><td style="padding-right:4px">Rel.&nbsp;date|</td>
					<td style="padding-left:4px">@answerN</td><td width="2">=</td><td style="padding-right:4px">Preset table</td>
					</tr>
				</table>
			   </td>
			</tr>
						
			<tr><td colspan="2" height="100%" width="100%" style="padding:1px">
			
			<textarea name="queryscript" 
			   class="regular0" 
			   style="min-height:160px;min-width:100%;padding:7px; border: 1px solid silver; width: 100%; height: 99%; word-break: break-all; background: ffffff; font-size: larger;">#List.QueryScript#</textarea>		
			
			</td></tr>
			
			</CFOUTPUT>
		</table>
	</td>
	</tr>
	
	<tr><td colspan="2" id="testresult" align="center"></td></td>
	
</table>

</cfoutput>