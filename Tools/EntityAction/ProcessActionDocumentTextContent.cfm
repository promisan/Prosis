
<cfoutput>

	<cfquery name="Doc"
			datasource="appsOrganization"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
		SET     TextSize 1000000
		SELECT  O.*, R.DocumentMode, R.DocumentCode,R.DocumentLayout
		FROM    OrganizationObjectActionReport O INNER JOIN
		Ref_EntityDocument R ON O.DocumentId = R.DocumentId
		WHERE   O.ActionId   = '#url.MemoActionID#'
	AND     O.DocumentId = '#url.documentid#'
	</cfquery>

<!--- Line below doc.documentMode neq PDF is there for backward
compatibility
All MODE = PDF NOW is Mode= AsIs with Layout = pdf
on March 12th 2011--->

	<cfif url.textmode eq "edit" and doc.documentMode neq "AsIs">

		<table width="100%" height="100%" border="0" class="formspacing">

		<tr style="height:30px;">
		<td width="160" height="20" style="padding-left:0px;padding-right:0px">

		<table>
		<tr>
		<td>
				<button type="button"
				name="Save#No#" id="Save#No#"
						style="width:227;height:26"
						class="button10g"
			onclick="updateTextArea();saveoutput('save','#url.MemoActionid#','#url.documentId#','document#no#',document.getElementById('element#no#').value);">
		<cf_tl id="Save Content"></button>
	</td>

	<td style="padding-left:3px">
			<button type="button"
			name="Clean#No#" id="Clean#No#"
					style="width:137;height:26"
					class="button10g"
			onclick="ptoken.navigate('ProcessActionDocumentTextElement.cfm?save=1&no=#no#&memoactionid=#url.MemoActionID#&documentid=#url.documentid#&frm=document#no#&element='+document.getElementById('element#no#').value,'boxFieldDoc#no#','','','POST','document#no#')">
			<img src="#SESSION.root#/Images/refresh.gif" align="absmiddle" alt="Removes invalid characters from the text" border="0"><cf_tl id="Cleanse Text"></button>
	</td>
		<td class="xxxhide" style="padding-left:4px" id="myboxes"></td>
	</tr>
	</table>

	</td>

		<cfoutput>

				<td>

						<input type="hidden" name="element#no#"   id="element#no#"   value="documentcontent">
					<input type="hidden" name="margintop#no#" id="margintop#no#" value="#doc.DocumentMarginTop#">

			<table><tr>
				<cfloop index="itm" list="documentcontent,documentheader">

						<td class="labelmedium" style="padding-left:10px">
								<input type="radio" name="ele#no#" id="ele#no#" class="radiol" value="#itm#" <cfif itm eq "documentcontent">checked</cfif>
						onClick="document.getElementById('Save#No#').click();document.getElementById('element#no#').value='#itm#';ptoken.navigate('ProcessActionDocumentTextElement.cfm?no=#no#&memoactionid=#url.MemoActionID#&documentid=#url.documentid#&element=#itm#','boxFieldDoc#no#')">

						<cfif itm eq "documentcontent">Body
							<cfelseif itm eq "documentheader">Header/Footer
						</cfif>
						</td>
				</cfloop>

				</tr>
				</table>

				</td>

		</cfoutput>

		<td align="right">

		<table>

		<tr><td>

				<button type="button"
						name="Mail" id="Mail"
						style="width:41;height:25"
						class="button10g"
				onclick="saveoutput('mail','#url.MemoActionid#','#url.documentId#','document#no#',document.getElementById('element#no#').value)">
			<img src="#SESSION.root#/Images/mail_new.gif" align="absmiddle" alt="Send eMail" border="0">
	</button>

	</td>
	<td style="padding-left:4px">

			<button type="button"
					name="Print" id="Print"
					style="width:41;height:25"
					class="button10g"
			onclick="saveoutput('pdf','#url.MemoActionid#','#url.documentId#','document#no#',document.getElementById('element#no#').value)">
			<img src="#SESSION.root#/Images/pdf_small.gif" align="absmiddle" alt="PDF" border="0">
	</button>

	</td>
	<td style="padding-left:4px">

			<button type="button"
					name="Print" id="Print"
					style="width:41;height:25"
					class="button10g" onclick="saveoutput('print','#URL.MemoActionid#','#url.documentId#','document#no#',document.getElementById('element#no#').value)">
			<img src="#SESSION.root#/Images/print.gif" align="absmiddle" alt="Print" border="0">
	</button>

	</td>
	</tr>
	</table>

	</td>
	</tr>

	<tr><td colspan="3" height="100%" width="100%" valign="top">

		<cfif url.textmode eq "read">

				<div align="left" style="height:100%; width:100%; position:absolute; overflow: auto; border-top: 0px solid Silver;">
				<cfset text = replace(doc.DocumentContent,"<script","<disable","all")>
						 <cfset text = replace(text,"<iframe","<disable","all")>
						 <cf_paragraph>#text#</cf_paragraph>
				</div>

			<cfelseif Doc.DocumentMode eq "AsIs" or url.textmode eq "prior">

