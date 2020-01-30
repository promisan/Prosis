<cf_screentop height="98%" label="Questionaire Maintenance" 
   close="parent.ColdFusion.Window.destroy('myeditquestion',true)" option="Question Maintenance" scroll="Yes" layout="webapp" banner="gray">

	<script language="JavaScript">
		
		function ask() {
			if (confirm("Do you want to remove this record ?")) {			
			return true 			
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
		
	</script>
	
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
	
	
    <CFFORM action="ObjectElementQuestionSubmit.cfm" target="questionSubmit" method="post" name="formquestion">
	
	<!--- edit form --->
	<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
		<tr><td></td></tr>
			
		 <tr class="hide"><td colspan="2"><iframe name="questionSubmit" id="questionSubmit" frameborder="0"></iframe></td></tr>
			
		 <cfoutput>
		 
		 <cfinput type="Hidden" name="documentId"    value="#URL.ID1#">		
		  
		 <cfif url.id2 neq "">
		 	<cfinput type="Hidden" name="questionId"    value="#URL.ID2#">
			<cfset qIdLanguageInput = "#URL.ID2#">	
		 <cfelse>
		 	<cfinput type="Hidden" name="questionId"    value="#newId#">	
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
		 <TR>
			 <TD class="labelmedium">Code *:&nbsp;</TD>  
			 <TD>
			 	<cfinput type="Text" name="questionCode" value="#get.questionCode#" message="Please enter a question code" required="Yes" size="20" maxlength="40" class="regularxl">
			 </TD>
		 </TR>	
		 
		 <!--- Field: questionLabel --->
		 <TR>
			 <TD class="labelmedium" valign="top">Label *:&nbsp;</TD>  
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
		 <TR>
			 <TD class="labelmedium" valign="top">Memo:&nbsp;</TD>  
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
					Class           = "regular">
			 </TD>
		 </TR>
		 
		 <!--- Field: inputMode --->
		 <TR>
			 <TD class="labelmedium">Input Mode *:</b></TD>  
			 <TD>
			 	<select name="inputMode" id="inputMode" class="regularxl">
					<option value="YesNo" <cfif get.inputMode eq "YesNo">selected</cfif>>Yes-No</option>
					<option value="YesNoNA" <cfif get.inputMode eq "YesNoNA">selected</cfif>>Yes-No-NA</option>
					<option value="5" <cfif get.inputMode eq "5">selected</cfif>>Score in 5</option>
					<option value="3" <cfif get.inputMode eq "3">selected</cfif>>Score in 3</option>					
				</select>
			 </TD>
		 </TR>
		 
		  <!--- Field: inputMode --->
		 <TR>
			 <TD class="labelmedium">Set Target *:</b></TD>  
			 <TD>
			    <cfdiv bind="url:#session.root#/system/entityaction/EntityObject/getQuestionTarget.cfm?inputmode={inputMode}&selected=#get.inputValuePass#">
				
			 </TD>
		 </TR>
		 		 
		 <!--- Field: enableInputMemo --->
		 <TR>
			 <TD class="labelmedium" style="padding-right:20px">Enable Memo *:</TD>  
			 <TD class="labelmedium">
			 	<input type="radio" class="radiol" name="enableInputMemo" id="enableInputMemo" value="0" <cfif get.enableInputMemo eq "0">checked</cfif>>No
				<input type="radio" class="radiol" name="enableInputMemo" id="enableInputMemo" value="1" <cfif get.enableInputMemo eq "1" or url.id2 eq "">checked</cfif>>Yes	
			 </TD>
		 </TR>		
		 
		 <!--- Field: enableInputAttachment --->
		 <TR>
			 <TD class="labelmedium" style="padding-right:20px">Enable Attachment *:</TD>  
			 <TD class="labelmedium">
			 	<input type="radio" class="radiol" name="enableInputAttachment" id="enableInputAttachment" value="0" <cfif get.enableInputAttachment eq "0">checked</cfif>>No
				<input type="radio" class="radiol" name="enableInputAttachment" id="enableInputAttachment" value="1" <cfif get.enableInputAttachment eq "1" or url.id2 eq "">checked</cfif>>Yes	
			 </TD>
		 </TR>		 		 
		 		
		<tr><td height="6"></td></tr>
		<tr><td colspan="4" class="linedotted"></td></tr>
		<tr><td height="6"></td></tr>
		
		<tr><td colspan="4" align="center" height="30">
		
		<cfif url.id2 eq "">				
		
			<input class="button10g" type="submit" name="Save" id="Save" value="Save" onclick="return validateTextArea('formquestion', 'QuestionMemo', 200)">
			
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
			
			<input class="button10g" type="submit" name="Update" id="Update" value="Update" onclick="return validateTextArea('formquestion', 'QuestionMemo', 200)">
		
		</cfif>		
		
		</td></tr>
		
	</cfoutput>
      	
</TABLE>
  </CFFORM>