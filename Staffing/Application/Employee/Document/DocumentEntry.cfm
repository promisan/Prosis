
<cfquery name="DocumentType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_DocumentType
</cfquery>

<cf_assignId>  

<cfform action="#session.root#/Staffing/Application/Employee/Document/DocumentEntrySubmit.cfm?documentid=#rowguid#" method="POST" name="documententry">

<table width="98%" align="center">	
  
	<tr><td>
  
		<cfoutput><input type="hidden" name="PersonNo" value="#URL.ID#" class="regular"></cfoutput>

				<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
				   <tr>
				    <td width="100%" align="left" valign="middle" style="border:0px solid silver;font-size:25px" class="labellarge">
					<table><tr><td>
					<cfoutput>
					<img src="#session.root#/images/document.png" alt="" width="68" height="68" border="0">
					</td>
					<td class="labellarge" style="padding-top:15px;font-size:25px;padding-left:10px"><cf_tl id="Register issued document">
					</cfoutput>
					</td></tr></table>
				    </td>
				  </tr> 	
				  
				  <tr><td colspan="1" class="line" height="1"></td></tr>
				      
				  <tr>
				    <td width="98%" align="center" style="padding-left:10px">
				    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
			
					<cfquery name="Dependent" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   PersonDependent
							WHERE  PersonNo = '#url.ID#'
							AND    ActionStatus != '9'					
					</cfquery>
					
					<tr><td height="5"></td></tr>				
					<TR>
				    <TD class="labelmedium"><cf_tl id="Individual">:</TD>
					<TD width="80%" class="labelmedium">
					<select name="DependentId" class="regularxl enterastab">
						<option value="">[Same]</option>
						<cfoutput query="Dependent">
							<option value="#dependentid#">#FirstName# #LastName# [#Gender#] #dateformat(BirthDate,CLIENT.DateFormatShow)#</option>
						</cfoutput>
					</select>	
					</td>
					</tr>		
						
					<TR>
				    <TD class="labelmedium"><cf_space spaces="40"><cf_tl id="Document type">: <font color="FF0000">*</font></TD>
				    <TD width="80%" class="labelmedium">
					  	<select name="documenttype" size="1" class="regularxl enterastab">
						<cfoutput query="DocumentType">
						<option value="#DocumentType#">
				    		#Description#
						</option>
						</cfoutput>
					    </select>
					</TD>
					</TR>
					
					<TR>
				    <TD class="labelmedium"><cf_tl id="Document No">:<font color="#FF0000">*</font></TD>
				    <TD>
					  	<cfinput type="Text" 
						     name="DocumentReference" 
							 message="Please enter a document No" 
							 required="Yes" 
							 visible="Yes" 
							 enabled="Yes" 
							 size="30" 
							 maxlength="30" 
							 class="regularxl enterastab">
					</TD>
					</TR>
					
				    <TR>
				    <TD class="labelmedium"><cf_tl id="Date Effective">:</TD>
				    <TD>	
						<cf_intelliCalendarDate9
						FieldName="DateEffective" 
						class="regularxl enterastab"
						DateFormat="#APPLICATION.DateFormat#"
						Default="#Dateformat(now(), CLIENT.DateFormatShow)#">	
							
					</TD>
					</TR>
					
					<TR>
				    <TD class="labelmedium"><cf_tl id="Date Expiration">:</TD>
				    <TD>	
						<cf_intelliCalendarDate9
						FieldName="DateExpiration" 
						DateFormat="#APPLICATION.DateFormat#"
						Default=""
						class="regularxl enterastab"
						AllowBlank="True">				
					</TD>
					</TR>			
								
					<cfquery name="Nation" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   *
					    FROM     Ref_Nation
						WHERE    Operational = 1
						ORDER BY Name
					</cfquery>
					
					<TR>
				    <TD class="labelmedium"><cf_tl id="Country">:</TD>
				    <TD>
					   	<select name="country" class="regularxl enterastab">
							<option value=""></option>
						    <cfoutput query="Nation">
							<option value="#Code#">#Name#</option>
							</cfoutput>
					   	</select>		
					</TD>
					</TR>
						   
					<TR>
				        <td class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</td>
				        <TD><textarea class="regular" style="width:98%;font-size:13px;padding:3px" rows="3" totlength="200"  onkeyup="return ismaxlength(this)" name="Remarks"></textarea> </TD>
					</TR>
								
					<cf_filelibraryscript>
					
					<tr>
						<td class="labelmedium"><cf_tl id="Attachment">:</td>
						<td><cfdiv bind="url:#session.root#/Staffing/Application/Employee/Document/DocumentEntryAttachment.cfm?id=#url.id#&documentid=#rowguid#&documenttype={documenttype}" id="att"></td>			
					</tr>			
					
					<tr><td height="5"></td></tr>		
											
					<tr><td class="line" colspan="2"></td></tr>
					<tr><td height="5"></td></tr>		
				
					<tr><td align="center" colspan="2" height="30">
					<cfoutput>
						<cf_tl id="Back" var="1">
				   	   <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="ptoken.navigate('#session.root#/Staffing/Application/Employee/Document/EmployeeDocumentContent.cfm?ID=#url.id#','dialog')">
				   		<cf_tl id="Reset" var="1">
					   <input class="button10g" type="reset"  name="Reset" value="#lt_text#">
				   		<cf_tl id="Save" var="1">   
					   <input class="button10g" type="submit" name="Submit" value="#lt_text#">
					</cfoutput>	   
				   </td>
				   		   
				</table>
				
		</td></tr>
		
		</table>
	
	</td></tr>
	
	</table>	

</CFFORM>

<cfset ajaxOnLoad("doCalendar")>
