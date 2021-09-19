

<!--- Query returning search results --->
<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT * FROM Parameter
</cfquery>

<cfquery name="Document" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM PersonDocument S, 
	     Ref_DocumentType R
	WHERE S.DocumentType = R.DocumentType
	AND PersonNo = '#URL.ID#'
	AND DocumentId = '#URL.ID1#'
</cfquery>

<cfform action="#session.root#/Staffing/Application/Employee/Document/DocumentEditSubmit.cfm" method="POST" name="DocumentEdit">

	<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="0">
	  <tr><td>
	
	<cfoutput query = "Document">
	
	<input type="hidden" name="PersonNo"   value="#PersonNo#"   class="regular">
	<input type="hidden" name="DocumentId" value="#DocumentId#" class="regular">
	
	<table width="96%" align="center">
	
	   <tr class="line">
	    <td width="100%" align="left" valign="middle" style="border:0px solid silver;font-size:25px" class="labellarge">
		<table><tr><td>
		<cfoutput>
		<img src="#session.root#/images/document.png" alt="" width="68" height="68" border="0">
		</td>
		<td class="labellarge" style="padding-top:10px;font-size:25px;padding-left:10px"><cf_tl id="Edit issued document">
		</cfoutput>
		</td></tr></table>
	    </td>
	  </tr> 	
	  	  
	  <tr>
	  	
		<td width="92%" align="center">
	   
		    <table border="0" class="formpadding" width="97%" align="right">
	
			<tr><td height="5"></td></tr>		
								
			<cfif dependentid neq "">
			
			<cfquery name="Dependent" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   PersonDependent
					WHERE  PersonNo = '#URL.ID#'
					AND    DependentId = '#dependentid#'
					AND    ActionStatus != '9'					
			</cfquery>
			
			<input type="hidden" name="DependentId" value="#dependentid#">
								
					<TR>
				    <TD height="21" class="labelmedium"><cf_tl id="Individual">:</TD>
					<TD width="80%" class="labelmedium">
					 #Dependent.FirstName# #Dependent.LastName# [#Dependent.Gender#] #dateformat(Dependent.BirthDate,CLIENT.DateFormatShow)#
					</td>
			</tr>		
			
			</cfif>
			
			<TR>
		    <TD class="labelmedium"><cf_tl id="Document type">:</TD>
		    <TD width="80%">
			<INPUT type="text" class="regularxl enterastab" value="#Document.DocumentType#" name="Documenttype" maxLength="20" size="20" readonly>		
			</TD>
			</TR>
			
			<TR>
		    <TD class="labelmedium"><cf_tl id="Document No">:</TD>
		    <TD>
			<INPUT type="text" class="regularxl enterastab" value="#Document.DocumentReference#" name="DocumentReference" maxLength="30" size="30">		
			</TD>
			</TR>
			
		    <TR>
		    <TD class="labelmedium"><cf_tl id="Date Effective">:</TD>
		    <TD>
			
				<cf_intelliCalendarDate9
					FormName="DocumentEdit"
					FieldName="DateEffective" 
					Class="regularxl enterastab"
					DateFormat="#APPLICATION.DateFormat#"
					Default="#Dateformat(Document.DateEffective, CLIENT.DateFormatShow)#">	
			
			</TD>
			</TR>
				
			<TR>
		    <TD class="labelmedium"><cf_tl id="Date Expiration">:</TD>
		    <TD>	
				
				<cf_intelliCalendarDate9
					FormName="DocumentEdit"
					FieldName="DateExpiration" 		
					Class="regularxl enterastab"
					DateFormat="#APPLICATION.DateFormat#"
					Default="#Dateformat(Document.DateExpiration, CLIENT.DateFormatShow)#">	
					
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
			
			   	<select name="Country" class="regularxl enterastab">
					<option value=""></option>
				    <cfloop query="Nation" >
					<option value="#Code#" <cfif Document.IssuedCountry eq Code>selected</cfif>>#Name#</option>
					</cfloop>		    
			   	</select>		
				
			</TD>
			</TR>					
				
			<tr><td class="labelmedium" valign="top" style="padding-top:5px"><cf_tl id="Attachment">:</td>
			<td>		
					<cf_filelibraryN
						DocumentPath="#Parameter.DocumentLibrary#"
						SubDirectory="#URL.ID#" 
						Filter="#documenttype#_#left(documentid,8)#"
						attachdialog = "yes"
						Insert="yes"
						Remove="yes"
						Listing="yes">
			</td>		
			</tr>
			
			<TR>
		        <td style="padding-top:6px" valign="top" class="labelmedium"><cf_tl id="Remarks">:</td>
		        <TD style="padding-left:0px">
				<textarea style="width:98%;padding:3px;font-size:13px" class="regular" totlength="200"  onkeyup="return ismaxlength(this)" rows="3" name="Remarks">#Document.Remarks#</textarea>
				</TD>
			</TR>
					  
		   </table>
		   
		  </td>
		  </tr>
		  
		  <tr><td height="5"></td></tr>		
		  <tr><td colspan="2" class="line"></td></tr>
		  <tr><td height="5"></td></tr>		
		  
		  <tr><td align="center" colspan="2" height="30">
		  
			   <input type="button"  name="cancel" value="Back" class="button10g" 
			      onClick="ptoken.navigate('#session.root#/Staffing/Application/Employee/Document/EmployeeDocumentContent.cfm?ID=#url.id#','dialog')">
			   
			   <cfif Document.enableRemove eq "1">
				   <cf_tl id="Delete" var="1">
				   <input class="button10g" type="submit"  name="Delete" value=" #lt_text#"
				   onClick="ptoken.navigate('#session.root#/Staffing/Application/Employee/Document/DocumentEditSubmit.cfm?action=delete&ID=#url.id#&id1=#url.id1#','dialog')">
			   </cfif>
			  	   
			   <cfif Document.enableEdit eq "1">
			   
				   <cf_tl id="Submit" var="1">
				   <input class="button10g" type="submit" name="Submit" value=" #lt_text#">
				   
			   <cfelse>	   
			   
			       <cfinvoke component  = "Service.Access" 
				      method     = "contract"
					  personno   = "#URL.ID#"	
					  role       = "'ContractManager','PayrollOfficer'"		
					  returnvariable = "access">
					
					<cfif access eq "ALL" or access eq "EDIT">		
					
					   <cf_tl id="Submit" var="1">
					   <input class="button10g" type="submit" name="Submit" value="#lt_text#">
					
					</cfif>		   
			   
			   </cfif>
		   
		   </td>
		   </tr>
		</table>   
	      
	</cfoutput>
	
	</td>
	</tr>
	
	</table>

</CFFORM>

<cfset ajaxOnLoad("doCalendar")>