<!---

 <cfdiv id="MarginHold" class="hide">   <!--- dummy div to use for ColdFusion.navigate update of top margin --->
 <cfset text = replace(doc.DocumentContent,"<script","<disable","all")>
 <cfset text = replace(text,"<iframe","<disable","all")>
 <cf_paragraph>
     #text#
 </cf_paragraph>

 --->

				<iframe src="#session.root#\Tools\EntityAction\ProcessActionDocumentTextContentAsIs.cfm?memoactionid=#url.memoactionid#&documentid=#url.documentid#"
					width="100%" height="100%" frameborder="0"></iframe>

		<cfelse>

			<cfset url.element = "documentcontent">

				<form id="document#no#" name="document#no#" style="height:100%;padding-right:2px">
				<cfdiv id="boxFieldDoc#no#">
						<cfinclude template="ProcessActionDocumentTextElement.cfm">
					</cfdiv>
				</form>

		</cfif>

		</td></tr>

		</table>

		<cfelseif doc.documentMode eq "AsIs" and doc.DocumentLayout eq "PDF">

<!--- PDF load --->

		<table width="100%" height="96%" border="0">
		<tr><td style="padding:1px;border:1px solid 6688aa">

<!--- create a correct path --->
		<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
		<cfset mid = oSecurity.gethash()/>

		<cfset link = "#SESSION.root#/CFRStage/getFile.cfm?id=#EncodeForURL(doc.DocumentPath)#&mode=WkfObject&mid=#mid#">

		<cfset link = replace(link,"\","/","ALL")>
		<cfloop index="i" from="1" to="3">
			<cfset link = replace(link,"//","/","ALL")>
		</cfloop>
		<cfset link = replace(link,":/","://","ALL")>

		<iframe src="#link#"
			width="100%"
			height="100%"
			scrolling="yes"
			frameborder="0"></iframe>

	</td>

	</tr></table>

	<cfelse>

		<form name="document#no#" id="document#no#" style="height:100%">

	<table border="0" height="100%" width="100%">

	<tr class="line">

	<td align="left" colspan="3" height="26" style="padding-top:3px;padding-left:1px">

	<table class="formspacing">

	<tr>

<!--- this option is disabled

<cfif url.textmode neq "read">

     <td style="height:30px" class="labelit">Header Margin:&nbsp;

    <select name="margintop" id="margintop" class="regularxl"
     onChange="ColdFusion.Ajax.submitForm('doc#no#','ProcessActionDocumentSubmit.cfm?documentid=#url.documentid#')">
     <cfloop index="m" from="0.0" to="5" step="0.5">
         <option value="#m#"
         <cfif doc.DocumentMarginTop eq m>selected</cfif>>#m#</option>
      </cfloop>
      </select>

     </td>

    <td width="10">&nbsp;</td>

</cfif>

--->

		<td align="right" style="width:20;height:30px">
				<button type="button"
						name="Mail" id="Mail"
						style="width:41;height:25"
						class="button10g" onclick="docoutput('mail','#URL.MemoActionid#','#url.documentId#')">
			<img src="#SESSION.root#/Images/mail_new.gif" align="absmiddle" alt="Send eMail" border="0">
	</button>
	</td>

	<td align="right"  style="width:20;height:30px">
			<button type="button"
					name="PDF"  id="PDF"
					style="width:41;height:25"
					class="button10g" onclick="docoutput('pdf','#URL.MemoActionid#','#url.documentId#')">
			<img src="#SESSION.root#/Images/pdf_small.gif" align="absmiddle" alt="PDF" border="0">
	</button>
	</td>


	<td align="right"  style="width:20;height:30px">
			<button type="button"
					name="Print" id="Print"
					style="width:41;height:25"
					class="button10g" onclick="docoutput('print','#URL.MemoActionid#','#url.documentId#')">
			<img src="#SESSION.root#/Images/print.gif" align="absmiddle" alt="Print" border="0">
	</button>
	</td>
		<td width="2"></td>

	</tr>
	</table>

	</td></tr>

	<tr>

	<td colspan="3" height="100%" width="100%" valign="top">

		<cfif url.textmode eq "read">

				<div align="left" style="height:290px; width:100%; position:absolute; overflow: auto; border-top: 0px solid Silver;">
				<cfset text = replace(doc.DocumentContent,"<script","<disable","all")>
				 <cfset text = replace(text,"<iframe","<disable","all")>
				 <cf_paragraph>#text#</cf_paragraph>
				</div>

			<cfelseif Doc.DocumentMode eq "AsIs" or url.textmode eq "prior">

				<iframe
						src="#session.root#\Tools\EntityAction\ProcessActionDocumentTextContentAsIs.cfm?memoactionid=#url.memoactionid#&documentid=#url.documentid#"
					width="100%"
					height="100%"
					scrolling="yes"
					frameborder="0">
			</iframe>
<!---
<cfdiv id="MarginHold" class="hide">   <!--- dummy div to use for ColdFusion.navigate update of top margin --->
<cfset text = replace(doc.DocumentContent,"<script","<disable","all")>
<cfset text = replace(text,"<iframe","<disable","all")>
<cf_paragraph>#text#</cf_paragraph>
--->

		<cfelse>

			<cf_securediv id="boxFieldDoc#no#"
					bind="url:ProcessActionDocumentTextElement.cfm?no=#no#&memoactionid=#url.MemoActionID#&documentid=#url.documentid#&element=documentcontent">

		</cfif>

		</td></tr>

		</table>

		</form>

	</cfif>

</cfoutput>

<cfset ajaxonload("initTextArea")>

