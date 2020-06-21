<cf_screentop height="98%" label="Questionaire Maintenance"
	jquery="Yes"
   close="parent.ProsisUI.closeWindow('myeditquestion',true)" option="Question Maintenance" html="no" scroll="Yes" layout="webapp" banner="gray">

    <cfoutput>  
	<script language="JavaScript">
		
		function ask() {
			if (confirm("Do you want to remove this record ?")) {			
			ptoken.navigate('ObjectElementQuestionSubmit.cfm?action=delete&documentid=#url.id1#&questionId=#url.id2#','process','','','POST','formquestion')		
			}			
			return false			
		}				
		
		function validateTextArea(formname, basename, maxlength){
			var memoForm = document.getElementById(formname);
			var memoReturn = true
			var message = ''			
			
			for (i=0; i < memoForm.elements.length; i++){
				if (memoForm.elements[i].name.substr(0,basename.length) ==  basename){							
					if (memoForm.elements[i].value.length > maxlength){
						message = message + memoForm.elements[i].name + ' field has ' + memoForm.elements[i].value.length + ' characters.\nThe limit characters for this field is ' + maxlength + '.\n\n'
						memoForm.elements[i].focus()
						memoReturn = false
					}
				}
			}
			
			if (!memoReturn) alert(message)			
			return (memoReturn)
			}
				
		function formvalidate() {
			document.formquestion.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
    	      ptoken.navigate('ObjectElementQuestionSubmit.cfm?action=update&documentid=#url.id1#&questionId=#url.id2#','process','','','POST','formquestion')
	    	}   
        }	 	
		
	</script>
	</cfoutput>
	
	<cfquery name="Get" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT	*
		FROM	Ref_EntityDocumentQuestion
		WHERE	documentId = '#URL.ID1#'
		<cfif url.id2 eq "">
		AND    	1 = 0
		<cfelse>
		AND    	questionId = '#URL.ID2#'
		</cfif>	
	</cfquery>	 	
	
	<cfquery name="Last" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT	*
		FROM	Ref_EntityDocumentQuestion
		WHERE	documentId = '#URL.ID1#'
		ORDER BY ListingOrder DESC		
	</cfquery>
	
	<cfquery name="getId" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT convert(varchar(100), newId()) as newId
	</cfquery>
	
	<cfset newId = getId.newId>	
		
    <CFFORM method="post" name="formquestion">
	
	<!--- edit form --->
	<table width="94%" align="center" class="formpadding">
	
		<tr><td></td></tr>
			
		 <tr class="hide"><td colspan="2" id="process"></td></tr>
			
		 <cfoutput>
		 
		 <input type="hidden" name="documentId"    value="#URL.ID1#">		
		  
		 <cfif url.id2 neq "">
		 	<input type="hidden" name="questionId"    value="#URL.ID2#">
			<cfset qIdLanguageInput = "#URL.ID2#">	
		 <cfelse>
		 	<input type="hidden" name="questionId"    value="#newId#">	
			<cfset qIdLanguageInput = "#newId#">
		 </cfif>		
				 
		 <!--- Field: listingOrder --->
		 <TR>
			 <TD class="labelmedium">Sort *:&nbsp;</TD>  
			 <TD>
			    <cfif get.ListingOrder eq "">
				  <cfif last.listingorder eq "">
				  <cfset val = 1>
				  <cfelse>
				  <cfset val = last.ListingOrder+1>
				  </cfif>
				<cfelse>
				  <cfset val = get.ListingOrder>  
				</cfif>
			 	<cfinput type="Text" name="listingOrder" value="#val#" message="Please enter a numeric listing order" required="Yes" style="width:30px;text-align:center"  maxlength="3" validate="integer" class="regularxl">
			 </TD>			 
		 </TR>
		 
		 <!--- Field: questionCode --->
		 <TR  class="labelmedium">
			 <TD>Code *:</TD>  
			 <TD>
			 	<cfinput type="Text" name="questionCode" value="#get.questionCode#" message="Please enter a question code" required="Yes" size="20" maxlength="40" class="regularxl">
			 </TD>
		 </TR>	
		 
		 <!--- Field: questionLabel --->
		 <TR  class="labelmedium">
			 <TD>Label *:</TD>  
			 <TD>			 	 	
				<cf_LanguageInput
					TableCode       = "Questionaire" 
					Mode            = "Edit"
					Name            = "questionLabel"
					Value           = "#get.questionLabel#"
					Key1Value       = "#qIdLanguageInput#"
					Type            = "Input"
					Required        = "Yes"
					Message         = "Please enter a question label"
					MaxLength       = "150"
					Size            = "70"
					Class           = "regularxl">				
			 </TD>
		 </TR>
		 
		 <!--- Field: questionMemo --->
		 <TR class="labelmedium">
			 <TD valign="top" style="padding-top:3px;padding-right:5px">Instruction:</TD>  
			 <TD width="75%">
			 	<cf_LanguageInput
					TableCode       = "Questionaire" 
					Mode            = "Edit"
					Name            = "QuestionMemo"
					Value           = "#get.questionMemo#"
					Key1Value       = "#qIdLanguageInput#"
					Type            = "Text"
					Required        = "No"
					Message         = "Please enter a question memo"
					MaxLength       = "200"
					Rows            = "6"
					Cols            = "40"
					Class           = "regularxl">
			 </TD>
		 </TR>
		 
		 <!--- Field: inputMode --->
		 <TR class="labelmedium">
			 <TD>Score Mode *:</b></TD>  
			 <TD>
			 <table>
			 <tr><td>
			 	<select name="inputMode" id="inputMode" class="regularxl">
					<option value="YesNo" <cfif get.inputMode eq "YesNo">selected</cfif>>Yes[1]-No[9]</option>
					<option value="YesNoNA" <cfif get.inputMode eq "YesNoNA">selected</cfif>>Yes[1]-No[9]-NA[0]</option>
					<option value="YesNoPa" <cfif get.inputMode eq "YesNoPA">selected</cfif>>Yes[1]-No[9]-Partly[5]</option>
					<option value="6" <cfif get.inputMode eq "6">selected</cfif>>Score 1-6</option>
					<option value="5" <cfif get.inputMode eq "5">selected</cfif>>Score 1-5</option>
					<option value="4" <cfif get.inputMode eq "4">selected</cfif>>Score 1-4</option>
					<option value="3" <cfif get.inputMode eq "3">selected</cfif>>Score 1-3</option>					
				</select>
			 </TD>
			 <td style="padding-left:4px"><cfdiv bind="url:#session.root#/system/entityaction/EntityObject/getQuestionTarget.cfm?field=inputmodelabel&documentid=#URL.ID1#&questionid=#URL.ID2#&inputmode={inputMode}"></td>
			 </tr>
			 </table>
		 </TR>
		 	 
		 <!--- Field: inputMode --->
		 <TR class="labelmedium">
			 <TD>Score Target value *:</b></TD>  
			 <TD>
			    <cfdiv bind="url:#session.root#/system/entityaction/EntityObject/getQuestionTarget.cfm?field=target&inputmode={inputMode}&selected=#get.inputValuePass#">
				
			 </TD>
		 </TR>
		 		 
		 <!--- Field: enableInputMemo --->
		 <TR class="labelmedium">
			 <TD style="padding-right:20px">Enable Explanatory memo:</TD>  
			 <TD>
			 	<table>
				<tr class="labelmedium">
					<td><input type="radio" class="radiol" name="enableInputMemo" id="enableInputMemo" value="0" <cfif get.enableInputMemo eq "0">checked</cfif>></td>
					<td style="padding-left:2px">No</td>
					<td style="padding-left:7px"><input type="radio" class="radiol" name="enableInputMemo" id="enableInputMemo" value="1" <cfif get.enableInputMemo eq "1" or url.id2 eq "">checked</cfif>></td>
					<td style="padding-left:2px">Yes</td>
					<td style="padding-left:7px"><input type="radio" class="radiol" name="enableInputMemo" id="enableInputMemo" value="2" <cfif get.enableInputMemo eq "2" or url.id2 eq "">checked</cfif>></td>
					<td style="padding-left:2px">Enforce</td>
					<td style="padding-left:7px"><input type="radio" class="radiol" name="enableInputMemo" id="enableInputMemo" value="3" <cfif get.enableInputMemo eq "3">checked</cfif>></td>
					<td style="padding-left:2px">Enforce Score <> [Score Target value]</td>
					<td style="padding-left:7px"><input type="radio" class="radiol" name="enableInputMemo" id="enableInputMemo" value="4" <cfif get.enableInputMemo eq "4">checked</cfif>></td>
					<td style="padding-left:2px">Enforce Score = [Score Target value]</td>
				</tr>
				</table>
				 </TD>
		 </TR>		
		 
		 <TR  class="labelmedium">
			 <TD>Memo instruction:</TD>  
			 <TD>			 	 	
			 	<cfinput type="Text" name="InputMemoInstruction" value="#get.InputMemoInstruction#" required="No" size="60" maxlength="100" class="regularxl">						
			 </TD>
		 </TR>
		 
		 <!--- Field: enableInputAttachment --->
		 <TR class="labelmedium">
			 <TD style="padding-right:20px">Enable Attachments:</TD>  
			 <TD>
			 <table>
				<tr class="labelmedium">
					<td><input type="radio" class="radiol" name="enableInputAttachment" id="enableInputAttachment" value="0" <cfif get.enableInputAttachment eq "0">checked</cfif>></td>
					<td style="padding-left:2px">No</td>
					<td style="padding-left:7px"><input type="radio" class="radiol" name="enableInputAttachment" id="enableInputAttachment" value="1" <cfif get.enableInputAttachment eq "1" or url.id2 eq "">checked</cfif>></td>
					<td style="padding-left:2px">Yes</td>					
				</tr>
				</table>
			 </TD>
		 </TR>		 		 
		 		
		<tr><td height="6"></td></tr>
		<tr><td colspan="4" class="line"></td></tr>
		<tr><td height="6"></td></tr>
		
		<tr><td colspan="4" align="center" height="30">
		
		<cfif url.id2 eq "">				
		
			<input class="button10g" type="button" name="Save" id="Save" value="Save" onclick="formvalidate()">
			
		<cfelse>
		
			<cfquery name="verifyDelete"
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  TOP 1 *
				FROM	OrganizationObjectQuestion
				WHERE 	QuestionId = '#URL.ID2#'
			</cfquery>
			
			<cfif verifyDelete.recordCount eq 0><input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()"></cfif>
			
			<input class="button10g" type="button" name="Update" id="Update" value="Update" onclick="formvalidate()">
		
		</cfif>		
		
		</td></tr>
		
	</cfoutput>
      	
</TABLE>
  </CFFORM>