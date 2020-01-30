
<cfif url.stepto neq "">
	
	<cfif url.PublishNo neq "">
	
		<cfquery name="Get" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_EntityActionPublishProcess 
			WHERE   ProcessClass = 'GoTo' 
			AND     ActionCode = '#URL.ActionCode#'
			AND     ProcessActionCode = '#URL.stepto#' 
			AND     ActionPublishNo = '#URL.PublishNo#'			 						 
		</cfquery>
	
	<cfelse>
	
	   <cfquery name="Get" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_EntityClassActionProcess 
			WHERE   EntityCode    = '#URL.EntityCode#'
			AND     EntityClass   = '#URL.EntityClass#'
			AND     ProcessClass  = 'GoTo' 
			AND     ActionCode    = '#URL.ActionCode#'
			AND     ProcessActionCode = '#URL.stepto#' 
								 
		</cfquery>
		
	</cfif>	

<cfset box = replace(url.stepto,"-","","ALL")>
		
<cfform method="POST" name="form#box#">
		       	
		<table width="100%" cellspacing="0" cellpadding="0" align="right" class="formpadding">
		
			<TR>
				<td valign="top" style="padding-right:4px"><img src="<cfoutput>#SESSION.root#</cfoutput>/images/join.gif" alt="" border="0"></td>
			    <TD class="labelit">Require Memo:</TD>
			    <TD class="labelit">
				<table class="formspacing">
				<tr>
				<td><input type="radio" class="radiol" name="ConditionMemo" id="ConditionMemo" value="0" <cfif Get.ConditionMemo eq "0">checked</cfif>></td><td class="labelit">No</td>
				<td><input type="radio" class="radiol" name="ConditionMemo" id="ConditionMemo" value="1" <cfif Get.ConditionMemo eq "1">checked</cfif>></td><td class="labelit">Yes</td>
				</tr>
				</table>
				</TD>
			</TR>	
									
			<TR>
				
				<td></td>
			    <TD width="140" class="labelit" valign="top">
				
					<table><tr><td>
					Condition Query:
					</td></tr>
					
					<tr><td style="padding-top:5px;padding-right:4px">
					
					<cfset ds = "#get.ConditionDataSource#">
					<cfif ds eq "">
					 <cfset ds = "AppsOrganization">
					</cfif>
				
					<!--- Get "factory" --->
					<CFOBJECT ACTION="CREATE"
					TYPE="JAVA"
					CLASS="coldfusion.server.ServiceFactory"
					NAME="factory">
					
					<CFSET dsService=factory.getDataSourceService()>		
									
					<cfset dsNames = dsService.getNames()>
					<cfset ArraySort(dsnames, "textnocase")> 
				
					<select name="ConditionDataSource" id="ConditionDataSource" class="regularh" style="width:150;">
														
						<CFLOOP INDEX="i"
							FROM="1"
							TO="#ArrayLen(dsNames)#">
						
							<CFOUTPUT>
							<option value="#dsNames[i]#" <cfif ds eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
							</cfoutput>
						
						</cfloop>
						
					</select>
					
					</td></tr>
					
					</table>
				
				</TD>
				<TD>
			    	<textarea cols="84" style="padding;3px;height:60px;font-size:13px;width:95%" class="regular" name="ConditionScript"><cfoutput>#Get.ConditionScript#</cfoutput></textarea>
				</TD>
				</TR>	
								
				<tr><td></td><td align="right" class="labelit"></td><td colspan="1" style="font-size:12px" class="labelit">Query is executed prior to forwarding the workflow to this step 
				<br>Use <b>@action, @key1, @key2, @key3 and @key4 @acc, @last @first</b> to refer to the action,object or user identification</td></tr>
								
				
				<TR>
				<td></td>
			    <TD class="labelit">Condition field:</TD>
			    <TD>
				<table><tr><td>
				<cfinput class="regularxl" type="Text" value="#Get.ConditionField#"  name="ConditionField" required="No" size="30" maxlength="30">
				</td>
				  <TD class="labelit" style="padding-left:10px">Operand & Value:</TD>
			    <TD style="padding-left:5px">
				<cfinput class="regularxl" type="Text" value="#Get.ConditionValue#"  name="ConditionValue" required="No" size="10" maxlength="20">
				</TD>
				
				</tr>
				
				
				</table>
				</TD>
				</TR>
									
				<TR>
				<td></td>
			    <TD class="labelit">Error message:</TD>
			    <TD>
				<cfinput class="regularxl" type="Text" value="#Get.ConditionMessage#"  name="ConditionMessage" required="No" size="80" maxlength="80">
				</TD>
				</TR>
						
				
				
				<cfquery name="Mail" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM  Ref_EntityDocument
					WHERE EntityCode = '#URL.EntityCode#'
					AND   DocumentType = 'Mail'
					ORDER BY DocumentDescription
					</cfquery>	
				
				<TR>
				<td></td>
			    <TD class="labelit">Outgoing Mail:</TD>
			    <TD>
				<select name="MailCode" id="MailCode" class="regularxl">
				    <option value="" selected>No mail</option>
				 	<cfoutput query="Mail">
					    <option value="#DocumentCode#"
						 <cfif DocumentCode eq Get.MailCode>selected</cfif>>
						 #DocumentDescription#</option>
					</cfoutput>
				</select>
				</TD>
			</TR>
				
			<cfoutput>
				
			   <tr><td colspan="5" id="conditionresult#url.stepto#"></td></tr>
			   <tr><td colspan="3" class="linedotted"></td></tr>	
			   <tr>
				 <td colspan="3" height="35" align="center">
					 <input type="button" class="button10g" value="Verify"  onClick="saveflowcondition('#box#','#url.stepto#','4')" name="Verify" id="Verify">				
					 <input type="button" class="button10g" value="Update"  onClick="saveflowcondition('#box#','#url.stepto#','3')" name="Save" id="Save">		 
				 </td>
			   </tr>
			
			</cfoutput>	
									
	</table>
				
</cfform>		
	
</cfif>	

