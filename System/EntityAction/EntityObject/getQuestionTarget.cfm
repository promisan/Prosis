
<cfswitch expression="#url.field#">

<cfcase value="target">
	
	<cfif url.inputmode eq "YesNo">
	
	<select name="InputValuePass" class="regularxl">
		<option value="9" <cfif url.selected eq "9">selected</cfif>>No</option>
		<option value="1" <cfif url.selected eq "1">selected</cfif>>Yes</option>
	</select>
	
	<cfelseif url.inputmode eq "YesNoNA">
	
	<select name="InputValuePass" class="regularxl">
		<option value="9" <cfif url.selected eq "9">selected</cfif>>No</option>
		<option value="1" <cfif url.selected eq "1">selected</cfif>>Yes</option>	
	</select>
	
	<cfelseif url.inputmode eq "YesNoPA">
	
	<select name="InputValuePass" class="regularxl">
		<option value="9" <cfif url.selected eq "9">selected</cfif>>No</option>
		<option value="1" <cfif url.selected eq "1">selected</cfif>>Yes</option>	
		<option value="5" <cfif url.selected eq "5">selected</cfif>>Partly</option>
	</select>
	
	<cfelse>
		
		<cfoutput>
		<select name="InputValuePass" class="regularxl">
		   <cfloop index="itm" from="1" to="#url.inputmode#">
			<option value="#itm#" <cfif url.selected eq itm>selected</cfif>>#itm#</option>
		   </cfloop>			
		</select>
		</cfoutput>
	
	</cfif>
	
</cfcase>	

<cfcase value="inputmodelabel">
	
	<cfif url.inputmode eq "3" or url.inputmode eq "4" or url.inputmode eq "5" or url.inputmode eq "6">
	
		<cfquery name="get" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  * 
			FROM 	Ref_EntityDocumentQuestion		
			WHERE 	DocumentId  			= '#url.documentId#'
			AND 	QuestionId  			= '#url.questionId#'
		</cfquery>
	   
	   <cfoutput>
		<table cellspacing="0" cellpadding="0">
		<tr><td style="padding-left:5px;padding-right:5px"><cf_uitooltip tooltip="Record labels for score 1 to #url.inputmode# separated by a comma"><cf_tl id="Labels"></cf_uitooltip></td>
	    <td>
		<input type="text" name="InputModeStringList" value="#get.InputModeStringList#" maxlength="100" class="regularxl" style="width:600px">		
		</td></tr></table>
		</cfoutput>
	
	<cfelse>
	
		<input type="hidden" name="InputModeStringList" value="">
	
	</cfif>

</cfcase>

</cfswitch>
<!--- get questionaire target --->